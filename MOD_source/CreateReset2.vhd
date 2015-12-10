--*********************************************************************************
-- Author : Zaichu Yang
-- Project: 600Mbps Parallel Digital Demodulator
-- Date   : 2008.7.7
--
-- Purpose: 
--        Generate the reset signal (for test).
--
-- Revision History:
--      2008.7.7        first rev.
--*********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity CreateReset2 is
        port (
                Clk_in          : in std_logic;
                --reset_pin       : in std_logic;
				 
                aReset	: out std_logic
                );
end   CreateReset2;              

architecture rtl of CreateReset2 is
--signal counter : integer range 0 to 10000 := 0;
signal counter : integer range 0 to 10000 := 0;
signal counter2 : integer range 0 to 800 := 0;
signal reset_pin_reg1, reset_pin_reg0 : std_logic;
signal mode_reg2, mode_reg1, mode_reg0: std_logic_vector(2 downto 0);
signal mode_change : std_logic;

-- 150MHz
-- 1/(1/150)*10^6 = 1.5*10^8   : 1 seconds

-- 2MHz
-- 4 seconds : 4*2*10^6  ( = 10000 * 800 )

begin
	 process( Clk_in)
	 begin
		if rising_edge( Clk_in ) then
			
				if counter /= 10000 then
					counter <= counter+1;
					if counter2 = 800 then
						aReset <= '0';
					else
						aReset <= '1';
					end if;
				else
					counter <= 0;
					if counter2 /= 800 then
						counter2 <= counter2 + 1;
						aReset <= '1';
					else
						aReset <= '0';
					end if;
				end if;
				
--				if reset_pin_reg1='1' or aReset='1' then
--					aReset_out <= '1';
--				else
--					aReset_out <= '0';
--				end if;
--				
--				reset_pin_reg1 <= reset_pin_reg0;
--				reset_pin_reg0 <= reset_pin;
--	
		end if;
	end process;
	
		
-------------------------------------------------
	 
--	 process (Clk_in)
--    begin
--       if rising_edge(Clk_in) then
--			mode_reg0 <= mode;
--			mode_reg1 <= mode_reg0;
--			mode_reg2 <= mode_reg1;
--			if mode_reg2 = mode_reg1 then
--				mode_change <='0';
--			else
--				mode_change <='1';
--			end if;
--       end if;
--    end process;
		    
               
end rtl;