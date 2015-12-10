-------------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2008.10.10
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 	Revolve the phase based on  error of carrier.
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2008.10.21 first revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Phase_Revolve is 
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
end Phase_Revolve;

architecture rtl of Phase_Revolve is
	component SinData_cr IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (kErrWidth-2 DOWNTO 0);
			clken		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (kSinWidth-1 DOWNTO 0)
		);
	END component;

	component CosData_cr IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (kErrWidth-2 DOWNTO 0);
			clken		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (kSinWidth-1 DOWNTO 0)
		);
	END component;
    	
    	signal sSin_Reg,sCos_Reg : signed (kSinWidth-1 downto 0);
    	
    	type InterArray is Array ( natural range <>) of signed (kDataWidth+kSinWidth-1 downto 0);
    	signal sMult_Reg: InterArray (3 downto 0);
    	signal sRevolved_Reg	: InterArray (1 downto 0);

    	type InputDataArray is Array ( natural range <>) of signed (kDataWidth-1 downto 0);
    	signal sInData_Reg,sQuadData_Reg: InputDataArray (4 downto 0);
    	
    	--To avoid overflow, the width is kErrWidth+1, and the format is (2,kErrWidth-2)
    	signal sPhaseRevolve : signed (kErrWidth downto 0); 
    	
    	signal sSinAddress,sCosAddress	: signed (kErrWidth-1 downto 0);
    	
    	--Output Register
	signal sEnableOut_Reg    : std_logic;
	signal sInPhaseOut_Reg   : std_logic_vector(kDataWidth-1 downto 0);
	signal sQuadPhaseOut_Reg : std_logic_vector(kDataWidth-1 downto 0);

begin


GetSinData: SinData_cr
	port map (
		address		=> std_logic_vector(sSinAddress(kErrWidth-2 downto 0)),
		clken		=> sEnableIn,
		clock		=> Clk,
		signed(q)	=> sSin_Reg
		);
		
GetCosData: CosData_cr
	port map (
		address		=> std_logic_vector(sCosAddress(kErrWidth-2 downto 0)),
		clken		=> sEnableIn,
		clock		=> Clk,
		signed(q)	=> sCos_Reg
		);

PhaseRevolve_Calc: Process ( aReset, Clk)
	begin
		if aReset='1' then
			for i in 0 to 4 loop
				sInData_Reg(i)	<= (others => '0');
				sQuadData_Reg(i)<= (others => '0');
			end loop;
			for i in 0 to 3 loop
				sMult_Reg(i)	<= (others => '0');
			end loop;
			
			for i in 0 to 1 loop
				sRevolved_Reg(i)<= (others => '0');
			end loop;
			
			sPhaseRevolve		<= (others => '0');
			sSinAddress		<= (others => '0');
			sCosAddress		<= (others => '0');	
			sInPhaseOut_Reg		<= (others => '0');
			sQuadPhaseOut_Reg	<= (others => '0');
			sEnableOut_Reg		<= '0';
		elsif rising_edge(Clk) then
			if sEnableIn='1' then
				-- the first pipline
				sInData_Reg(0)	<= signed(sInPhase);	
				sQuadData_Reg(0)<= signed(sQuadPhase);
				for i in 1 to 4 loop
					sInData_Reg(i)	<= sInData_Reg(i-1);	
					sQuadData_Reg(i)<= sQuadData_Reg(i-1);
				end loop;
				
				if sPhaseRevolve(kErrWidth downto kErrWidth-1) = "01" then 
					sPhaseRevolve	<= sPhaseRevolve+signed(sErrCarrier(kErrWidth-1) & sErrCarrier)-to_signed(2**(kErrWidth-1),kErrWidth+1);
				elsif sPhaseRevolve(kErrWidth downto kErrWidth-1) = "10" then
					sPhaseRevolve	<= sPhaseRevolve+signed(sErrCarrier(kErrWidth-1) & sErrCarrier)+to_signed(2**(kErrWidth-1),kErrWidth+1);
				else
					sPhaseRevolve	<= sPhaseRevolve+signed(sErrCarrier(kErrWidth-1) & sErrCarrier);
				end if;
				
				if sPhaseRevolve(kErrWidth) >= '0' then 
					sSinAddress	<= signed('0' & sPhaseRevolve(kErrWidth-2 downto 0));
					sCosAddress	<= signed('0' & sPhaseRevolve(kErrWidth-2 downto 0));
				else
					sSinAddress	<= signed('1' & sPhaseRevolve(kErrWidth-2 downto 0))+to_signed(2**(kErrWidth-1),kErrWidth);
					sCosAddress	<= signed('1' & sPhaseRevolve(kErrWidth-2 downto 0))+to_signed(2**(kErrWidth-1),kErrWidth);
				end if;
				
				
				--Phase revolve
				-- the second pipline				
				sMult_Reg(0)	<= sCos_Reg*sInData_Reg(3);
				sMult_Reg(1)	<= sSin_Reg*sQuadData_Reg(3);
				sMult_Reg(2)	<= sCos_Reg*sQuadData_Reg(3);
				sMult_Reg(3)	<= sSin_Reg*sInData_Reg(3);
				
				-- the third pipline
				sRevolved_Reg(0)<= sMult_Reg(0)-sMult_Reg(1);
				sRevolved_Reg(1)<= sMult_Reg(2)+sMult_Reg(3);
				
				-- the fourth pipline
				sEnableOut_Reg		<= '1';
				sInPhaseOut_Reg		<= std_logic_vector(sRevolved_Reg(0)(kDataWidth+kSinWidth-1) & sRevolved_Reg(0)(kDataWidth+kSinWidth-4 downto kSinWidth-2));
				sQuadPhaseOut_Reg	<= std_logic_vector(sRevolved_Reg(1)(kDataWidth+kSinWidth-1) & sRevolved_Reg(1)(kDataWidth+kSinWidth-4 downto kSinWidth-2));
			else
				sEnableOut_Reg		<= '0';
			end if;	
			
			
		end if;
	end Process;
	sEnableOut	<= sEnableOut_Reg;
	sInPhaseOut	<= sInPhaseOut_Reg;
	sQuadPhaseOut	<= sQuadPhaseOut_Reg;
	
end rtl;  
