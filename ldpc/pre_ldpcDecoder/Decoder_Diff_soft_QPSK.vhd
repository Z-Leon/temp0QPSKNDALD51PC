library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder_Diff_soft_QPSK is
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		Decode_Mode	: in std_logic_vector(2 downto 0);
		datain_i0	: in std_logic_vector(3 downto 0);
		datain_i1	: in std_logic_vector(3 downto 0);
		datain_q0	: in std_logic_vector(3 downto 0);
		datain_q1	: in std_logic_vector(3 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(3 downto 0);
		dataout_i1       : out  std_logic_vector(3 downto 0);
		dataout_q0       : out  std_logic_vector(3 downto 0);
		dataout_q1       : out  std_logic_vector(3 downto 0);
		dataout_valid   : out  std_logic 
	);
end entity;

architecture rtl of Decoder_Diff_soft_QPSK is
signal datain_i0_reg,datain_q0_reg,datain_i1_reg,datain_q1_reg : std_logic_vector(3 downto 0);
signal dataout_i0_reg0,dataout_q0_reg0,dataout_i1_reg0,dataout_q1_reg0 : std_logic_vector(3 downto 0);
signal dataout_valid_reg : std_logic;
begin
	process(aReset,clk)
		variable temp0,temp1 : std_logic_vector(1 downto 0);
	begin
		if aReset = '1' then
			datain_i0_reg <= (others => '0');
			datain_q0_reg <= (others => '0');
			datain_i1_reg <= (others => '0');
			datain_q1_reg <= (others => '0');
			temp0 := "00";
			temp1 := "00";
			dataout_i0_reg0 <= (others => '0');
			dataout_i1_reg0 <= (others => '0');
			dataout_q0_reg0 <= (others => '0');
			dataout_q1_reg0 <= (others => '0');
			dataout_valid_reg <= '0';
		elsif rising_edge(clk) then
			if datain_valid = '1' then
				datain_i0_reg <= datain_i0;
				datain_q0_reg <= datain_q0;
				datain_i1_reg <= datain_i1;
				datain_q1_reg <= datain_q1;
				temp0 := datain_i1_reg(3) & datain_q1_reg(3);
				temp1 := datain_i0(3) & datain_q0(3);
				case temp0 is
					when "00" =>
						dataout_i0_reg0(3) <= (datain_i0(3)) xor (datain_i1_reg(3));
						dataout_q0_reg0(3) <= (datain_q0(3)) xor (datain_q1_reg(3));
						dataout_i0_reg0(2 downto 0) <= datain_i0(2 downto 0);
						dataout_q0_reg0(2 downto 0) <= datain_q0(2 downto 0);
					when "01" =>
						dataout_i0_reg0(3) <= (datain_q0(3)) xor (datain_q1_reg(3));
						dataout_q0_reg0(3) <= (datain_i0(3)) xor (datain_i1_reg(3));
						dataout_i0_reg0(2 downto 0) <= datain_q0(2 downto 0);
						dataout_q0_reg0(2 downto 0) <= datain_i0(2 downto 0);
					when "10" =>
						dataout_i0_reg0(3) <= (datain_q0(3)) xor (datain_q1_reg(3));
						dataout_q0_reg0(3) <= (datain_i0(3)) xor (datain_i1_reg(3));
						dataout_i0_reg0(2 downto 0) <= datain_q0(2 downto 0);
						dataout_q0_reg0(2 downto 0) <= datain_i0(2 downto 0);
					when others =>
						dataout_i0_reg0(3) <= (datain_i0(3)) xor (datain_i1_reg(3));
						dataout_q0_reg0(3) <= (datain_q0(3)) xor (datain_q1_reg(3));
						dataout_i0_reg0(2 downto 0) <= datain_i0(2 downto 0);
						dataout_q0_reg0(2 downto 0) <= datain_q0(2 downto 0);
					end case;
				case temp1 is
					when "00" =>
						dataout_i1_reg0(3) <= datain_i1(3) xor datain_i0(3);
						dataout_q1_reg0(3) <= datain_q1(3) xor datain_q0(3);
						dataout_i1_reg0(2 downto 0) <= datain_i1(2 downto 0);
						dataout_q1_reg0(2 downto 0) <= datain_q1(2 downto 0);
					when "01" =>
						dataout_i1_reg0(3) <= datain_q1(3) xor datain_q0(3);
						dataout_q1_reg0(3) <= datain_i1(3) xor datain_i0(3);
						dataout_i1_reg0(2 downto 0) <= datain_q1(2 downto 0);
						dataout_q1_reg0(2 downto 0) <= datain_i1(2 downto 0);
					when "10" =>
						dataout_i1_reg0(3) <= datain_q1(3) xor datain_q0(3);
						dataout_q1_reg0(3) <= datain_i1(3) xor datain_i0(3);
						dataout_i1_reg0(2 downto 0) <= datain_q1(2 downto 0);
						dataout_q1_reg0(2 downto 0) <= datain_i1(2 downto 0);
					when others =>
						dataout_i1_reg0(3) <= datain_i1(3) xor datain_i0(3);
						dataout_q1_reg0(3) <= datain_q1(3) xor datain_q0(3);
						dataout_i1_reg0(2 downto 0) <= datain_i1(2 downto 0);
						dataout_q1_reg0(2 downto 0) <= datain_q1(2 downto 0);
				end case;
				
				dataout_valid_reg <= '1';
			else
				dataout_valid_reg <= '0';
			end if;
		end if;
	end process;
	
	process(aReset,clk)
	begin
		if aReset = '1' then
			dataout_i0 <= (others => '0');
			dataout_q0 <= (others => '0');
			dataout_i1 <= (others => '0');
			dataout_q1 <= (others => '0');
			dataout_valid <= '0';
		elsif rising_edge(clk) then
			if Decode_Mode = "011" then
				if dataout_valid_reg = '1' then
					dataout_i0 <= not dataout_i0_reg0(3) & not(dataout_i0_reg0(3) xor dataout_i0_reg0(2)) & not(dataout_i0_reg0(3) xor dataout_i0_reg0(1)) & not(dataout_i0_reg0(3) xor dataout_i0_reg0(0)) ;
					dataout_i1 <= not dataout_i1_reg0(3) & not(dataout_i1_reg0(3) xor dataout_i1_reg0(2)) & not(dataout_i1_reg0(3) xor dataout_i1_reg0(1)) & not(dataout_i1_reg0(3) xor dataout_i1_reg0(0)) ;
					dataout_q0 <= not dataout_q0_reg0(3) & not(dataout_q0_reg0(3) xor dataout_q0_reg0(2)) & not(dataout_q0_reg0(3) xor dataout_q0_reg0(1)) & not(dataout_q0_reg0(3) xor dataout_q0_reg0(0)) ;
					dataout_q1 <= not dataout_q1_reg0(3) & not(dataout_q1_reg0(3) xor dataout_q1_reg0(2)) & not(dataout_q1_reg0(3) xor dataout_q1_reg0(1)) & not(dataout_q1_reg0(3) xor dataout_q1_reg0(0)) ;
					dataout_valid <= '1';
				else
					dataout_valid <= '0';
				end if;
			else
				if datain_valid = '1' then
					dataout_i0 <= not datain_i0(3) & not(datain_i0(3) xor datain_i0(2)) & not(datain_i0(3) xor datain_i0(1)) & not(datain_i0(3) xor datain_i0(0)) ;
					dataout_i1 <= not datain_i1(3) & not(datain_i1(3) xor datain_i1(2)) & not(datain_i1(3) xor datain_i1(1)) & not(datain_i1(3) xor datain_i1(0)) ;
					dataout_q0 <= not datain_q0(3) & not(datain_q0(3) xor datain_q0(2)) & not(datain_q0(3) xor datain_q0(1)) & not(datain_q0(3) xor datain_q0(0)) ;
					dataout_q1 <= not datain_q1(3) & not(datain_q1(3) xor datain_q1(2)) & not(datain_q1(3) xor datain_q1(1)) & not(datain_q1(3) xor datain_q1(0)) ;
					dataout_valid <= '1';
				else
					dataout_valid <= '0';
				end if;
			end if;
		end if;
	end process;
end rtl;



					
		