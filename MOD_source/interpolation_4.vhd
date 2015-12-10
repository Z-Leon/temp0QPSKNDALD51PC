library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interpolation_4 is
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

architecture rtl of  interpolation_4 is

component	interpoltationfilter_4_p8	is
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

signal flag : integer range 0 to 7;
signal counter1 : integer range 0 to 1;
signal cDin_reg0,cDin_reg1,cDin_reg2,cDin_reg3 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg4,cDin_reg5,cDin_reg6,cDin_reg7 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg8,cDin_reg9,cDin_reg10,cDin_reg11 : std_logic_vector(kInSize-1 downto 0);
signal cDin_reg12,cDin_reg13,cDin_reg14,cDin_reg15 : std_logic_vector(kInSize-1 downto 0);
signal cDout0_reg,cDout1_reg,cDout2_reg,cDout3_reg : std_logic_vector(kInSize-1 downto 0);
signal cDout4_reg,cDout5_reg,cDout6_reg,cDout7_reg : std_logic_vector(kInSize-1 downto 0);

begin

process(aReset,ClkIn)
begin
	if aReset = '1' then
		counter1 <= 0;
		cDin_reg0 <= (others => '0');
		cDin_reg1 <= (others => '0');
		cDin_reg2 <= (others => '0');
		cDin_reg3 <= (others => '0');
		cDin_reg4 <= (others => '0');
		cDin_reg5 <= (others => '0');
		cDin_reg6 <= (others => '0');
		cDin_reg7 <= (others => '0');
		cDin_reg8 <= (others => '0');
		cDin_reg9 <= (others => '0');
		cDin_reg10 <= (others => '0');
		cDin_reg11 <= (others => '0');
		cDin_reg12 <= (others => '0');
		cDin_reg13 <= (others => '0');
		cDin_reg14 <= (others => '0');
		cDin_reg15 <= (others => '0');
	elsif rising_edge(ClkIn) then
		if counter1 = 0 then
			cDin_reg0 <= cDin0; 
			cDin_reg1 <= cDin1;
			cDin_reg2 <= cDin2;
			cDin_reg3 <= cDin3;
			cDin_reg4 <= cDin4;
			cDin_reg5 <= cDin5;
			cDin_reg6 <= cDin6;
			cDin_reg7 <= cDin7;
			counter1 <= 1;
		else
			cDin_reg8 <= cDin0; 
			cDin_reg9 <= cDin1;
			cDin_reg10 <= cDin2;
			cDin_reg11 <= cDin3;
			cDin_reg12 <= cDin4;
			cDin_reg13 <= cDin5;
			cDin_reg14 <= cDin6;
			cDin_reg15 <= cDin7;
			counter1 <= 0;
		end if;
	end if;
end process;

process(aReset,ClkOut)
begin
	if aReset = '1' then
		flag <= 0;
		cDout0_reg <= (others => '0');
		cDout1_reg <= (others => '0');
		cDout2_reg <= (others => '0');
		cDout3_reg <= (others => '0');
		cDout4_reg <= (others => '0');
		cDout5_reg <= (others => '0');
		cDout6_reg <= (others => '0');
		cDout7_reg <= (others => '0');
	elsif rising_edge(ClkOut) then
		if flag = 0 then
			cDout0_reg <= cDin_reg8;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg9;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 1;
		elsif flag = 1 then
			cDout0_reg <= cDin_reg10;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg11;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 2;
		elsif flag = 2 then
			cDout0_reg <= cDin_reg12;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg13;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 3;
		elsif flag = 3 then
			cDout0_reg <= cDin_reg14;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg15;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 4;
		elsif flag = 4 then
			cDout0_reg <= cDin_reg0;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg1;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 5;
		elsif flag = 5 then
			cDout0_reg <= cDin_reg2;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg3;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 6;
		elsif flag = 6 then
			cDout0_reg <= cDin_reg4;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg5;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 7;
		else
			cDout0_reg <= cDin_reg6;
			cDout1_reg <= (others => '0');
			cDout2_reg <= (others => '0');
			cDout3_reg <= (others => '0');
			cDout4_reg <= cDin_reg7;
			cDout5_reg <= (others => '0');
			cDout6_reg <= (others => '0');
			cDout7_reg <= (others => '0');
			flag <= 0;
		end if;
	end if;
end process;

interpoltationfilter_4_p8_inst :	interpoltationfilter_4_p8	
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
