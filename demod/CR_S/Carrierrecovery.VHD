-------------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2008.10.10
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- The carrier recovery module, using joint frequency and phase recovery algorithm
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2008.10.10 first revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CarrierRecovery is 
  generic(kDataWidth  : positive := 8;
  	  kErrWidth   :positive  :=12;
  	  kSinWidth   : positive :=16);
  port(               
    aReset            : in std_logic;
    Clk               : in std_logic;
                    
    -- Input data from timing recovery module
    sEnableIn         : in std_logic;
    sInPhase          : in std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhase        : in std_logic_vector(kDataWidth-1 downto 0);
    
    -- Loop status signal, when '1' locked, otherwise not locked
    sLockSign         : out std_logic;
    
    -- output data ready signal and data
    sEnableOut        : out std_logic;
    sInPhaseOut       : out std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhaseOut     : out std_logic_vector(kDataWidth-1 downto 0));
end CarrierRecovery;

architecture rtl of CarrierRecovery is

          component Phase_Revolve is 
          generic(
                kDataWidth  : positive := 8;
                kErrWidth   : positive := 12;
                kSinWidth   : positive := 16
                );
          port(               
            aReset            : in std_logic;
            Clk               : in std_logic;
                            
            -- Input data from timing recovery module
            sEnableIn         : in std_logic;
            sInPhase          : in std_logic_vector(kDataWidth-1 downto 0);
            sQuadPhase        : in std_logic_vector(kDataWidth-1 downto 0);
            
            sErrCarrier       : in std_logic_vector(kErrWidth-1 downto 0);
            
            -- output data ready signal and data
            sEnableOut        : out std_logic;
            sInPhaseOut       : out std_logic_vector(kDataWidth-1 downto 0);
            sQuadPhaseOut     : out std_logic_vector(kDataWidth-1 downto 0));
        end component;
    
        component PF_Err_Detect is 
          generic(
                kDataWidth  : positive := 8;
                kErrWidth   : positive := 12
                );
          port(               
            aReset            : in std_logic;
            Clk               : in std_logic;
                            
            -- Input data from Phase revolve module
            sEnableIn         : in std_logic;
            sInPhase          : in std_logic_vector(kDataWidth-1 downto 0);
            sQuadPhase        : in std_logic_vector(kDataWidth-1 downto 0);
            
            -- output data ready signal and data
            sEnableOut        : out std_logic;
            sErrOut           : out std_logic_vector(kErrWidth-1 downto 0));
        end component;

        component LoopFilter_CR is 
          generic(
                kErrWidth   : positive := 12
                );
          port(               
            aReset            : in std_logic;
            Clk               : in std_logic;
            
            sErrIn            : in std_logic_vector(kErrWidth-1 downto 0);
            sEnableIn         : in std_logic;
                       
            sEnableOut        : out std_logic;
            sLoopOut          : out std_logic_vector(kErrWidth-1 downto 0)
            );
        end component;
    
        signal sEnableOut_Phase_Revolve : std_logic;
        signal sEnableOut_PF_Err_Detect : std_logic;
        signal sEnableOut_LoopFilter_CR : std_logic;
        
        signal sInPhaseOut_Reg          : std_logic_vector(kDataWidth-1 downto 0);
        signal sQuadPhaseOut_Reg        : std_logic_vector(kDataWidth-1 downto 0);

        signal sErrOut_PF_Err_Detect    : std_logic_vector(kErrWidth-1 downto 0);       
        signal sLoopOut_LoopFilter_CR   : std_logic_vector(kErrWidth-1 downto 0);
begin
        Phase_Revolve_entity: Phase_Revolve
                generic map(kDataWidth,kErrWidth,kSinWidth )
                port map(               
                    aReset            => aReset,
                    Clk               => Clk,
                                    
                    -- Input data from timing recovery module
                    sEnableIn         => sEnableIn,
                    sInPhase          => sInPhase,
                    sQuadPhase        => sQuadPhase,
                    
                    sErrCarrier       => sLoopOut_LoopFilter_CR,
                    
                    -- output data ready signal and data
                    sEnableOut        => sEnableOut_Phase_Revolve,
                    sInPhaseOut       => sInPhaseOut_Reg,
                    sQuadPhaseOut     => sQuadPhaseOut_Reg
                    );

--output data
	process (aReset,Clk)
	begin
		if aReset='1' then
		elsif rising_edge(Clk) then
			if sEnableIn='1' then
				sInPhaseOut	<= sInPhaseOut_Reg;
				sQuadPhaseOut	<= sQuadPhaseOut_Reg;
				sEnableOut	<= '1';
			else
				sEnableOut	<= '0';
			end if;
		end if;
	end process;

        PF_Err_Detect_entity: PF_Err_Detect  
                  generic map (kDataWidth,kErrWidth)
                  port map (               
                    aReset            => aReset,
                    Clk               => Clk,
                                    
                    -- Input data from Phase revolve module
                    sEnableIn         => sEnableIn,
                    sInPhase          => sInPhaseOut_Reg,
                    sQuadPhase        => sQuadPhaseOut_Reg,
                    
                    -- output 
                    sEnableOut        => sEnableOut_PF_Err_Detect,
                    sErrOut           => sErrOut_PF_Err_Detect
                    );
        
        LoopFilter_CR_entity: LoopFilter_CR  
          generic map(kErrWidth)
          port map (               
                    aReset            => aReset,
                    Clk               => Clk,
                    
                    sErrIn            => sErrOut_PF_Err_Detect,
                    sEnableIn         => sEnableIn,
                               
                    sEnableOut        => sEnableOut_LoopFilter_CR,
                    sLoopOut          => sLoopOut_LoopFilter_CR
                    );
        
end rtl;  
