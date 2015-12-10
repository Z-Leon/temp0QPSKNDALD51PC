library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interpolation_2 is
generic(
			kInSize : positive := 14
			);
port(
		aReset	: in std_logic;
		ClkIn		: in std_logic;
		ClkOut   : in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kInSize-1 downto 0);
		cDout1	: out std_logic_vector(kInSize-1 downto 0);
		cDout2	: out std_logic_vector(kInSize-1 downto 0);
		cDout3	: out std_logic_vector(kInSize-1 downto 0);
		cDout4	: out std_logic_vector(kInSize-1 downto 0);
		cDout5	: out std_logic_vector(kInSize-1 downto 0);
		cDout6	: out std_logic_vector(kInSize-1 downto 0);
		cDout7	: out std_logic_vector(kInSize-1 downto 0)
		);
end entity;

architecture rtl of  interpolation_2 is

component	interpoltationfilter_p8	is
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
end	component;

component	P3toS1_14	is
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
end component;

component	P24toP8_14	is
	 generic(
		kDataWidth  : positive :=14 );
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in1		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in2		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in3		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in4		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in5		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in6		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in7		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in8		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in9		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in10		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in11		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in12		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in13		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in14		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in15		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in16		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in17		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in18		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in19		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in20		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in21		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in22		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in23		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in24		: in std_logic_vector(kDataWidth-1 downto 0);
		--valid_in	: in std_logic;

		data_out1		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out2		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out3		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out4		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out5		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out6		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out7		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out8		: out std_logic_vector(kDataWidth-1 downto 0)
		--valid_out	: out std_logic
		);
end component;


signal flag : integer range 0 to 3;
signal counter1 : integer range 0 to 1;
signal cDin_reg0,cDin_reg1,cDin_reg2,cDin_reg3 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg4,cDin_reg5,cDin_reg6,cDin_reg7 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg8,cDin_reg9,cDin_reg10,cDin_reg11 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg12,cDin_reg13,cDin_reg14,cDin_reg15 : std_logic_vector(kInSize-1 downto 0);
signal cDout0_reg,cDout1_reg,cDout2_reg,cDout3_reg : std_logic_vector(kInSize-1 downto 0);
signal cDout4_reg,cDout5_reg,cDout6_reg,cDout7_reg : std_logic_vector(kInSize-1 downto 0);

begin

--process(aReset,ClkIn)
--begin
--	if aReset = '1' then
--		counter1 <= 0;
--		cDin_reg0 <= (others => '0');
--		cDin_reg1 <= (others => '0');
--		cDin_reg2 <= (others => '0');
--		cDin_reg3 <= (others => '0');
--		cDin_reg4 <= (others => '0');
--		cDin_reg5 <= (others => '0');
--		cDin_reg6 <= (others => '0');
--		cDin_reg7 <= (others => '0');
--		cDin_reg8 <= (others => '0');
--		cDin_reg9 <= (others => '0');
--		cDin_reg10 <= (others => '0');
--		cDin_reg11 <= (others => '0');
--		cDin_reg12 <= (others => '0');
--		cDin_reg13 <= (others => '0');
--		cDin_reg14 <= (others => '0');
--		cDin_reg15 <= (others => '0');
--	elsif rising_edge(ClkIn) then
--		if counter1 = 0 then
--			cDin_reg0 <= cDin0; 
--			cDin_reg1 <= cDin1;
--			cDin_reg2 <= cDin2;
--			cDin_reg3 <= cDin3;
--			cDin_reg4 <= cDin4;
--			cDin_reg5 <= cDin5;
--			cDin_reg6 <= cDin6;
--			cDin_reg7 <= cDin7;
--			counter1 <= 1;
--		else
--			cDin_reg8 <= cDin0; 
--			cDin_reg9 <= cDin1;
--			cDin_reg10 <= cDin2;
--			cDin_reg11 <= cDin3;
--			cDin_reg12 <= cDin4;
--			cDin_reg13 <= cDin5;
--			cDin_reg14 <= cDin6;
--			cDin_reg15 <= cDin7;
--			counter1 <= 0;
--		end if;
--	end if;
--end process;
--
--process(aReset,ClkOut)
--begin
--	if aReset = '1' then
--		flag <= 0;
--		cDout0_reg <= (others => '0');
--		cDout1_reg <= (others => '0');
--		cDout2_reg <= (others => '0');
--		cDout3_reg <= (others => '0');
--		cDout4_reg <= (others => '0');
--		cDout5_reg <= (others => '0');
--		cDout6_reg <= (others => '0');
--		cDout7_reg <= (others => '0');
--	elsif rising_edge(ClkOut) then
--		if flag = 0 then
--			cDout0_reg <= cDin_reg8;
--			cDout1_reg <= (others => '0');
--			cDout2_reg <= cDin_reg9;
--			cDout3_reg <= (others => '0');
--			cDout4_reg <= cDin_reg10;
--			cDout5_reg <= (others => '0');
--			cDout6_reg <= cDin_reg11;
--			cDout7_reg <= (others => '0');
--			flag <= 1;
--		elsif flag = 1 then
--			cDout0_reg <= cDin_reg12;
--			cDout1_reg <= (others => '0');
--			cDout2_reg <= cDin_reg13;
--			cDout3_reg <= (others => '0');
--			cDout4_reg <= cDin_reg14;
--			cDout5_reg <= (others => '0');
--			cDout6_reg <= cDin_reg15;
--			cDout7_reg <= (others => '0');
--			flag <= 2;
--		elsif flag = 2 then
--			cDout0_reg <= cDin_reg0;
--			cDout1_reg <= (others => '0');
--			cDout2_reg <= cDin_reg1;
--			cDout3_reg <= (others => '0');
--			cDout4_reg <= cDin_reg2;
--			cDout5_reg <= (others => '0');
--			cDout6_reg <= cDin_reg3;
--			cDout7_reg <= (others => '0');
--			flag <= 3;
--		else
--			cDout0_reg <= cDin_reg4;
--			cDout1_reg <= (others => '0');
--			cDout2_reg <= cDin_reg5;
--			cDout3_reg <= (others => '0');
--			cDout4_reg <= cDin_reg6;
--			cDout5_reg <= (others => '0');
--			cDout6_reg <= cDin_reg7;
--			cDout7_reg <= (others => '0');
--			flag <= 0;
--		end if;
--	end if;
--end process;



P24toP8_14_inst:	P24toP8_14	
	 generic map(
		14 )
port map(
		aReset		=> aReset,
		clk_in		=> ClkIn,
		clk_out		=> ClkOut,
		data_in1		=> cDin0,
		--data_in2		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in3		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in4		=> cDin1,
		--data_in5		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in6		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in7		=> cDin2,
		--data_in8		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in9		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in10	=> cDin3,
		--data_in11		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in12		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in13	=> cDin4,
		--data_in14		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in15		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in16	=> cDin5,
		--data_in17		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in18		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in19	=> cDin6,
		--data_in20		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in21		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in22	=> cDin7,
		--data_in23		: in std_logic_vector(kDataWidth-1 downto 0);
		--data_in24		: in std_logic_vector(kDataWidth-1 downto 0);
		--valid_in	: in std_logic;

		data_out1		=> cDout0_reg,
		data_out2		=> cDout1_reg,
		data_out3		=> cDout2_reg,
		data_out4		=> cDout3_reg,
		data_out5		=> cDout4_reg,
		data_out6		=> cDout5_reg,
		data_out7		=> cDout6_reg,
		data_out8		=> cDout7_reg
		--valid_out	: out std_logic
		);



interpoltationfilter_p8_inst :	interpoltationfilter_p8	
	 generic map(
		14,
		14)
port map(
		aReset	=> aReset,
		Clk		=> ClkOut,
		cDin0		=> cDout0_reg,
		cDin1		=> cDout1_reg,
		cDin2		=> cDout2_reg,
		cDin3		=> cDout3_reg,
		cDin4		=> cDout4_reg,
		cDin5		=> cDout5_reg,
		cDin6		=> cDout6_reg,
		cDin7		=> cDout7_reg,
		cDout0		=> cDout0,
		cDout1		=> cDout1,
		cDout2		=> cDout2,
		cDout3		=> cDout3,
		cDout4		=> cDout4,
		cDout5		=> cDout5,
		cDout6		=> cDout6,
		cDout7		=> cDout7
		);



end rtl;
