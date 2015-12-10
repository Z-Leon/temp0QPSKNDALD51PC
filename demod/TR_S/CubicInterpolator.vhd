-------------------------------------------------------------------------------
--
-- File: CubicInterpolator.vhd
-- Author: William Zhang 
-- Original Project: QPSK Serial Demodulator
-- Date: 2007.01.22
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
-- Cubic Interpolator. The coefficients are 10 digit signed data
-- kOutWidth must be smaller than kInWidth + kCoeWidth
-- The interpolator's DC gain is 1/2
--
-- Hardware specific information
-- 1. Each multiplier and adder (between taps) has two cycles delay, for convenient 
--    IP core replacement in future
-- 2. The multipliers in each FIR filter are not optimized by the synthesizers.
--
-- Some limitations
-- 1. kOutWidth must be smaller than kInWidth+kCoeWidth-1
-- 2. In order to use the 18x18 multiplier efficiently, it is recommended to 
--    set the sum of kInWidth+kCoeWidth-1 is no more than 18
--    If you would like more precisions, contact wilzhang
-- 3. The mulitiplier limits the running speed. The max clock freq is around 180MHz
--    Replace the multiplier with IP core ones and the fixed coefficient multiplier 
--    with CSD ones to achieve higher running speed
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2007.01.16 First revision 
-- 2007.04.10 Calculate the DC gain: 1/2
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CubicInterpolator is 
	generic(
		kInWidth  : positive := 9;
		kOutWidth : positive := 14; -- kOutWidth must be smaller than kInWidth+kCoeWidth-1
		kMuWidth  : positive := 17);
	port(
		aReset       : in std_logic;
		SamplingClk  : in std_logic;
		sMu       	 : in std_logic_vector(kMuWidth-1 downto 0);
		sDin				 : in std_logic_vector(kInWidth-1 downto 0);
		sDout 		   : out std_logic_vector(kOutWidth-1 downto 0));
end CubicInterpolator;

architecture rtl of CubicInterpolator is

	-- Modify the following coefficients and kCoeWidth to achieve 
	-- different precision
	type IntArray_t is array (natural range <>) of integer;
--	constant kTap0 : IntArray_t(0 to 3) := ( 43, -128,  128, -43);
--	constant kTap1 : IntArray_t(0 to 3) := (  0,  128, -256, 128);
--	constant kTap2 : IntArray_t(0 to 3) := (-43,  256, -128, -85);
--	constant kTap3 : IntArray_t(0 to 3) := (  0,    0,  256,   0);

	constant kTap0 : IntArray_t(0 to 3) := ( 86, -256,  256, -86);
	constant kTap1 : IntArray_t(0 to 3) := (  0,  256, -512, 256);
	constant kTap2 : IntArray_t(0 to 3) := (-86,  512, -256, -170);
	constant kTap3 : IntArray_t(0 to 3) := (  0,    0,  512,   0);
	
   --constant kTap0 : IntArray_t(0 to 3) := ( 11, -32,  32, -11);
--	constant kTap1 : IntArray_t(0 to 3) := (  0,  32, -64, 32);
--	constant kTap2 : IntArray_t(0 to 3) := (-11,  64, -32, -21);
--	constant kTap3 : IntArray_t(0 to 3) := (  0,    0,  64,   0);
	
--	constant kCoeWidth : integer := 10;
	constant kCoeWidth : integer := 11;
	
	type SignedArray_t is array (natural range <>) of signed(kInWidth+kCoeWidth-1 downto 0);
	signal sProd0 : SignedArray_t(3 downto 0);
	signal sProd1 : SignedArray_t(3 downto 0);
	signal sProd2 : SignedArray_t(3 downto 0);
	signal sProd3 : SignedArray_t(3 downto 0);
	signal sSum0  : SignedArray_t(2 downto 0);
	signal sSum1  : SignedArray_t(2 downto 0);
	signal sSum2  : SignedArray_t(2 downto 0);
	signal sSum3  : SignedArray_t(2 downto 0);
	signal sSum1Delay : SignedArray_t(1 downto 0);
	signal sSum2Delay : SignedArray_t(5 downto 0);
	signal sSum3Delay : SignedArray_t(9 downto 0);
	
	type InterpArray_t is array (natural range <>) of signed(kInWidth+kCoeWidth+kMuWidth-1 downto 0); 
	signal sInterpProd : InterpArray_t(5 downto 0);
	
	type InArray_t is array (natural range <>) of signed(kInWidth-1 downto 0);
	signal sDelayChain : InArray_t(3 downto 0);
	
	type MuArray_t is array (natural range <>) of signed(kMuWidth-1 downto 0);
	constant kMuDelayCycle : positive := 12;
	signal sMuDelayChain : MuArray_t(kMuDelayCycle-1 downto 0);
	
	type SumArray_t is array (natural range <>) of signed(kInWidth+kCoeWidth-1 downto 0);
	signal sInterpSum : SumArray_t(5 downto 0);
	signal sDoutBuffer : SumArray_t(5 downto 0);
	
begin
	
	process(aReset, SamplingClk)
  begin
  	if aReset='1' then
  		sDout <= (others => '0');
  		for i in 0 to 3 loop
  			sDelayChain(i) <= (others => '0');
  			sProd0(i) <= (others => '0');
  			sProd1(i) <= (others => '0');
  			sProd2(i) <= (others => '0');
  			sProd3(i) <= (others => '0');
  		end loop;
  		for i in 0 to 2 loop
  			sSum0(i) <= (others => '0');
  			sSum1(i) <= (others => '0');
  			sSum2(i) <= (others => '0');
  			sSum3(i) <= (others => '0');
  		end loop;
  		for i in 0 to 5 loop
  			sInterpProd(i) <= (others => '0');
  			sInterpSum(i) <= (others => '0');
  		end loop;
  		for i in 0 to 1 loop
  			sSum1Delay(i) <= (others => '0');
  		end loop;	
  		for i in 0 to 5 loop
  			sSum2Delay(i) <= (others => '0');
  		end loop;	
  		for i in 0 to 9 loop
  			sSum3Delay(i) <= (others => '0');
  		end loop;	
  		for i in 0 to 4 loop
				sDoutBuffer(i) <= (others => '0');
			end loop;			  
			for i in 0 to kMuDelayCycle-1 loop
  			sMuDelayChain(i) <= (others => '0');
  		end loop;											
  	elsif rising_edge(SamplingClk) then
  	  sDelayChain(0) <= signed(sDin);
	    for i in 1 to 3 loop
  			sDelayChain(i) <= sDelayChain(i-1);
  		end loop;
  		for i in 0 to 3 loop
  			sProd0(i) <= sDelayChain(i) * to_signed(kTap0(i), kCoeWidth);
  			sProd1(i) <= sDelayChain(i) * to_signed(kTap1(i), kCoeWidth);
  			sProd2(i) <= sDelayChain(i) * to_signed(kTap2(i), kCoeWidth);
  			sProd3(i) <= sDelayChain(i) * to_signed(kTap3(i), kCoeWidth);
  		end loop;
  		sMuDelayChain(0) <= signed(sMu);
			for i in 1 to kMuDelayCycle-1 loop
  			sMuDelayChain(i) <= sMuDelayChain(i-1);
  		end loop;
  		sSum0(0) <= sProd0(0) + sProd0(1);
  		sSum0(1) <= sProd0(2) + sProd0(3);
  		sSum0(2) <= sSum0(0)  + sSum0(1);
  		sSum1(0) <= sProd1(0) + sProd1(1);
  		sSum1(1) <= sProd1(2) + sProd1(3);
  		sSum1(2) <= sSum1(0)  + sSum1(1);
  		sSum2(0) <= sProd2(0) + sProd2(1);
  		sSum2(1) <= sProd2(2) + sProd2(3);
  		sSum2(2) <= sSum2(0)  + sSum2(1);
  		sSum3(0) <= sProd3(0) + sProd3(1);
  		sSum3(1) <= sProd3(2) + sProd3(3);
  		sSum3(2) <= sSum3(0)  + sSum3(1);  
  		sSum1Delay(0)  <= sSum1(2);
  		sSum1Delay(1)  <= sSum1Delay(0);
  		sSum2Delay(0)  <= sSum2(2);
  		for i in 1 to 5 loop
  			sSum2Delay(i) <= sSum2Delay(i-1);
  		end loop;
  		sSum3Delay(0)  <= sSum3(2);
  		for i in 1 to 9 loop
  			sSum3Delay(i) <= sSum3Delay(i-1);
  		end loop;
  		sInterpProd(0) <= sMuDelayChain(3) * sSum0(2);
  		sInterpProd(1) <= sInterpProd(0);
  		sInterpSum(0)  <= sInterpProd(1)(kInWidth+kCoeWidth+kMuWidth-2 downto kMuWidth-1)
  											+ sSum1Delay(1);
  		sInterpSum(1)  <= sInterpSum(0);									
  	  sInterpProd(2) <= sInterpSum(1) * sMuDelayChain(7);
  	  sInterpProd(3) <= sInterpProd(2);
  	  sInterpSum(2)  <= sInterpProd(3)(kInWidth+kCoeWidth+kMuWidth-2 downto kMuWidth-1)
  											+ sSum2Delay(5);
  		sInterpSum(3) <= sInterpSum(2);
  		sInterpProd(4) <= sInterpSum(3) * sMuDelayChain(11);
  		sInterpProd(5) <= sInterpProd(4);
  	  sInterpSum(4)  <= sInterpProd(5)(kInWidth+kCoeWidth+kMuWidth-2 downto kMuWidth-1)
  											+ sSum3Delay(9);
  		sInterpSum(5)  <= sInterpSum(4);									
			-- delay the output for additional 6 cycle
			-- total delay is 17 cycles, the same as the bdf design
			sDoutBuffer(0) <= sInterpSum(5);
			for i in 1 to 5 loop
				sDoutBuffer(i) <= sDoutBuffer(i-1);
			end loop;		
			--sDout <= std_logic_vector(sInterpSum(5)(kInWidth+kCoeWidth-2 downto kInWidth+kCoeWidth-kOutWidth-1));	  											
			sDout <= std_logic_vector(sInterpSum(5)(kInWidth+kCoeWidth-3 downto kInWidth+kCoeWidth-kOutWidth-2));	  											
  	end if;
  end process;
  
end rtl;