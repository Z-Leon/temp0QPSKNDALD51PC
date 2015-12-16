library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_4to8 is
port(
		aReset : in std_logic;
		clk : in std_logic;
		clkout : in std_logic;
		data_in0 : in std_logic_vector(3 downto 0);
		data_in1 : in std_logic_vector(3 downto 0);
		data_in2 : in std_logic_vector(3 downto 0);
		data_in3 : in std_logic_vector(3 downto 0);
		valid : in std_logic;
		
		data_out0 : out std_logic_vector(3 downto 0);
		data_out1 : out std_logic_vector(3 downto 0);
		data_out2 : out std_logic_vector(3 downto 0);
		data_out3 : out std_logic_vector(3 downto 0);
		data_out4 : out std_logic_vector(3 downto 0);
		data_out5 : out std_logic_vector(3 downto 0);
		data_out6 : out std_logic_vector(3 downto 0);
		data_out7 : out std_logic_vector(3 downto 0);
		validout : out std_logic);
end entity;


architecture rtl of data_4to8 is

component fifo_datap4top8 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdusedw		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;


signal counter : integer;
signal data_reg0,data_reg1,data_reg2,data_reg3 : std_logic_vector(3 downto 0);
signal rdreq ,rdreq_reg : std_logic;
signal rdusedw		: STD_LOGIC_VECTOR (7 DOWNTO 0);
signal q :  STD_LOGIC_VECTOR (31 DOWNTO 0);
signal comb_din : std_logic_vector(15 downto 0) ;

begin
comb_din <= data_in3 & data_in2 & data_in1 & data_in0;
fifo_datap4top8_inst : fifo_datap4top8 
	PORT map 
	(
		aclr		=> aReset,
		data		=> comb_din, --data_in3 & data_in2 & data_in1 & data_in0,
		rdclk		=> clkout,
		rdreq		=> rdreq,
		wrclk		=> clk,
		wrreq		=> valid,
		q		=> q,
		rdusedw		=> rdusedw
	);



process(clkout,aReset)
begin
	if aReset = '1' then
		--counter <= 0;
		data_out0 <= (others => '0');
		data_out1 <= (others => '0');
		data_out2 <= (others => '0');
		data_out3 <= (others => '0');
		data_out4 <= (others => '0');
		data_out5 <= (others => '0');
		data_out6 <= (others => '0');
		data_out7 <= (others => '0');
		validout <= '0';
		rdreq <= '0';
		rdreq_reg <= '0';
	elsif rising_edge(clkout) then
		if unsigned(rdusedw) >= 32 then
			rdreq <= '1';
		else
			rdreq <= '0';
		end if;
		
		rdreq_reg <= rdreq;

		
		if rdreq_reg = '1' then	
			data_out0 <= q(3 downto 0);
			data_out1 <= q(7 downto 4);
			data_out2 <= q(11 downto 8);
			data_out3 <= q(15 downto 12);
			data_out4 <= q(19 downto 16);
			data_out5 <= q(23 downto 20);
			data_out6 <= q(27 downto 24);
			data_out7 <= q(31 downto 28);
			validout <= '1';
		else	
			data_out0 <= (others => '0');
			data_out1 <= (others => '0');
			data_out2 <= (others => '0');
			data_out3 <= (others => '0');
			data_out4 <= (others => '0');
			data_out5 <= (others => '0');
			data_out6 <= (others => '0');
			data_out7 <= (others => '0');
			validout <= '0';
		end if;
	end if;
end process;
end rtl;