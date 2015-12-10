-------------------------------------------------------------------------------
--
-- File: GardnerTED_v2.vhd
-- Author: Jiang Long 
-- Original Project: QPSK Serial Demodulator
-- Date: 2010.06.22
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
-- 计算Gardner TED
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2010.06.22 First revision 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GardnerTED_v2 is 
  generic(
    kInWidth  : positive := 9;
    kOutWidth : positive := 14); -- kOutWidth must be smaller than kInWidth+kCoeWidth-1
  port(
    aReset       : in std_logic;
    Clk          : in std_logic;
    cInPhase     : in std_logic_vector(kInWidth-1 downto 0);
    cQuadPhase   : in std_logic_vector(kInWidth-1 downto 0);
    InterpType   : in std_logic_vector(1 downto 0);
    cTimingError : out std_logic_vector(kOutWidth-1 downto 0)
    );
end GardnerTED_v2;

architecture rtl of GardnerTED_v2 is

  type InSignedArray_t is array (natural range <>) of signed(kInWidth-1 downto 0);
  signal cInPhaseDly, cQuadPhaseDly : InSignedArray_t(3 downto 0);
  signal cInPhase_mid, cQuadPhase_mid : signed(kInWidth-1 downto 0);
  
  signal cInDiff, cQuadDiff : signed(kInWidth downto 0);
  signal cInProd, cQuadProd, cInProdDly, cQuadProdDly : signed(2*kInWidth downto 0);
  signal cError : signed(kOutWidth-1 downto 0);
  
begin
  
  cTimingError <= std_logic_vector(cError);
  
  -- Delay the input data
  process(aReset, Clk)
  begin
    if aReset='1' then
      for i in 0 to 3 loop
        cInPhaseDly(i)   <= (others => '0');
        cQuadPhaseDly(i) <= (others => '0');
      end loop;
    elsif rising_edge(Clk) then
      if InterpType = "11" then              --最佳点
        cInPhaseDly(0) <= signed(cInPhase);
        cQuadPhaseDly(0) <= signed(cQuadPhase);
        
        cInPhaseDly(1) <= cInPhaseDly(0);
        cQuadPhaseDly(1) <= cQuadPhaseDly(0);
      else
      	null;
      end if;
      
      if InterpType = "01" then               --过零点
        cInPhaseDly(2) <= signed(cInPhase);
        cQuadPhaseDly(2) <= signed(cQuadPhase);
        cInPhaseDly(3) <= cInPhaseDly(2);
        cQuadPhaseDly(3) <= cQuadPhaseDly(2);
      else
      	null;
      end if;
    end if;
  end process;
  
  
  -- Calculate the gardner timing error
  process(aReset, Clk)
  begin
    if aReset='1' then
      cInDiff   <= (others => '0');
      cQuadDiff <= (others => '0');
      cInPhase_mid <= (others => '0');
      cQuadPhase_mid <= (others => '0');
    elsif rising_edge(Clk) then
      if InterpType = "11" then
        cInDiff   <= resize( cInPhaseDly(0) , kInWidth+1 ) - resize( cInPhaseDly(1) , kInWidth + 1 );
        cQuadDiff <= resize( cQuadPhaseDly(0) , kInWidth+1 ) - resize( cQuadPhaseDly(1) , kInWidth + 1 );
        cInPhase_mid <= cInPhaseDly(3);
        cQuadPhase_mid <= cQuadPhaseDly(3);
      end if;                    
    end if;
  end process;
  
  process(aReset, Clk)
  begin
    if aReset='1' then
      cInProd   <= (others => '0');   
      cQuadProd <= (others => '0');   
      cError       <= (others => '0');
    elsif rising_edge(Clk) then
      cInProd   <= cInDiff * cInPhase_mid;
      cQuadProd <= cQuadDiff * cQuadPhase_mid;
      cError <= -cInProd(2*kInWidth-1 downto 2*kInWidth-kOutWidth) 
                     - cQuadProd(2*kInWidth-1 downto 2*kInWidth-kOutWidth);
    end if;
  end process;
  

end rtl;