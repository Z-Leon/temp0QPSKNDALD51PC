library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	CNU_p	 is         
port(
     clk     : in  std_logic;
	  reset   : in  std_logic;
	  data_in : in  std_logic_vector(1023 downto 0);
	  data_out: out  std_logic_vector(1023 downto 0)
      );	 
end	CNU_p;
  
architecture rtl of CNU_p is
    
    component CNU is
        port( 
          clk     : in  std_logic;
	       reset   : in  std_logic;
	       data_in : in  std_logic_vector(127 downto 0);
	       data_out: out std_logic_vector(127 downto 0)
		     );
	  end component;
	  
  begin
    		CNU_inst1:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(127 downto 0),
			--i_val=>i_val,
			data_out=>data_out(127 downto 0)
			--o_val=>o_val
		   );
		
	    CNU_inst2:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(255 downto 128),
			--i_val=>i_val,
			data_out=>data_out(255 downto 128)
			--o_val=>o_val
		);
		
	    CNU_inst3:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(383 downto 256),
			--i_val=>i_val,
			data_out=>data_out(383 downto 256)
			--o_val=>o_val
		);
		
	   CNU_inst4:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(511 downto 384),
			--i_val=>i_val,
			data_out=>data_out(511 downto 384)
			--o_val=>o_val
		);
		
	   CNU_inst5:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(639 downto 512),
			--i_val=>i_val,
			data_out=>data_out(639 downto 512)
			--o_val=>o_val
		   );
		
	   CNU_inst6:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(767 downto 640),
			--i_val=>i_val,
			data_out=>data_out(767 downto 640)
			--o_val=>o_val
		);
		
	   CNU_inst7:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(895 downto 768),
			--i_val=>i_val,
			data_out=>data_out(895 downto 768)
			--o_val=>o_val
		);
		
	   CNU_inst8:CNU
		port map(
			clk=>clk,
			reset=>reset,
			data_in=>data_in(1023 downto 896),
			--i_val=>i_val,
			data_out=>data_out(1023 downto 896)
			--o_val=>o_val
		 );
		 end rtl;