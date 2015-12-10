-------------------------------------------------------------------------------
--
-- File: InterpCtrl_v2.vhd
-- Author: Jiang Long 
-- Original Project: QPSK Serial Demodulator
-- Date: 2010.06.23
--
-------------------------------------------------------------------------------
--
-- (c) 2010 Copyright Wireless Broadband Transmission Lab
-- All Rights Reserved
-- EE Dept. at Tsinghua Univ.
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 内插控制模块，全部重写。去掉了Mk，只用Mu，通用性较差
-- 参看笔记
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2010.06.23 First revision 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InterpCtrl_v2 is 
  generic(
    kInSize    : positive := 32;
    kMuSize    : positive := 16
   );
  port(
    aReset       : in std_logic;
    Clk          : in std_logic;
    cLoopFilter  : in std_logic_vector(kInSize-1 downto 0);  -- input format is 4.28
    cMu          : out std_logic_vector(kMuSize-1 downto 0);
    InterpType   : out std_logic_vector(1 downto 0)
   
    );
end InterpCtrl_v2;

architecture rtl of InterpCtrl_v2 is

  signal MuOmega : signed(kInSize-1 downto 0);
  type MuOmega_t is array (natural range <>) of signed(kInSize-1 downto 0);
  signal MuOmega_d : MuOmega_t(2 downto 0);
  
  type cMu_t is array (natural range <>) of std_logic_vector(kMuSize-1 downto 0);
  signal cMu_d : cMu_t(2 downto 0);
  
  type InterpType_t is array (natural range <>) of std_logic_vector(1 downto 0);
  signal InterpType_d : InterpType_t(2 downto 0);
  
  signal flag : integer range 0 to 3;
  signal counter : integer range 0 to 1;
  
  
begin
  
---------------------------------------
  process(aReset, Clk)
  begin
  	if aReset='1' then
      MuOmega <= (others=>'0');           -- format is 4.28
      counter <= 0;
    elsif rising_edge(Clk) then
    
    	if counter =0 then
    		counter <= 1;
    	else
    		counter <= 0;
    	end if;
    	
    	if counter = 1 then                                                                   --MuOmega值每两个时钟周期变化一次
	    	if MuOmega(kInSize-1 downto kInSize-4)="0001" then                                    
	      	MuOmega <= MuOmega + shift_right(signed(cLoopFilter),0)-signed'(x"10000000");     -- 如果MuOmega值大于1,则减1
	      elsif MuOmega(kInSize-1 downto kInSize-4)="1111" then
	      	MuOmega <= MuOmega + shift_right(signed(cLoopFilter),0)+signed'(x"10000000");     -- 如果MuOmega值小于1,则加1
	      else
	      	MuOmega <= MuOmega + shift_right(signed(cLoopFilter),0);                          -- 正常情况
	      end if;
	    else
	    	MuOmega <= MuOmega;
	    end if;
	    
    end if;
  end process;
---------------------------------------------
  process(aReset, Clk)
  begin
  	if aReset='1' then
  		for i in 0 to 2 loop
      	MuOmega_d(i) <= (others=>'0');
      end loop;
    elsif rising_edge(Clk) then
    	MuOmega_d(2) <= MuOmega_d(1);
    	MuOmega_d(1) <= MuOmega_d(0);
    	MuOmega_d(0) <= MuOmega;
    end if;
  end process;
----------------------------------------------------
  process( MuOmega_d(2), MuOmega_d(1), MuOmega_d(0) )
  begin
  	if MuOmega_d(1)(kInSize-1 downto kInSize-4)="0001" and MuOmega_d(2)(kInSize-1 downto kInSize-4)/=MuOmega_d(1)(kInSize-1 downto kInSize-4) then
  		flag <= 1;             -- d(2)小于1, d(1)=d(0) 都大于1  （例如过采样）
  	elsif MuOmega_d(1)(kInSize-1 downto kInSize-4)="1111" and MuOmega_d(2)(kInSize-1 downto kInSize-4)/=MuOmega_d(1)(kInSize-1 downto kInSize-4) then
  	  flag <= 2;             -- d(2)大于0, d(1)=d(0) 都小于0  （例如欠采样）
  	else
  		flag <=0;
  	end if;
  end process;
----------------------------------------------------------  
  process(aReset, Clk)
  begin
  	if aReset='1' then
  		for i in 0 to 2 loop
      	cMu_d(i) <= (others=>'0');
      end loop;
    elsif rising_edge(Clk) then
    	cMu_d(0) <= '0'&std_logic_vector(MuOmega(kInSize-5 downto kInSize-kMuSize-3));      -- Mu取MuOmega的小数部分
    	cMu_d(1) <= cMu_d(0);
    	if flag=2 and InterpType_d(2)(0)='0' then                           -- 在此条件下，Mu值要用Mu-1代替 （欠采样，且前一个点为过渡点）  参看笔记
    		cMu_d(2) <= std_logic_vector(signed(cMu_d(1))-signed'(x"8000"));  -- if kMuSize changed, 8000 need to be changed
    	else
    		cMu_d(2) <= cMu_d(1);
    	end if; 
    end if;
  end process;
---------------------------------------------------------------------
	-- InterpType: 插值点类型（11:最佳点 01:过零点 00,10: 过渡点)
	-- InterpType的一般顺序为00,01,10,11,00..., 即过渡点、过零点、过渡点、最佳点、过渡点...的顺序，也就是下面process中最后一个else描述的情况
	-- 但若Mu值出现跳变，则需要根据情况来调整，完成丢点或留点的操作. 参看笔记
	process(aReset, Clk)
  begin
  	if aReset='1' then
  		for i in 1 to 2 loop
      	InterpType_d(i) <= (others=>'0');
      end loop;
      InterpType_d(0) <= "00";
    elsif rising_edge(Clk) then
    	if flag = 1 then
    		InterpType_d(2)<="00";
    		InterpType_d(1)<=std_logic_vector(unsigned(InterpType_d(2))+1);
    		InterpType_d(0)<=std_logic_vector(unsigned(InterpType_d(2))+2);
    	elsif flag = 2 then
    		if InterpType_d(2)(0)='0' then
    			InterpType_d(2)<=std_logic_vector(unsigned(InterpType_d(2))+1);
    		else 
    			InterpType_d(2)<=std_logic_vector(unsigned(InterpType_d(2))+2);
    		end if; 
  			InterpType_d(1)<=std_logic_vector(unsigned(InterpType_d(2))+3);
  			InterpType_d(0)<=InterpType_d(2);
  		else
  			InterpType_d(2)<=InterpType_d(1);
    		InterpType_d(1)<=InterpType_d(0);
    		InterpType_d(0)<=std_logic_vector(unsigned(InterpType_d(0))+1);
    	end if;    	
    end if;
  end process;
-------------------------------------------------
	process(aReset, Clk)         -- 输出的Mu与插值点类型InterpType相对应
  begin
  	if aReset='1' then
    	InterpType <= (others=>'0');
    	cMu <= (others=>'0');
    elsif rising_edge(Clk) then
    	InterpType <=InterpType_d(2);
    	cMu <= cMu_d(2);
    end if;
  end process;
  
  
  
end rtl;