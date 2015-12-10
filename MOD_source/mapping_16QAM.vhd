library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mapping_16QAM is
generic(
			kOutSize : positive := 14
			);
port(
		aReset : in std_logic;
		clkin : in std_logic;
		clkout : in std_logic;
		val_in : in std_logic;
		datain : in std_logic_vector(7 downto 0);
		dataout_I0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_I1 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q1 : out std_logic_vector(kOutSize - 1 downto 0)
		);
end entity;

architecture rtl of mapping_16QAM is

component FIFO_Interface_8_4 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
END component;

constant SP_gen : std_logic_vector(0 to 31) := "11000110111010100001001011001110";
constant LP_gen : std_logic_vector(0 to 1087) :=
	"101011111010110100000110111011011010110000010111011111000111100110"&
	"1001101011100011010001011111110100101100010100110001100000001100110010101"& --73bit pn511
	"1001001111110110100100100110111111001011010100001010001001110110010111101"&
	"1000011010101001110010000110001000010000000010001000110010001110101011011"&
	"0001110001001010100011011001111100111100010110111001010010000010011001110"&
	"1000111110111100000111111111000011110111000010110011011011110100001110011"&
	"0000100100010101110101111001001011100111000000111011101001111010100101000"&
	"0001010101011111010110100000110111011011010110000010111011111000111100110"&
	"1001101011100011010001011111110100101100010100110001100000001100110010101"& --73bit pn511
	"1001001111110110100100100110111111001011010100001010001001110110010111101"&
	"1000011010101001110010000110001000010000000010001000110010001110101011011"&
	"0001110001001010100011011001111100111100010110111001010010000010011001110"&
	"1000111110111100000111111111000011110111000010110011011011110100001110011"&
	"0000100100010101110101111001001011100111000000111011101001111010100101000"&
	"0001010101011111010110100000110111011011010110000010111011111000111100110";
constant UW_gen : std_logic_vector(0 to 63) := "0110101011111100000100001100010100111101000111001001011011101100";
signal rdreq : std_logic;
signal dataout_fifo : std_logic_vector(7 downto 0);
signal rdusedw : std_logic_vector(15 downto 0);
type state_t is (state_SP, state_LP, state_UW, state_Data);
signal state, next_state : state_t;
signal counter_SP : integer range 0 to 31;
signal Num_SP : integer range 0 to 65535;
signal data_map0,data_map1 : std_logic_vector(3 downto 0);
signal data_MOD : std_logic;
signal LP_start,LP_end,frame_end,UW_end,Data_end : std_logic;
signal counter_LP : integer range 0 to 1088;
signal counter_UW : integer range 0 to 63;
signal counter_Data : integer range 0 to 479;
signal Num_UW : integer range 0 to 65;
signal PN_15 : std_logic_vector(14 downto 0);
constant cons_threshold1	: positive := 1365; --585*7=4095         
constant cons_threshold2	: positive := cons_threshold1*3;         
constant cons_QPSK : positive :=3052; --1365*sqrt(5)

begin

FIFO_Interface_8_4_inst : FIFO_Interface_8_4
	PORT map
	(
		aclr		=> aReset,
		data		=> datain,
		rdclk		=> clkout,
		rdreq		=> rdreq,
		wrclk		=> clkin,
		wrreq		=> val_in,
		q			=> dataout_fifo,
		rdempty	=> open,	
		rdusedw	=> rdusedw,	
		wrfull	=> open	
	);

	
   process( clkout, aReset )
	begin 
		if aReset = '1' then
			state <= state_SP;
		elsif rising_edge( clkout ) then
			state <= next_state;
		end if;
	end process;
	
	process(state,LP_start,LP_end,UW_end,frame_end,Data_end)
	begin
		next_state <= state;
		case state is
			when state_SP => 
				if LP_start = '1' then
					next_state <= state_LP;
				end if;
			when state_LP =>
				if LP_end = '1' then
					next_state <= state_UW;
				end if;
			when state_UW =>
				if UW_end = '1' then
					next_state <= state_Data;
				elsif frame_end = '1' then
					next_state <= state_SP;
				end if;
			when state_Data => 
				if Data_end = '1' then
					next_state <= state_UW;
				end if;
			when others => 
				next_state <= state_SP;
		end case;
	end process;
	
	process(clkout,aReset)
	begin
		if aReset = '1' then
			counter_SP <= 0;
			Num_SP <= 0;
			data_map0 <= "0000";
			data_map1 <= "0000";
			data_MOD <= '0';
			LP_start <= '0';
			counter_LP <= 0;
			LP_end <= '0';
			counter_UW <= 0;
			Num_UW <= 0;
			frame_end <= '0';
			UW_end <= '0';
			rdreq <= '0';
			Data_end <= '0';
			PN_15 <= "100110101011110";
		elsif rising_edge(clkout) then
			if state = state_SP then
				PN_15 <= "100110101011110";
				if counter_SP < 15 then
					counter_SP <= counter_SP + 1;
				else
					counter_SP <= 0;
				end if;
				if counter_SP = 14 then
					Num_SP <= Num_SP + 1;
				end if;
				data_map0 <= SP_gen(2*counter_SP) & SP_gen(2*counter_SP) & "10";
				data_map1 <= SP_gen(2*counter_SP + 1) & SP_gen(2*counter_SP + 1) & "10";
				data_MOD <= '0';
				if Num_SP >= 4 and unsigned(rdusedw) >= 30720 then
					LP_start <= '1';
				else
					LP_start <= '0';
				end if;
				Num_UW <= 0;
				Data_end <= '0';
			elsif state = state_LP then
				Num_SP <= 0;
				LP_start <= '0';
				if counter_LP < 543 then
					counter_LP <= counter_LP + 1;
				else
					counter_LP <= 0;
				end if;
				data_map0 <= LP_gen(2*counter_LP) & LP_gen(2*counter_LP) & "10";
				data_map1 <= LP_gen(2*counter_LP + 1) & LP_gen(2*counter_LP + 1) & "10";
				data_MOD <= '0';
				if counter_LP = 542 then
					LP_end <= '1';
				else
					LP_end <= '0';
				end if;
				Num_UW <= 0;
			elsif state = state_UW then
				LP_end <= '0';
				if counter_UW < 31 then
					counter_UW <= counter_UW + 1;
				else
					counter_UW <= 0;
				end if;
				data_map0 <= UW_gen(2*counter_UW) & UW_gen(2*counter_UW) & "10";
				data_map1 <= UW_gen(2*counter_UW + 1) & UW_gen(2*counter_UW + 1) & "10";
				data_MOD <= '0';
				if counter_UW = 29 then
					Num_UW <= Num_UW + 1;
				end if;
				if counter_UW = 30 then
					if Num_UW = 65 then
						frame_end <= '1';
						UW_end <= '0';
						rdreq <= '0';
					else
						rdreq <= '1';
						UW_end <= '1';
						frame_end <= '0';
					end if;
				else
					UW_end <= '0';
					frame_end <= '0';
				end if;
			elsif state = state_Data then
				PN_15(14 downto 8) <= PN_15(6 downto 0);
				for i in 0 to 7 loop
					PN_15(i) <= PN_15(7 + i) XOR PN_15(6+i);
				end loop;
				UW_end <= '0';
				frame_end <= '0';
				if counter_Data < 479 then
					counter_Data <= counter_Data + 1;
				else
					counter_Data <= 0;
				end if;
				if counter_Data <= 477 then
					rdreq <= '1';
				else
					rdreq <= '0';
				end if;
				data_map0(0) <= dataout_fifo(0) XOR PN_15(14);
				data_map0(1) <= dataout_fifo(1) XOR PN_15(13);
				data_map0(2) <= dataout_fifo(2) XOR PN_15(12);
				data_map0(3) <= dataout_fifo(3) XOR PN_15(11);
				data_map1(0) <= dataout_fifo(4) XOR PN_15(10);
				data_map1(1) <= dataout_fifo(5) XOR PN_15(9);
				data_map1(2) <= dataout_fifo(6) XOR PN_15(8);
				data_map1(3) <= dataout_fifo(7) XOR PN_15(7);
--				data_map0 <= dataout_fifo(3 downto 0);
--				data_map1 <= dataout_fifo(7 downto 4);
				data_MOD <= '1';
				if counter_Data = 478 then
					Data_end <= '1';
				else
					Data_end <= '0';
				end if;
			else
				NUll;
			end if;
		end if;
	end process;
				
	
process(aReset,clkout)
begin
	if aReset = '1' then
		dataout_I0 <= (others => '0');
		dataout_Q0 <= (others => '0');
		dataout_I1 <= (others => '0');
		dataout_Q1 <= (others => '0');	
	elsif rising_edge(clkout) then
		if data_MOD = '0' then
			if data_map0 = "0010" then
				dataout_I0 <= std_logic_vector(to_signed(-cons_Qpsk, kOutSize));
				dataout_Q0 <= std_logic_vector(to_signed(-cons_Qpsk, kOutSize));
			elsif data_map0 = "1110" then
				dataout_I0 <= std_logic_vector(to_signed(cons_Qpsk, kOutSize));
				dataout_Q0 <= std_logic_vector(to_signed(cons_Qpsk, kOutSize));
			else
				dataout_I0 <= std_logic_vector(to_signed(0, kOutSize));
				dataout_Q0 <= std_logic_vector(to_signed(0, kOutSize));
			end if;
			if data_map1 = "0010" then
				dataout_I1 <= std_logic_vector(to_signed(-cons_Qpsk, kOutSize));
				dataout_Q1 <= std_logic_vector(to_signed(-cons_Qpsk, kOutSize));
			elsif data_map1 = "1110" then
				dataout_I1 <= std_logic_vector(to_signed(cons_Qpsk, kOutSize));
				dataout_Q1 <= std_logic_vector(to_signed(cons_Qpsk, kOutSize));
			else
				dataout_I1 <= std_logic_vector(to_signed(0, kOutSize));
				dataout_Q1 <= std_logic_vector(to_signed(0, kOutSize));
			end if;
		else
			case data_map0 is
				when "0000" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "0001" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "0010" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "0011" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1000" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "1001" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1010" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "1011" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1100" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "1101" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "1110" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "1111" =>
						dataout_I0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "0100" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "0101" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "0110" =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when others =>
						dataout_I0 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q0 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
			end case;
			case data_map1 is
				when "0000" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "0001" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "0010" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "0011" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1000" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "1001" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1010" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
				when "1011" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
				when "1100" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "1101" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "1110" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "1111" =>
						dataout_I1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "0100" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when "0101" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold1, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
				when "0110" =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold1, kOutSize));
				when others =>
						dataout_I1 <= std_logic_vector(to_signed(-cons_threshold2, kOutSize));
						dataout_Q1 <= std_logic_vector(to_signed(cons_threshold2, kOutSize));
			end case;
		end if;
	end if;
end process;	
end rtl;