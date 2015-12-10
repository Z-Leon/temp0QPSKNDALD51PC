library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

 entity CNU_normalization is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic; 
	        data_in : in std_logic_vector(2 downto 0);
	        data_out: out std_logic_vector(2 downto 0)
	          );
 end entity;
 
 architecture rtl of CNU_normalization is
  
  signal data_add:std_logic_vector(4 downto 0);
  
  begin
      data_add<=('0' & data_in &'0')+("00" & data_in);
  
  process(clk,reset)
    begin
      if (reset='1') then
          data_out<="000";
        elsif (clk'event and clk='1') then
            data_out<=data_add(4 downto 2);
    end if;
  end process;
  
  end rtl;
   