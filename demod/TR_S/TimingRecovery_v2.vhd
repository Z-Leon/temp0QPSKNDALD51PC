-------------------------------------------------------------------------------
--
-- File: TimingRecovery_v2.vhd
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
-- The timing recovery module
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2007.02.06 first revision
-- 2007.03.03 change the vhook_e to vhook because of altera compilation problem
-- 2007.03.05 output symbol by decimating two    
-- 2010.06.23 Change to v2 by JL   
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimingRecovery_v2 is 
  generic(
    kInSize  : positive := 8;
    kOutSize : positive := 8;
    kKpSize  : positive := 3;
    kKiSize  : positive := 3;
    kMkSize  : positive := 2;
    kMuSize  : positive := 16;
    kValidCtrl : natural := 0);
  port(
    aReset         : in std_logic;
    SamplingClk    : in std_logic;
    --HalfClk        : in std_logic;
    --QuarterClk     : in std_logic;
    --aKp            : in std_logic_vector(kKpSize-1 downto 0);
    --aKi            : in std_logic_vector(kKiSize-1 downto 0);
    sInPhase       : in std_logic_vector(kInSize-1 downto 0);
    sQuadPhase     : in std_logic_vector(kInSize-1 downto 0);
    --sMk            : out std_logic_vector(kMkSize-1 downto 0);
    sMu            : out std_logic_vector(kMuSize-1 downto 0);
    sInPhaseOut    : out std_logic_vector(kOutSize-1 downto 0);
    sQuadPhaseOut  : out std_logic_vector(kOutSize-1 downto 0);
    
    --OutsLoopFilter    : out std_logic_vector(31 downto 0);
    
    sDataValid     : out std_logic
    );
    -- SymbolClk is used for carrier recovery block
    -- comment the following line if the carrier recovery is using data enable 
    -- method
    --hSymbolClk     : out std_logic);
end TimingRecovery_v2;

architecture rtl of TimingRecovery_v2 is


  component CubicInterpolator
    generic (
      kInWidth : positive := 9;
      kOutWidth : positive := 14;
      kMuWidth : positive := 17);
    port (
      aReset : in std_logic;
      SamplingClk : in std_logic;
      sMu : in std_logic_vector(kMuWidth-1 downto 0);
      sDin : in std_logic_vector(kInWidth-1 downto 0);
      sDout : out std_logic_vector(kOutWidth-1 downto 0));
  end component;
 
  component GardnerTED_v2  
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
	end component;

  component LoopFilter_v2
    generic (
      kInSize : positive := 14;
      kOutSize : positive := 32;
      kKpSize : positive := 3;
      kKiSize : positive := 3);
    port (
      aReset : in std_logic;
      Clk : in std_logic;
      cDataValid : in std_logic_vector(1 downto 0);
      cKp : in std_logic_vector(kKpSize-1 downto 0);
      cKi : in std_logic_vector(kKiSize-1 downto 0);
      cTimingError : in std_logic_vector(kInSize-1 downto 0);
      cLoopFilter : out std_logic_vector(kOutSize-1 downto 0)
      );
  end component;
  
  component InterpCtrl_v2  
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
  end component;
  
  component InterpType_delay 
	port(
		aReset : in std_logic;
		clk    : in std_logic;
		data_in : in std_logic_vector(1 downto 0);
		data_out : out std_logic_vector(1 downto 0)
		);
  end component;
  ------------------------------------

  constant kMkDlyCycles : positive := 17;
  constant kCubicSize : positive := 9;
  constant kTimingErrorSize : positive := 14;
  constant kLoopFilterSize : positive := 32;
  
  signal sLoopFilter: std_logic_vector(kLoopFilterSize-1 downto 0);
  signal sTimingError: std_logic_vector(kTimingErrorSize-1 downto 0);
  signal sCubicQuadPhase: std_logic_vector(kCubicSize-1 downto 0);
  signal sCubicInPhase: std_logic_vector(kCubicSize-1 downto 0);
  signal sMuInt : std_logic_vector(kMuSize-1 downto 0);
  signal sMkInt : std_logic_vector(kMkSize-1 downto 0);
  signal sDeciTE : std_logic_vector(kTimingErrorSize-1 downto 0);
  signal sInPhaseAdjust: std_logic_vector(kInSize-1 downto 0);
  signal sQuadPhaseAdjust: std_logic_vector(kInSize-1 downto 0);
  signal sCubicQuadPhaseDecimate: std_logic_vector(kCubicSize-1 downto 0);
  signal sCubicInPhaseDecimate: std_logic_vector(kCubicSize-1 downto 0);
  
  --vhook_sigstart
  signal sGardnerDataRdy: std_logic;
  signal sDeciRdy: std_logic;
  signal sDataRdyIC: std_logic;
  signal sDataRdyIC0: std_logic;
  --vhook_sigend
  --jiang
  --signal sDataRdy_Delay : std_logic_vector(15 downto 0 );
	signal InterpType,InterpType_d: std_logic_vector(1 downto 0);
	signal sMu_jl : std_logic_vector(kMuSize-1 downto 0);
	signal sLoopFilter_jl: std_logic_vector(kLoopFilterSize-1 downto 0);
	

begin

  InPhaseCubic: CubicInterpolator
    generic map (
      kInWidth  => kInSize,     -- in  positive := 9
      kOutWidth => kCubicSize,  -- in  positive := 14
      kMuWidth  => kMuSize)     -- in  positive := 17
    port map (
      aReset      => aReset,          -- in  std_logic
      SamplingClk => SamplingClk,     -- in  std_logic
      sMu         => sMuInt,          -- in  std_logic_vector(kMuWidth-1 downto 0)
      sDin        => sInPhase,  -- in  std_logic_vector(kInWidth-1 downto 0)
      sDout       => sCubicInPhase);  -- out std_logic_vector(kOutWidth-1 downto 0)
  
 
  QuadPhaseCubic: CubicInterpolator
    generic map (
      kInWidth  => kInSize,     -- in  positive := 9
      kOutWidth => kCubicSize,  -- in  positive := 14
      kMuWidth  => kMuSize)     -- in  positive := 17
    port map (
      aReset      => aReset,            -- in  std_logic
      SamplingClk => SamplingClk,       -- in  std_logic
      sMu         => sMuInt,            -- in  std_logic_vector(kMuWidth-1 downto 0)
      sDin        => sQuadPhase,  -- in  std_logic_vector(kInWidth-1 downto 0)
      sDout       => sCubicQuadPhase);  -- out std_logic_vector(kOutWidth-1 downto 0)
  
  	InterpTypeDelay1: InterpType_delay
	port map(
		aReset  => aReset,
		clk     => SamplingClk,
		data_in => InterpType,
		data_out => InterpType_d
		);
    
 
  GardnerTEDx: GardnerTED_v2
    generic map (
      kInWidth  => kCubicSize,        -- in  positive := 9
      kOutWidth => kTimingErrorSize)  -- in  positive := 14
    port map (
      aReset       => aReset,           -- in  std_logic
      Clk          => SamplingClk,      -- in  std_logic
      cInPhase     => sCubicInPhase,    -- in  std_logic_vector(kInWidth-1 downto 0)
      cQuadPhase   => sCubicQuadPhase,  -- in  std_logic_vector(kInWidth-1 downto 0)
      InterpType   => InterpType_d,       -- in  std_logic
      cTimingError => sTimingError    -- out std_logic_vector(kOutWidth-1 downto 0)
      ); -- out std_logic
  

 
  LoopFilterx: LoopFilter_v2
    generic map (
      kInSize  => kTimingErrorSize,  -- in  positive := 14
      kOutSize => kLoopFilterSize,   -- in  positive := 32
      kKpSize  => kKpSize,           -- in  positive := 3
      kKiSize  => kKiSize)           -- in  positive := 3
    port map (
      aReset       => aReset,       -- in  std_logic
      Clk          => SamplingClk,  -- in  std_logic
      cDataValid   => InterpType_d,     -- in  std_logic
   
      cKp          => "110",
      cKi          => "101",

      cTimingError => sTimingError,      -- in  std_logic_vector(kInSize-1 downto 0)
      cLoopFilter  => sLoopFilter  -- out std_logic_vector(kOutSize-1 downto 0)
     );        -- out std_logic
  

	InterpCtrl_jl_inst: InterpCtrl_v2  
  generic map(
    kInSize    => kLoopFilterSize,
    kMuSize    => kMuSize
   )
  port map(
    aReset       => aReset,
    Clk          => SamplingClk,
    cLoopFilter  => sLoopFilter,  -- input format is 4.28
    cMu          => sMuInt,
    InterpType   => InterpType
   
    );

   --sMk <= sMkInt;
  sMu <= sMuInt;
  Process(SamplingClk,aReset)
  begin
  	if aReset = '1' then
  		sInPhaseOut <= (others=>'0');
  		sQuadPhaseOut <= (others=>'0');
  		sDataValid <= '0';
  	elsif rising_edge( SamplingClk ) then
		  sInPhaseOut <= sCubicInPhase(kCubicSize-1 downto kCubicSize-kOutSize);
		  sQuadPhaseOut <= sCubicQuadPhase(kCubicSize-1 downto kCubicSize-kOutSize);
		  if InterpType_d = "11" then
		  	sDataValid <= '1';
		  else
		  	sDataValid <= '0';
		  end if; 
		end if;
	end process;
   
	  
end rtl;
