--2-----------------------------------------------------------------------------
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

entity Carrierrecovery_P2 is 
  generic(kDataWidth  : positive := 8;
  	  kErrWidth   :positive  :=12;
  	  kSinWidth   : positive :=16);
  port(               
    aReset            : in std_logic;
    Clk               : in std_logic;
                    
    -- Input data from timing recovery module
    sEnableIn         : in std_logic;
    sInPhase0         : in std_logic_vector(kDataWidth-1 downto 0);
    sInPhase1         : in std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhase0       : in std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhase1       : in std_logic_vector(kDataWidth-1 downto 0);
    
    -- Loop status signal, when '1' locked, otherwise not locked
    sLockSign         : out std_logic;
    
    -- output data ready signal and data
    sEnableOut        : out std_logic;
    sInPhaseOut0      : out std_logic_vector(kDataWidth-1 downto 0);
    sInPhaseOut1      : out std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhaseOut0    : out std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhaseOut1    : out std_logic_vector(kDataWidth-1 downto 0));
end Carrierrecovery_P2;

architecture rtl of Carrierrecovery_P2 is


				component Phase_Revolve_P2 is 
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
				    sInPhase0         : in std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhase0       : in std_logic_vector(kDataWidth-1 downto 0);
				    sInPhase1         : in std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhase1       : in std_logic_vector(kDataWidth-1 downto 0);
				    
				    sErrCarrier       : in std_logic_vector(kErrWidth-1 downto 0);
				    
				    -- output data ready signal and data
--				    sEnableOut        : out Boolean;
				    sInPhaseOut0       : out std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhaseOut0     : out std_logic_vector(kDataWidth-1 downto 0);
				    sInPhaseOut1       : out std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhaseOut1     : out std_logic_vector(kDataWidth-1 downto 0));
				end component;

				component PF_Err_Detect_P2 is 
				  generic(
				  	kDataWidth  : positive := 8;
				  	kErrWidth   : positive := 12
				  	);
				  port(               
				    aReset            : in std_logic;
				    Clk               : in std_logic;
				                    
				    -- Input data from Phase revolve module
				    sEnableIn         : in std_logic;
				    sInPhase0         : in std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhase0       : in std_logic_vector(kDataWidth-1 downto 0);
				    sInPhase1         : in std_logic_vector(kDataWidth-1 downto 0);
				    sQuadPhase1       : in std_logic_vector(kDataWidth-1 downto 0);
				    
				    -- output data ready signal and data
--				    sEnableOut        : out boolean;
				    sErrOut0          : out std_logic_vector(kErrWidth-1 downto 0);
				    sErrOut1          : out std_logic_vector(kErrWidth-1 downto 0));
				end component;
    
        component LoopFilter_CR_P2 is 
          generic(
                kErrWidth   : positive := 12
                );
          port(               
            aReset            : in std_logic;
            Clk               : in std_logic;
            
				    sErrIn0	      		: in std_logic_vector(kErrWidth-1 downto 0);
				    sErrIn1	      		: in std_logic_vector(kErrWidth-1 downto 0);
				    sEnableIn	      	: in std_logic;
				               
--				    sEnableOut        : out Boolean;
				    sLoopOut          : out std_logic_vector(kErrWidth-1 downto 0)
            );
        end component;
    
        signal sEnableOut_Phase_Revolve : Boolean;
        signal sEnableOut_PF_Err_Detect0: Boolean;
        signal sEnableOut_PF_Err_Detect1: Boolean;
        signal sEnableOut_LoopFilter_CR : Boolean;
        
        signal sInPhaseOut_Reg0         : std_logic_vector(kDataWidth-1 downto 0);
        signal sQuadPhaseOut_Reg0       : std_logic_vector(kDataWidth-1 downto 0);
        signal sInPhaseOut_Reg1         : std_logic_vector(kDataWidth-1 downto 0);
        signal sQuadPhaseOut_Reg1       : std_logic_vector(kDataWidth-1 downto 0);

        signal sErrOut_PF_Err_Detect0,sErrOut_PF_Err_Detect1    : std_logic_vector(kErrWidth-1 downto 0);       
        signal sLoopOut_LoopFilter_CR   : std_logic_vector(kErrWidth-1 downto 0);
       -- signal aReset	: Boolean;
begin


        Phase_Revolve_entity: Phase_Revolve_P2
                generic map(kDataWidth,kErrWidth,kSinWidth )
                port map(               
                    aReset            => aReset,
                    Clk               => Clk,
                                    
                    -- Input data from timing recovery module
                    sEnableIn         => sEnableIn,
                    sInPhase0          => sInPhase0,
                    sQuadPhase0        => sQuadPhase0,
                    sInPhase1          => sInPhase1,
                    sQuadPhase1        => sQuadPhase1,
                    
                    sErrCarrier       => sLoopOut_LoopFilter_CR,
                    
                    -- output data ready signal and data
                    sInPhaseOut0       => sInPhaseOut_Reg0,
                    sQuadPhaseOut0     => sQuadPhaseOut_Reg0,
                    sInPhaseOut1       => sInPhaseOut_Reg1,
                    sQuadPhaseOut1     => sQuadPhaseOut_Reg1

                    );

--output data
	process (aReset,Clk)
	begin
		if aReset='1' then
			sInPhaseOut0       <= (others=>'0');
			sQuadPhaseOut0     <= (others=>'0');
			sInPhaseOut1       <= (others=>'0');
			sQuadPhaseOut1     <= (others=>'0');
			sEnableOut			<= '0';
		elsif rising_edge(Clk) then
			if sEnableIn = '1' then
					sInPhaseOut0       <= sInPhaseOut_Reg0 ;
				    sQuadPhaseOut0     <= sQuadPhaseOut_Reg0;
				    sInPhaseOut1       <= sInPhaseOut_Reg1;
				    sQuadPhaseOut1     <= sQuadPhaseOut_Reg1;
					sEnableOut <= '1';
			else
					sEnableOut <= '0';
			end if;
				
		end if;
	end process;

				PF_Err_Detect_P2_entity: PF_Err_Detect_P2 
				  generic map(kDataWidth,kErrWidth)
				  port map(               
				    aReset            => aReset,
				    Clk               => Clk,
				                    
				    -- Input data from Phase revolve module
				    sEnableIn         => sEnableIn,
				    sInPhase0         => sInPhaseOut_Reg0,
				    sQuadPhase0       => sQuadPhaseOut_Reg0,
				    sInPhase1         => sInPhaseOut_Reg1,
				    sQuadPhase1       => sQuadPhaseOut_Reg1,
				    
				    -- output data ready signal and data
--				    sEnableOut        => sEnableOut_PF_Err_Detect0,
				    sErrOut0          => sErrOut_PF_Err_Detect0,
				    sErrOut1          => sErrOut_PF_Err_Detect1
						);


        
        LoopFilter_CR_entity: LoopFilter_CR_P2  
          generic map(kErrWidth)
          port map (               
                    aReset            => aReset,
                    Clk               => Clk,
                    
                    sErrIn0           => sErrOut_PF_Err_Detect0,
                    sErrIn1           => sErrOut_PF_Err_Detect1,
                    sEnableIn         => sEnableIn,
                               
--                    sEnableOut        => sEnableOut_LoopFilter_CR,
                    sLoopOut          => sLoopOut_LoopFilter_CR
                    );
        
end rtl;  
