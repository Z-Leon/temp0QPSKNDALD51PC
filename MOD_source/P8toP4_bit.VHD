--————————————————————————————
--Author: Jiang Long (04-Mar-2015)
--可能存在潜在的冒险 There might be timing risks
--输入时钟频率必须严格为输出时钟频率的1/2倍
--严格的整倍数并转串时，valid_out才正确
--————————————————————————————
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	P8toP4_bit	is
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in	: in std_logic_vector(7 downto 0);
		valid_in	: in std_logic;

		data_out	: out std_logic_vector(3 downto 0);
		valid_out	: out std_logic
		);
end	P8toP4_bit;
architecture rtl of	P8toP4_bit	is 
	signal data_fifo: std_logic_vector(23 downto 0);
	signal valid_fifo : std_logic_vector(23 downto 0);
	signal counter_in : integer range 0 to	2 := 0;
	signal counter_out : integer range 0 to	5 := 0;
begin
	--Process In
	process (aReset, clk_in)
	begin
		if aReset='1' then
			data_fifo<=(others=>'0');
			valid_fifo<=(others=>'0');
			counter_in <= 0;
		elsif rising_edge(clk_in) then
			case counter_in is 
				when	0 =>
					data_fifo(8)<=data_in(0);
					data_fifo(9)<=data_in(1);
					data_fifo(10)<=data_in(2);
					data_fifo(11)<=data_in(3);
					data_fifo(12)<=data_in(4);
					data_fifo(13)<=data_in(5);
					data_fifo(14)<=data_in(6);
					data_fifo(15)<=data_in(7);
					valid_fifo(8)<=valid_in;
					valid_fifo(9)<=valid_in;
					valid_fifo(10)<=valid_in;
					valid_fifo(11)<=valid_in;
					valid_fifo(12)<=valid_in;
					valid_fifo(13)<=valid_in;
					valid_fifo(14)<=valid_in;
					valid_fifo(15)<=valid_in;
					counter_in<=1;
				when	1 =>
					data_fifo(16)<=data_in(0);
					data_fifo(17)<=data_in(1);
					data_fifo(18)<=data_in(2);
					data_fifo(19)<=data_in(3);
					data_fifo(20)<=data_in(4);
					data_fifo(21)<=data_in(5);
					data_fifo(22)<=data_in(6);
					data_fifo(23)<=data_in(7);
					valid_fifo(16)<=valid_in;
					valid_fifo(17)<=valid_in;
					valid_fifo(18)<=valid_in;
					valid_fifo(19)<=valid_in;
					valid_fifo(20)<=valid_in;
					valid_fifo(21)<=valid_in;
					valid_fifo(22)<=valid_in;
					valid_fifo(23)<=valid_in;
					counter_in<=2;
				when	2 =>
					data_fifo(0)<=data_in(0);
					data_fifo(1)<=data_in(1);
					data_fifo(2)<=data_in(2);
					data_fifo(3)<=data_in(3);
					data_fifo(4)<=data_in(4);
					data_fifo(5)<=data_in(5);
					data_fifo(6)<=data_in(6);
					data_fifo(7)<=data_in(7);
					valid_fifo(0)<=valid_in;
					valid_fifo(1)<=valid_in;
					valid_fifo(2)<=valid_in;
					valid_fifo(3)<=valid_in;
					valid_fifo(4)<=valid_in;
					valid_fifo(5)<=valid_in;
					valid_fifo(6)<=valid_in;
					valid_fifo(7)<=valid_in;
					counter_in<=0;
				when others =>
					null;
			end case;
		end if;
	end process;

	--Process Out
	process (aReset, clk_out)
	begin
		if aReset='1' then
			data_out<=(others=>'0');
			valid_out<='0';
			counter_out <= 0;
		elsif rising_edge(clk_out) then
			case counter_out is 
				when	0 =>
					data_out(0)<=data_fifo(0);
					data_out(1)<=data_fifo(1);
					data_out(2)<=data_fifo(2);
					data_out(3)<=data_fifo(3);
					valid_out<=valid_fifo(0);
					counter_out<=1;
				when	1 =>
					data_out(0)<=data_fifo(4);
					data_out(1)<=data_fifo(5);
					data_out(2)<=data_fifo(6);
					data_out(3)<=data_fifo(7);
					valid_out<=valid_fifo(4);
					counter_out<=2;
				when	2 =>
					data_out(0)<=data_fifo(8);
					data_out(1)<=data_fifo(9);
					data_out(2)<=data_fifo(10);
					data_out(3)<=data_fifo(11);
					valid_out<=valid_fifo(8);
					counter_out<=3;
				when	3 =>
					data_out(0)<=data_fifo(12);
					data_out(1)<=data_fifo(13);
					data_out(2)<=data_fifo(14);
					data_out(3)<=data_fifo(15);
					valid_out<=valid_fifo(12);
					counter_out<=4;
				when	4 =>
					data_out(0)<=data_fifo(16);
					data_out(1)<=data_fifo(17);
					data_out(2)<=data_fifo(18);
					data_out(3)<=data_fifo(19);
					valid_out<=valid_fifo(16);
					counter_out<=5;
				when	5 =>
					data_out(0)<=data_fifo(20);
					data_out(1)<=data_fifo(21);
					data_out(2)<=data_fifo(22);
					data_out(3)<=data_fifo(23);
					valid_out<=valid_fifo(20);
					counter_out<=0;
				when others =>
					null;
			end case;
		end if;
	end process;
end rtl;
