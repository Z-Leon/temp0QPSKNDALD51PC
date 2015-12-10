library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	VNU_block	 is         
port(
	 clk        :in std_logic;
	 reset      :in std_logic;
	 
	 channel_in :in std_logic_vector(511 downto 0);
	 data_in    :in std_logic_vector(2047 downto 0);
	 
    decision_out :out std_logic_vector(511 downto 0); 
	 data_out  :out std_logic_vector(2047 downto 0)
	   );	 
end	VNU_block;

architecture rtl of VNU_block is
  component VNU_p is
     port(
	 clk    : in std_logic;
	 reset 	: in std_logic;
	 
	 channel_in : in std_logic_vector(31 downto 0);   
	 data_in    : in std_logic_vector(127 downto 0);
	        
	 decision_out:out std_logic_vector(31 downto 0);
	 data_out    :out std_logic_vector(127 downto 0)
	 );
  end component;
 
 begin
   VNU_p_inst1:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(31 downto 0),  
	  data_in=>data_in(127 downto 0),     
	  decision_out=>decision_out(31 downto 0),
	  data_out =>data_out(127 downto 0)
	  );
	  
	VNU_p_inst2:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(63 downto 32),  
	  data_in=>data_in(255 downto 128),     
	  decision_out=>decision_out(63 downto 32),
	  data_out =>data_out(255 downto 128)
	  );
	  
	VNU_p_inst3:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(95 downto 64),  
	  data_in=>data_in(383 downto 256),     
	  decision_out=>decision_out(95 downto 64),
	  data_out =>data_out(383 downto 256)
	  );
	  
	VNU_p_inst4:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(127 downto 96),  
	  data_in=>data_in(511 downto 384),     
	  decision_out=>decision_out(127 downto 96),
	  data_out =>data_out(511 downto 384)
	  );
	  
	VNU_p_inst5:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(159 downto 128),  
	  data_in=>data_in(639 downto 512),     
	  decision_out=>decision_out(159 downto 128),
	  data_out =>data_out(639 downto 512)
	  );
	  
	 VNU_p_inst6:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(191 downto 160),  
	  data_in=>data_in(767 downto 640),     
	  decision_out=>decision_out(191 downto 160),
	  data_out =>data_out(767 downto 640)
	  );
	  
	VNU_p_inst7:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(223 downto 192),  
	  data_in=>data_in(895 downto 768),     
	  decision_out=>decision_out(223 downto 192),
	  data_out =>data_out(895 downto 768)
	  );
	  
	VNU_p_inst8:VNU_p
   port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(255 downto 224),  
	  data_in=>data_in(1023 downto 896),     
	  decision_out=>decision_out(255 downto 224),
	  data_out =>data_out(1023 downto 896)
	  );
	  
	VNU_p_inst9:VNU_p
    port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(287 downto 256),  
	  data_in=>data_in(1151 downto 1024),     
	  decision_out=>decision_out(287 downto 256),
	  data_out =>data_out(1151 downto 1024)
	  );
	  
	VNU_p_inst10:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(319 downto 288),  
	  data_in=>data_in(1279 downto 1152),     
	  decision_out=>decision_out(319 downto 288),
	  data_out =>data_out(1279 downto 1152)
	  ); 
	 
	 VNU_p_inst11:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(351 downto 320),  
	  data_in=>data_in(1407 downto 1280),     
	  decision_out=>decision_out(351 downto 320),
	  data_out =>data_out(1407 downto 1280)
	  ); 
	  
	  VNU_p_inst12:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(383 downto 352),  
	  data_in=>data_in(1535 downto 1408),     
	  decision_out=>decision_out(383 downto 352),
	  data_out =>data_out(1535 downto 1408)
	  ); 
	 
	  VNU_p_inst13:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(415 downto 384),  
	  data_in=>data_in(1663 downto 1536),     
	  decision_out=>decision_out(415 downto 384),
	  data_out =>data_out(1663 downto 1536)
	  ); 
	  
	  VNU_p_inst14:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(447 downto 416),  
	  data_in=>data_in(1791 downto 1664),     
	  decision_out=>decision_out(447 downto 416),
	  data_out =>data_out(1791 downto 1664)
	  ); 
	  
	  VNU_p_inst15:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(479 downto 448),  
	  data_in=>data_in(1919 downto 1792),     
	  decision_out=>decision_out(479 downto 448),
	  data_out =>data_out(1919 downto 1792)
	  ); 
	  
	  VNU_p_inst16:VNU_p
     port map(
     clk=>clk,
	  reset=>reset,	
	  channel_in=>channel_in(511 downto 480),  
	  data_in=>data_in(2047 downto 1920),     
	  decision_out=>decision_out(511 downto 480),
	  data_out =>data_out(2047 downto 1920)
	  ); 
	  
	end rtl;
	 