library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity P8toP8_LDPC is
port(
		aReset : in std_logic;
		clkin : in std_logic;
		clkout : in std_logic;
		i_data : in std_logic_vector(31 downto 0);
		i_sop  : in std_logic;
		i_valid: in std_logic;
		i_eop  : in std_logic;
		
		o_data : out std_logic_vector(31 downto 0);
      o_valid : out std_logic;
      o_sop  : out std_logic;
      o_eop  : out std_logic
);
end entity;

architecture rtl of P8toP8_LDPC is


component fifo_P8toP8 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdusedw		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;

signal rdreq : std_logic;
signal fifo_out : std_logic_vector(31 downto 0);
signal rdusedw : std_logic_vector(11 downto 0);
signal enablereg,sop_reg,eop_reg : std_logic;
signal enablereg1,sop_reg1,eop_reg1 : std_logic;
signal counter : integer;

begin

fifo_P8toP8_inst : fifo_P8toP8
	PORT map
	(
		aclr		=> aReset,
		data		=> i_data,
		rdclk		=> clkout,
		rdreq		=> rdreq,
		wrclk		=> clkin,
		wrreq		=> i_valid,
		q			=> fifo_out,
		rdusedw		=> rdusedw
	);


process(aReset,clkout)
begin
	if aReset = '1' then
		rdreq <= '0';
		counter <= 0;
		enablereg <= '0';
		sop_reg <= '0';
		eop_reg <= '0';
	elsif rising_edge(clkout) then
		if counter = 0 and unsigned(rdusedw) >= 1020 then
			counter <= 1;
		elsif counter >= 1 and counter <= 1019 then
			counter <= counter + 1;
		else
			counter <= 0;
		end if;
	
		if counter >= 1 and counter <= 1020 then
			rdreq <= '1';
		else
			rdreq <= '0';
		end if;
		
		if counter >= 1 and counter <= 1020 then
			enablereg <= '1';
		else
			enablereg <= '0';
		end if;
		
		if counter = 1 then
			sop_reg <= '1';
		else
			sop_reg <= '0';
		end if;
		
		if counter = 1020 then
			eop_reg <= '1';
		else
			eop_reg <= '0';
		end if;
		
	end if;
end process;


process(aReset,clkout)
begin
	if aReset = '1' then
		o_valid <= '0';
		o_sop <= '0';
		o_eop <= '0';
		o_data <= (others => '0');
		enablereg1 <= '0';
		sop_reg1 <= '0';
		eop_reg1 <= '0'; 
	elsif rising_edge(clkout) then
		enablereg1 <= enablereg;
		o_valid <= enablereg1;
		sop_reg1 <= sop_reg;
		o_sop <= sop_reg1;
		eop_reg1 <= eop_reg;
		o_eop <= eop_reg1;
		o_data <= fifo_out;--(3 downto 0) & fifo_out(7 downto 4) & fifo_out(11 downto 8) & fifo_out(15 downto 12) & fifo_out(19 downto 16) & fifo_out(23 downto 20) & fifo_out(27 downto 24) & fifo_out(31 downto 28);
	end if;
end process;

end rtl;