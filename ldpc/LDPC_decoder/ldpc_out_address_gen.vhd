library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ldpc_out_address_gen	 is         
port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   
   waddress      : out  std_logic_vector(95 downto 0);
   waddress_dly2 : out  std_logic_vector(95 downto 0);
   raddress      : out  std_logic_vector(5 downto 0)
   );	 
end	ldpc_out_address_gen;

architecture rtl of ldpc_out_address_gen is

signal waddress0      : std_logic_vector(95 downto 0);
signal waddress_dly20 : std_logic_vector(95 downto 0);
signal raddress0      : std_logic_vector(5 downto 0);

signal waddress_dly1  : std_logic_vector(95 downto 0);

begin
 process(clk,reset)
    begin
       if (reset='1') then
          waddress_dly1<=(others=>'0');
		    waddress_dly20<=(others=>'0');
		    elsif (clk'event and clk='1') then
		    waddress_dly1<=waddress0;
		    waddress_dly20<=waddress_dly1;
		  end if;
 end process;  
  
  process(clk,reset)
    begin
       if (reset='1') then
          waddress0 <= (others=>'0');
		    raddress0 <= (others=>'0');
		   elsif (clk'event and clk='1') then
		    waddress0(5 downto 0) <= waddress0(5 downto 0) + 1;
		    waddress0(11 downto 6) <= waddress0(11 downto 6) + 1;
		    waddress0(17 downto 12) <= waddress0(17 downto 12) + 1;
		    waddress0(23 downto 18) <= waddress0(23 downto 18) + 1;
		    waddress0(29 downto 24) <= waddress0(29 downto 24) + 1;
		    waddress0(35 downto 30) <= waddress0(35 downto 30) + 1;
		    waddress0(41 downto 36) <= waddress0(41 downto 36) + 1;
		    waddress0(47 downto 42) <= waddress0(47 downto 42) + 1;
	    	  waddress0(53 downto 48) <= waddress0(53 downto 48) + 1;
	    	  waddress0(59 downto 54) <= waddress0(59 downto 54) + 1;
		    waddress0(65 downto 60) <= waddress0(65 downto 60) + 1;
		    waddress0(71 downto 66) <= waddress0(71 downto 66) + 1;
		    waddress0(77 downto 72) <= waddress0(77 downto 72) + 1;
		    waddress0(83 downto 78) <= waddress0(83 downto 78) + 1;
		    waddress0(89 downto 84) <= waddress0(89 downto 84) + 1;
		    waddress0(95 downto 90) <= waddress0(95 downto 90) + 1;
		
		    raddress0 <= raddress0 + 1;
		  end if;
  end process;  
   
   waddress<=waddress0;
   waddress_dly2<=waddress_dly20;
   raddress<=raddress0;
 end rtl;
		        