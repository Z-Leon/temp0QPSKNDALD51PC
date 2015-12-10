library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity VNU_p is
     port(
	 clk    : in std_logic;
	 reset 	: in std_logic;
	 
	 channel_in : in std_logic_vector(31 downto 0);   
	 data_in    : in std_logic_vector(127 downto 0);
	        
	 decision_out:out std_logic_vector(31 downto 0);
	 data_out    :out std_logic_vector(127 downto 0)
	 );
end entity;

architecture rtl of VNU_p is
 component VNU is
     port(
          clk       :in std_logic;
          reset     :in std_logic;
          channel_in:in std_logic_vector(3 downto 0);  
          data_in   :in std_logic_vector(15 downto 0);  
          
          decision_out:out std_logic_vector(3 downto 0);  
          data_out    :out std_logic_vector(15 downto 0)
          ); 
 end component; 
 
 begin
  	   VNU_inst1 :VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(3 downto 0),
			data_in=>data_in(15 downto 0),
			--i_val=>i_val,
			decision_out=>decision_out(3 downto 0),
			data_out=>data_out(15 downto 0)
			--o_val=>o_val
			 );
		
		VNU_inst2  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(7 downto 4),
			data_in=>data_in(31 downto 16),
			--i_val=>i_val,
			decision_out=>decision_out(7 downto 4),
			data_out=>data_out(31 downto 16)
			--o_val=>o_val
			 );
		
		VNU_inst3  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(11 downto 8),
			data_in=>data_in(47 downto 32),
			--i_val=>i_val,
			decision_out=>decision_out(11 downto 8),
			data_out=>data_out(47 downto 32)
			--o_val=>o_val
			 );
		
		VNU_inst4  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(15 downto 12),
			data_in=>data_in(63 downto 48),
			--i_val=>i_val,
			decision_out=>decision_out(15 downto 12),
			data_out=>data_out(63 downto 48)
			--o_val=>o_val
			 );
		
		
		VNU_inst5  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(19 downto 16),
			data_in=>data_in(79 downto 64),
			--i_val=>i_val,
			decision_out=>decision_out(19 downto 16),
			data_out=>data_out(79 downto 64)
			--o_val=>o_val
			 );
		
		VNU_inst6  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(23 downto 20),
			data_in=>data_in(95 downto 80),
			--i_val=>i_val,
			decision_out=>decision_out(23 downto 20),
			data_out=>data_out(95 downto 80)
			--o_val=>o_val
			 );
		
		VNU_inst7  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(27 downto 24),
			data_in=>data_in(111 downto 96),
			--i_val=>i_val,
			decision_out=>decision_out(27 downto 24),
			data_out=>data_out(111 downto 96)
			--o_val=>o_val
			 );
		
		VNU_inst8  : VNU
		  port map(
			clk=>clk,
			reset=>reset,
			channel_in=>channel_in(31 downto 28),
			data_in=>data_in(127 downto 112),
			--i_val=>i_val,
			decision_out=>decision_out(31 downto 28),
			data_out=>data_out(127 downto 112)
			--o_val=>o_val
			 );   
	end rtl;