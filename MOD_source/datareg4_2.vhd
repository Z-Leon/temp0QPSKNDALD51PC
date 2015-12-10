library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datareg4_2 is
	generic(
		kInSize	 : positive := 14;
		kOutSize : positive := 60
	   );
	port(
		aReset	: in  std_logic;
		clk	: in  std_logic;
		cDin0	: in  std_logic_vector (kInSize-1 downto 0);
		cDin1	: in  std_logic_vector (kInSize-1 downto 0);
		cDin2	: in  std_logic_vector (kInSize-1 downto 0);
		cDin3	: in  std_logic_vector (kInSize-1 downto 0);
		cDout	: out std_logic_vector (kOutSize-1 downto 0)
		
		);
end datareg4_2;

architecture rtl of datareg4_2 is

begin


process( aReset, clk )
begin
	if aReset = '1' then
		cDout(4*kInSize-5 downto 0) <= ( others=>'0');
		cDout(4*kInSize-1) <= '1';
		cDout(4*kInSize-2) <= '1';
		cDout(4*kInSize-3) <= '1';
		cDout(4*kInSize-4) <= '1';
	elsif rising_edge( clk ) then
			cDout(4*kInSize-1) <= not(cDin0(kInSize-1));
			cDout(4*kInSize-2) <= not(cDin1(kInSize-1));
			cDout(4*kInSize-3) <= not(cDin2(kInSize-1));
			cDout(4*kInSize-4) <= not(cDin3(kInSize-1));
		for i in 0 to 4 loop 
			cDout(4*i+3) <= cDin0(i);
			cDout(4*i+2) <= cDin1(i);
			cDout(4*i+1) <= cDin2(i);
			cDout(4*i) <= cDin3(i);

		end loop;
			cDout(4*5+3) <= not cDin0(5);
			cDout(4*5+2) <= not cDin1(5);
			cDout(4*5+1) <= not cDin2(5);
			cDout(4*5) <= not cDin3(5);

		for i in 6 to 12 loop 
			cDout(4*i+3) <= cDin0(i);
			cDout(4*i+2) <= cDin1(i);
			cDout(4*i+1) <= cDin2(i);
			cDout(4*i) <= cDin3(i);

		end loop;
			
	end if;
end process;

			cDout(56) <= '1';
			cDout(57) <= '0';
			cDout(58) <= '1';
			cDout(59) <= '0';

end rtl;	