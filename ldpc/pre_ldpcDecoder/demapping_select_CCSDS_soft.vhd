library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demapping_select_CCSDS_soft is   --(3)wei yingpanjuezhi    (2 downto 0) jueduizhi
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		demapping_Mode	: in std_logic;
		datain_i0	: in std_logic_vector(7 downto 0);
		datain_i1	: in std_logic_vector(7 downto 0);
		datain_q0	: in std_logic_vector(7 downto 0);
		datain_q1	: in std_logic_vector(7 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(3 downto 0);
		dataout_i1       : out  std_logic_vector(3 downto 0);
		dataout_q0       : out  std_logic_vector(3 downto 0);
		dataout_q1       : out  std_logic_vector(3 downto 0);
		dataout_valid   : out  std_logic 
	);
end entity;

architecture rtl of demapping_select_CCSDS_soft is

begin
process(aReset,clk) 
begin
	if aReset = '1' then
		dataout_i0 <= (others => '0');
		dataout_q0 <= (others => '0');
		dataout_i1 <= (others => '0');
		dataout_q1 <= (others => '0');
		dataout_valid <= '0';
	elsif rising_edge(clk) then
		--if demapping_Mode = '0' then
			if signed(datain_i0) >= 16 then
				dataout_i0 <= "0111";
			elsif signed(datain_i0) <= -16 then
				dataout_i0 <= "1000";
			elsif signed(datain_i0) >= 0 then
				dataout_i0 <= datain_i0(7) & datain_i0(3 downto 1);
			else
				dataout_i0 <= datain_i0(7) & datain_i0(3 downto 1);
			end if;
				
			if signed(datain_i1) >= 16 then
				dataout_i1 <= "0111";
			elsif signed(datain_i1) <= -16 then
				dataout_i1 <= "1000";
			elsif signed(datain_i1) >= 0 then
				dataout_i1 <= datain_i1(7) & datain_i1(3 downto 1);
			else
				dataout_i1 <= datain_i1(7) &  datain_i1(3 downto 1);
			end if;
			
			if signed(datain_q0) >= 16 then
				dataout_q0 <= "0111";
			elsif signed(datain_q0) <= -16 then
				dataout_q0 <= "1000";
			elsif signed(datain_q0) >= 0 then
				dataout_q0 <= datain_q0(7) & datain_q0(3 downto 1);
			else
				dataout_q0 <= datain_q0(7) &  datain_q0(3 downto 1);
			end if;
				
			if signed(datain_q1) >= 16 then
				dataout_q1 <= "0111";
			elsif signed(datain_q1) <= -16 then
				dataout_q1 <= "1000";
			elsif signed(datain_q1) >= 0 then
				dataout_q1 <= datain_q1(7) & datain_q1(3 downto 1);
			else
				dataout_q1 <= datain_q1(7) &  datain_q1(3 downto 1);
			end if;	
				
			dataout_valid <= datain_valid;
		
				
	end if;
end process;
end rtl;