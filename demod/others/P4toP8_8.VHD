--————————————————————————————
--Author: Jiang Long (29-Sep-2014)
--输入时钟频率必须严格为输出时钟频率的2倍
--严格的整倍数并转串时，valid_out才正确
--————————————————————————————
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	P4toP8_8	is
	 generic(
		kDataWidth  : positive :=8 );
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in1		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in2		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in3		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in4		: in std_logic_vector(kDataWidth-1 downto 0);
		valid_in	: in std_logic;

		data_out1		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out2		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out3		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out4		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out5		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out6		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out7		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out8		: out std_logic_vector(kDataWidth-1 downto 0);
		valid_out	: out std_logic
		);
end	P4toP8_8;
architecture rtl of	P4toP8_8	is 
	type DataArray is array (natural range <>) of std_logic_vector(kDataWidth-1 downto 0);
	signal data_fifo: DataArray(23 downto 0);
	signal valid_fifo : std_logic_vector(23 downto 0);
	signal counter_in : integer range 0 to	5 := 0;
	signal counter_out : integer range 0 to	2 := 0;
begin
	--Process In
	process (aReset, clk_in)
	begin
		if aReset='1' then
			data_fifo(0)<=(others=>'0');
			data_fifo(1)<=(others=>'0');
			data_fifo(2)<=(others=>'0');
			data_fifo(3)<=(others=>'0');
			data_fifo(4)<=(others=>'0');
			data_fifo(5)<=(others=>'0');
			data_fifo(6)<=(others=>'0');
			data_fifo(7)<=(others=>'0');
			data_fifo(8)<=(others=>'0');
			data_fifo(9)<=(others=>'0');
			data_fifo(10)<=(others=>'0');
			data_fifo(11)<=(others=>'0');
			data_fifo(12)<=(others=>'0');
			data_fifo(13)<=(others=>'0');
			data_fifo(14)<=(others=>'0');
			data_fifo(15)<=(others=>'0');
			data_fifo(16)<=(others=>'0');
			data_fifo(17)<=(others=>'0');
			data_fifo(18)<=(others=>'0');
			data_fifo(19)<=(others=>'0');
			data_fifo(20)<=(others=>'0');
			data_fifo(21)<=(others=>'0');
			data_fifo(22)<=(others=>'0');
			data_fifo(23)<=(others=>'0');
			valid_fifo(0)<='0';
			valid_fifo(1)<='0';
			valid_fifo(2)<='0';
			valid_fifo(3)<='0';
			valid_fifo(4)<='0';
			valid_fifo(5)<='0';
			valid_fifo(6)<='0';
			valid_fifo(7)<='0';
			valid_fifo(8)<='0';
			valid_fifo(9)<='0';
			valid_fifo(10)<='0';
			valid_fifo(11)<='0';
			valid_fifo(12)<='0';
			valid_fifo(13)<='0';
			valid_fifo(14)<='0';
			valid_fifo(15)<='0';
			valid_fifo(16)<='0';
			valid_fifo(17)<='0';
			valid_fifo(18)<='0';
			valid_fifo(19)<='0';
			valid_fifo(20)<='0';
			valid_fifo(21)<='0';
			valid_fifo(22)<='0';
			valid_fifo(23)<='0';
			counter_in <= 0;
		elsif rising_edge(clk_in) then
			case counter_in is 
				when	0 =>
					data_fifo(8)<=data_in1;
					data_fifo(9)<=data_in2;
					data_fifo(10)<=data_in3;
					data_fifo(11)<=data_in4;
					valid_fifo(8)<=valid_in;
					valid_fifo(9)<=valid_in;
					valid_fifo(10)<=valid_in;
					valid_fifo(11)<=valid_in;
					counter_in<=1;
				when	1 =>
					data_fifo(12)<=data_in1;
					data_fifo(13)<=data_in2;
					data_fifo(14)<=data_in3;
					data_fifo(15)<=data_in4;
					valid_fifo(12)<=valid_in;
					valid_fifo(13)<=valid_in;
					valid_fifo(14)<=valid_in;
					valid_fifo(15)<=valid_in;
					counter_in<=2;
				when	2 =>
					data_fifo(16)<=data_in1;
					data_fifo(17)<=data_in2;
					data_fifo(18)<=data_in3;
					data_fifo(19)<=data_in4;
					valid_fifo(16)<=valid_in;
					valid_fifo(17)<=valid_in;
					valid_fifo(18)<=valid_in;
					valid_fifo(19)<=valid_in;
					counter_in<=3;
				when	3 =>
					data_fifo(20)<=data_in1;
					data_fifo(21)<=data_in2;
					data_fifo(22)<=data_in3;
					data_fifo(23)<=data_in4;
					valid_fifo(20)<=valid_in;
					valid_fifo(21)<=valid_in;
					valid_fifo(22)<=valid_in;
					valid_fifo(23)<=valid_in;
					counter_in<=4;
				when	4 =>
					data_fifo(0)<=data_in1;
					data_fifo(1)<=data_in2;
					data_fifo(2)<=data_in3;
					data_fifo(3)<=data_in4;
					valid_fifo(0)<=valid_in;
					valid_fifo(1)<=valid_in;
					valid_fifo(2)<=valid_in;
					valid_fifo(3)<=valid_in;
					counter_in<=5;
				when	5 =>
					data_fifo(4)<=data_in1;
					data_fifo(5)<=data_in2;
					data_fifo(6)<=data_in3;
					data_fifo(7)<=data_in4;
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
			data_out1<=(others=>'0');
			data_out2<=(others=>'0');
			data_out3<=(others=>'0');
			data_out4<=(others=>'0');
			data_out5<=(others=>'0');
			data_out6<=(others=>'0');
			data_out7<=(others=>'0');
			data_out8<=(others=>'0');
			valid_out<='0';
			counter_out <= 0;
		elsif rising_edge(clk_out) then
			case counter_out is 
				when	0 =>
					data_out1<=data_fifo(0);
					data_out2<=data_fifo(1);
					data_out3<=data_fifo(2);
					data_out4<=data_fifo(3);
					data_out5<=data_fifo(4);
					data_out6<=data_fifo(5);
					data_out7<=data_fifo(6);
					data_out8<=data_fifo(7);
					valid_out<=valid_fifo(0);
					counter_out<=1;
				when	1 =>
					data_out1<=data_fifo(8);
					data_out2<=data_fifo(9);
					data_out3<=data_fifo(10);
					data_out4<=data_fifo(11);
					data_out5<=data_fifo(12);
					data_out6<=data_fifo(13);
					data_out7<=data_fifo(14);
					data_out8<=data_fifo(15);
					valid_out<=valid_fifo(8);
					counter_out<=2;
				when	2 =>
					data_out1<=data_fifo(16);
					data_out2<=data_fifo(17);
					data_out3<=data_fifo(18);
					data_out4<=data_fifo(19);
					data_out5<=data_fifo(20);
					data_out6<=data_fifo(21);
					data_out7<=data_fifo(22);
					data_out8<=data_fifo(23);
					valid_out<=valid_fifo(16);
					counter_out<=0;
				when others =>
					null;
			end case;
		end if;
	end process;
end rtl;
