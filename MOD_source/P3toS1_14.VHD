--————————————————————————————
--Author: Jiang Long (28-Sep-2014)
--输入时钟频率必须严格为输出时钟频率的1/3倍
--严格的整倍数并转串时，valid_out才正确

-- Modified for Interpolation
--————————————————————————————
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	P3toS1_14	is
	 generic(
		kDataWidth  : positive :=14 );
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in1		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in2		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in3		: in std_logic_vector(kDataWidth-1 downto 0);
		--valid_in	: in std_logic;

		data_out1		: out std_logic_vector(kDataWidth-1 downto 0)
		--valid_out	: out std_logic
		);
end	P3toS1_14;
architecture rtl of	P3toS1_14	is 
	type DataArray is array (natural range <>) of std_logic_vector(kDataWidth-1 downto 0);
	signal data_fifo: DataArray(8 downto 0);
	signal valid_fifo : std_logic_vector(8 downto 0);
	signal counter_in : integer range 0 to	2 := 0;
	signal counter_out : integer range 0 to	8 := 0;
begin
	--Process In
	process (aReset, clk_in)
	begin
		if aReset='1' then
			data_fifo(0)<=(others=>'0');
			--data_fifo(1)<=(others=>'0');
			--data_fifo(2)<=(others=>'0');
			data_fifo(3)<=(others=>'0');
			--data_fifo(4)<=(others=>'0');
			--data_fifo(5)<=(others=>'0');
			data_fifo(6)<=(others=>'0');
			--data_fifo(7)<=(others=>'0');
			--data_fifo(8)<=(others=>'0');
			-- valid_fifo(0)<='0';
			-- valid_fifo(1)<='0';
			-- valid_fifo(2)<='0';
			-- valid_fifo(3)<='0';
			-- valid_fifo(4)<='0';
			-- valid_fifo(5)<='0';
			-- valid_fifo(6)<='0';
			-- valid_fifo(7)<='0';
			-- valid_fifo(8)<='0';
			counter_in <= 0;
		elsif rising_edge(clk_in) then
			case counter_in is 
				when	0 =>
					data_fifo(3)<=data_in1;
					--data_fifo(4)<=data_in2;
					--data_fifo(5)<=data_in3;
					-- valid_fifo(3)<=valid_in;
					-- valid_fifo(4)<=valid_in;
					-- valid_fifo(5)<=valid_in;
					counter_in<=1;
				when	1 =>
					data_fifo(6)<=data_in1;
					--data_fifo(7)<=data_in2;
					--data_fifo(8)<=data_in3;
					-- valid_fifo(6)<=valid_in;
					-- valid_fifo(7)<=valid_in;
					-- valid_fifo(8)<=valid_in;
					counter_in<=2;
				when	2 =>
					data_fifo(0)<=data_in1;
					--data_fifo(1)<=data_in2;
					--data_fifo(2)<=data_in3;
					-- valid_fifo(0)<=valid_in;
					-- valid_fifo(1)<=valid_in;
					-- valid_fifo(2)<=valid_in;
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
			--valid_out<='0';
			counter_out <= 0;
		elsif rising_edge(clk_out) then
			case counter_out is 
				when	0 =>
					data_out1<=data_fifo(0);
					--valid_out<=valid_fifo(0);
					counter_out<=1;
				when	1 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(1);
					counter_out<=2;
				when	2 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(2);
					counter_out<=3;
				when	3 =>
					data_out1<=data_fifo(3);
					--valid_out<=valid_fifo(3);
					counter_out<=4;
				when	4 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(4);
					counter_out<=5;
				when	5 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(5);
					counter_out<=6;
				when	6 =>
					data_out1<=data_fifo(6);
					--valid_out<=valid_fifo(6);
					counter_out<=7;
				when	7 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(7);
					counter_out<=8;
				when	8 =>
					data_out1<=(others=>'0');
					--valid_out<=valid_fifo(8);
					counter_out<=0;
				when others =>
					null;
			end case;
		end if;
	end process;
end rtl;
