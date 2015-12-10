---2----------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2009.6.30
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 	Revolve the phase based on  error of carrier.(for parallel structure)
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2009.6.30 first revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Phase_Revolve_branch is 
  generic(
  	kDataWidth  : positive := 8;
  	kErrWidth   : positive := 12;
  	kSinWidth   : positive := 16
  	);
  port(               
    aReset       : in std_logic;
    Clk          : in std_logic;
                    
    -- Input data from timing recovery module
    sEnableIn    : in std_logic;
    sInPhase     : in signed (kDataWidth-1 downto 0);
    sQuadPhase   : in signed (kDataWidth-1 downto 0);
    
    sPhaseRevolve: in signed (kErrWidth downto 0); 
    
    -- output data ready signal and data
    sInPhaseOut  : out signed(kDataWidth-1 downto 0);
    sQuadPhaseOut: out signed(kDataWidth-1 downto 0));
end Phase_Revolve_branch;

architecture rtl of Phase_Revolve_branch is
			component SinData IS
				PORT
				(
					address		: IN STD_LOGIC_VECTOR (kErrWidth-2 DOWNTO 0);
					clken		: IN STD_LOGIC ;
					clock		: IN STD_LOGIC ;
					q		: OUT STD_LOGIC_VECTOR (kSinWidth-1 DOWNTO 0)
				);
			END component;
		
			component CosData IS
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
    	signal sMult_Reg	: InterArray (3 downto 0);
    	signal sRevolved_Reg	: InterArray (1 downto 0);

    	type InputDataArray is Array ( natural range <>) of signed (kDataWidth-1 downto 0);
    	signal sInData_Reg,sQuadData_Reg: InputDataArray (4 downto 0);
    	
    	
    	signal sSinAddress,sCosAddress	: signed (kErrWidth-1 downto 0);
    	type BooleanArray is array (natural range <>) of boolean;
    	signal sEnable_Reg   : BooleanArray(5 downto 0);
    	
    	--Output Register
	  signal sEnableOut_Reg    : boolean;
	  signal sInPhaseOut_Reg,sQuadPhaseOut_Reg   		: signed(kDataWidth-1 downto 0);
	  
	  --signal for test
	  signal sSign_test : std_logic;

begin


GetSinData: SinData
	port map (
		address		=> std_logic_vector(sSinAddress(kErrWidth-2 downto 0)),
		clken		=> sEnableIn,
		clock		=> Clk,
		signed(q)	=> sSin_Reg
		);

GetCosData: CosData
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
			
			sSinAddress				<= (others => '0');
			sCosAddress				<= (others => '0');
			--sInPhaseOut_Reg			<= (others => '0');
			--sQuadPhaseOut_Reg		<= (others => '0');
			sInPhaseOut				<= (others => '0');
			sQuadPhaseOut			<= (others => '0');
			
			--for test
			--sSign_test	<= '0';
		elsif rising_edge(Clk) then
			if sEnableIn='1' then
				-- the first pipline
--				sEnable_Reg(0)   <= sEnableIn;
--				for i in 1 to 5 loop
--				   sEnable_Reg(i)   <= sEnable_Reg(i-1);
--				end loop;
--				
				sInData_Reg(0)	<= signed(sInPhase);	
				sQuadData_Reg(0)<= signed(sQuadPhase);
				for i in 1 to 4 loop
					sInData_Reg(i)	<= sInData_Reg(i-1);	
					sQuadData_Reg(i)<= sQuadData_Reg(i-1);
				end loop;
				
				if sPhaseRevolve(kErrWidth) >= '0' then 
					sSinAddress	<= signed('0' & sPhaseRevolve(kErrWidth-2 downto 0));
					sCosAddress	<= signed('0' & sPhaseRevolve(kErrWidth-2 downto 0));
				else
					sSinAddress	<= signed('1' & sPhaseRevolve(kErrWidth-2 downto 0))+to_signed(2**(kErrWidth-1)-1,kErrWidth);
					sCosAddress	<= signed('1' & sPhaseRevolve(kErrWidth-2 downto 0))+to_signed(2**(kErrWidth-1)-1,kErrWidth);
				end if;
				
				--Phase revolve
				-- the second pipline				
				sMult_Reg(0)	<= sCos_Reg*sInData_Reg(2);
				sMult_Reg(1)	<= sSin_Reg*sQuadData_Reg(2);
				sMult_Reg(2)	<= sCos_Reg*sQuadData_Reg(2);
				sMult_Reg(3)	<= sSin_Reg*sInData_Reg(2);
				
				-- the third pipline
				sRevolved_Reg(0)<= sMult_Reg(0)-sMult_Reg(1);
				sRevolved_Reg(1)<= sMult_Reg(2)+sMult_Reg(3);
				
				-- the fourth pipline
--				sEnableOut_Reg		<= sEnable_Reg(4);
				sInPhaseOut		<= sRevolved_Reg(0)(kDataWidth+kSinWidth-3 downto kSinWidth-2);
				sQuadPhaseOut	<= sRevolved_Reg(1)(kDataWidth+kSinWidth-3 downto kSinWidth-2);
				
				-- for test
--				if abs(sInPhaseOut_Reg)<= to_signed(10,8) and abs(sQuadPhaseOut_Reg)<= to_signed(10,8) and sEnableOut_Reg=true then
--					sSign_test	<= '1';
--				else
--					sSign_test	<= '0';
--				end if;

--				sEnableOut	<= sEnableOut_Reg;
--				sInPhaseOut	<= sInPhaseOut_Reg;
--				sQuadPhaseOut	<= sQuadPhaseOut_Reg;
			else
				null;
			end if;				
		end if;
	end Process;
	
	
end rtl;  
