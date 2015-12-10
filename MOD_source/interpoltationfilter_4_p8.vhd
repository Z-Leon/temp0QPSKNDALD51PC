--————————————————————————————
--本程序为自动生成 (03-Apr-2014)
--功能：8路并行CFIR滤波
--————————————————————————————
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity	interpoltationfilter_4_p8	is
	 generic(
		kInSize  : positive :=14;
		kOutSize : positive :=14);
port(
		aReset	: in std_logic;
		Clk		: in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kOutSize-1 downto 0);
		cDout1	: out std_logic_vector(kOutSize-1 downto 0);
		cDout2	: out std_logic_vector(kOutSize-1 downto 0);
		cDout3	: out std_logic_vector(kOutSize-1 downto 0);
		cDout4	: out std_logic_vector(kOutSize-1 downto 0);
		cDout5	: out std_logic_vector(kOutSize-1 downto 0);
		cDout6	: out std_logic_vector(kOutSize-1 downto 0);
		cDout7	: out std_logic_vector(kOutSize-1 downto 0)
		);
end	interpoltationfilter_4_p8;
architecture rtl of	interpoltationfilter_4_p8	is 
	type IntegerArray is array (natural range <>) of integer;
	--滤波器系数
	--fs = 1600  fpass = 100 fstop = 200  round(Num*2^16*0.65)
	constant kTap : IntegerArray(0 to	12)	:=(670,-8,-349,-814,-1205,-1264,-766,397,2143,4196,6139,7531,8035);
	--系数位宽
	constant kCoeSize : positive :=16;
	--输入数据缓存器
	type InputRegArray is array (natural range <>) of std_logic_vector(kInSize-1 downto 0);
	signal cInputReg : InputRegArray(24 downto 0);
	--求和数据缓存器，为了求和溢出，需要扩充1bit
	type SumRegArray is array (natural range <>) of signed (kInSize downto 0);
	signal cSumReg : SumRegArray(103 downto 0);
	--中间寄存器数组类型
	type InterRegArray is array (natural range <>) of signed (kCoeSize+kInSize downto 0);
	--定义中间寄存器
	signal cInterReg : InterRegArray (215 downto 0);
begin
	process (aReset, Clk)
	begin
		if aReset='1' then
		--对输入寄存器初始化
			for i in 0 to	24 loop
				cInputReg(i)	<= (others => '0');
			end loop;
		--对求和寄存器初始化
			for i in 0 to	103 loop
				cSumReg(i)	<= (others => '0');
			end loop;
		--对中间寄存器初始化
			for i in 0 to	215 loop
				cInterReg(i)	<= (others => '0');
			end loop;
		--对输出端口初始化
			cDout0	<= (others => '0');
			cDout1	<= (others => '0');
			cDout2	<= (others => '0');
			cDout3	<= (others => '0');
			cDout4	<= (others => '0');
			cDout5	<= (others => '0');
			cDout6	<= (others => '0');
			cDout7	<= (others => '0');
		elsif rising_edge(Clk) then
			--输入数据缓存

			cInputReg(7)	<=cDin0;
			cInputReg(6)	<=cDin1;
			cInputReg(5)	<=cDin2;
			cInputReg(4)	<=cDin3;
			cInputReg(3)	<=cDin4;
			cInputReg(2)	<=cDin5;
			cInputReg(1)	<=cDin6;
			cInputReg(0)	<=cDin7;

			cInputReg(8)	<=cInputReg(0);
			cInputReg(9)	<=cInputReg(1);
			cInputReg(10)	<=cInputReg(2);
			cInputReg(11)	<=cInputReg(3);
			cInputReg(12)	<=cInputReg(4);
			cInputReg(13)	<=cInputReg(5);
			cInputReg(14)	<=cInputReg(6);
			cInputReg(15)	<=cInputReg(7);

			cInputReg(16)	<=cInputReg(8);
			cInputReg(17)	<=cInputReg(9);
			cInputReg(18)	<=cInputReg(10);
			cInputReg(19)	<=cInputReg(11);
			cInputReg(20)	<=cInputReg(12);
			cInputReg(21)	<=cInputReg(13);
			cInputReg(22)	<=cInputReg(14);
			cInputReg(23)	<=cInputReg(15);

			cInputReg(24)	<=cInputReg(16);

			--第1条支路
			--************求和以利用对称性************
			cSumReg(0)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(1)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(2)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(3)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(4)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(5)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(6)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(7)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(8)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(9)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(10)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(11)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(12)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			--************与系数相乘************
			cInterReg(0)	<= cSumReg(0)*to_signed(kTap(0),kCoeSize);
			cInterReg(1)	<= cSumReg(1)*to_signed(kTap(1),kCoeSize);
			cInterReg(2)	<= cSumReg(2)*to_signed(kTap(2),kCoeSize);
			cInterReg(3)	<= cSumReg(3)*to_signed(kTap(3),kCoeSize);
			cInterReg(4)	<= cSumReg(4)*to_signed(kTap(4),kCoeSize);
			cInterReg(5)	<= cSumReg(5)*to_signed(kTap(5),kCoeSize);
			cInterReg(6)	<= cSumReg(6)*to_signed(kTap(6),kCoeSize);
			cInterReg(7)	<= cSumReg(7)*to_signed(kTap(7),kCoeSize);
			cInterReg(8)	<= cSumReg(8)*to_signed(kTap(8),kCoeSize);
			cInterReg(9)	<= cSumReg(9)*to_signed(kTap(9),kCoeSize);
			cInterReg(10)	<= cSumReg(10)*to_signed(kTap(10),kCoeSize);
			cInterReg(11)	<= cSumReg(11)*to_signed(kTap(11),kCoeSize);
			cInterReg(12)	<= cSumReg(12)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(13)	<=cInterReg(0)+cInterReg(1);
			cInterReg(14)	<=cInterReg(2)+cInterReg(3);
			cInterReg(15)	<=cInterReg(4)+cInterReg(5);
			cInterReg(16)	<=cInterReg(6)+cInterReg(7);
			cInterReg(17)	<=cInterReg(8)+cInterReg(9);
			cInterReg(18)	<=cInterReg(10)+cInterReg(11);
			cInterReg(19)	<=cInterReg(12);
			--*****************pipline2*****************
			cInterReg(20)	<=cInterReg(13)+cInterReg(14);
			cInterReg(21)	<=cInterReg(15)+cInterReg(16);
			cInterReg(22)	<=cInterReg(17)+cInterReg(18);
			cInterReg(23)	<=cInterReg(19);
			--*****************pipline3*****************
			cInterReg(24)	<=cInterReg(20)+cInterReg(21);
			cInterReg(25)	<=cInterReg(22)+cInterReg(23);
			--*****************pipline4*****************
			cInterReg(26)	<=cInterReg(24)+cInterReg(25);

			--第2条支路
			--************求和以利用对称性************
			cSumReg(13)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(14)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(15)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(16)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(17)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(18)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(19)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(20)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(21)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(22)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(23)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(24)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(25)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			--************与系数相乘************
			cInterReg(27)	<= cSumReg(13)*to_signed(kTap(0),kCoeSize);
			cInterReg(28)	<= cSumReg(14)*to_signed(kTap(1),kCoeSize);
			cInterReg(29)	<= cSumReg(15)*to_signed(kTap(2),kCoeSize);
			cInterReg(30)	<= cSumReg(16)*to_signed(kTap(3),kCoeSize);
			cInterReg(31)	<= cSumReg(17)*to_signed(kTap(4),kCoeSize);
			cInterReg(32)	<= cSumReg(18)*to_signed(kTap(5),kCoeSize);
			cInterReg(33)	<= cSumReg(19)*to_signed(kTap(6),kCoeSize);
			cInterReg(34)	<= cSumReg(20)*to_signed(kTap(7),kCoeSize);
			cInterReg(35)	<= cSumReg(21)*to_signed(kTap(8),kCoeSize);
			cInterReg(36)	<= cSumReg(22)*to_signed(kTap(9),kCoeSize);
			cInterReg(37)	<= cSumReg(23)*to_signed(kTap(10),kCoeSize);
			cInterReg(38)	<= cSumReg(24)*to_signed(kTap(11),kCoeSize);
			cInterReg(39)	<= cSumReg(25)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(40)	<=cInterReg(27)+cInterReg(28);
			cInterReg(41)	<=cInterReg(29)+cInterReg(30);
			cInterReg(42)	<=cInterReg(31)+cInterReg(32);
			cInterReg(43)	<=cInterReg(33)+cInterReg(34);
			cInterReg(44)	<=cInterReg(35)+cInterReg(36);
			cInterReg(45)	<=cInterReg(37)+cInterReg(38);
			cInterReg(46)	<=cInterReg(39);
			--*****************pipline2*****************
			cInterReg(47)	<=cInterReg(40)+cInterReg(41);
			cInterReg(48)	<=cInterReg(42)+cInterReg(43);
			cInterReg(49)	<=cInterReg(44)+cInterReg(45);
			cInterReg(50)	<=cInterReg(46);
			--*****************pipline3*****************
			cInterReg(51)	<=cInterReg(47)+cInterReg(48);
			cInterReg(52)	<=cInterReg(49)+cInterReg(50);
			--*****************pipline4*****************
			cInterReg(53)	<=cInterReg(51)+cInterReg(52);

			--第3条支路
			--************求和以利用对称性************
			cSumReg(26)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(27)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(28)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(29)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(30)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(31)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(32)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(33)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(34)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(35)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(36)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(37)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(38)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			--************与系数相乘************
			cInterReg(54)	<= cSumReg(26)*to_signed(kTap(0),kCoeSize);
			cInterReg(55)	<= cSumReg(27)*to_signed(kTap(1),kCoeSize);
			cInterReg(56)	<= cSumReg(28)*to_signed(kTap(2),kCoeSize);
			cInterReg(57)	<= cSumReg(29)*to_signed(kTap(3),kCoeSize);
			cInterReg(58)	<= cSumReg(30)*to_signed(kTap(4),kCoeSize);
			cInterReg(59)	<= cSumReg(31)*to_signed(kTap(5),kCoeSize);
			cInterReg(60)	<= cSumReg(32)*to_signed(kTap(6),kCoeSize);
			cInterReg(61)	<= cSumReg(33)*to_signed(kTap(7),kCoeSize);
			cInterReg(62)	<= cSumReg(34)*to_signed(kTap(8),kCoeSize);
			cInterReg(63)	<= cSumReg(35)*to_signed(kTap(9),kCoeSize);
			cInterReg(64)	<= cSumReg(36)*to_signed(kTap(10),kCoeSize);
			cInterReg(65)	<= cSumReg(37)*to_signed(kTap(11),kCoeSize);
			cInterReg(66)	<= cSumReg(38)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(67)	<=cInterReg(54)+cInterReg(55);
			cInterReg(68)	<=cInterReg(56)+cInterReg(57);
			cInterReg(69)	<=cInterReg(58)+cInterReg(59);
			cInterReg(70)	<=cInterReg(60)+cInterReg(61);
			cInterReg(71)	<=cInterReg(62)+cInterReg(63);
			cInterReg(72)	<=cInterReg(64)+cInterReg(65);
			cInterReg(73)	<=cInterReg(66);
			--*****************pipline2*****************
			cInterReg(74)	<=cInterReg(67)+cInterReg(68);
			cInterReg(75)	<=cInterReg(69)+cInterReg(70);
			cInterReg(76)	<=cInterReg(71)+cInterReg(72);
			cInterReg(77)	<=cInterReg(73);
			--*****************pipline3*****************
			cInterReg(78)	<=cInterReg(74)+cInterReg(75);
			cInterReg(79)	<=cInterReg(76)+cInterReg(77);
			--*****************pipline4*****************
			cInterReg(80)	<=cInterReg(78)+cInterReg(79);

			--第4条支路
			--************求和以利用对称性************
			cSumReg(39)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(40)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(41)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(42)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(43)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(44)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(45)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(46)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(47)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(48)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(49)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(50)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(51)	<=signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			--************与系数相乘************
			cInterReg(81)	<= cSumReg(39)*to_signed(kTap(0),kCoeSize);
			cInterReg(82)	<= cSumReg(40)*to_signed(kTap(1),kCoeSize);
			cInterReg(83)	<= cSumReg(41)*to_signed(kTap(2),kCoeSize);
			cInterReg(84)	<= cSumReg(42)*to_signed(kTap(3),kCoeSize);
			cInterReg(85)	<= cSumReg(43)*to_signed(kTap(4),kCoeSize);
			cInterReg(86)	<= cSumReg(44)*to_signed(kTap(5),kCoeSize);
			cInterReg(87)	<= cSumReg(45)*to_signed(kTap(6),kCoeSize);
			cInterReg(88)	<= cSumReg(46)*to_signed(kTap(7),kCoeSize);
			cInterReg(89)	<= cSumReg(47)*to_signed(kTap(8),kCoeSize);
			cInterReg(90)	<= cSumReg(48)*to_signed(kTap(9),kCoeSize);
			cInterReg(91)	<= cSumReg(49)*to_signed(kTap(10),kCoeSize);
			cInterReg(92)	<= cSumReg(50)*to_signed(kTap(11),kCoeSize);
			cInterReg(93)	<= cSumReg(51)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(94)	<=cInterReg(81)+cInterReg(82);
			cInterReg(95)	<=cInterReg(83)+cInterReg(84);
			cInterReg(96)	<=cInterReg(85)+cInterReg(86);
			cInterReg(97)	<=cInterReg(87)+cInterReg(88);
			cInterReg(98)	<=cInterReg(89)+cInterReg(90);
			cInterReg(99)	<=cInterReg(91)+cInterReg(92);
			cInterReg(100)	<=cInterReg(93);
			--*****************pipline2*****************
			cInterReg(101)	<=cInterReg(94)+cInterReg(95);
			cInterReg(102)	<=cInterReg(96)+cInterReg(97);
			cInterReg(103)	<=cInterReg(98)+cInterReg(99);
			cInterReg(104)	<=cInterReg(100);
			--*****************pipline3*****************
			cInterReg(105)	<=cInterReg(101)+cInterReg(102);
			cInterReg(106)	<=cInterReg(103)+cInterReg(104);
			--*****************pipline4*****************
			cInterReg(107)	<=cInterReg(105)+cInterReg(106);

			--第5条支路
			--************求和以利用对称性************
			cSumReg(52)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(53)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(54)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(55)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(56)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(57)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(58)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(59)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(60)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(61)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(62)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(63)	<=signed(cInputReg(9)(kInSize-1)&cInputReg(9))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(64)	<=signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			--************与系数相乘************
			cInterReg(108)	<= cSumReg(52)*to_signed(kTap(0),kCoeSize);
			cInterReg(109)	<= cSumReg(53)*to_signed(kTap(1),kCoeSize);
			cInterReg(110)	<= cSumReg(54)*to_signed(kTap(2),kCoeSize);
			cInterReg(111)	<= cSumReg(55)*to_signed(kTap(3),kCoeSize);
			cInterReg(112)	<= cSumReg(56)*to_signed(kTap(4),kCoeSize);
			cInterReg(113)	<= cSumReg(57)*to_signed(kTap(5),kCoeSize);
			cInterReg(114)	<= cSumReg(58)*to_signed(kTap(6),kCoeSize);
			cInterReg(115)	<= cSumReg(59)*to_signed(kTap(7),kCoeSize);
			cInterReg(116)	<= cSumReg(60)*to_signed(kTap(8),kCoeSize);
			cInterReg(117)	<= cSumReg(61)*to_signed(kTap(9),kCoeSize);
			cInterReg(118)	<= cSumReg(62)*to_signed(kTap(10),kCoeSize);
			cInterReg(119)	<= cSumReg(63)*to_signed(kTap(11),kCoeSize);
			cInterReg(120)	<= cSumReg(64)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(121)	<=cInterReg(108)+cInterReg(109);
			cInterReg(122)	<=cInterReg(110)+cInterReg(111);
			cInterReg(123)	<=cInterReg(112)+cInterReg(113);
			cInterReg(124)	<=cInterReg(114)+cInterReg(115);
			cInterReg(125)	<=cInterReg(116)+cInterReg(117);
			cInterReg(126)	<=cInterReg(118)+cInterReg(119);
			cInterReg(127)	<=cInterReg(120);
			--*****************pipline2*****************
			cInterReg(128)	<=cInterReg(121)+cInterReg(122);
			cInterReg(129)	<=cInterReg(123)+cInterReg(124);
			cInterReg(130)	<=cInterReg(125)+cInterReg(126);
			cInterReg(131)	<=cInterReg(127);
			--*****************pipline3*****************
			cInterReg(132)	<=cInterReg(128)+cInterReg(129);
			cInterReg(133)	<=cInterReg(130)+cInterReg(131);
			--*****************pipline4*****************
			cInterReg(134)	<=cInterReg(132)+cInterReg(133);

			--第6条支路
			--************求和以利用对称性************
			cSumReg(65)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(66)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(67)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(68)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(69)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(70)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(71)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(72)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(73)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(74)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(75)	<=signed(cInputReg(9)(kInSize-1)&cInputReg(9))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(76)	<=signed(cInputReg(8)(kInSize-1)&cInputReg(8))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(77)	<=signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			--************与系数相乘************
			cInterReg(135)	<= cSumReg(65)*to_signed(kTap(0),kCoeSize);
			cInterReg(136)	<= cSumReg(66)*to_signed(kTap(1),kCoeSize);
			cInterReg(137)	<= cSumReg(67)*to_signed(kTap(2),kCoeSize);
			cInterReg(138)	<= cSumReg(68)*to_signed(kTap(3),kCoeSize);
			cInterReg(139)	<= cSumReg(69)*to_signed(kTap(4),kCoeSize);
			cInterReg(140)	<= cSumReg(70)*to_signed(kTap(5),kCoeSize);
			cInterReg(141)	<= cSumReg(71)*to_signed(kTap(6),kCoeSize);
			cInterReg(142)	<= cSumReg(72)*to_signed(kTap(7),kCoeSize);
			cInterReg(143)	<= cSumReg(73)*to_signed(kTap(8),kCoeSize);
			cInterReg(144)	<= cSumReg(74)*to_signed(kTap(9),kCoeSize);
			cInterReg(145)	<= cSumReg(75)*to_signed(kTap(10),kCoeSize);
			cInterReg(146)	<= cSumReg(76)*to_signed(kTap(11),kCoeSize);
			cInterReg(147)	<= cSumReg(77)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(148)	<=cInterReg(135)+cInterReg(136);
			cInterReg(149)	<=cInterReg(137)+cInterReg(138);
			cInterReg(150)	<=cInterReg(139)+cInterReg(140);
			cInterReg(151)	<=cInterReg(141)+cInterReg(142);
			cInterReg(152)	<=cInterReg(143)+cInterReg(144);
			cInterReg(153)	<=cInterReg(145)+cInterReg(146);
			cInterReg(154)	<=cInterReg(147);
			--*****************pipline2*****************
			cInterReg(155)	<=cInterReg(148)+cInterReg(149);
			cInterReg(156)	<=cInterReg(150)+cInterReg(151);
			cInterReg(157)	<=cInterReg(152)+cInterReg(153);
			cInterReg(158)	<=cInterReg(154);
			--*****************pipline3*****************
			cInterReg(159)	<=cInterReg(155)+cInterReg(156);
			cInterReg(160)	<=cInterReg(157)+cInterReg(158);
			--*****************pipline4*****************
			cInterReg(161)	<=cInterReg(159)+cInterReg(160);

			--第7条支路
			--************求和以利用对称性************
			cSumReg(78)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cDin5(kInSize-1)&cDin5);
			cSumReg(79)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(80)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(81)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(82)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(83)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(84)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(85)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(86)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(87)	<=signed(cInputReg(9)(kInSize-1)&cInputReg(9))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(88)	<=signed(cInputReg(8)(kInSize-1)&cInputReg(8))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(89)	<=signed(cInputReg(7)(kInSize-1)&cInputReg(7))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(90)	<=signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			--************与系数相乘************
			cInterReg(162)	<= cSumReg(78)*to_signed(kTap(0),kCoeSize);
			cInterReg(163)	<= cSumReg(79)*to_signed(kTap(1),kCoeSize);
			cInterReg(164)	<= cSumReg(80)*to_signed(kTap(2),kCoeSize);
			cInterReg(165)	<= cSumReg(81)*to_signed(kTap(3),kCoeSize);
			cInterReg(166)	<= cSumReg(82)*to_signed(kTap(4),kCoeSize);
			cInterReg(167)	<= cSumReg(83)*to_signed(kTap(5),kCoeSize);
			cInterReg(168)	<= cSumReg(84)*to_signed(kTap(6),kCoeSize);
			cInterReg(169)	<= cSumReg(85)*to_signed(kTap(7),kCoeSize);
			cInterReg(170)	<= cSumReg(86)*to_signed(kTap(8),kCoeSize);
			cInterReg(171)	<= cSumReg(87)*to_signed(kTap(9),kCoeSize);
			cInterReg(172)	<= cSumReg(88)*to_signed(kTap(10),kCoeSize);
			cInterReg(173)	<= cSumReg(89)*to_signed(kTap(11),kCoeSize);
			cInterReg(174)	<= cSumReg(90)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(175)	<=cInterReg(162)+cInterReg(163);
			cInterReg(176)	<=cInterReg(164)+cInterReg(165);
			cInterReg(177)	<=cInterReg(166)+cInterReg(167);
			cInterReg(178)	<=cInterReg(168)+cInterReg(169);
			cInterReg(179)	<=cInterReg(170)+cInterReg(171);
			cInterReg(180)	<=cInterReg(172)+cInterReg(173);
			cInterReg(181)	<=cInterReg(174);
			--*****************pipline2*****************
			cInterReg(182)	<=cInterReg(175)+cInterReg(176);
			cInterReg(183)	<=cInterReg(177)+cInterReg(178);
			cInterReg(184)	<=cInterReg(179)+cInterReg(180);
			cInterReg(185)	<=cInterReg(181);
			--*****************pipline3*****************
			cInterReg(186)	<=cInterReg(182)+cInterReg(183);
			cInterReg(187)	<=cInterReg(184)+cInterReg(185);
			--*****************pipline4*****************
			cInterReg(188)	<=cInterReg(186)+cInterReg(187);

			--第8条支路
			--************求和以利用对称性************
			cSumReg(91)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17))+signed(cDin6(kInSize-1)&cDin6);
			cSumReg(92)	<=signed(cInputReg(16)(kInSize-1)&cInputReg(16))+signed(cDin5(kInSize-1)&cDin5);
			cSumReg(93)	<=signed(cInputReg(15)(kInSize-1)&cInputReg(15))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(94)	<=signed(cInputReg(14)(kInSize-1)&cInputReg(14))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(95)	<=signed(cInputReg(13)(kInSize-1)&cInputReg(13))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(96)	<=signed(cInputReg(12)(kInSize-1)&cInputReg(12))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(97)	<=signed(cInputReg(11)(kInSize-1)&cInputReg(11))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(98)	<=signed(cInputReg(10)(kInSize-1)&cInputReg(10))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(99)	<=signed(cInputReg(9)(kInSize-1)&cInputReg(9))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(100)	<=signed(cInputReg(8)(kInSize-1)&cInputReg(8))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(101)	<=signed(cInputReg(7)(kInSize-1)&cInputReg(7))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(102)	<=signed(cInputReg(6)(kInSize-1)&cInputReg(6))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(103)	<=signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			--************与系数相乘************
			cInterReg(189)	<= cSumReg(91)*to_signed(kTap(0),kCoeSize);
			cInterReg(190)	<= cSumReg(92)*to_signed(kTap(1),kCoeSize);
			cInterReg(191)	<= cSumReg(93)*to_signed(kTap(2),kCoeSize);
			cInterReg(192)	<= cSumReg(94)*to_signed(kTap(3),kCoeSize);
			cInterReg(193)	<= cSumReg(95)*to_signed(kTap(4),kCoeSize);
			cInterReg(194)	<= cSumReg(96)*to_signed(kTap(5),kCoeSize);
			cInterReg(195)	<= cSumReg(97)*to_signed(kTap(6),kCoeSize);
			cInterReg(196)	<= cSumReg(98)*to_signed(kTap(7),kCoeSize);
			cInterReg(197)	<= cSumReg(99)*to_signed(kTap(8),kCoeSize);
			cInterReg(198)	<= cSumReg(100)*to_signed(kTap(9),kCoeSize);
			cInterReg(199)	<= cSumReg(101)*to_signed(kTap(10),kCoeSize);
			cInterReg(200)	<= cSumReg(102)*to_signed(kTap(11),kCoeSize);
			cInterReg(201)	<= cSumReg(103)*to_signed(kTap(12),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(202)	<=cInterReg(189)+cInterReg(190);
			cInterReg(203)	<=cInterReg(191)+cInterReg(192);
			cInterReg(204)	<=cInterReg(193)+cInterReg(194);
			cInterReg(205)	<=cInterReg(195)+cInterReg(196);
			cInterReg(206)	<=cInterReg(197)+cInterReg(198);
			cInterReg(207)	<=cInterReg(199)+cInterReg(200);
			cInterReg(208)	<=cInterReg(201);
			--*****************pipline2*****************
			cInterReg(209)	<=cInterReg(202)+cInterReg(203);
			cInterReg(210)	<=cInterReg(204)+cInterReg(205);
			cInterReg(211)	<=cInterReg(206)+cInterReg(207);
			cInterReg(212)	<=cInterReg(208);
			--*****************pipline3*****************
			cInterReg(213)	<=cInterReg(209)+cInterReg(210);
			cInterReg(214)	<=cInterReg(211)+cInterReg(212);
			--*****************pipline4*****************
			cInterReg(215)	<=cInterReg(213)+cInterReg(214);

			--输出数据 （四舍五入）
			if cInterReg(26)(14-1)='0' then
				cDout0	<= std_logic_vector(cInterReg(26)(14+kOutSize-1 downto	14));
			else
				cDout0	<= std_logic_vector(cInterReg(26)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(53)(14-1)='0' then
				cDout1	<= std_logic_vector(cInterReg(53)(14+kOutSize-1 downto	14));
			else
				cDout1	<= std_logic_vector(cInterReg(53)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(80)(14-1)='0' then
				cDout2	<= std_logic_vector(cInterReg(80)(14+kOutSize-1 downto	14));
			else
				cDout2	<= std_logic_vector(cInterReg(80)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(107)(14-1)='0' then
				cDout3	<= std_logic_vector(cInterReg(107)(14+kOutSize-1 downto	14));
			else
				cDout3	<= std_logic_vector(cInterReg(107)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(134)(14-1)='0' then
				cDout4	<= std_logic_vector(cInterReg(134)(14+kOutSize-1 downto	14));
			else
				cDout4	<= std_logic_vector(cInterReg(134)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(161)(14-1)='0' then
				cDout5	<= std_logic_vector(cInterReg(161)(14+kOutSize-1 downto	14));
			else
				cDout5	<= std_logic_vector(cInterReg(161)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(188)(14-1)='0' then
				cDout6	<= std_logic_vector(cInterReg(188)(14+kOutSize-1 downto	14));
			else
				cDout6	<= std_logic_vector(cInterReg(188)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(215)(14-1)='0' then
				cDout7	<= std_logic_vector(cInterReg(215)(14+kOutSize-1 downto	14));
			else
				cDout7	<= std_logic_vector(cInterReg(215)(14+kOutSize-1 downto	14)+1);
			end if;
		end if;
	end process;
end rtl;
