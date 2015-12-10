library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

 entity DNU_p is
    port( 
           clk     : in  std_logic;
	        reset   : in  std_logic; 
	        data_in : in  std_logic_vector(255 downto 0);
	        i_eop   : in  std_logic; 
	        
	        decision: out std_logic
	          );
 end entity;
 
  architecture rtl of DNU_p is
  
  signal decision_out:std_logic_vector(7 downto 0);
   component DNU is
       port(
           clk:     in  std_logic;
           reset:   in  std_logic;
           data_in: in  std_logic_vector(31 downto 0);
           data_out:out std_logic
           );
   end component;
    
  begin
      
     DNU_inst1 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(31 downto 0),
			data_out=>decision_out(0)
			 );
		
		DNU_inst2 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(63 downto 32),
			data_out=>decision_out(1)
			 );
		
		DNU_inst3 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(95 downto 64),
			data_out=>decision_out(2)
			 );
		
		DNU_inst4 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(127 downto 96),
			data_out=>decision_out(3)
			 );
		
		DNU_inst5 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(159 downto 128),
			data_out=>decision_out(4)
			 );
		
		DNU_inst6 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(191 downto 160),
			data_out=>decision_out(5)
			 );
		
		DNU_inst7 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(223 downto 192),
			data_out=>decision_out(6)
			 );
		
		DNU_inst8 : DNU 
		 port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(255 downto 224),
			data_out=>decision_out(7)
			 );
		
		decision<=(decision_out(6) or decision_out(5) or decision_out(4) or decision_out(3) or decision_out(2) or decision_out(1) or decision_out(0)) 
				  when (i_eop='1') else
				  (decision_out(7) or decision_out(6) or decision_out(5) or decision_out(4) or decision_out(3) or decision_out(2) or decision_out(1) or decision_out(0));
		--decision<=i_eop ? | decision_out(6 : 0)  downto   | decision_out);
   end rtl;