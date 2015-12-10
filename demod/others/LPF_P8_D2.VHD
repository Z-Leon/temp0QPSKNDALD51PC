--��������������������������������������������������������
--������Ϊ�Զ����� (29-Sep-2014)
--���ܣ�8·����LPF_P8_D2�˲�
--��ȡ�ʣ�2
--��������������������������������������������������������
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity	LPF_P8_D2	is
	 generic(
		kInSize  : positive :=12;
		kOutSize : positive :=8);
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
		cDout3	: out std_logic_vector(kOutSize-1 downto 0)
		);
end	LPF_P8_D2;
architecture rtl of	LPF_P8_D2	is 
	type IntegerArray is array (natural range <>) of integer;
	--�˲���ϵ��
	constant kTap : IntegerArray(0 to	24)	:=(7,19,15,-15,-63,-83,-22,116,235,190,-83,-444,-576,-218,547,1193,1038,-192,-1918,-2794,-1454,2514,8017,12823,14730);
	--ϵ��λ��
	constant kCoeSize : positive :=16;
	--�������ݻ�����
	type InputRegArray is array (natural range <>) of std_logic_vector(kInSize-1 downto 0);
	signal cInputReg : InputRegArray(48 downto 0);
	--�������ݻ�������Ϊ��������������Ҫ���1bit
	type SumRegArray is array (natural range <>) of signed (kInSize downto 0);
	signal cSumReg : SumRegArray(99 downto 0);
	--�м��Ĵ�����������
	type InterRegArray is array (natural range <>) of signed (kCoeSize+kInSize downto 0);
	--�����м��Ĵ���
	signal cInterReg : InterRegArray (139 downto 0);
begin
	process (aReset, Clk)
	begin
		if aReset='1' then
		--�������Ĵ�����ʼ��
			for i in 0 to	48 loop
				cInputReg(i)	<= (others => '0');
			end loop;
		--�����ͼĴ�����ʼ��
			for i in 0 to	99 loop
				cSumReg(i)	<= (others => '0');
			end loop;
		--���м��Ĵ�����ʼ��
			for i in 0 to	139 loop
				cInterReg(i)	<= (others => '0');
			end loop;
		--�������˿ڳ�ʼ��
			cDout0	<= (others => '0');
			cDout1	<= (others => '0');
			cDout2	<= (others => '0');
			cDout3	<= (others => '0');
		elsif rising_edge(Clk) then
			--�������ݻ���

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

			--��2��֧·
			--************���������öԳ���************
			cSumReg(0)	<=signed(cInputReg(47)(kInSize-1)&cInputReg(47))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(1)	<=signed(cInputReg(46)(kInSize-1)&cInputReg(46))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(2)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(3)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(4)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(5)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(6)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(7)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(8)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(9)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(10)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(11)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(12)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(13)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(14)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(15)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(16)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(17)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(18)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(19)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(20)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(21)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(22)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			cSumReg(23)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(22)(kInSize-1)&cInputReg(22));
			cSumReg(24)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23));
			--************��ϵ������************
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
			--*****************����*****************
			--*****************pipline1*****************
			cInterReg(25)	<=cInterReg(0)+cInterReg(1)+cInterReg(2)+cInterReg(3);
			cInterReg(26)	<=cInterReg(4)+cInterReg(5)+cInterReg(6)+cInterReg(7);
			cInterReg(27)	<=cInterReg(8)+cInterReg(9)+cInterReg(10)+cInterReg(11);
			cInterReg(28)	<=cInterReg(12)+cInterReg(13)+cInterReg(14)+cInterReg(15);
			cInterReg(29)	<=cInterReg(16)+cInterReg(17)+cInterReg(18)+cInterReg(19);
			cInterReg(30)	<=cInterReg(20)+cInterReg(21)+cInterReg(22)+cInterReg(23);
			cInterReg(31)	<=cInterReg(24);
			--*****************pipline2*****************
			cInterReg(32)	<=cInterReg(25)+cInterReg(26)+cInterReg(27)+cInterReg(28);
			cInterReg(33)	<=cInterReg(29)+cInterReg(30)+cInterReg(31);
			--*****************pipline3*****************
			cInterReg(34)	<=cInterReg(32)+cInterReg(33);

			--��3��֧·
			--************���������öԳ���************
			cSumReg(25)	<=signed(cInputReg(45)(kInSize-1)&cInputReg(45))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(26)	<=signed(cInputReg(44)(kInSize-1)&cInputReg(44))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(27)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(28)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(29)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(30)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(31)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(32)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(33)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(34)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(35)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(36)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(37)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(38)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(39)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(40)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(41)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(42)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(43)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(44)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(45)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(46)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(47)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			cSumReg(48)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(20)(kInSize-1)&cInputReg(20));
			cSumReg(49)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21));
			--************��ϵ������************
			cInterReg(35)	<= cSumReg(25)*to_signed(kTap(0),kCoeSize);
			cInterReg(36)	<= cSumReg(26)*to_signed(kTap(1),kCoeSize);
			cInterReg(37)	<= cSumReg(27)*to_signed(kTap(2),kCoeSize);
			cInterReg(38)	<= cSumReg(28)*to_signed(kTap(3),kCoeSize);
			cInterReg(39)	<= cSumReg(29)*to_signed(kTap(4),kCoeSize);
			cInterReg(40)	<= cSumReg(30)*to_signed(kTap(5),kCoeSize);
			cInterReg(41)	<= cSumReg(31)*to_signed(kTap(6),kCoeSize);
			cInterReg(42)	<= cSumReg(32)*to_signed(kTap(7),kCoeSize);
			cInterReg(43)	<= cSumReg(33)*to_signed(kTap(8),kCoeSize);
			cInterReg(44)	<= cSumReg(34)*to_signed(kTap(9),kCoeSize);
			cInterReg(45)	<= cSumReg(35)*to_signed(kTap(10),kCoeSize);
			cInterReg(46)	<= cSumReg(36)*to_signed(kTap(11),kCoeSize);
			cInterReg(47)	<= cSumReg(37)*to_signed(kTap(12),kCoeSize);
			cInterReg(48)	<= cSumReg(38)*to_signed(kTap(13),kCoeSize);
			cInterReg(49)	<= cSumReg(39)*to_signed(kTap(14),kCoeSize);
			cInterReg(50)	<= cSumReg(40)*to_signed(kTap(15),kCoeSize);
			cInterReg(51)	<= cSumReg(41)*to_signed(kTap(16),kCoeSize);
			cInterReg(52)	<= cSumReg(42)*to_signed(kTap(17),kCoeSize);
			cInterReg(53)	<= cSumReg(43)*to_signed(kTap(18),kCoeSize);
			cInterReg(54)	<= cSumReg(44)*to_signed(kTap(19),kCoeSize);
			cInterReg(55)	<= cSumReg(45)*to_signed(kTap(20),kCoeSize);
			cInterReg(56)	<= cSumReg(46)*to_signed(kTap(21),kCoeSize);
			cInterReg(57)	<= cSumReg(47)*to_signed(kTap(22),kCoeSize);
			cInterReg(58)	<= cSumReg(48)*to_signed(kTap(23),kCoeSize);
			cInterReg(59)	<= cSumReg(49)*to_signed(kTap(24),kCoeSize);
			--*****************����*****************
			--*****************pipline1*****************
			cInterReg(60)	<=cInterReg(35)+cInterReg(36)+cInterReg(37)+cInterReg(38);
			cInterReg(61)	<=cInterReg(39)+cInterReg(40)+cInterReg(41)+cInterReg(42);
			cInterReg(62)	<=cInterReg(43)+cInterReg(44)+cInterReg(45)+cInterReg(46);
			cInterReg(63)	<=cInterReg(47)+cInterReg(48)+cInterReg(49)+cInterReg(50);
			cInterReg(64)	<=cInterReg(51)+cInterReg(52)+cInterReg(53)+cInterReg(54);
			cInterReg(65)	<=cInterReg(55)+cInterReg(56)+cInterReg(57)+cInterReg(58);
			cInterReg(66)	<=cInterReg(59);
			--*****************pipline2*****************
			cInterReg(67)	<=cInterReg(60)+cInterReg(61)+cInterReg(62)+cInterReg(63);
			cInterReg(68)	<=cInterReg(64)+cInterReg(65)+cInterReg(66);
			--*****************pipline3*****************
			cInterReg(69)	<=cInterReg(67)+cInterReg(68);

			--��4��֧·
			--************���������öԳ���************
			cSumReg(50)	<=signed(cInputReg(43)(kInSize-1)&cInputReg(43))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(51)	<=signed(cInputReg(42)(kInSize-1)&cInputReg(42))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(52)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(53)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(54)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(55)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(56)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(57)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(58)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(59)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(60)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(61)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(62)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(63)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(64)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(65)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(66)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(67)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(68)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(69)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(70)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(71)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(72)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			cSumReg(73)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(18)(kInSize-1)&cInputReg(18));
			cSumReg(74)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19));
			--************��ϵ������************
			cInterReg(70)	<= cSumReg(50)*to_signed(kTap(0),kCoeSize);
			cInterReg(71)	<= cSumReg(51)*to_signed(kTap(1),kCoeSize);
			cInterReg(72)	<= cSumReg(52)*to_signed(kTap(2),kCoeSize);
			cInterReg(73)	<= cSumReg(53)*to_signed(kTap(3),kCoeSize);
			cInterReg(74)	<= cSumReg(54)*to_signed(kTap(4),kCoeSize);
			cInterReg(75)	<= cSumReg(55)*to_signed(kTap(5),kCoeSize);
			cInterReg(76)	<= cSumReg(56)*to_signed(kTap(6),kCoeSize);
			cInterReg(77)	<= cSumReg(57)*to_signed(kTap(7),kCoeSize);
			cInterReg(78)	<= cSumReg(58)*to_signed(kTap(8),kCoeSize);
			cInterReg(79)	<= cSumReg(59)*to_signed(kTap(9),kCoeSize);
			cInterReg(80)	<= cSumReg(60)*to_signed(kTap(10),kCoeSize);
			cInterReg(81)	<= cSumReg(61)*to_signed(kTap(11),kCoeSize);
			cInterReg(82)	<= cSumReg(62)*to_signed(kTap(12),kCoeSize);
			cInterReg(83)	<= cSumReg(63)*to_signed(kTap(13),kCoeSize);
			cInterReg(84)	<= cSumReg(64)*to_signed(kTap(14),kCoeSize);
			cInterReg(85)	<= cSumReg(65)*to_signed(kTap(15),kCoeSize);
			cInterReg(86)	<= cSumReg(66)*to_signed(kTap(16),kCoeSize);
			cInterReg(87)	<= cSumReg(67)*to_signed(kTap(17),kCoeSize);
			cInterReg(88)	<= cSumReg(68)*to_signed(kTap(18),kCoeSize);
			cInterReg(89)	<= cSumReg(69)*to_signed(kTap(19),kCoeSize);
			cInterReg(90)	<= cSumReg(70)*to_signed(kTap(20),kCoeSize);
			cInterReg(91)	<= cSumReg(71)*to_signed(kTap(21),kCoeSize);
			cInterReg(92)	<= cSumReg(72)*to_signed(kTap(22),kCoeSize);
			cInterReg(93)	<= cSumReg(73)*to_signed(kTap(23),kCoeSize);
			cInterReg(94)	<= cSumReg(74)*to_signed(kTap(24),kCoeSize);
			--*****************����*****************
			--*****************pipline1*****************
			cInterReg(95)	<=cInterReg(70)+cInterReg(71)+cInterReg(72)+cInterReg(73);
			cInterReg(96)	<=cInterReg(74)+cInterReg(75)+cInterReg(76)+cInterReg(77);
			cInterReg(97)	<=cInterReg(78)+cInterReg(79)+cInterReg(80)+cInterReg(81);
			cInterReg(98)	<=cInterReg(82)+cInterReg(83)+cInterReg(84)+cInterReg(85);
			cInterReg(99)	<=cInterReg(86)+cInterReg(87)+cInterReg(88)+cInterReg(89);
			cInterReg(100)	<=cInterReg(90)+cInterReg(91)+cInterReg(92)+cInterReg(93);
			cInterReg(101)	<=cInterReg(94);
			--*****************pipline2*****************
			cInterReg(102)	<=cInterReg(95)+cInterReg(96)+cInterReg(97)+cInterReg(98);
			cInterReg(103)	<=cInterReg(99)+cInterReg(100)+cInterReg(101);
			--*****************pipline3*****************
			cInterReg(104)	<=cInterReg(102)+cInterReg(103);

			--��5��֧·
			--************���������öԳ���************
			cSumReg(75)	<=signed(cInputReg(41)(kInSize-1)&cInputReg(41))+signed(cDin6(kInSize-1)&cDin6);
			cSumReg(76)	<=signed(cInputReg(40)(kInSize-1)&cInputReg(40))+signed(cDin5(kInSize-1)&cDin5);
			cSumReg(77)	<=signed(cInputReg(39)(kInSize-1)&cInputReg(39))+signed(cDin4(kInSize-1)&cDin4);
			cSumReg(78)	<=signed(cInputReg(38)(kInSize-1)&cInputReg(38))+signed(cDin3(kInSize-1)&cDin3);
			cSumReg(79)	<=signed(cInputReg(37)(kInSize-1)&cInputReg(37))+signed(cDin2(kInSize-1)&cDin2);
			cSumReg(80)	<=signed(cInputReg(36)(kInSize-1)&cInputReg(36))+signed(cDin1(kInSize-1)&cDin1);
			cSumReg(81)	<=signed(cInputReg(35)(kInSize-1)&cInputReg(35))+signed(cDin0(kInSize-1)&cDin0);
			cSumReg(82)	<=signed(cInputReg(34)(kInSize-1)&cInputReg(34))+signed(cInputReg(0)(kInSize-1)&cInputReg(0));
			cSumReg(83)	<=signed(cInputReg(33)(kInSize-1)&cInputReg(33))+signed(cInputReg(1)(kInSize-1)&cInputReg(1));
			cSumReg(84)	<=signed(cInputReg(32)(kInSize-1)&cInputReg(32))+signed(cInputReg(2)(kInSize-1)&cInputReg(2));
			cSumReg(85)	<=signed(cInputReg(31)(kInSize-1)&cInputReg(31))+signed(cInputReg(3)(kInSize-1)&cInputReg(3));
			cSumReg(86)	<=signed(cInputReg(30)(kInSize-1)&cInputReg(30))+signed(cInputReg(4)(kInSize-1)&cInputReg(4));
			cSumReg(87)	<=signed(cInputReg(29)(kInSize-1)&cInputReg(29))+signed(cInputReg(5)(kInSize-1)&cInputReg(5));
			cSumReg(88)	<=signed(cInputReg(28)(kInSize-1)&cInputReg(28))+signed(cInputReg(6)(kInSize-1)&cInputReg(6));
			cSumReg(89)	<=signed(cInputReg(27)(kInSize-1)&cInputReg(27))+signed(cInputReg(7)(kInSize-1)&cInputReg(7));
			cSumReg(90)	<=signed(cInputReg(26)(kInSize-1)&cInputReg(26))+signed(cInputReg(8)(kInSize-1)&cInputReg(8));
			cSumReg(91)	<=signed(cInputReg(25)(kInSize-1)&cInputReg(25))+signed(cInputReg(9)(kInSize-1)&cInputReg(9));
			cSumReg(92)	<=signed(cInputReg(24)(kInSize-1)&cInputReg(24))+signed(cInputReg(10)(kInSize-1)&cInputReg(10));
			cSumReg(93)	<=signed(cInputReg(23)(kInSize-1)&cInputReg(23))+signed(cInputReg(11)(kInSize-1)&cInputReg(11));
			cSumReg(94)	<=signed(cInputReg(22)(kInSize-1)&cInputReg(22))+signed(cInputReg(12)(kInSize-1)&cInputReg(12));
			cSumReg(95)	<=signed(cInputReg(21)(kInSize-1)&cInputReg(21))+signed(cInputReg(13)(kInSize-1)&cInputReg(13));
			cSumReg(96)	<=signed(cInputReg(20)(kInSize-1)&cInputReg(20))+signed(cInputReg(14)(kInSize-1)&cInputReg(14));
			cSumReg(97)	<=signed(cInputReg(19)(kInSize-1)&cInputReg(19))+signed(cInputReg(15)(kInSize-1)&cInputReg(15));
			cSumReg(98)	<=signed(cInputReg(18)(kInSize-1)&cInputReg(18))+signed(cInputReg(16)(kInSize-1)&cInputReg(16));
			cSumReg(99)	<=signed(cInputReg(17)(kInSize-1)&cInputReg(17));
			--************��ϵ������************
			cInterReg(105)	<= cSumReg(75)*to_signed(kTap(0),kCoeSize);
			cInterReg(106)	<= cSumReg(76)*to_signed(kTap(1),kCoeSize);
			cInterReg(107)	<= cSumReg(77)*to_signed(kTap(2),kCoeSize);
			cInterReg(108)	<= cSumReg(78)*to_signed(kTap(3),kCoeSize);
			cInterReg(109)	<= cSumReg(79)*to_signed(kTap(4),kCoeSize);
			cInterReg(110)	<= cSumReg(80)*to_signed(kTap(5),kCoeSize);
			cInterReg(111)	<= cSumReg(81)*to_signed(kTap(6),kCoeSize);
			cInterReg(112)	<= cSumReg(82)*to_signed(kTap(7),kCoeSize);
			cInterReg(113)	<= cSumReg(83)*to_signed(kTap(8),kCoeSize);
			cInterReg(114)	<= cSumReg(84)*to_signed(kTap(9),kCoeSize);
			cInterReg(115)	<= cSumReg(85)*to_signed(kTap(10),kCoeSize);
			cInterReg(116)	<= cSumReg(86)*to_signed(kTap(11),kCoeSize);
			cInterReg(117)	<= cSumReg(87)*to_signed(kTap(12),kCoeSize);
			cInterReg(118)	<= cSumReg(88)*to_signed(kTap(13),kCoeSize);
			cInterReg(119)	<= cSumReg(89)*to_signed(kTap(14),kCoeSize);
			cInterReg(120)	<= cSumReg(90)*to_signed(kTap(15),kCoeSize);
			cInterReg(121)	<= cSumReg(91)*to_signed(kTap(16),kCoeSize);
			cInterReg(122)	<= cSumReg(92)*to_signed(kTap(17),kCoeSize);
			cInterReg(123)	<= cSumReg(93)*to_signed(kTap(18),kCoeSize);
			cInterReg(124)	<= cSumReg(94)*to_signed(kTap(19),kCoeSize);
			cInterReg(125)	<= cSumReg(95)*to_signed(kTap(20),kCoeSize);
			cInterReg(126)	<= cSumReg(96)*to_signed(kTap(21),kCoeSize);
			cInterReg(127)	<= cSumReg(97)*to_signed(kTap(22),kCoeSize);
			cInterReg(128)	<= cSumReg(98)*to_signed(kTap(23),kCoeSize);
			cInterReg(129)	<= cSumReg(99)*to_signed(kTap(24),kCoeSize);
			--*****************����*****************
			--*****************pipline1*****************
			cInterReg(130)	<=cInterReg(105)+cInterReg(106)+cInterReg(107)+cInterReg(108);
			cInterReg(131)	<=cInterReg(109)+cInterReg(110)+cInterReg(111)+cInterReg(112);
			cInterReg(132)	<=cInterReg(113)+cInterReg(114)+cInterReg(115)+cInterReg(116);
			cInterReg(133)	<=cInterReg(117)+cInterReg(118)+cInterReg(119)+cInterReg(120);
			cInterReg(134)	<=cInterReg(121)+cInterReg(122)+cInterReg(123)+cInterReg(124);
			cInterReg(135)	<=cInterReg(125)+cInterReg(126)+cInterReg(127)+cInterReg(128);
			cInterReg(136)	<=cInterReg(129);
			--*****************pipline2*****************
			cInterReg(137)	<=cInterReg(130)+cInterReg(131)+cInterReg(132)+cInterReg(133);
			cInterReg(138)	<=cInterReg(134)+cInterReg(135)+cInterReg(136);
			--*****************pipline3*****************
			cInterReg(139)	<=cInterReg(137)+cInterReg(138);

			--�������� ���������룩
--			if cInterReg(34)(16-1)='0' then
--				cDout0	<= std_logic_vector(cInterReg(34)(16+kOutSize-1 downto	16));
--			else
--				cDout0	<= std_logic_vector(cInterReg(34)(16+kOutSize-1 downto	16)+1);
--			end if;
--			if cInterReg(69)(16-1)='0' then
--				cDout1	<= std_logic_vector(cInterReg(69)(16+kOutSize-1 downto	16));
--			else
--				cDout1	<= std_logic_vector(cInterReg(69)(16+kOutSize-1 downto	16)+1);
--			end if;
--			if cInterReg(104)(16-1)='0' then
--				cDout2	<= std_logic_vector(cInterReg(104)(16+kOutSize-1 downto	16));
--			else
--				cDout2	<= std_logic_vector(cInterReg(104)(16+kOutSize-1 downto	16)+1);
--			end if;
--			if cInterReg(139)(16-1)='0' then
--				cDout3	<= std_logic_vector(cInterReg(139)(16+kOutSize-1 downto	16));
--			else
--				cDout3	<= std_logic_vector(cInterReg(139)(16+kOutSize-1 downto	16)+1);
--			end if;
			
			if cInterReg(34)(15-1)='0' then
				cDout0	<= std_logic_vector(cInterReg(34)(15+kOutSize-1 downto	15));
			else
				cDout0	<= std_logic_vector(cInterReg(34)(15+kOutSize-1 downto	15)+1);
			end if;
			if cInterReg(69)(15-1)='0' then
				cDout1	<= std_logic_vector(cInterReg(69)(15+kOutSize-1 downto	15));
			else
				cDout1	<= std_logic_vector(cInterReg(69)(15+kOutSize-1 downto	15)+1);
			end if;
			if cInterReg(104)(15-1)='0' then
				cDout2	<= std_logic_vector(cInterReg(104)(15+kOutSize-1 downto	15));
			else
				cDout2	<= std_logic_vector(cInterReg(104)(15+kOutSize-1 downto	15)+1);
			end if;
			if cInterReg(139)(15-1)='0' then
				cDout3	<= std_logic_vector(cInterReg(139)(15+kOutSize-1 downto	15));
			else
				cDout3	<= std_logic_vector(cInterReg(139)(15+kOutSize-1 downto	15)+1);
			end if;
			
		end if;
	end process;
end rtl;
