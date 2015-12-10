library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity	CNU_block	 is         
port(
	 clk   : in std_logic;
	 reset : in std_logic;
	 data_in  :in std_logic_vector(2047 downto 0); 
	 data_out :out std_logic_vector(2047 downto 0)
	 );	 
end	CNU_block;

architecture rtl of CNU_block is 

component CNU_p is
    port(
	 clk    : in std_logic;
	 reset 	: in std_logic;
	 
	 data_in  :in std_logic_vector(1023 downto 0); 
	 data_out :out std_logic_vector(1023 downto 0)
	      );
  end component;  
 
 
  begin  
   CNU_p_inst1:CNU_p 
    port map(
	 clk=>clk,
	 reset=>reset,	
	 data_in=>data_in(1023 downto 0),
	 data_out=>data_out(1023 downto 0)
	   );
	 
	CNU_p_inst2:CNU_p 
    port map(
	 clk=>clk,
	 reset=>reset,	
	 data_in=>data_in(2047 downto 1024),
	 data_out=>data_out(2047 downto 1024)
	  );
	    
  end rtl;
