-------------------------------------------------------------------------------
--
-- File: LoopFilter.vhd
-- Author: William Zhang 
-- Original Project: QPSK Serial Demodulator
-- Date: 2007.02.02
--
-------------------------------------------------------------------------------
--
-- (c) 2006 Copyright Wireless Broadband Transmission Lab
-- All Rights Reserved
-- EE Dept. at Tsinghua Univ.
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- Loop filter in the timing recovery. Proportional gain and integral gain 
-- is realtime configurable
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2007.02.02 First revision 
-- 2007.04.10 Second rev Correct a bug output size is larger than integ size
-- 2010.06.22 cDataValid部分稍作修改
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LoopFilter_v2 is 
  generic(
    kInSize   : positive := 14;
    kOutSize  : positive := 32;
    kKpSize   : positive := 3;
    kKiSize   : positive := 3);
  port(
    aReset       : in std_logic;
    Clk          : in std_logic;
    cDataValid   : in std_logic_vector(1 downto 0);
    cKp          : in std_logic_vector(kKpSize-1 downto 0);
    cKi          : in std_logic_vector(kKiSize-1 downto 0);
    cTimingError : in std_logic_vector(kInSize-1 downto 0);
    cLoopFilter  : out std_logic_vector(kOutSize-1 downto 0)
   );
end LoopFilter_v2;

architecture rtl of LoopFilter_v2 is

  constant kIntegSize : positive := 32;
  signal cPropTE : signed(kIntegSize-1 downto 0);
  signal cPropTE_Dly : signed(kIntegSize-1 downto 0);
  signal cIntegTE : signed(kIntegSize-1 downto 0);
  signal cAccumulator : signed(kIntegSize-1 downto 0);
  signal cSum : signed(kIntegSize-1 downto 0);
  --jiang
  signal loopf : std_logic_vector( 24 downto 0 );
  
begin
  
  -- when the output size is smaller than the integer size
  -- output the highest digits
  OutputSizeAdjustHigherBits:
  if kOutSize <= kIntegSize generate
    HigherBits : 
    cLoopFilter  <= std_logic_vector(cSum(kIntegSize-1 downto kIntegSize-kOutSize));
  end generate OutputSizeAdjustHigherBits;  
  
  -- when the output size is larger than the integer size
  -- output the sign extended number
  OutputSizeAdjustAllBits:
  if kOutSize > kIntegSize generate
    HigherBits : 
    cLoopFilter  <= std_logic_vector(resize(cSum, kOutSize));
  end generate OutputSizeAdjustAllBits; 
  
  process(aReset, Clk)
    variable PropTE  : signed(kIntegSize-1 downto 0);
    variable IntegTE : signed(kIntegSize-1 downto 0);
  begin
    if aReset='1' then
      cPropTE  <= (others => '0');
      cIntegTE <= (others => '0');
      cAccumulator <= (others => '0'); 
      cSum <= (others => '0');
      cPropTE_Dly <= (others => '0');
    elsif rising_edge(Clk) then
      if cDataValid="11" then       -- "10","01","00"都可以,没有这个条件判断应该也可以
        PropTE  := resize(signed(cTimingError), kIntegSize);
        IntegTE := resize(signed(cTimingError), kIntegSize);
        -- proportional gain control
        case to_integer(unsigned(cKp)) is
          when 0 =>
            cPropTE <= shift_left(PropTE, 18);
          when 1 =>
            cPropTE <= shift_left(PropTE, 17);
          when 2 =>
            cPropTE <= shift_left(PropTE, 16);
          when 3 =>
            cPropTE <= shift_left(PropTE, 15);
          when 4 =>
            cPropTE <= shift_left(PropTE, 14);
          when 5 =>
            cPropTE <= shift_left(PropTE, 13);
          when 6 =>
            cPropTE <= shift_left(PropTE, 10);--12
          when 7 =>
            cPropTE <= shift_left(PropTE, 11);
          when others =>
            cPropTE <= shift_left(PropTE, 0); 
        end case;
        
        -- integral gain control
        case to_integer(unsigned(cKi)) is
          when 0 =>
            cIntegTE <= shift_left(IntegTE, 10);
          when 1 =>                          
            cIntegTE <= shift_left(IntegTE, 9);
          when 2 =>                          
            cIntegTE <= shift_left(IntegTE, 8);
          when 3 =>                          
            cIntegTE <= shift_left(IntegTE, 7);
          when 4 =>                          
            cIntegTE <= shift_left(IntegTE, 6);
          when 5 =>                          
            cIntegTE <= shift_left(IntegTE, 4); --modified by yzch  6
          when 6 =>                          
            cIntegTE <= shift_left(IntegTE, 4);
          when 7 =>                          
            cIntegTE <= shift_left(IntegTE, 3);
          when others =>                     
            cIntegTE <= shift_left(IntegTE, 0);
        end case;
        
        if (cAccumulator >= signed'(x"F0000000") and cAccumulator <= signed'(x"10000000")) then
        	cAccumulator <= cAccumulator + cIntegTE;
				else
					cAccumulator <= signed'(x"00000000");
        end if;	
        --cAccumulator <= cAccumulator + cIntegTE;
        cPropTE_Dly <= cPropTE;
        cSum <= cAccumulator + cPropTE_Dly;
      end if; 
    end if;                               
  end process;
  

 
  
  --jiang
  process(aReset, Clk)
  begin
    if aReset='1' then
      loopf <=(others=> '0');
    elsif rising_edge(Clk) then
      loopf <= std_logic_vector(cSum(24 downto 0));
    end if;
  end process;
  --long
  
end rtl;