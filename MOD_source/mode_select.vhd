library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mode_select is
generic(
			kInSize : positive := 14
	);
port(
		aReset : in std_logic;
		clk    : in std_logic;
		mode	 : in std_logic;
		dataA0 : in std_logic_vector(kInSize - 1 downto 0);
		dataA1 : in std_logic_vector(kInSize - 1 downto 0);
		dataA2 : in std_logic_vector(kInSize - 1 downto 0);
		dataA3 : in std_logic_vector(kInSize - 1 downto 0);
		dataA4 : in std_logic_vector(kInSize - 1 downto 0);
		dataA5 : in std_logic_vector(kInSize - 1 downto 0);
		dataA6 : in std_logic_vector(kInSize - 1 downto 0);
		dataA7 : in std_logic_vector(kInSize - 1 downto 0);
		dataB0 : in std_logic_vector(kInSize - 1 downto 0);
		dataB1 : in std_logic_vector(kInSize - 1 downto 0);
		dataB2 : in std_logic_vector(kInSize - 1 downto 0);
		dataB3 : in std_logic_vector(kInSize - 1 downto 0);
		dataB4 : in std_logic_vector(kInSize - 1 downto 0);
		dataB5 : in std_logic_vector(kInSize - 1 downto 0);
		dataB6 : in std_logic_vector(kInSize - 1 downto 0);
		dataB7 : in std_logic_vector(kInSize - 1 downto 0);
		
		dataout0 : out std_logic_vector(kInSize - 1 downto 0);
		dataout1 : out std_logic_vector(kInSize - 1 downto 0);
		dataout2 : out std_logic_vector(kInSize - 1 downto 0);
		dataout3 : out std_logic_vector(kInSize - 1 downto 0);
		dataout4 : out std_logic_vector(kInSize - 1 downto 0);
		dataout5 : out std_logic_vector(kInSize - 1 downto 0);
		dataout6 : out std_logic_vector(kInSize - 1 downto 0);
		dataout7 : out std_logic_vector(kInSize - 1 downto 0)
		);
end entity;

architecture rtl of mode_select is



begin
process(aReset,clk)
begin
	if aReset = '1' then
		dataout0 <= (others => '0');
		dataout1 <= (others => '0');
		dataout2 <= (others => '0');
		dataout3 <= (others => '0');
		dataout4 <= (others => '0');
		dataout5 <= (others => '0');
		dataout6 <= (others => '0');
		dataout7 <= (others => '0');
	elsif rising_edge(clk) then
		if mode = '0' then
			dataout0 <= dataA0;
			dataout1 <= dataA1;
			dataout2 <= dataA2;
			dataout3 <= dataA3;
			dataout4 <= dataA4;
			dataout5 <= dataA5;
			dataout6 <= dataA6;
			dataout7 <= dataA7;
		else
			dataout0 <= dataB0;
			dataout1 <= dataB1;
			dataout2 <= dataB2;
			dataout3 <= dataB3;
			dataout4 <= dataB4;
			dataout5 <= dataB5;
			dataout6 <= dataB6;
			dataout7 <= dataB7;
		end if;
	end if;
end process;
end rtl;