--2-----------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2008.10.10
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 	Get the error of carrier.
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2008.10.23 first revision
--
-- 2015.04 Remove Loop Filter which is before stop-go ctrl module   Author: Jiang Long
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PF_Err_Detect_P2 is 
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
--    sEnableOut        : out boolean;
    sErrOut0          : out std_logic_vector(kErrWidth-1 downto 0);
    sErrOut1          : out std_logic_vector(kErrWidth-1 downto 0));
end PF_Err_Detect_P2;

architecture rtl of PF_Err_Detect_P2 is
	constant cAccSize	: positive :=2*kDataWidth+4;
	signal sInPhase_Reg0,sQuadPhase_Reg0  		: signed(kDataWidth-1 downto 0);
	signal sInPhase_Ref_Reg0,sQuadPhase_Ref_Reg0: signed(kDataWidth-1 downto 0); --correct star point
	signal sInPhase_Reg1,sQuadPhase_Reg1  		: signed(kDataWidth-1 downto 0);
	signal sInPhase_Ref_Reg1,sQuadPhase_Ref_Reg1: signed(kDataWidth-1 downto 0); --correct star point

	type MultArray is Array (natural range <>) of signed (2*kDataWidth	-1 downto 0);
	signal sInter_Reg0: MultArray (2 downto 0);
	signal sInter_Reg1: MultArray (2 downto 0);
	signal sInter_Reg2: MultArray (4 downto 0);
	
	type AccArray is Array (natural range <>) of signed (cAccSize-1 downto 0);
	signal sAcc_Reg	: AccArray (10 downto 0);
	
	signal sErr_Reg0,sErr_Reg1		: signed (cAccSize-1 downto 0); 
	
	type BooleanArrary is array (natural range <>) of boolean;
	signal sEnable_Reg	: BooleanArrary (9 downto 0);
begin
	process (aReset,Clk)
	begin
		if aReset='1' then
			sInPhase_Reg0		<= (others => '0');
			sQuadPhase_Reg0		<= (others => '0');
			sInPhase_Ref_Reg0	<= (others => '0');
			sQuadPhase_Ref_Reg0	<= (others => '0');
			sInPhase_Reg1		<= (others => '0');
			sQuadPhase_Reg1		<= (others => '0');
			sInPhase_Ref_Reg1	<= (others => '0');
			sQuadPhase_Ref_Reg1	<= (others => '0');
			for i in 0 to 1 loop
				sInter_Reg0(i)	<= (others => '0');
				sInter_Reg1(i)	<= (others => '0');
				--sInter_Reg2(i)	<= (others => '0');
			end loop;
			
			for i in 0 to 3 loop
				sInter_Reg2(i)	<= (others => '0');
			end loop;
			--sInter_Reg	<= (others => '0');
			
--			for i in 0 to 9 loop
--				sAcc_Reg(i)	<= (others => '0');
--			end loop;
--
--			sErr_Reg0		<= (others => '0');
--			sErr_Reg1		<= (others => '0');
--	
--			sErrOut0		<= (others => '0');
--			sErrOut1		<= (others => '0');
----			sEnableOut		<= false;
		elsif rising_edge(Clk) then
			if sEnableIn='1' then
	
				-- the first pipline
				if sInPhase0(kDataWidth-1)='0' then
					sInPhase_Reg0	<= signed(sInPhase0);
					sInPhase_Ref_Reg0<= to_signed(91,kDataWidth);
				else
					sInPhase_Reg0	<= signed(sInPhase0);
					sInPhase_Ref_Reg0<= to_signed(-91,kDataWidth);
				end if;

				if sInPhase1(kDataWidth-1)='0' then
					sInPhase_Reg1	<= signed(sInPhase1);
					sInPhase_Ref_Reg1<= to_signed(91,kDataWidth);
				else
					sInPhase_Reg1	<= signed(sInPhase1);
					sInPhase_Ref_Reg1<= to_signed(-91,kDataWidth);
				end if;
				
				if sQuadPhase0(kDataWidth-1)='0' then
					sQuadPhase_Reg0		<= signed(sQuadPhase0);
					sQuadPhase_Ref_Reg0	<= to_signed(91,kDataWidth);
				else
					sQuadPhase_Reg0		<= signed(sQuadPhase0);
					sQuadPhase_Ref_Reg0	<= to_signed(-91,kDataWidth);
				end if;

				if sQuadPhase1(kDataWidth-1)='0' then
					sQuadPhase_Reg1		<= signed(sQuadPhase1);
					sQuadPhase_Ref_Reg1	<= to_signed(91,kDataWidth);
				else
					sQuadPhase_Reg1		<= signed(sQuadPhase1);
					sQuadPhase_Ref_Reg1	<= to_signed(-91,kDataWidth);
				end if;
				
				-- the second pipline
				sInter_Reg0(0)	<= sInPhase_Ref_Reg0*sQuadPhase_Reg0;
				sInter_Reg0(1)	<= sQuadPhase_Ref_Reg0*sInPhase_Reg0;
				sInter_Reg1(0)	<= sInPhase_Ref_Reg1*sQuadPhase_Reg1;
				sInter_Reg1(1)	<= sQuadPhase_Ref_Reg1*sInPhase_Reg1;
				
				-- the third pipline
				sInter_Reg2(0)	<= sInter_Reg0(1) - sInter_Reg0(0);
				sInter_Reg2(1)	<= sInter_Reg1(1) - sInter_Reg1(0);
				
				
			else
				null;
			end if;
		end if;
	end process;

	sErrOut0 <= std_logic_vector(sInter_Reg2(0)(2*kDataWidth	-1 downto 2*kDataWidth-kErrWidth));
	sErrOut1 <= std_logic_vector(sInter_Reg2(1)(2*kDataWidth	-1 downto 2*kDataWidth-kErrWidth));
	
end rtl;  
