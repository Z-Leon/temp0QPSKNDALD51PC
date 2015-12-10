-------------------------------------------------------------------------------
--
-- File: InterpType_delay.vhd
-- Author: Jiang Long 
-- Original Project: QPSK Serial Demodulator
-- Date: 2010.06.22
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
-- 对InterpType信号进行延时操作，与cubic内插模块的Mu值延时一致，保证插值输出数据 
-- 与本模块的输出InterType_d满足对应关系
-- InterpType: 插值点类型（11:最佳点 01:过零点 00,10: 过渡点)
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2010.06.22 First revision 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InterpType_delay is
	port(
		aReset : in std_logic;
		clk    : in std_logic;
		sEnable         : in std_logic;
		data_in : in unsigned(1 downto 0);
		data_out : out unsigned(1 downto 0)
		);
end InterpType_delay;

architecture rt1 of InterpType_delay is
	constant kDelayLen : positive := 4;--8;
	type data_t is array (natural range <>) of unsigned(1 downto 0);
	signal delaydata : data_t(kDelayLen downto 0);
begin
	process(aReset , clk)
	begin
		if aReset='1' then
		for i in 0 to kDelayLen loop
			delaydata(i) <= (others=>'0');
		end loop;
			data_out <= (others => '0'); 
		elsif ( clk'event and clk='1' ) then
			if sEnable='1' then
				data_out <= delaydata(kDelayLen);
				for i in 1 to kDelayLen loop
					delaydata(i) <= delaydata(i-1);
				end loop;
				delaydata(0) <= data_in;
			else
				null;
			end if;
		end if;
	end process;
end rt1;