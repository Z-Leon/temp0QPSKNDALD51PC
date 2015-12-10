-------------------------------------------------------------------------------
--
-- Author: Zaichu Yang
-- Project: QPSK  Demodulator
-- Date: 2008.10.10
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- 	Loopfilter for  carrier recovery.
-------------------------------------------------------------------------------
--
-- Revision History: 
-- 2008.10.23 first revision
--
-- 2015.04 Remove stop-go ctrl module   Author: Jiang Long
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LoopFilter_CR_P2 is 
  generic(
  	kErrWidth   : positive := 12
  	);
  port(               
    aReset            : in  std_logic;
    Clk               : in std_logic;
    
    sErrIn0	      : in std_logic_vector(kErrWidth-1 downto 0);
    sErrIn1	      : in std_logic_vector(kErrWidth-1 downto 0);
    sEnableIn	      : in  std_logic;
               
--    sEnableOut        : out  Boolean;
    sLoopOut          : out std_logic_vector(kErrWidth-1 downto 0)
    );
end LoopFilter_CR_P2;

architecture rtl of LoopFilter_CR_P2 is
	component cnst_CR_loop IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;

	constant cAccSize	: positive :=32;
	
    --signal sErrIn_Inter	      : signed (kErrWidth-1 downto 0);
	 signal sErrIn_Inter	      : signed (kErrWidth downto 0);

	type ErrInArray is Array (natural range <>) of signed (kErrWidth-1 downto 0);
	signal sErrIn_Reg: ErrInArray (3 downto 0);
	
	signal sLoopFilter_Pre0,sLoopFilter_Pre1		: signed(kErrWidth downto 0);
	signal sAcc_Pre0,sAcc_Pre1			: signed(cAccSize - 1 downto 0);
	signal sAcc_Prop,sAcc_Prop_Reg,sAcc_Integ	: signed(cAccSize - 1 downto 0);	
	
	signal sAcc,sLoopOut_Reg	: signed(cAccSize - 1 downto 0); 
	type BooleanArrary is array (natural range <>) of boolean;
	signal sEnable_Reg		: BooleanArrary (7 downto 0);
	
	signal sS_G_Sign0,sS_G_Sign1 : std_logic_vector (3 downto 0); --停锟竭匡拷锟狡憋拷识
	signal loop_para : std_logic_vector(15 downto 0) ;
begin

	cnst_CR_loop_inst :  cnst_CR_loop 
	PORT map
	(
		result		=> loop_para
	);


	process (aReset,Clk)
	begin
		if aReset='1' then
			sErrIn_Inter	<= (others => '0');
--			for i in 0 to 1 loop
--				sErrIn_Reg(i)	<= (others => '0');
--			end loop;
			--sLoopFilter_Pre0		<= (others => '0');
			--sLoopFilter_Pre1		<= (others => '0');
			--sAcc_Pre0		<= (others => '0');
			--sAcc_Pre1		<= (others => '0');
			sAcc_Prop		<= (others => '0');
			sAcc_Prop_Reg		<= (others => '0');
			sAcc_Integ		<= (others => '0');
			sAcc			<= (others => '0');
			sLoopOut_Reg		<= (others => '0');
			--sLoopOut		<= (others => '0');
			--sS_G_Sign0	<= (others => '0');
			--sS_G_Sign1	<= (others => '0');
		elsif rising_edge(Clk) then
			if sEnableIn='1' then
				-- the first pipline
				sErrIn_Inter	<= signed( sErrIn0(sErrIn0'high) & sErrIn0)+signed( sErrIn1(sErrIn1'high)& sErrIn1);

				case( loop_para(6 downto 4) ) is 
					when "000" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,11);
					when "001" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,12);
					when "010" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,13);
					when "011" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,14);
					when "100" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,15);
					when "101" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,16);
					when "110" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,17);
					when "111" =>  
						sAcc_Integ	<= shift_right(sAcc_Pre1,18);
					when others =>
						sAcc_Integ	<= shift_right(sAcc_Pre1,14);
				end case;

				case( loop_para(2 downto 0) ) is 
					when "000" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,5);
					when "001" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,6);
					when "010" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,7);
					when "011" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,8);
					when "100" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,9);
					when "101" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,10);
					when "110" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,11);
					when "111" =>  
						sAcc_Prop	<= shift_right(sAcc_Pre1,12);
					when others =>
						sAcc_Prop	<= shift_right(sAcc_Pre1,8);
				end case;

			

				sAcc_Prop_Reg	<= sAcc_Prop;
				if (sAcc(cAccSize - 1 downto cAccSize-kErrWidth) > to_signed(4,kErrWidth)) or (sAcc(cAccSize - 1 downto cAccSize-kErrWidth) < to_signed(-4,kErrWidth)) then
				    sAcc   <= (others => '0');
				else
				   sAcc		<= sAcc+sAcc_Integ;
				end if;

				sLoopOut_Reg	<= sAcc_Prop_Reg+sAcc;

				
			else
				null;
			end if;

		end if;
	end process;
	
	sAcc_Pre1	<=  (sErrIn_Inter & to_signed(0,cAccSize-kErrWidth-1));

	process(sLoopOut_Reg)
	begin
		if sLoopOut_Reg(cAccSize - 1 downto cAccSize-kErrWidth) > to_signed(4,kErrWidth) then
			sLoopOut <= B"0000_0000_0100";
		elsif sLoopOut_Reg(cAccSize - 1 downto cAccSize-kErrWidth) < to_signed(-4,kErrWidth) then
			sLoopOut <= B"1111_1111_1100";
		else
			sLoopOut	<= std_logic_vector( sLoopOut_Reg(cAccSize - 1 downto cAccSize-kErrWidth));
		end if;
	end process;


end rtl;  
