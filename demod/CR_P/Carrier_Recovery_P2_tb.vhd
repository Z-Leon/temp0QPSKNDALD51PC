---2----------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2009.7.1
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 	Testbench for Carrier recovery.
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2009.7.1 first revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity Carrier_Recovery_P2_tb is 
	  generic(
	  	kDataWidth  : positive := 8;
	  	kErrWidth   : positive := 12;
	  	kSinWidth   : positive := 16
	  	);
end Carrier_Recovery_P2_tb;

architecture rtl of Carrier_Recovery_P2_tb is

	component CarrierRecovery_P2 is 
	  generic(
	  	kDataWidth  : positive := 8;
	  	kErrWidth   : positive := 12;
	  	kSinWidth   : positive := 16
	  	);
	  port(               
	    aReset            : in boolean;
	    Clk               : in std_logic;
	                    
    -- Input data from timing recovery module
    sEnableIn         : in boolean;
    sInPhase0         : in std_logic_vector(kDataWidth-1 downto 0);
    sInPhase1         : in std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhase0       : in std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhase1       : in std_logic_vector(kDataWidth-1 downto 0);
    
    -- Loop status signal, when '1' locked, otherwise not locked
    sLockSign         : out std_logic;
    
    -- output data ready signal and data
    sEnableOut        : out boolean;
    sInPhaseOut0      : out std_logic_vector(kDataWidth-1 downto 0);
    sInPhaseOut1      : out std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhaseOut0    : out std_logic_vector(kDataWidth-1 downto 0);
    sQuadPhaseOut1    : out std_logic_vector(kDataWidth-1 downto 0)
	  );
	end component;
	
	signal    aReset            : boolean;
	signal    Clk               : std_logic;
	signal    sEnableIn         : boolean;
	signal    sInPhase0,sInPhase1          : std_logic_vector(kDataWidth-1 downto 0);
	signal    sQuadPhase0,sQuadPhase1      : std_logic_vector(kDataWidth-1 downto 0);
	    
	signal   sErrCarrier        : std_logic_vector(kErrWidth-1 downto 0);
	    
	signal    sEnableOut        : boolean;
	signal    sInPhaseOut0      : std_logic_vector(kDataWidth-1 downto 0);
	signal    sQuadPhaseOut0    : std_logic_vector(kDataWidth-1 downto 0);
	signal    sInPhaseOut1      : std_logic_vector(kDataWidth-1 downto 0);
	signal    sQuadPhaseOut1    : std_logic_vector(kDataWidth-1 downto 0);
	
        signal StopSim : boolean := false;
        constant kSClkPeriod : time := 1 ns;
        constant kSimCycles : positive := 200000;
        

begin

         Clkgen: process
          begin
            if(StopSim) then
              wait;
            end if;
            Clk <= '0';
            wait for kSClkPeriod;
            Clk <= '1';
            wait for kSClkPeriod;
          end process;

          resetgen: process
          begin
            aReset <= true;
            wait for 200 ns;
            aReset <= false;
            wait;
          end process;



	uut: CarrierRecovery_P2  
	  generic map(8,12,16)
	  port map(               
	    aReset            => aReset,
	    Clk               => Clk,
	                    
	    -- Input data from timing recovery module
	    sEnableIn         => sEnableIn,
	    sInPhase0         => sInPhase0,
	    sQuadPhase0       => sQuadPhase0,
	    sInPhase1         => sInPhase1,
	    sQuadPhase1       => sQuadPhase1,
	    
	    sLockSign         => open,
	    
	    -- output data ready signal and data
	    sEnableOut        => sEnableOut,
	    sInPhaseOut0      => sInPhaseOut0,
	    sQuadPhaseOut0    => sQuadPhaseOut0,
	    sInPhaseOut1      => sInPhaseOut1,
	    sQuadPhaseOut1    => sQuadPhaseOut1
	    );
	    
	
          -- Read Data from file
ReadData: process(aReset, Clk)

            --file infile : text open read_mode is "..\data\result_timerecovery.txt";--data_with_cf_dev.txt";
            file infile : text open read_mode is "..\data\data_from_wyc_8percent.txt";--data_with_cf_dev.txt";
            variable dl : line;
            variable InPhase0, QuadPhase0,InPhase1, QuadPhase1,Enable : integer;
          begin
            if aReset then
        	      sInPhase0			<= (others => '0');
              	sQuadPhase0 	<= (others => '0');
        	      sInPhase1			<= (others => '0');
              	sQuadPhase1 	<= (others => '0');
              	sEnableIn	<= false;
            elsif rising_edge(Clk) then
              if not endfile(infile) then
                readline(infile, dl);
--                read(dl, Enable);
--                if Enable=1 then
                   sEnableIn	<= true;
--                else
--                   sEnableIn <= false;
--                end if;
                
                read(dl, InPhase0);
                sInPhase0 <= std_logic_vector(to_signed(InPhase0,8));
                read(dl, QuadPhase0);
                sQuadPhase0 <= std_logic_vector(to_signed(QuadPhase0,8));
                
                readline(infile, dl);
                read(dl, InPhase1);
                sInPhase1 <= std_logic_vector(to_signed(InPhase1,8));
                read(dl, QuadPhase1);
                sQuadPhase1 <= std_logic_vector(to_signed(QuadPhase1,8));
                
              end if;

            end if;
          end process;

          -- record the  data to file
RecordRecoveredData:     process (aReset,Clk)
            file WriteFile : text open write_mode is "../data/result_phase_revolve.txt";
            variable DataLine : line;
            variable WriteData : integer;
            constant kSpace : character := ' ';
          begin
            if aReset then
            elsif rising_edge(Clk) then
              if sEnableOut then
                WriteData := to_integer(signed(sInPhaseOut0));
                write(DataLine, WriteData);
                write(DataLine, kSpace);
                WriteData := to_integer(signed(sQuadPhaseOut0));
                write(DataLine, WriteData);
                writeline(WriteFile, DataLine);
              end if; 
            end if;
          end process;
	
end rtl;  
