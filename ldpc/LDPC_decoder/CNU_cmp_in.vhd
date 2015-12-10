library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

   entity CNU_cmp_in is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1: in std_logic_vector(2 downto 0);
	        data_in2: in std_logic_vector(2 downto 0);
	        
	        min1    : out std_logic_vector(2 downto 0);
	        min2    : out std_logic_vector(2 downto 0);
	        min_index: out std_logic
		      );
   end entity;
  architecture rtl of CNU_cmp_in is
   
    signal min_index_wire:std_logic; 
    
    begin
        
    --min_index_wire<= '1'  when (data_in1 >= data_in2)  else '0';
  process(data_in1,data_in2)
   begin
    if (data_in1 >= data_in2) then
        min_index_wire<= '1';
    elsif (data_in1 < data_in2) then
        min_index_wire<= '0';
	 else
	     min_index_wire<= 'X';
	   end if;
  end process;
  
  --process(clk,reset)
  -- begin
  -- if (reset='1') then
  --    min1 <= "000";
	--	min1 <= "000";
	--  elsif (clk'event and clk='1') then
	--    min_index <= min_index_wire;
	--     if (min_index_wire='1') then
	--       min1<=data_in2;
	--       min2<=data_in1;
	--     else
	--       min1<=data_in1;
	--       min2<=data_in2;
	--     end if;
	--  end if;
 -- end process;
  
  --付的程序实际上有点问题，初始化不对，但为了好找程序的错误，任和其一样，到最后再改，下面才是正确的
  process(clk,reset)
   begin
    if (reset='1') then
       min1 <= "000";
       min2 <= "000";
    	  min_index <='0';
    elsif (clk'event and clk='1') then
       min_index <= min_index_wire;
       if (min_index_wire='1') then
	       min1<=data_in2;
	       min2<=data_in1;
	     else
	      min1<=data_in1;
	       min2<=data_in2;
	     end if;
	   end if;
    end process;
end rtl;
	     