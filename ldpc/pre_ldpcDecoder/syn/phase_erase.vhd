-------------------------------------------------------------------------------
--
-- File: phase_erase.vhd
-- Author: wency 
-- Original Project: 
-- Date: 2010.10
--
-------------------------------------------------------------------------------
--
-- (c) 2010 Copyright Wireless Broadband Transmission Lab
-- All Rights Reserved
-- EE Dept. at Tsinghua University.
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- This file is to find correlation peak of incoming data and to erase the phase shift
-- output o_src_asm(i) is 1 at position of the start of frame
-------------------------------------------------------------------------------

library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	phase_erase	 is         
port(
	 clk       : in std_logic;
	 reset     : in std_logic;
	 
	 data_in    : in std_logic_vector(32 downto 1);
	 data_in_val: in std_logic;
	 corr_sum   : in std_logic_vector(24 downto 1);
	 state_in   : in std_logic_vector( 3 downto 1);
	 
	 data_out    :out std_logic_vector(32 downto 1);
	 data_out_val:out std_logic
	 );	 
end	phase_erase;

architecture rtl of phase_erase is
   
   constant shift0   :std_logic_vector(3 downto 1):="001";
   constant shift90  :std_logic_vector(3 downto 1):="010";
	constant shift180 :std_logic_vector(3 downto 1):="011";
	constant shift270 :std_logic_vector(3 downto 1):="100";
	
   signal shift_state_reg :std_logic_vector(3 downto 1);
   signal shift_state :std_logic_vector(3 downto 1);
   
 begin 
  process(clk,reset)
	 begin
	  if(reset='1') then
	      shift_state_reg<="000";
	  elsif(clk'event and clk='1') then  
		   if(corr_sum(24 downto 22)/="000") then
		      shift_state_reg<=corr_sum(24 downto 22);
		   end if;
		   
		   if(corr_sum(21 downto 19)/="000") then
		      shift_state_reg<=corr_sum(21 downto 19);
		   end if;
		   
		   if(corr_sum(18 downto 16)/="000") then
		      shift_state_reg<=corr_sum(18 downto 16);
		   end if;
		   
			if(corr_sum(15 downto 13)/="000") then
		      shift_state_reg<=corr_sum(15 downto 13);
		   end if;
		   
		   if(corr_sum(12 downto 10)/="000") then
		      shift_state_reg<=corr_sum(12 downto 10);
		   end if;
		   
		   if(corr_sum(9 downto 7)/="000") then
		      shift_state_reg<=corr_sum(9 downto 7);
		   end if;
		   
		   if(corr_sum(6 downto 4)/="000") then
		      shift_state_reg<=corr_sum(6 downto 4);
		   end if;
		   
		   if(corr_sum(3 downto 1)/="000") then
		      shift_state_reg<=corr_sum(3 downto 1);
		   end if;
		end if;
	end	process;	
   
   process(reset,clk)
     begin
      if(reset='1') then
	      shift_state<="000";
	   elsif(clk'event and clk='1') then  
		   if(state_in="000") then
		       shift_state<=shift_state_reg;
		   else
		       shift_state<=shift_state;
		   end if;
		end if;
	end process;
	
	process(reset,clk)
     begin
      if(reset='1') then
	      data_out<=(others=>'0');
	      data_out_val<='0';
	   elsif(clk'event and clk='1') then 
	      data_out_val<=data_in_val; 
		   case shift_state is
		       when  shift0 =>
		          data_out<=data_in; 
		       when  shift90 =>
		          data_out(32 downto 29)<=data_in(28 downto 25);
		          data_out(28 downto 25)<=not data_in(32 downto 29); 
		          
		          data_out(24 downto 21)<=data_in(20 downto 17);
		          data_out(20 downto 17)<=not data_in(24 downto 21); 
		          
		          data_out(16 downto 13)<=data_in(12 downto 9);
		          data_out(12 downto 9) <=not data_in(16 downto 13); 
		          
		          data_out(8 downto 5)  <=data_in(4 downto 1);
		          data_out(4 downto 1)  <=not data_in(8 downto 5); 
		      
		       when  shift180 =>
		          data_out(32 downto 29)<=not data_in(32 downto 29);
		          data_out(28 downto 25)<=not data_in(28 downto 25); 
		          
		          data_out(24 downto 21)<=not data_in(24 downto 21);
		          data_out(20 downto 17)<=not data_in(20 downto 17); 
		          
		          data_out(16 downto 13)<=not data_in(16 downto 13);
		          data_out(12 downto 9) <=not data_in(12 downto 9); 
		          
		          data_out(8 downto 5)  <=not data_in(8 downto 5);
		          data_out(4 downto 1)  <=not data_in(4 downto 1); 
		      
		      when  shift270 =>
		          data_out(32 downto 29)<=not data_in(28 downto 25);
		          data_out(28 downto 25)<=data_in(32 downto 29); 
		          
		          data_out(24 downto 21)<=not data_in(20 downto 17);
		          data_out(20 downto 17)<=data_in(24 downto 21); 
		          
		          data_out(16 downto 13)<=not data_in(12 downto 9);
		          data_out(12 downto 9) <=data_in(16 downto 13); 
		          
		          data_out(8 downto 5)  <=not data_in(4 downto 1);
		          data_out(4 downto 1)  <=data_in(8 downto 5);    
		      when  others =>
		          data_out<=data_in; 
		    end case;    
		end if;
	end process;

	
	end rtl;
	