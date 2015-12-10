library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CNU_cmp_concatenate_4 is
    port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1_A : in std_logic_vector(2 downto 0);
	        data_in2_A : in std_logic_vector(2 downto 0);
	        min_index_A: in std_logic_vector(3 downto 0);
	        
	        data_in1_B : in std_logic_vector(2 downto 0);
	        data_in2_B : in std_logic_vector(2 downto 0);
	        min_index_B: in std_logic_vector(3 downto 0);
	        
	        
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic_vector(4 downto 0)
		     );
end entity;

architecture rtl of CNU_cmp_concatenate_4 is
    signal min_cmp_wire1 :std_logic;
    signal min_cmp_wire2 :std_logic;
    signal min_cmp_wire3 :std_logic;
    signal min_index_wire:std_logic_vector(3 downto 0); 
   begin
   
process(data_in1_A , data_in1_B)
   begin
    if (data_in1_A >= data_in1_B) then
        min_cmp_wire1<= '1';
    elsif (data_in1_A < data_in1_B) then
        min_cmp_wire1<= '0';
	 else
	     min_cmp_wire1<= 'X';
	 end if;
end process;

process(data_in2_A , data_in1_B)
   begin
    if (data_in2_A >= data_in1_B) then
        min_cmp_wire2<= '1';
    elsif (data_in1_A < data_in1_B) then
        min_cmp_wire2<= '0';
	 else
	     min_cmp_wire2<= 'X';
	 end if;
end process;

process(data_in1_A , data_in2_B)
   begin
    if (data_in1_A >= data_in2_B) then
        min_cmp_wire3<= '1';
    elsif (data_in1_A < data_in2_B) then
        min_cmp_wire3<= '0';
	 else
	     min_cmp_wire3<= 'X';
	 end if;
end process;

 --   min_cmp_wire1 <='1' when (data_in1_A >= data_in1_B) else '0';
 --   min_cmp_wire2 <='1' when (data_in2_A >= data_in1_B) else '0';
 --   min_cmp_wire3 <='1' when (data_in1_A >= data_in2_B) else '0';
    min_index_wire<=min_index_B when ( min_cmp_wire1='1') else min_index_A;
    
 process(clk,reset)
   begin
    if (reset='1') then
      min1 <= "000";
		min2 <= "000";
		min_index <= "00000";
	  elsif (clk'event and clk='1') then
	     if (min_cmp_wire1='1') then
	       min1<=data_in1_B;
	     else
	       min1<=data_in1_A;
	     end if;
	     
	     if (min_cmp_wire1='1') then
	          if (min_cmp_wire3='1') then
	            min2<=data_in2_B;
	          else
	            min2<=data_in1_A; 
	          end if; 
	        else
	          if (min_cmp_wire2='1') then
	            min2<=data_in1_B;
	          else
	            min2<=data_in2_A; 
	          end if;
	      end if;
	      min_index <= min_cmp_wire1 & min_index_wire; 
	   end if; 
end process;
end rtl;