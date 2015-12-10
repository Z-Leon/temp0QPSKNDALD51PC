-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PF_Err_Detect is 
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
end PF_Err_Detect;

architecture rtl of PF_Err_Detect is
	constant cAccSize	: positive :=2*kDataWidth+4;
	signal sInPhase_Reg,sQuadPhase_Reg  		: signed(kDataWidth-1 downto 0);
	signal sInPhase_Ref_Reg,sQuadPhase_Ref_Reg 	: signed(kDataWidth-1 downto 0); --correct star point

	type MultArray is Array (natural range <>) of signed (2*kDataWidth	-1 downto 0);
	signal sInter_Reg: MultArray (3 downto 0);
	
	type AccArray is Array (natural range <>) of signed (cAccSize-1 downto 0);
	signal sAcc_Reg	: AccArray (4 downto 0);
	
	signal sErr_Reg		: signed (cAccSize-1 downto 0); 
	
	signal sEnable_Reg	: std_logic_vector (6 downto 0);
begin
	process (aReset,Clk)
	begin
		if aReset='1' then
			sInPhase_Reg		<= (others => '0');
			sQuadPhase_Reg		<= (others => '0');
			sInPhase_Ref_Reg	<= (others => '0');
			sQuadPhase_Ref_Reg	<= (others => '0');
			for i in 0 to 3 loop
				sInter_Reg(i)	<= (others => '0');
			end loop;

			for i in 0 to 4 loop
				sAcc_Reg(i)	<= (others => '0');
			end loop;

			sErr_Reg		<= (others => '0');
			sEnable_Reg		<= (others => '0');
		elsif rising_edge(Clk) then
			if sEnableIn= '1' then
				sEnable_Reg(0) 	<= '1';
				for i in 1 to 6 loop
					sEnable_Reg(i)	<= sEnable_Reg(i-1);
				end loop;
				
				-- the first pipline
				if sInPhase(kDataWidth-1)='0' then
					sInPhase_Reg	<= signed(sInPhase);
					sInPhase_Ref_Reg<= to_signed(2**(kDataWidth-1)-1,kDataWidth);
				else
					sInPhase_Reg	<= signed(sInPhase);
					sInPhase_Ref_Reg<= to_signed(1-2**(kDataWidth-1),kDataWidth);
				end if;
				
				if sQuadPhase(kDataWidth-1)='0' then
					sQuadPhase_Reg		<= signed(sQuadPhase);
					sQuadPhase_Ref_Reg	<= to_signed(2**(kDataWidth-1)-1,kDataWidth);
				else
					sQuadPhase_Reg		<= signed(sQuadPhase);
					sQuadPhase_Ref_Reg	<= to_signed(1-2**(kDataWidth-1),kDataWidth);
				end if;
				
				-- the second pipline
				sInter_Reg(0)	<= sInPhase_Ref_Reg*sQuadPhase_Reg;
				sInter_Reg(1)	<= sQuadPhase_Ref_Reg*sInPhase_Reg;
				
				-- the third pipline
				sInter_Reg(2)	<= sInter_Reg(1) - sInter_Reg(0);
				
				
				--  joint Frequency-Phase Carrier Recovery
				
				-- the fourth pipline
				sAcc_Reg(0)	<= sInter_Reg(2)&to_signed(0,cAccSize-2*kDataWidth);
				sInter_Reg(3)	<= sInter_Reg(2);
				
				-- the fifth pipline
				sAcc_Reg(1)	<= shift_right(sAcc_Reg(0),4);
				sAcc_Reg(2)	<= sInter_Reg(3)&to_signed(0,cAccSize-2*kDataWidth);
				
				-- the sixth pipline
				sAcc_Reg(3)	<= sAcc_Reg(3) + sAcc_Reg(1);
				sAcc_Reg(4)	<= shift_right(sAcc_Reg(2),0);
				
				-- the seventh pipline
				sErr_Reg	<= sAcc_Reg(3)+sAcc_Reg(4);
				
				-- the eighth pipline
				sErrOut		<= std_logic_vector(sErr_Reg(cAccSize-1 downto cAccSize-kErrWidth));
				
				sEnableOut	<= sEnable_Reg(6);
			else
				sEnableOut	<= '0';
			end if;
		end if;
	end process;
	
end rtl;  
