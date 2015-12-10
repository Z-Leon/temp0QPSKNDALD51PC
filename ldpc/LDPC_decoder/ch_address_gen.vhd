library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ch_address_gen	 is         
port(
	   clk       : in std_logic;
	   reset     : in std_logic;
	 
	   rdaddress_reset : in std_logic;
	   val       :       in std_logic;
      
      ch_waddress : out std_logic_vector(5 downto 0); 
	   ch_raddress : out std_logic_vector(95 downto 0)
	    );	 
end	ch_address_gen;

architecture rtl of ch_address_gen is
    
signal ch_waddress0 : std_logic_vector(5 downto 0); 
signal ch_raddress0 : std_logic_vector(95 downto 0); 

begin
process(clk,reset)
  begin
    if (reset='1') then
         ch_waddress0 <=(others=>'0');
		 ch_raddress0 <=(others=>'0'); 
	 elsif (clk'event and clk='1') then
	    if (rdaddress_reset='1') then
	        ch_raddress0<=(others=>'0');
	    else
	        ch_raddress0(5 downto 0) <= ch_raddress0(5 downto 0) + 1;
			  ch_raddress0(11 downto 6) <= ch_raddress0(11 downto 6) + 1;
			  ch_raddress0(17 downto 12) <= ch_raddress0(17 downto 12) + 1;
			  ch_raddress0(23 downto 18) <= ch_raddress0(23 downto 18) + 1;
			  ch_raddress0(29 downto 24) <= ch_raddress0(29 downto 24) + 1;
			  ch_raddress0(35 downto 30) <= ch_raddress0(35 downto 30) + 1;
			  ch_raddress0(41 downto 36) <= ch_raddress0(41 downto 36) + 1;
			  ch_raddress0(47 downto 42) <= ch_raddress0(47 downto 42) + 1;
			  ch_raddress0(53 downto 48) <= ch_raddress0(53 downto 48) + 1;
			  ch_raddress0(59 downto 54) <= ch_raddress0(59 downto 54) + 1;
			  ch_raddress0(65 downto 60) <= ch_raddress0(65 downto 60) + 1;
			  ch_raddress0(71 downto 66) <= ch_raddress0(71 downto 66) + 1;
			  ch_raddress0(77 downto 72) <= ch_raddress0(77 downto 72) + 1;
			  ch_raddress0(83 downto 78) <= ch_raddress0(83 downto 78) + 1;
			  ch_raddress0(89 downto 84) <= ch_raddress0(89 downto 84) + 1;
			  ch_raddress0(95 downto 90) <= ch_raddress0(95 downto 90) + 1;
			 end if;
		       if (val='1') then
			       ch_waddress0 <= ch_waddress0 + 1;
		        else
			       ch_waddress0 <= ch_waddress0;
			   end if;
			
		end if;
 end process;
	ch_raddress <=ch_raddress0 ;
	ch_waddress <=ch_waddress0	;
 end rtl;
	 
	      