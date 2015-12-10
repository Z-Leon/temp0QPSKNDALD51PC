library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PN_gen8 is
port(
		aReset 	: in std_logic;
		clk		: in std_logic;
		PN_Dataout	: out std_logic_vector(7 downto 0)
		);
end entity;

architecture rtl of PN_gen8 is
signal a : std_logic_vector(22 downto 0);

begin
process(aReset,clk)
begin
	if aReset = '1' then
		a <= "01000000000000000000000";
		PN_Dataout <= (others => '0');
	elsif rising_edge(clk) then
		a(22 downto 15) <= a(7 downto 0) XOR a(12 downto 5); --a(8 downto 7);
		a(14 downto 0) <= a(22 downto 8);
		PN_Dataout <= a(7 downto 0);
	end if;
end process;
end rtl;