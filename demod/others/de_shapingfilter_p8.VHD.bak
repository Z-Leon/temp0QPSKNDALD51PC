--————————————————————————————
--本程序为自动生成 (11-Apr-2014)
--功能：8路并行CFIR滤波
--————————————————————————————
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity	shapingfilter_p8_MOD	is
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
end	shapingfilter_p8_MOD;
architecture rtl of	shapingfilter_p8_MOD	is 
	type IntegerArray is array (natural range <>) of integer;
	--滤波器系数
	--constant kTap : IntegerArray(0 to	24)	:=(-20,89,122,36,-98,-150,-38,168,278,130,-240,-560,-492,79,856,1233,695,-721,-2232,-2605,-842,3118,8150,12362,14003);  --0.25
	--constant kTap : IntegerArray(0 to	24)	:=(-29,0,35,0,-42,0,52,0,-65,0,86,0,-117,0,169,0,-265,0,477,0,-1113,0,5563,13107,16689);  --1
	constant kTap : IntegerArray(0 to	24)	:=(58,22,-54,-77,-8,77,66,-50,-132,-50,140,216,40,-216,-197,203,556,203,-983,-2056,-1391,2056,7584,12773,14898);  --0.5
	--系数位宽
	constant kCoeSize : positive :=16;
	--输入数据缓存器
	type InputRegArray is array (natural range <>) of std_logic_vector(kInSize-1 downto 0);
	signal cInputReg : InputRegArray(48 downto 0);
	--求和数据缓存器，为了求和溢出，需要扩充1bit
	type SumRegArray is array (natural range <>) of signed (kInSize downto 0);
	signal cSumReg : SumRegArray(199 downto 0);
	--中间寄存器数组类型
	type InterRegArray is array (natural range <>) of signed (kCoeSize+kInSize downto 0);
	--定义中间寄存器
	signal cInterReg : InterRegArray (415 downto 0);
begin
	process (aReset, Clk)
	begin
		if aReset='1' then
		--对输入寄存器初始化
			for i in 0 to	48 loop
				cInputReg(i)	<= (others => '0');
			end loop;
		--对求和寄存器初始化
			for i in 0 to	199 loop
				cSumReg(i)	<= (others => '0');
			end loop;
		--对中间寄存器初始化
			for i in 0 to	415 loop
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
			cInputReg(25)	<=cInputReg(17);
			cInputReg(26)	<=cInputReg(18);
			cInputReg(27)	<=cInputReg(19);
			cInputReg(28)	<=cInputReg(20);
			cInputReg(29)	<=cInputReg(21);
			cInputReg(30)	<=cInputReg(22);
			cInputReg(31)	<=cInputReg(23);

			cInputReg(32)	<=cInputReg(24);
			cInputReg(33)	<=cInputReg(25);
			cInputReg(34)	<=cInputReg(26);
			cInputReg(35)	<=cInputReg(27);
			cInputReg(36)	<=cInputReg(28);
			cInputReg(37)	<=cInputReg(29);
			cInputReg(38)	<=cInputReg(30);
			cInputReg(39)	<=cInputReg(31);

			cInputReg(40)	<=cInputReg(32);
			cInputReg(41)	<=cInputReg(33);
			cInputReg(42)	<=cInputReg(34);
			cInputReg(43)	<=cInputReg(35);
			cInputReg(44)	<=cInputReg(36);
			cInputReg(45)	<=cInputReg(37);
			cInputReg(46)	<=cInputReg(38);
			cInputReg(47)	<=cInputReg(39);

			cInputReg(48)	<=cInputReg(40);

			--第1条支路
			--************求和以利用对称性************
			cSumReg(0)	<=signed(cInputReg(48)(kInSize-1)&cInputReg(48))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(1)	<=signed(cInputReg(47)(kInSize-1)&cInputReg(47))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(2)	<=signed(cInputReg(46)(kInSize-1)&cInputReg(46))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(3)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(4)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(5)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(6)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(7)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(8)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(9)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(10)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(11)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(12)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(13)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(14)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(15)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(16)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(17)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(18)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(19)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(20)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(21)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			cSumReg(22)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(22)(kInSize-1)&cInputReg(22));
			cSumReg(23)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(23)(kInSize-1)&cInputReg(23));
			cSumReg(24)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24));
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
			cInterReg(13)	<= cSumReg(13)*to_signed(kTap(13),kCoeSize);
			cInterReg(14)	<= cSumReg(14)*to_signed(kTap(14),kCoeSize);
			cInterReg(15)	<= cSumReg(15)*to_signed(kTap(15),kCoeSize);
			cInterReg(16)	<= cSumReg(16)*to_signed(kTap(16),kCoeSize);
			cInterReg(17)	<= cSumReg(17)*to_signed(kTap(17),kCoeSize);
			cInterReg(18)	<= cSumReg(18)*to_signed(kTap(18),kCoeSize);
			cInterReg(19)	<= cSumReg(19)*to_signed(kTap(19),kCoeSize);
			cInterReg(20)	<= cSumReg(20)*to_signed(kTap(20),kCoeSize);
			cInterReg(21)	<= cSumReg(21)*to_signed(kTap(21),kCoeSize);
			cInterReg(22)	<= cSumReg(22)*to_signed(kTap(22),kCoeSize);
			cInterReg(23)	<= cSumReg(23)*to_signed(kTap(23),kCoeSize);
			cInterReg(24)	<= cSumReg(24)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(25)	<=cInterReg(0)+cInterReg(1);
			cInterReg(26)	<=cInterReg(2)+cInterReg(3);
			cInterReg(27)	<=cInterReg(4)+cInterReg(5);
			cInterReg(28)	<=cInterReg(6)+cInterReg(7);
			cInterReg(29)	<=cInterReg(8)+cInterReg(9);
			cInterReg(30)	<=cInterReg(10)+cInterReg(11);
			cInterReg(31)	<=cInterReg(12)+cInterReg(13);
			cInterReg(32)	<=cInterReg(14)+cInterReg(15);
			cInterReg(33)	<=cInterReg(16)+cInterReg(17);
			cInterReg(34)	<=cInterReg(18)+cInterReg(19);
			cInterReg(35)	<=cInterReg(20)+cInterReg(21);
			cInterReg(36)	<=cInterReg(22)+cInterReg(23);
			cInterReg(37)	<=cInterReg(24);
			--*****************pipline2*****************
			cInterReg(38)	<=cInterReg(25)+cInterReg(26);
			cInterReg(39)	<=cInterReg(27)+cInterReg(28);
			cInterReg(40)	<=cInterReg(29)+cInterReg(30);
			cInterReg(41)	<=cInterReg(31)+cInterReg(32);
			cInterReg(42)	<=cInterReg(33)+cInterReg(34);
			cInterReg(43)	<=cInterReg(35)+cInterReg(36);
			cInterReg(44)	<=cInterReg(37);
			--*****************pipline3*****************
			cInterReg(45)	<=cInterReg(38)+cInterReg(39);
			cInterReg(46)	<=cInterReg(40)+cInterReg(41);
			cInterReg(47)	<=cInterReg(42)+cInterReg(43);
			cInterReg(48)	<=cInterReg(44);
			--*****************pipline4*****************
			cInterReg(49)	<=cInterReg(45)+cInterReg(46);
			cInterReg(50)	<=cInterReg(47)+cInterReg(48);
			--*****************pipline5*****************
			cInterReg(51)	<=cInterReg(49)+cInterReg(50);

			--第2条支路
			--************求和以利用对称性************
			cSumReg(25)	<=signed(cInputReg(47)(kInSize-1)&cInputReg(47))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(26)	<=signed(cInputReg(46)(kInSize-1)&cInputReg(46))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(27)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(28)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(29)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(30)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(31)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(32)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(33)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(34)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(35)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(36)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(37)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(38)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(39)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(40)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(41)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(42)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(43)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(44)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(45)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(46)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(47)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			cSumReg(48)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(22)(kInSize-1)&cInputReg(22));
			cSumReg(49)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23));
			--************与系数相乘************
			cInterReg(52)	<= cSumReg(25)*to_signed(kTap(0),kCoeSize);
			cInterReg(53)	<= cSumReg(26)*to_signed(kTap(1),kCoeSize);
			cInterReg(54)	<= cSumReg(27)*to_signed(kTap(2),kCoeSize);
			cInterReg(55)	<= cSumReg(28)*to_signed(kTap(3),kCoeSize);
			cInterReg(56)	<= cSumReg(29)*to_signed(kTap(4),kCoeSize);
			cInterReg(57)	<= cSumReg(30)*to_signed(kTap(5),kCoeSize);
			cInterReg(58)	<= cSumReg(31)*to_signed(kTap(6),kCoeSize);
			cInterReg(59)	<= cSumReg(32)*to_signed(kTap(7),kCoeSize);
			cInterReg(60)	<= cSumReg(33)*to_signed(kTap(8),kCoeSize);
			cInterReg(61)	<= cSumReg(34)*to_signed(kTap(9),kCoeSize);
			cInterReg(62)	<= cSumReg(35)*to_signed(kTap(10),kCoeSize);
			cInterReg(63)	<= cSumReg(36)*to_signed(kTap(11),kCoeSize);
			cInterReg(64)	<= cSumReg(37)*to_signed(kTap(12),kCoeSize);
			cInterReg(65)	<= cSumReg(38)*to_signed(kTap(13),kCoeSize);
			cInterReg(66)	<= cSumReg(39)*to_signed(kTap(14),kCoeSize);
			cInterReg(67)	<= cSumReg(40)*to_signed(kTap(15),kCoeSize);
			cInterReg(68)	<= cSumReg(41)*to_signed(kTap(16),kCoeSize);
			cInterReg(69)	<= cSumReg(42)*to_signed(kTap(17),kCoeSize);
			cInterReg(70)	<= cSumReg(43)*to_signed(kTap(18),kCoeSize);
			cInterReg(71)	<= cSumReg(44)*to_signed(kTap(19),kCoeSize);
			cInterReg(72)	<= cSumReg(45)*to_signed(kTap(20),kCoeSize);
			cInterReg(73)	<= cSumReg(46)*to_signed(kTap(21),kCoeSize);
			cInterReg(74)	<= cSumReg(47)*to_signed(kTap(22),kCoeSize);
			cInterReg(75)	<= cSumReg(48)*to_signed(kTap(23),kCoeSize);
			cInterReg(76)	<= cSumReg(49)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(77)	<=cInterReg(52)+cInterReg(53);
			cInterReg(78)	<=cInterReg(54)+cInterReg(55);
			cInterReg(79)	<=cInterReg(56)+cInterReg(57);
			cInterReg(80)	<=cInterReg(58)+cInterReg(59);
			cInterReg(81)	<=cInterReg(60)+cInterReg(61);
			cInterReg(82)	<=cInterReg(62)+cInterReg(63);
			cInterReg(83)	<=cInterReg(64)+cInterReg(65);
			cInterReg(84)	<=cInterReg(66)+cInterReg(67);
			cInterReg(85)	<=cInterReg(68)+cInterReg(69);
			cInterReg(86)	<=cInterReg(70)+cInterReg(71);
			cInterReg(87)	<=cInterReg(72)+cInterReg(73);
			cInterReg(88)	<=cInterReg(74)+cInterReg(75);
			cInterReg(89)	<=cInterReg(76);
			--*****************pipline2*****************
			cInterReg(90)	<=cInterReg(77)+cInterReg(78);
			cInterReg(91)	<=cInterReg(79)+cInterReg(80);
			cInterReg(92)	<=cInterReg(81)+cInterReg(82);
			cInterReg(93)	<=cInterReg(83)+cInterReg(84);
			cInterReg(94)	<=cInterReg(85)+cInterReg(86);
			cInterReg(95)	<=cInterReg(87)+cInterReg(88);
			cInterReg(96)	<=cInterReg(89);
			--*****************pipline3*****************
			cInterReg(97)	<=cInterReg(90)+cInterReg(91);
			cInterReg(98)	<=cInterReg(92)+cInterReg(93);
			cInterReg(99)	<=cInterReg(94)+cInterReg(95);
			cInterReg(100)	<=cInterReg(96);
			--*****************pipline4*****************
			cInterReg(101)	<=cInterReg(97)+cInterReg(98);
			cInterReg(102)	<=cInterReg(99)+cInterReg(100);
			--*****************pipline5*****************
			cInterReg(103)	<=cInterReg(101)+cInterReg(102);

			--第3条支路
			--************求和以利用对称性************
			cSumReg(50)	<=signed(cInputReg(46)(kInSize-1)&cInputReg(46))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(51)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(52)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(53)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(54)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(55)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(56)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(57)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(58)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(59)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(60)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(61)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(62)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(63)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(64)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(65)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(66)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(67)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(68)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(69)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(70)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(71)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(72)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(73)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			cSumReg(74)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22));
			--************与系数相乘************
			cInterReg(104)	<= cSumReg(50)*to_signed(kTap(0),kCoeSize);
			cInterReg(105)	<= cSumReg(51)*to_signed(kTap(1),kCoeSize);
			cInterReg(106)	<= cSumReg(52)*to_signed(kTap(2),kCoeSize);
			cInterReg(107)	<= cSumReg(53)*to_signed(kTap(3),kCoeSize);
			cInterReg(108)	<= cSumReg(54)*to_signed(kTap(4),kCoeSize);
			cInterReg(109)	<= cSumReg(55)*to_signed(kTap(5),kCoeSize);
			cInterReg(110)	<= cSumReg(56)*to_signed(kTap(6),kCoeSize);
			cInterReg(111)	<= cSumReg(57)*to_signed(kTap(7),kCoeSize);
			cInterReg(112)	<= cSumReg(58)*to_signed(kTap(8),kCoeSize);
			cInterReg(113)	<= cSumReg(59)*to_signed(kTap(9),kCoeSize);
			cInterReg(114)	<= cSumReg(60)*to_signed(kTap(10),kCoeSize);
			cInterReg(115)	<= cSumReg(61)*to_signed(kTap(11),kCoeSize);
			cInterReg(116)	<= cSumReg(62)*to_signed(kTap(12),kCoeSize);
			cInterReg(117)	<= cSumReg(63)*to_signed(kTap(13),kCoeSize);
			cInterReg(118)	<= cSumReg(64)*to_signed(kTap(14),kCoeSize);
			cInterReg(119)	<= cSumReg(65)*to_signed(kTap(15),kCoeSize);
			cInterReg(120)	<= cSumReg(66)*to_signed(kTap(16),kCoeSize);
			cInterReg(121)	<= cSumReg(67)*to_signed(kTap(17),kCoeSize);
			cInterReg(122)	<= cSumReg(68)*to_signed(kTap(18),kCoeSize);
			cInterReg(123)	<= cSumReg(69)*to_signed(kTap(19),kCoeSize);
			cInterReg(124)	<= cSumReg(70)*to_signed(kTap(20),kCoeSize);
			cInterReg(125)	<= cSumReg(71)*to_signed(kTap(21),kCoeSize);
			cInterReg(126)	<= cSumReg(72)*to_signed(kTap(22),kCoeSize);
			cInterReg(127)	<= cSumReg(73)*to_signed(kTap(23),kCoeSize);
			cInterReg(128)	<= cSumReg(74)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(129)	<=cInterReg(104)+cInterReg(105);
			cInterReg(130)	<=cInterReg(106)+cInterReg(107);
			cInterReg(131)	<=cInterReg(108)+cInterReg(109);
			cInterReg(132)	<=cInterReg(110)+cInterReg(111);
			cInterReg(133)	<=cInterReg(112)+cInterReg(113);
			cInterReg(134)	<=cInterReg(114)+cInterReg(115);
			cInterReg(135)	<=cInterReg(116)+cInterReg(117);
			cInterReg(136)	<=cInterReg(118)+cInterReg(119);
			cInterReg(137)	<=cInterReg(120)+cInterReg(121);
			cInterReg(138)	<=cInterReg(122)+cInterReg(123);
			cInterReg(139)	<=cInterReg(124)+cInterReg(125);
			cInterReg(140)	<=cInterReg(126)+cInterReg(127);
			cInterReg(141)	<=cInterReg(128);
			--*****************pipline2*****************
			cInterReg(142)	<=cInterReg(129)+cInterReg(130);
			cInterReg(143)	<=cInterReg(131)+cInterReg(132);
			cInterReg(144)	<=cInterReg(133)+cInterReg(134);
			cInterReg(145)	<=cInterReg(135)+cInterReg(136);
			cInterReg(146)	<=cInterReg(137)+cInterReg(138);
			cInterReg(147)	<=cInterReg(139)+cInterReg(140);
			cInterReg(148)	<=cInterReg(141);
			--*****************pipline3*****************
			cInterReg(149)	<=cInterReg(142)+cInterReg(143);
			cInterReg(150)	<=cInterReg(144)+cInterReg(145);
			cInterReg(151)	<=cInterReg(146)+cInterReg(147);
			cInterReg(152)	<=cInterReg(148);
			--*****************pipline4*****************
			cInterReg(153)	<=cInterReg(149)+cInterReg(150);
			cInterReg(154)	<=cInterReg(151)+cInterReg(152);
			--*****************pipline5*****************
			cInterReg(155)	<=cInterReg(153)+cInterReg(154);

			--第4条支路
			--************求和以利用对称性************
			cSumReg(75)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(76)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(77)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(78)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(79)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(80)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(81)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(82)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(83)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(84)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(85)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(86)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(87)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(88)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(89)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(90)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(91)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(92)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(93)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(94)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(95)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(96)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(97)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(98)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(99)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			--************与系数相乘************
			cInterReg(156)	<= cSumReg(75)*to_signed(kTap(0),kCoeSize);
			cInterReg(157)	<= cSumReg(76)*to_signed(kTap(1),kCoeSize);
			cInterReg(158)	<= cSumReg(77)*to_signed(kTap(2),kCoeSize);
			cInterReg(159)	<= cSumReg(78)*to_signed(kTap(3),kCoeSize);
			cInterReg(160)	<= cSumReg(79)*to_signed(kTap(4),kCoeSize);
			cInterReg(161)	<= cSumReg(80)*to_signed(kTap(5),kCoeSize);
			cInterReg(162)	<= cSumReg(81)*to_signed(kTap(6),kCoeSize);
			cInterReg(163)	<= cSumReg(82)*to_signed(kTap(7),kCoeSize);
			cInterReg(164)	<= cSumReg(83)*to_signed(kTap(8),kCoeSize);
			cInterReg(165)	<= cSumReg(84)*to_signed(kTap(9),kCoeSize);
			cInterReg(166)	<= cSumReg(85)*to_signed(kTap(10),kCoeSize);
			cInterReg(167)	<= cSumReg(86)*to_signed(kTap(11),kCoeSize);
			cInterReg(168)	<= cSumReg(87)*to_signed(kTap(12),kCoeSize);
			cInterReg(169)	<= cSumReg(88)*to_signed(kTap(13),kCoeSize);
			cInterReg(170)	<= cSumReg(89)*to_signed(kTap(14),kCoeSize);
			cInterReg(171)	<= cSumReg(90)*to_signed(kTap(15),kCoeSize);
			cInterReg(172)	<= cSumReg(91)*to_signed(kTap(16),kCoeSize);
			cInterReg(173)	<= cSumReg(92)*to_signed(kTap(17),kCoeSize);
			cInterReg(174)	<= cSumReg(93)*to_signed(kTap(18),kCoeSize);
			cInterReg(175)	<= cSumReg(94)*to_signed(kTap(19),kCoeSize);
			cInterReg(176)	<= cSumReg(95)*to_signed(kTap(20),kCoeSize);
			cInterReg(177)	<= cSumReg(96)*to_signed(kTap(21),kCoeSize);
			cInterReg(178)	<= cSumReg(97)*to_signed(kTap(22),kCoeSize);
			cInterReg(179)	<= cSumReg(98)*to_signed(kTap(23),kCoeSize);
			cInterReg(180)	<= cSumReg(99)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(181)	<=cInterReg(156)+cInterReg(157);
			cInterReg(182)	<=cInterReg(158)+cInterReg(159);
			cInterReg(183)	<=cInterReg(160)+cInterReg(161);
			cInterReg(184)	<=cInterReg(162)+cInterReg(163);
			cInterReg(185)	<=cInterReg(164)+cInterReg(165);
			cInterReg(186)	<=cInterReg(166)+cInterReg(167);
			cInterReg(187)	<=cInterReg(168)+cInterReg(169);
			cInterReg(188)	<=cInterReg(170)+cInterReg(171);
			cInterReg(189)	<=cInterReg(172)+cInterReg(173);
			cInterReg(190)	<=cInterReg(174)+cInterReg(175);
			cInterReg(191)	<=cInterReg(176)+cInterReg(177);
			cInterReg(192)	<=cInterReg(178)+cInterReg(179);
			cInterReg(193)	<=cInterReg(180);
			--*****************pipline2*****************
			cInterReg(194)	<=cInterReg(181)+cInterReg(182);
			cInterReg(195)	<=cInterReg(183)+cInterReg(184);
			cInterReg(196)	<=cInterReg(185)+cInterReg(186);
			cInterReg(197)	<=cInterReg(187)+cInterReg(188);
			cInterReg(198)	<=cInterReg(189)+cInterReg(190);
			cInterReg(199)	<=cInterReg(191)+cInterReg(192);
			cInterReg(200)	<=cInterReg(193);
			--*****************pipline3*****************
			cInterReg(201)	<=cInterReg(194)+cInterReg(195);
			cInterReg(202)	<=cInterReg(196)+cInterReg(197);
			cInterReg(203)	<=cInterReg(198)+cInterReg(199);
			cInterReg(204)	<=cInterReg(200);
			--*****************pipline4*****************
			cInterReg(205)	<=cInterReg(201)+cInterReg(202);
			cInterReg(206)	<=cInterReg(203)+cInterReg(204);
			--*****************pipline5*****************
			cInterReg(207)	<=cInterReg(205)+cInterReg(206);

			--第5条支路
			--************求和以利用对称性************
			cSumReg(100)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(101)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(102)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(103)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(104)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(105)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(106)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(107)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(108)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(109)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(110)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(111)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(112)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(113)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(114)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(115)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(116)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(117)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(118)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(119)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(120)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(121)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(122)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(123)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(124)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			--************与系数相乘************
			cInterReg(208)	<= cSumReg(100)*to_signed(kTap(0),kCoeSize);
			cInterReg(209)	<= cSumReg(101)*to_signed(kTap(1),kCoeSize);
			cInterReg(210)	<= cSumReg(102)*to_signed(kTap(2),kCoeSize);
			cInterReg(211)	<= cSumReg(103)*to_signed(kTap(3),kCoeSize);
			cInterReg(212)	<= cSumReg(104)*to_signed(kTap(4),kCoeSize);
			cInterReg(213)	<= cSumReg(105)*to_signed(kTap(5),kCoeSize);
			cInterReg(214)	<= cSumReg(106)*to_signed(kTap(6),kCoeSize);
			cInterReg(215)	<= cSumReg(107)*to_signed(kTap(7),kCoeSize);
			cInterReg(216)	<= cSumReg(108)*to_signed(kTap(8),kCoeSize);
			cInterReg(217)	<= cSumReg(109)*to_signed(kTap(9),kCoeSize);
			cInterReg(218)	<= cSumReg(110)*to_signed(kTap(10),kCoeSize);
			cInterReg(219)	<= cSumReg(111)*to_signed(kTap(11),kCoeSize);
			cInterReg(220)	<= cSumReg(112)*to_signed(kTap(12),kCoeSize);
			cInterReg(221)	<= cSumReg(113)*to_signed(kTap(13),kCoeSize);
			cInterReg(222)	<= cSumReg(114)*to_signed(kTap(14),kCoeSize);
			cInterReg(223)	<= cSumReg(115)*to_signed(kTap(15),kCoeSize);
			cInterReg(224)	<= cSumReg(116)*to_signed(kTap(16),kCoeSize);
			cInterReg(225)	<= cSumReg(117)*to_signed(kTap(17),kCoeSize);
			cInterReg(226)	<= cSumReg(118)*to_signed(kTap(18),kCoeSize);
			cInterReg(227)	<= cSumReg(119)*to_signed(kTap(19),kCoeSize);
			cInterReg(228)	<= cSumReg(120)*to_signed(kTap(20),kCoeSize);
			cInterReg(229)	<= cSumReg(121)*to_signed(kTap(21),kCoeSize);
			cInterReg(230)	<= cSumReg(122)*to_signed(kTap(22),kCoeSize);
			cInterReg(231)	<= cSumReg(123)*to_signed(kTap(23),kCoeSize);
			cInterReg(232)	<= cSumReg(124)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(233)	<=cInterReg(208)+cInterReg(209);
			cInterReg(234)	<=cInterReg(210)+cInterReg(211);
			cInterReg(235)	<=cInterReg(212)+cInterReg(213);
			cInterReg(236)	<=cInterReg(214)+cInterReg(215);
			cInterReg(237)	<=cInterReg(216)+cInterReg(217);
			cInterReg(238)	<=cInterReg(218)+cInterReg(219);
			cInterReg(239)	<=cInterReg(220)+cInterReg(221);
			cInterReg(240)	<=cInterReg(222)+cInterReg(223);
			cInterReg(241)	<=cInterReg(224)+cInterReg(225);
			cInterReg(242)	<=cInterReg(226)+cInterReg(227);
			cInterReg(243)	<=cInterReg(228)+cInterReg(229);
			cInterReg(244)	<=cInterReg(230)+cInterReg(231);
			cInterReg(245)	<=cInterReg(232);
			--*****************pipline2*****************
			cInterReg(246)	<=cInterReg(233)+cInterReg(234);
			cInterReg(247)	<=cInterReg(235)+cInterReg(236);
			cInterReg(248)	<=cInterReg(237)+cInterReg(238);
			cInterReg(249)	<=cInterReg(239)+cInterReg(240);
			cInterReg(250)	<=cInterReg(241)+cInterReg(242);
			cInterReg(251)	<=cInterReg(243)+cInterReg(244);
			cInterReg(252)	<=cInterReg(245);
			--*****************pipline3*****************
			cInterReg(253)	<=cInterReg(246)+cInterReg(247);
			cInterReg(254)	<=cInterReg(248)+cInterReg(249);
			cInterReg(255)	<=cInterReg(250)+cInterReg(251);
			cInterReg(256)	<=cInterReg(252);
			--*****************pipline4*****************
			cInterReg(257)	<=cInterReg(253)+cInterReg(254);
			cInterReg(258)	<=cInterReg(255)+cInterReg(256);
			--*****************pipline5*****************
			cInterReg(259)	<=cInterReg(257)+cInterReg(258);

			--第6条支路
			--************求和以利用对称性************
			cSumReg(125)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(126)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(127)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(128)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(129)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(130)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(131)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(132)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(133)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(134)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(135)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(136)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(137)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(138)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(139)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(140)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(141)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(142)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(143)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(144)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(145)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(146)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(147)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(148)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(149)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			--************与系数相乘************
			cInterReg(260)	<= cSumReg(125)*to_signed(kTap(0),kCoeSize);
			cInterReg(261)	<= cSumReg(126)*to_signed(kTap(1),kCoeSize);
			cInterReg(262)	<= cSumReg(127)*to_signed(kTap(2),kCoeSize);
			cInterReg(263)	<= cSumReg(128)*to_signed(kTap(3),kCoeSize);
			cInterReg(264)	<= cSumReg(129)*to_signed(kTap(4),kCoeSize);
			cInterReg(265)	<= cSumReg(130)*to_signed(kTap(5),kCoeSize);
			cInterReg(266)	<= cSumReg(131)*to_signed(kTap(6),kCoeSize);
			cInterReg(267)	<= cSumReg(132)*to_signed(kTap(7),kCoeSize);
			cInterReg(268)	<= cSumReg(133)*to_signed(kTap(8),kCoeSize);
			cInterReg(269)	<= cSumReg(134)*to_signed(kTap(9),kCoeSize);
			cInterReg(270)	<= cSumReg(135)*to_signed(kTap(10),kCoeSize);
			cInterReg(271)	<= cSumReg(136)*to_signed(kTap(11),kCoeSize);
			cInterReg(272)	<= cSumReg(137)*to_signed(kTap(12),kCoeSize);
			cInterReg(273)	<= cSumReg(138)*to_signed(kTap(13),kCoeSize);
			cInterReg(274)	<= cSumReg(139)*to_signed(kTap(14),kCoeSize);
			cInterReg(275)	<= cSumReg(140)*to_signed(kTap(15),kCoeSize);
			cInterReg(276)	<= cSumReg(141)*to_signed(kTap(16),kCoeSize);
			cInterReg(277)	<= cSumReg(142)*to_signed(kTap(17),kCoeSize);
			cInterReg(278)	<= cSumReg(143)*to_signed(kTap(18),kCoeSize);
			cInterReg(279)	<= cSumReg(144)*to_signed(kTap(19),kCoeSize);
			cInterReg(280)	<= cSumReg(145)*to_signed(kTap(20),kCoeSize);
			cInterReg(281)	<= cSumReg(146)*to_signed(kTap(21),kCoeSize);
			cInterReg(282)	<= cSumReg(147)*to_signed(kTap(22),kCoeSize);
			cInterReg(283)	<= cSumReg(148)*to_signed(kTap(23),kCoeSize);
			cInterReg(284)	<= cSumReg(149)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(285)	<=cInterReg(260)+cInterReg(261);
			cInterReg(286)	<=cInterReg(262)+cInterReg(263);
			cInterReg(287)	<=cInterReg(264)+cInterReg(265);
			cInterReg(288)	<=cInterReg(266)+cInterReg(267);
			cInterReg(289)	<=cInterReg(268)+cInterReg(269);
			cInterReg(290)	<=cInterReg(270)+cInterReg(271);
			cInterReg(291)	<=cInterReg(272)+cInterReg(273);
			cInterReg(292)	<=cInterReg(274)+cInterReg(275);
			cInterReg(293)	<=cInterReg(276)+cInterReg(277);
			cInterReg(294)	<=cInterReg(278)+cInterReg(279);
			cInterReg(295)	<=cInterReg(280)+cInterReg(281);
			cInterReg(296)	<=cInterReg(282)+cInterReg(283);
			cInterReg(297)	<=cInterReg(284);
			--*****************pipline2*****************
			cInterReg(298)	<=cInterReg(285)+cInterReg(286);
			cInterReg(299)	<=cInterReg(287)+cInterReg(288);
			cInterReg(300)	<=cInterReg(289)+cInterReg(290);
			cInterReg(301)	<=cInterReg(291)+cInterReg(292);
			cInterReg(302)	<=cInterReg(293)+cInterReg(294);
			cInterReg(303)	<=cInterReg(295)+cInterReg(296);
			cInterReg(304)	<=cInterReg(297);
			--*****************pipline3*****************
			cInterReg(305)	<=cInterReg(298)+cInterReg(299);
			cInterReg(306)	<=cInterReg(300)+cInterReg(301);
			cInterReg(307)	<=cInterReg(302)+cInterReg(303);
			cInterReg(308)	<=cInterReg(304);
			--*****************pipline4*****************
			cInterReg(309)	<=cInterReg(305)+cInterReg(306);
			cInterReg(310)	<=cInterReg(307)+cInterReg(308);
			--*****************pipline5*****************
			cInterReg(311)	<=cInterReg(309)+cInterReg(310);

			--第7条支路
			--************求和以利用对称性************
			cSumReg(150)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cDin5(kInSize-1)&cDin5);
			cSumReg(151)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(152)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(153)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(154)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(155)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(156)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(157)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(158)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(159)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(160)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(161)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(162)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(163)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(164)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(165)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(166)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(167)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(168)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(169)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(170)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(171)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(172)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(173)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(174)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			--************与系数相乘************
			cInterReg(312)	<= cSumReg(150)*to_signed(kTap(0),kCoeSize);
			cInterReg(313)	<= cSumReg(151)*to_signed(kTap(1),kCoeSize);
			cInterReg(314)	<= cSumReg(152)*to_signed(kTap(2),kCoeSize);
			cInterReg(315)	<= cSumReg(153)*to_signed(kTap(3),kCoeSize);
			cInterReg(316)	<= cSumReg(154)*to_signed(kTap(4),kCoeSize);
			cInterReg(317)	<= cSumReg(155)*to_signed(kTap(5),kCoeSize);
			cInterReg(318)	<= cSumReg(156)*to_signed(kTap(6),kCoeSize);
			cInterReg(319)	<= cSumReg(157)*to_signed(kTap(7),kCoeSize);
			cInterReg(320)	<= cSumReg(158)*to_signed(kTap(8),kCoeSize);
			cInterReg(321)	<= cSumReg(159)*to_signed(kTap(9),kCoeSize);
			cInterReg(322)	<= cSumReg(160)*to_signed(kTap(10),kCoeSize);
			cInterReg(323)	<= cSumReg(161)*to_signed(kTap(11),kCoeSize);
			cInterReg(324)	<= cSumReg(162)*to_signed(kTap(12),kCoeSize);
			cInterReg(325)	<= cSumReg(163)*to_signed(kTap(13),kCoeSize);
			cInterReg(326)	<= cSumReg(164)*to_signed(kTap(14),kCoeSize);
			cInterReg(327)	<= cSumReg(165)*to_signed(kTap(15),kCoeSize);
			cInterReg(328)	<= cSumReg(166)*to_signed(kTap(16),kCoeSize);
			cInterReg(329)	<= cSumReg(167)*to_signed(kTap(17),kCoeSize);
			cInterReg(330)	<= cSumReg(168)*to_signed(kTap(18),kCoeSize);
			cInterReg(331)	<= cSumReg(169)*to_signed(kTap(19),kCoeSize);
			cInterReg(332)	<= cSumReg(170)*to_signed(kTap(20),kCoeSize);
			cInterReg(333)	<= cSumReg(171)*to_signed(kTap(21),kCoeSize);
			cInterReg(334)	<= cSumReg(172)*to_signed(kTap(22),kCoeSize);
			cInterReg(335)	<= cSumReg(173)*to_signed(kTap(23),kCoeSize);
			cInterReg(336)	<= cSumReg(174)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(337)	<=cInterReg(312)+cInterReg(313);
			cInterReg(338)	<=cInterReg(314)+cInterReg(315);
			cInterReg(339)	<=cInterReg(316)+cInterReg(317);
			cInterReg(340)	<=cInterReg(318)+cInterReg(319);
			cInterReg(341)	<=cInterReg(320)+cInterReg(321);
			cInterReg(342)	<=cInterReg(322)+cInterReg(323);
			cInterReg(343)	<=cInterReg(324)+cInterReg(325);
			cInterReg(344)	<=cInterReg(326)+cInterReg(327);
			cInterReg(345)	<=cInterReg(328)+cInterReg(329);
			cInterReg(346)	<=cInterReg(330)+cInterReg(331);
			cInterReg(347)	<=cInterReg(332)+cInterReg(333);
			cInterReg(348)	<=cInterReg(334)+cInterReg(335);
			cInterReg(349)	<=cInterReg(336);
			--*****************pipline2*****************
			cInterReg(350)	<=cInterReg(337)+cInterReg(338);
			cInterReg(351)	<=cInterReg(339)+cInterReg(340);
			cInterReg(352)	<=cInterReg(341)+cInterReg(342);
			cInterReg(353)	<=cInterReg(343)+cInterReg(344);
			cInterReg(354)	<=cInterReg(345)+cInterReg(346);
			cInterReg(355)	<=cInterReg(347)+cInterReg(348);
			cInterReg(356)	<=cInterReg(349);
			--*****************pipline3*****************
			cInterReg(357)	<=cInterReg(350)+cInterReg(351);
			cInterReg(358)	<=cInterReg(352)+cInterReg(353);
			cInterReg(359)	<=cInterReg(354)+cInterReg(355);
			cInterReg(360)	<=cInterReg(356);
			--*****************pipline4*****************
			cInterReg(361)	<=cInterReg(357)+cInterReg(358);
			cInterReg(362)	<=cInterReg(359)+cInterReg(360);
			--*****************pipline5*****************
			cInterReg(363)	<=cInterReg(361)+cInterReg(362);

			--第8条支路
			--************求和以利用对称性************
			cSumReg(175)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin6(kInSize-1)&cDin6);
			cSumReg(176)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cDin5(kInSize-1)&cDin5);
			cSumReg(177)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(178)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(179)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(180)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(181)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(182)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(183)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(184)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(185)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(186)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(187)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(188)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(189)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(190)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(191)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(192)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(193)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(194)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(195)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(196)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(197)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(198)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(199)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			--************与系数相乘************
			cInterReg(364)	<= cSumReg(175)*to_signed(kTap(0),kCoeSize);
			cInterReg(365)	<= cSumReg(176)*to_signed(kTap(1),kCoeSize);
			cInterReg(366)	<= cSumReg(177)*to_signed(kTap(2),kCoeSize);
			cInterReg(367)	<= cSumReg(178)*to_signed(kTap(3),kCoeSize);
			cInterReg(368)	<= cSumReg(179)*to_signed(kTap(4),kCoeSize);
			cInterReg(369)	<= cSumReg(180)*to_signed(kTap(5),kCoeSize);
			cInterReg(370)	<= cSumReg(181)*to_signed(kTap(6),kCoeSize);
			cInterReg(371)	<= cSumReg(182)*to_signed(kTap(7),kCoeSize);
			cInterReg(372)	<= cSumReg(183)*to_signed(kTap(8),kCoeSize);
			cInterReg(373)	<= cSumReg(184)*to_signed(kTap(9),kCoeSize);
			cInterReg(374)	<= cSumReg(185)*to_signed(kTap(10),kCoeSize);
			cInterReg(375)	<= cSumReg(186)*to_signed(kTap(11),kCoeSize);
			cInterReg(376)	<= cSumReg(187)*to_signed(kTap(12),kCoeSize);
			cInterReg(377)	<= cSumReg(188)*to_signed(kTap(13),kCoeSize);
			cInterReg(378)	<= cSumReg(189)*to_signed(kTap(14),kCoeSize);
			cInterReg(379)	<= cSumReg(190)*to_signed(kTap(15),kCoeSize);
			cInterReg(380)	<= cSumReg(191)*to_signed(kTap(16),kCoeSize);
			cInterReg(381)	<= cSumReg(192)*to_signed(kTap(17),kCoeSize);
			cInterReg(382)	<= cSumReg(193)*to_signed(kTap(18),kCoeSize);
			cInterReg(383)	<= cSumReg(194)*to_signed(kTap(19),kCoeSize);
			cInterReg(384)	<= cSumReg(195)*to_signed(kTap(20),kCoeSize);
			cInterReg(385)	<= cSumReg(196)*to_signed(kTap(21),kCoeSize);
			cInterReg(386)	<= cSumReg(197)*to_signed(kTap(22),kCoeSize);
			cInterReg(387)	<= cSumReg(198)*to_signed(kTap(23),kCoeSize);
			cInterReg(388)	<= cSumReg(199)*to_signed(kTap(24),kCoeSize);
			--*****************求和*****************
			--*****************pipline1*****************
			cInterReg(389)	<=cInterReg(364)+cInterReg(365);
			cInterReg(390)	<=cInterReg(366)+cInterReg(367);
			cInterReg(391)	<=cInterReg(368)+cInterReg(369);
			cInterReg(392)	<=cInterReg(370)+cInterReg(371);
			cInterReg(393)	<=cInterReg(372)+cInterReg(373);
			cInterReg(394)	<=cInterReg(374)+cInterReg(375);
			cInterReg(395)	<=cInterReg(376)+cInterReg(377);
			cInterReg(396)	<=cInterReg(378)+cInterReg(379);
			cInterReg(397)	<=cInterReg(380)+cInterReg(381);
			cInterReg(398)	<=cInterReg(382)+cInterReg(383);
			cInterReg(399)	<=cInterReg(384)+cInterReg(385);
			cInterReg(400)	<=cInterReg(386)+cInterReg(387);
			cInterReg(401)	<=cInterReg(388);
			--*****************pipline2*****************
			cInterReg(402)	<=cInterReg(389)+cInterReg(390);
			cInterReg(403)	<=cInterReg(391)+cInterReg(392);
			cInterReg(404)	<=cInterReg(393)+cInterReg(394);
			cInterReg(405)	<=cInterReg(395)+cInterReg(396);
			cInterReg(406)	<=cInterReg(397)+cInterReg(398);
			cInterReg(407)	<=cInterReg(399)+cInterReg(400);
			cInterReg(408)	<=cInterReg(401);
			--*****************pipline3*****************
			cInterReg(409)	<=cInterReg(402)+cInterReg(403);
			cInterReg(410)	<=cInterReg(404)+cInterReg(405);
			cInterReg(411)	<=cInterReg(406)+cInterReg(407);
			cInterReg(412)	<=cInterReg(408);
			--*****************pipline4*****************
			cInterReg(413)	<=cInterReg(409)+cInterReg(410);
			cInterReg(414)	<=cInterReg(411)+cInterReg(412);
			--*****************pipline5*****************
			cInterReg(415)	<=cInterReg(413)+cInterReg(414);

			--输出数据 （四舍五入）
			if cInterReg(51)(14-1)='0' then
				cDout0	<= std_logic_vector(cInterReg(51)(14+kOutSize-1 downto	14));
			else
				cDout0	<= std_logic_vector(cInterReg(51)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(103)(14-1)='0' then
				cDout1	<= std_logic_vector(cInterReg(103)(14+kOutSize-1 downto	14));
			else
				cDout1	<= std_logic_vector(cInterReg(103)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(155)(14-1)='0' then
				cDout2	<= std_logic_vector(cInterReg(155)(14+kOutSize-1 downto	14));
			else
				cDout2	<= std_logic_vector(cInterReg(155)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(207)(14-1)='0' then
				cDout3	<= std_logic_vector(cInterReg(207)(14+kOutSize-1 downto	14));
			else
				cDout3	<= std_logic_vector(cInterReg(207)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(259)(14-1)='0' then
				cDout4	<= std_logic_vector(cInterReg(259)(14+kOutSize-1 downto	14));
			else
				cDout4	<= std_logic_vector(cInterReg(259)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(311)(14-1)='0' then
				cDout5	<= std_logic_vector(cInterReg(311)(14+kOutSize-1 downto	14));
			else
				cDout5	<= std_logic_vector(cInterReg(311)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(363)(14-1)='0' then
				cDout6	<= std_logic_vector(cInterReg(363)(14+kOutSize-1 downto	14));
			else
				cDout6	<= std_logic_vector(cInterReg(363)(14+kOutSize-1 downto	14)+1);
			end if;
			if cInterReg(415)(14-1)='0' then
				cDout7	<= std_logic_vector(cInterReg(415)(14+kOutSize-1 downto	14));
			else
				cDout7	<= std_logic_vector(cInterReg(415)(14+kOutSize-1 downto	14)+1);
			end if;
		end if;
	end process;
end rtl;
