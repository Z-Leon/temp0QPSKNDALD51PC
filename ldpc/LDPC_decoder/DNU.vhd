library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DNU is
       port(
           clk:     in  std_logic;
           reset:   in  std_logic;
           data_in: in  std_logic_vector(31 downto 0);
           data_out:out  std_logic
           );
end entity;

architecture rtl of DNU is
    signal xor_reg1:std_logic_vector(5 downto 0);
    signal xor_reg2:std_logic;
begin
 process(clk,reset)
  begin
    if (reset='1') then
        xor_reg1<="000000";
        xor_reg2<='0';
    elsif (clk'event and clk='1') then
      xor_reg1(0) <=data_in(5) xor data_in(4) xor data_in(3) xor data_in(2) xor data_in(1) xor data_in(0);
      xor_reg1(1) <=data_in(11) xor data_in(10) xor data_in(9) xor data_in(8) xor data_in(7) xor data_in(6);
		xor_reg1(2) <=data_in(16) xor data_in(15) xor data_in(14) xor data_in(13) xor data_in(12);
		xor_reg1(3) <=data_in(21) xor data_in(20) xor data_in(19) xor data_in(18) xor data_in(17);
		xor_reg1(4) <=data_in(26) xor data_in(25) xor data_in(24) xor data_in(23) xor data_in(22);
		xor_reg1(5) <=data_in(31) xor data_in(30) xor data_in(29) xor data_in(28) xor data_in(27);
		
		xor_reg2 <=xor_reg1(5) xor xor_reg1(4) xor xor_reg1(3) xor xor_reg1(2) xor xor_reg1(1) xor xor_reg1(0);
	  end if;
 end process;
 data_out <= xor_reg2;
end rtl;