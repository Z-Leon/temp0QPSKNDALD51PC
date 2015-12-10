-------------------------------------------------------------------------------
--
-- File: asm_modify.v
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
-- This file is to make use of incoming data with frame syn maker
-- Output is the frame data without frame head,but with the signal of start,end,valid
-- This file is a parallel version based on asm_modify_p.v written by wxf
-------------------------------------------------------------------------------

library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	asm_modify	 is         
port(
	 clk       : in std_logic;
	 reset     : in std_logic;
	 
	 data_in   : in std_logic_vector(32 downto 1);
	 i_sink_asm: in std_logic_vector(8 downto 1);    --attached syn maker(asm)
	 i_sink_val: in std_logic;
	  i_framelengthsub1: in std_logic_vector(10 downto 1);
	 
	 dataout32   : out std_logic_vector(32 downto 1);
	 o_sop       : out std_logic;  --每一帧的开始输出信号
    o_eop       : out std_logic;  --每一帧的输出结束信号
    o_val       : out std_logic;  --输出数据有效信号
    s_state     : out std_logic_vector(3 downto 1)
    );	 
end	asm_modify;

architecture rtl of asm_modify is
   --constant i_framelengthsub1:std_logic_vector(10 downto 1):="11"& x"ff"; --4+8160/8-1=1024-1=1023
   --constant i_framelengthsub1:std_logic_vector(10 downto 1):="01"& x"02"; --4+8160/8-1=1024-1=1023
	
   constant c_intl :std_logic_vector(3 downto 1):="000";
	constant c_acqu :std_logic_vector(3 downto 1):="001";
	constant c_sync :std_logic_vector(3 downto 1):="010";
	constant c_warn :std_logic_vector(3 downto 1):="100";
	
	
   signal  s_data_in_reg1 :std_logic_vector(32 downto 1);    --输入数据寄存
	signal  s_data_in_reg2 :std_logic_vector(32 downto 1);
	
	signal  s_sink_data_reg1 :std_logic_vector(8 downto 1);  --输入数据的符号位寄存
	signal  s_sink_data_reg2 :std_logic_vector(8 downto 1);
	
	signal  s_sink_asm_reg1 :std_logic_vector(8 downto 1);    --输入同步信号提示信号
	signal  s_sink_asm_reg2 :std_logic_vector(8 downto 1);
	signal  s_sink_asm_reg3 :std_logic_vector(8 downto 1);
	signal  s_sink_asm_reg4 :std_logic_vector(8 downto 1);
	
	
	signal  s_bytecnt :std_logic_vector(10 downto 1);
	signal  s_cntreg  :std_logic_vector(10 downto 1);
	signal  s_out_cnt :std_logic_vector(10 downto 1);
	
	signal  s_syn_data_reg       :std_logic_vector(32 downto 1);
	
	signal  s_asm_position_flag  :std_logic_vector(4 downto 1);
	signal  s_asm_position_flag1 :std_logic_vector(4 downto 1);
	signal  s_asm_syn_flag       :std_logic_vector(4 downto 1);
	
	signal s_samebyte_cond :std_logic;
	signal s_priobyte_cond :std_logic;
	signal s_nextbyte_cond :std_logic;
	
	signal s_samebyte_cond_reg1 :std_logic;
	signal s_priobyte_cond_reg1 :std_logic;
	signal s_priobyte_cond_reg2 :std_logic;	
	
	signal s_priobyte_cnt_cond    :std_logic;
	signal s_nextbyte_cnt_cond    :std_logic;
	signal s_beyondrange_cnt_cond :std_logic;
	
	signal s_sink_val_reg1 :std_logic;
	signal s_val :std_logic;
	
	signal s_state0  : std_logic_vector(3 downto 1);
	
	signal s_asm_position_reg :std_logic_vector(8 downto 1);
	
	signal s_cntreg_sub1 :std_logic_vector(10 downto 1);
	signal s_cntreg_sub2 :std_logic_vector(10 downto 1);
	
	signal s_cond_syn    :boolean;
	signal s_cond_loseframehead :boolean;
	
	signal dataout8modify :std_logic_vector(8 downto 1);
	
	signal acframe_cnt:std_logic_vector(3 downto 1);
	signal lsframe_cnt:std_logic_vector(3 downto 1);
	
	begin 
	    
	  process(clk,reset)
	    begin
	    if (reset='1') then
	      s_data_in_reg1 <=(others=>'0');                                       --输入数据寄存
			s_data_in_reg2 <=(others=>'0');
				  
	      s_sink_data_reg1 <= x"00";                                            --输入数据的符号位寄存
			s_sink_data_reg2 <= x"00";
			
			s_sink_asm_reg1 <= x"00";
			s_sink_asm_reg2 <= x"00";
			s_sink_asm_reg3 <= x"00";			
			s_sink_asm_reg4 <= x"00";			
			
			s_sink_val_reg1 <= '0';
				
			elsif (clk'event and clk='1')	then
			    s_sink_val_reg1 <= i_sink_val;
			  if (i_sink_val='1') then
			     s_sink_data_reg1 <=data_in(32)&data_in(28)&data_in(24)&data_in(20)
			                       &data_in(16)&data_in(12)&data_in(8)&data_in(4);  --输入数据的符号位寄存
				  s_sink_data_reg2 <= s_sink_data_reg1;	
				
				  s_data_in_reg1 <=data_in;                                          --输入数据寄存
				  s_data_in_reg2 <= s_data_in_reg1;	
				  
				  s_sink_asm_reg1 <= i_sink_asm;	
				  s_sink_asm_reg2 <= s_sink_asm_reg1;
				  s_sink_asm_reg3 <= s_sink_asm_reg2;
				  s_sink_asm_reg4 <= s_sink_asm_reg3;	
			  end	if;
			end if;
	end process;
	
  --s_bytecnt is byte counter, 0~i_framelength-1
  process(clk,reset)
	begin
		if(reset='1') then
			s_bytecnt <= "00" & x"00";
		elsif (clk'event and clk='1' and i_sink_val='1')	then
		    if( s_bytecnt=i_framelengthsub1 ) then
				s_bytecnt<="00" & x"00";
		    else 
		      s_bytecnt <= s_bytecnt +1;
			 end if;
		end	if;	
	end	process;	
	
	--used for debug, modify the right item of equation only
	--i_sink_asm_position_flag is the position of 1 in asm byte
	
	s_asm_position_reg <= s_sink_asm_reg2;		
	process(clk , reset)
	 begin
		if(reset='1') then
			s_asm_position_flag <= "0000";
		 elsif(clk'event and clk='1' and s_sink_val_reg1='1') then--即必须保证peak下一个时刻输入的数据时有效的
		   if(s_asm_position_reg(8)='1') then
		     s_asm_position_flag <= "1000";
		   
			elsif(s_asm_position_reg(7)='1') then
		     s_asm_position_flag <= "0111";
			
			elsif(s_asm_position_reg(6)='1') then
			 s_asm_position_flag <= "0110";
			 
			elsif(s_asm_position_reg(5)='1') then
			 s_asm_position_flag <= "0101";
			 
			elsif(s_asm_position_reg(4)='1') then
			 s_asm_position_flag <= "0100";
			
			elsif(s_asm_position_reg(3)='1') then
			 s_asm_position_flag <= "0011";
			
			elsif(s_asm_position_reg(2)='1') then
			 s_asm_position_flag <= "0010";
			 
			elsif(s_asm_position_reg(1)='1') then
			 s_asm_position_flag <= "0001";
			else
			 s_asm_position_flag <= "0000";
			end if;
		end if;
	end	process;	
	
	--calculate prior one cycle	
	process(clk , reset)
	begin
		if(reset='1') then
		   s_asm_position_flag1 <= "0000";
			s_samebyte_cond <= '0';
			s_nextbyte_cond <= '0';
			s_priobyte_cond <= '0';
			
			s_samebyte_cond_reg1 <= '0';
			s_priobyte_cond_reg1 <= '0';
			s_priobyte_cond_reg2 <= '0';			
		
		elsif (clk'event and clk='1' and s_sink_val_reg1='1') then
		   s_asm_position_flag1 <= s_asm_position_flag;
			
			if ((s_asm_syn_flag="0001" and s_asm_position_flag<="0100" and s_asm_position_flag/=0) or 
			    (s_asm_syn_flag="0010" and s_asm_position_flag<="0101" and s_asm_position_flag/=0) or
				(s_asm_syn_flag="0011" and s_asm_position_flag<="0110" and s_asm_position_flag/=0) or
				(s_asm_syn_flag="0100" and (s_asm_position_flag<="0111" and s_asm_position_flag>="0001")) or
				(s_asm_syn_flag="0101" and (s_asm_position_flag<="1000" and s_asm_position_flag>="0010")) or
				(s_asm_syn_flag="0110" and s_asm_position_flag>="0011") or 
				(s_asm_syn_flag="0111" and s_asm_position_flag>="0100") or
				(s_asm_syn_flag="1000" and s_asm_position_flag>="0101") ) then
			 --asm in two frames appear in the same byte and within permitted range
				 s_samebyte_cond <= '1';
			 else
			    s_samebyte_cond <= '0';
			end if;
			 
			if((s_asm_syn_flag="0110" and s_asm_position_flag="0001") or 
				(s_asm_syn_flag="0111" and s_asm_position_flag<="0010" and s_asm_position_flag/=0) or
				(s_asm_syn_flag="1000" and s_asm_position_flag<="0011" and s_asm_position_flag/=0) ) then
			 --asm in two frames appear in the prior byte and within permitted range
				 s_priobyte_cond <= '1';
			  else
			   s_priobyte_cond <= '0';
			end if;
			
			if( (s_asm_syn_flag="0001" and s_asm_position_flag>="0110") or 
				(s_asm_syn_flag="0010" and s_asm_position_flag>="0111") or
				(s_asm_syn_flag="0011" and s_asm_position_flag="1000") ) then
			 --asm in two frames appear in the next byte and within permitted range
				s_nextbyte_cond <= '1'; 
			else
			   s_nextbyte_cond <= '0';
			end	if;	
			s_samebyte_cond_reg1 <= s_samebyte_cond;
			s_priobyte_cond_reg1 <= s_priobyte_cond;
			s_priobyte_cond_reg2 <= s_priobyte_cond_reg1;			
		 end if;
	end process;
	
	process(clk,reset)
	begin
		if(reset='1') then
		 s_cntreg_sub1 <="00" & x"00";
		 s_cntreg_sub2 <="00" & x"00"; 
		elsif (clk'event and clk='1') then
		  --s_cntreg substract 1
		  if( s_cntreg=0 ) then
		    s_cntreg_sub1 <= i_framelengthsub1;
		   else
			 s_cntreg_sub1 <= s_cntreg - 1;
		  end if;
			
			--s_cntreg substract 2
			if( s_cntreg=0 ) then
		     s_cntreg_sub2 <= i_framelengthsub1 - 1;
			elsif( s_cntreg=1 ) then
		     s_cntreg_sub2 <= i_framelengthsub1;
			else
			  s_cntreg_sub2 <= s_cntreg - 2;
			end if;
		end	if;	
	end process;
	
	--calculate prior one cycle	
	process(clk,reset)
	begin
		if(reset='1') then
		   s_priobyte_cnt_cond <= '0';
			s_nextbyte_cnt_cond <= '0';
			s_beyondrange_cnt_cond <= '0';
		elsif (clk'event and clk='1') then
		 --s_cntreg=s_bytecnt-1 in normal method
		  if( s_cntreg=s_bytecnt ) then 
		     s_nextbyte_cnt_cond <= '1';
			else 
		     s_nextbyte_cnt_cond <= '0';
		  end if;
			
			--s_cntreg=s_bytecnt+1 in normal method
		  if( s_cntreg_sub2=s_bytecnt )  then
		     s_priobyte_cnt_cond <= '1';
		  else 
		     s_priobyte_cnt_cond <= '0';
		  end if;
			
			--s_cntreg<s_bytecnt-1 or s_cntreg>s_bytecnt+1 in normal method
		  if( (s_cntreg/=s_bytecnt) and (s_cntreg_sub1/=s_bytecnt) and (s_cntreg_sub2/=s_bytecnt) ) then
			 s_beyondrange_cnt_cond <= '1';
		  else 
		    s_beyondrange_cnt_cond <= '0';
		  end if;
		
		end	if;	
	end process;
	
	s_cond_syn <= ( (s_cntreg=s_bytecnt) and (s_samebyte_cond='1') ) or 
					  ( (s_priobyte_cnt_cond='1') and (s_priobyte_cond='1') ) or
					  ( (s_nextbyte_cnt_cond='1') and (s_nextbyte_cond='1') );
					  
	s_cond_loseframehead <=((s_nextbyte_cnt_cond='1') and 
								  (s_samebyte_cond_reg1='0') and 
								  (s_priobyte_cond_reg2='0') );
	
	--state machine
	process(clk,reset)
	 begin
		if(reset='1') then
		   s_state0 <= c_intl;
			s_cntreg <= "00" & x"00";
			s_asm_syn_flag <= "0000";
			s_out_cnt <= "00" & x"00";
			acframe_cnt<="000";
			lsframe_cnt<="000";
		 elsif(clk'event and clk='1' and s_sink_val_reg1='1') then
		  --counter for output
			if( s_out_cnt=i_framelengthsub1 ) then --只有在下一个时刻有效才考虑输出，防止不能完整输出
			  s_out_cnt <= "00" & x"00";
			 else
			  s_out_cnt <= s_out_cnt + 1;
			end if;
			
			case s_state0 is
			   when c_intl =>
			       if(s_sink_asm_reg4/=x"00") then
					   --if asm is found 
						s_state0 <= c_acqu;		
						s_out_cnt <= "00" & x"00";	
						s_cntreg <= s_bytecnt; --
						s_asm_syn_flag <=s_asm_position_flag1;
						
						acframe_cnt <= "000";	 
					 end	if;
				when c_acqu =>
				    if(s_sink_asm_reg4/=x"00") then					
					   if(s_cond_syn) then
					      s_out_cnt <= "00" & x"00";	
							s_cntreg <= s_bytecnt; --
						   s_asm_syn_flag <=s_asm_position_flag1; 
						   
					      if(acframe_cnt<1) then
				              acframe_cnt<=acframe_cnt+1;
				              s_state0 <= c_acqu;
				         else	
							     s_state0 <= c_sync;
							     acframe_cnt <= "000";	
							end if;
						elsif(s_beyondrange_cnt_cond='1') then
						  --asm appears in wrong place, state unchanged
							s_state0 <= c_acqu;
						else						  
							s_state0 <= c_intl;
						end if;
					else
					   if(s_cond_loseframehead) then						 
							s_state0 <= c_intl; 
						end if;
				   end	if;			
				
				when c_sync =>
				   if(s_cntreg=s_bytecnt) then
					  s_out_cnt <= "00" & x"00";
					end if;
					
					if(s_sink_asm_reg4/=x"00") then					
					   if(s_cond_syn) then
						   s_out_cnt <= "00" & x"00";	
							s_cntreg <= s_bytecnt; --
						   s_asm_syn_flag <=s_asm_position_flag1; 
						   
							s_state0 <= c_sync;
						elsif(s_beyondrange_cnt_cond='1') then
						  --asm appears in wrong place, state unchanged
							s_state0 <= c_sync;
						else
						  --parameters unchanged
							s_state0 <= c_warn;
							lsframe_cnt <="000";	
						end if;
					else
					   if(s_cond_loseframehead) then
						 --parameters unchanged
							s_state0 <= c_warn;
							lsframe_cnt <="000";	 
						end if;
					end	if;	
							
				 when c_warn =>
				  if(s_sink_asm_reg4/=x"00")	then				
					   if(s_cond_syn) then
					      s_state0 <= c_sync;
					      s_out_cnt <= "00" & x"00";	
							s_cntreg <= s_bytecnt; --
						   s_asm_syn_flag <=s_asm_position_flag1;   
						elsif(s_beyondrange_cnt_cond='1') then
						  --asm appears in wrong place, state unchanged
							s_state0 <= c_warn;
						else	
						     if(lsframe_cnt<3) then
				              lsframe_cnt<=lsframe_cnt+1;
				              s_state0 <= c_warn;
				           else
				              lsframe_cnt <="000";		
							     s_state0 <= c_intl;
							  end if;					  
							
						end if;
				  else
					  if(s_cond_loseframehead) then
						    if(lsframe_cnt<3) then
				              lsframe_cnt<=lsframe_cnt+1;
				              s_state0 <= c_warn;
				          else
				              lsframe_cnt <="000";		
							     s_state0 <= c_intl;
							 end if;	
					   end if;
				  end if;
				  	 		
				when others =>
				   s_state0 <= c_intl;
			  end case;
		   end if;
		end process;
	s_state<=s_state0;
		
	--output correct data according to the position of asm
	process(clk,reset)
	 begin   
	 if(reset='1') then
		 s_syn_data_reg <= x"00000000";
	 elsif (clk'event and clk='1' )then
		 case s_asm_syn_flag is			
		  when x"8" =>
			   s_syn_data_reg <= s_data_in_reg2(32 downto 1);
		  when x"7" =>
			   s_syn_data_reg <= s_data_in_reg2(28 downto 1) & s_data_in_reg1(32 downto 29);
		  when x"6" =>
			   s_syn_data_reg <= s_data_in_reg2(24 downto 1) & s_data_in_reg1(32 downto 25);
		  when x"5" =>
			 	s_syn_data_reg <= s_data_in_reg2(20 downto 1) & s_data_in_reg1(32 downto 21);
		  when x"4" =>
			 	s_syn_data_reg <= s_data_in_reg2(16 downto 1) & s_data_in_reg1(32 downto 17);
		  when	x"3" =>
				s_syn_data_reg <= s_data_in_reg2(12 downto 1) & s_data_in_reg1(32 downto 13);
		  when x"2" =>
			 	s_syn_data_reg <= s_data_in_reg2(8 downto 1) & s_data_in_reg1(32 downto 9);
		  when	x"1" =>
				s_syn_data_reg <= s_data_in_reg2(4 downto 1) & s_data_in_reg1(32 downto 5);
		  when others =>
			   s_syn_data_reg <= s_data_in_reg2(32 downto 1);
		  end case;
		 end if;
	end process;
	
	--output valid signal
	process(clk , reset)
	 begin
	   if(reset='1') then
		 s_val <= '0';
		elsif(clk'event and clk='1') then
		   if(s_out_cnt<i_framelengthsub1-2 and s_out_cnt>=1) then
		       if(s_state0=c_sync or s_state0=c_warn)then
				   s_val <= s_sink_val_reg1;
			    else
				   s_val <= '0';
			    end if;
		   else
			    s_val <= '0';
		  end if;		
	  end if;
	end process;  
	o_val<=s_val;
	
	--output asm
	process(s_out_cnt,s_state0,s_val)
	begin
	  if( s_out_cnt=2 and (s_state0=c_sync or s_state0=c_warn)and s_val='1')then
		 o_sop <= '1';			
	  else
		 o_sop <= '0';
	  end if; 
	end process;
	
	--output o_eop
	process(s_out_cnt,s_state0,s_val)
	begin
	  if( s_out_cnt=i_framelengthsub1-2 and (s_state0=c_sync or s_state0=c_warn) and s_val='1' )then
		 o_eop<= '1';			
	  else
		 o_eop<= '0';
	  end if; 
	end process;
	
	dataout32<= s_syn_data_reg;
	dataout8modify<=not (s_syn_data_reg(32) & s_syn_data_reg(28) & s_syn_data_reg(24) & s_syn_data_reg(20)
                      & s_syn_data_reg(16) & s_syn_data_reg(12) & s_syn_data_reg(8) & s_syn_data_reg(4));   --only to wtach
	end rtl;