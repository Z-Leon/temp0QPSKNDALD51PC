-------------------------------------------------------------------------------
--
-- author : Zaichu Yang
-- project: QPSK Parallel demodulation
-- date   : 2008.6.11
--
-- purpose：Parallel polynomial interpolation for time recovery
--
-------------------------------------------------------------------------------
--
-- Revision History:
-- 2008.6.11 First revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use std.textio.all;


entity PolyInterpP8 is
        generic(
                kInWidth        : positive := 14; -- bit width of decimate Fraction
                kCountWidth     : positive := 4;  -- bit width of counter
                kDataWidth      : positive :=8);  -- bit width of input and output data
        port   (
                aReset          : in  boolean;
                Clk_in          : in  std_logic;
                
                sEnable         : in boolean; --The Enable signal of input data
                
                sMk0		: in  boolean; 
                sMk1		: in  boolean; 
                sMk2		: in  boolean; 
                sMk3		: in  boolean; 
                sMk4		: in  boolean; 
                sMk5		: in  boolean; 
                sMk6		: in  boolean; 
                sMk7		: in  boolean; 
                
                sSign0		: in  boolean;
                sSign1		: in  boolean;
                sSign2		: in  boolean;
                sSign3		: in  boolean;
                sSign4		: in  boolean;
                sSign5		: in  boolean;
                sSign6		: in  boolean;
                sSign7		: in  boolean;
                
                sMu0            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu1            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu2            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu3            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu4            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu5            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu6            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sMu7            : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataIn6        : in  signed (kDataWidth-1 downto 0);
                sDataIn7        : in  signed (kDataWidth-1 downto 0);
                
                sDataOut0       : out signed (kDataWidth-1 downto 0);
                sDataOut1       : out signed (kDataWidth-1 downto 0);
                sDataOut2       : out signed (kDataWidth-1 downto 0);
                sDataOut3       : out signed (kDataWidth-1 downto 0);
                sDataOut4       : out signed (kDataWidth-1 downto 0);
                sDataOut5       : out signed (kDataWidth-1 downto 0);
                sDataOut6       : out signed (kDataWidth-1 downto 0);
                sDataOut7       : out signed (kDataWidth-1 downto 0);
                
                sEnableOut      : out boolean);
end PolyInterpP8;

architecture rtl of PolyInterpP8 is
        
        component ParallelFractionDecimate_branch   
          generic(
                kInWidth        : positive ; -- 抽取率位宽
                kCountWidth     : positive ;  -- 计数器的宽度
                kDataWidth      : positive ;  -- 输入数据宽度
                kRomOutWidth    : positive ); -- ROM 模块输出数据的位宽 
          port   (
                aReset          : in  boolean;
                Clk_in          : in  std_logic;
                sMuIn           : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sEnableIn       : in  boolean;
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataOut        : out signed (kDataWidth-1 downto 0);
                sEnableOut      : out boolean);
        end  component;
        
        component Parallel8TapFifo   --输出数据fifo
        generic(
                kCountWidth     : positive ;  -- 计数器的宽度
                kDataWidth      : positive );  -- 输入数据宽度
        port   (
                aReset          : in  boolean;
                Clk_in          : in  std_logic;
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataIn6        : in  signed (kDataWidth-1 downto 0);
                sDataIn7        : in  signed (kDataWidth-1 downto 0);
                sEnableIn0      : in boolean;
                sEnableIn1      : in boolean;
                sEnableIn2      : in boolean;
                sEnableIn3      : in boolean;
                sEnableIn4      : in boolean;
                sEnableIn5      : in boolean;
                sEnableIn6      : in boolean;
                sEnableIn7      : in boolean;
                sDataOut0       : Out  signed (kDataWidth-1 downto 0);
                sDataOut1       : Out  signed (kDataWidth-1 downto 0);
                sDataOut2       : Out  signed (kDataWidth-1 downto 0);
                sDataOut3       : Out  signed (kDataWidth-1 downto 0);
                sDataOut4       : Out  signed (kDataWidth-1 downto 0);
                sDataOut5       : Out  signed (kDataWidth-1 downto 0);
                sDataOut6       : Out  signed (kDataWidth-1 downto 0);
                sDataOut7       : Out  signed (kDataWidth-1 downto 0);
                sEnableOut      : Out  Boolean
                );
        end  component;
        
        --***************************
        type EnableArray is Array (natural range <>) of Boolean;
        signal sMk_Reg        : EnableArray (15 downto 0);
        signal sSign_Reg      : EnableArray (7 downto 0);
        signal sEnableOut_Inter : EnableArray (7 downto 0);
        --signal sEnable_Reg    : Boolean;
        
        type DataoutArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sDataOut_Inter  	:	DataoutArray (7 downto 0);
        
        --用于输入数据缓存
        type DataInArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sDataIn0_Reg     : DataInArray (1 downto 0);
        signal sDataIn1_Reg     : DataInArray (1 downto 0);
        signal sDataIn2_Reg     : DataInArray (1 downto 0);
        signal sDataIn3_Reg     : DataInArray (1 downto 0);
        signal sDataIn4_Reg     : DataInArray (1 downto 0);
        signal sDataIn5_Reg     : DataInArray (1 downto 0);
        signal sDataIn6_Reg     : DataInArray (1 downto 0);
        signal sDataIn7_Reg     : DataInArray (1 downto 0);
        
        --用于存储插值运算的数据
        signal sDataInterpIn0	: DataInArray (5 downto 0);
        signal sDataInterpIn1	: DataInArray (5 downto 0);
        signal sDataInterpIn2	: DataInArray (5 downto 0);
        signal sDataInterpIn3	: DataInArray (5 downto 0);
        signal sDataInterpIn4	: DataInArray (5 downto 0);
        signal sDataInterpIn5	: DataInArray (5 downto 0);
        signal sDataInterpIn6	: DataInArray (5 downto 0);
        signal sDataInterpIn7	: DataInArray (5 downto 0);
        
        type MuInArray is Array (natural range <>) of unsigned (kInWidth-kCountWidth-1 downto 0);
        signal sMu_Reg          : MuInArray (15 downto 0);
        --*****************************
            
        --ROM输出数据的位宽
        constant kRomOutWidth   : integer :=16;

begin

        --第1路内插        
        interpolate_branch1: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(8),
                        sEnableIn       => sMk_Reg(8),
                        sDataIn0        => sDataInterpIn0(0),
                        sDataIn1        => sDataInterpIn0(1),
                        sDataIn2        => sDataInterpIn0(2),
                        sDataIn3        => sDataInterpIn0(3),
                        sDataIn4        => sDataInterpIn0(4),
                        sDataIn5        => sDataInterpIn0(5),
                        sDataOut        => sDataOut_Inter(0),
                        sEnableOut      => sEnableOut_Inter(0));

        --第2路内插        
        interpolate_branch2: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(9),
                        sEnableIn       => sMk_Reg(9),
                        sDataIn0        => sDataInterpIn1(0),
                        sDataIn1        => sDataInterpIn1(1),
                        sDataIn2        => sDataInterpIn1(2),
                        sDataIn3        => sDataInterpIn1(3),
                        sDataIn4        => sDataInterpIn1(4),
                        sDataIn5        => sDataInterpIn1(5),
                        sDataOut        => sDataOut_Inter(1),
                        sEnableOut      => sEnableOut_Inter(1));

        --第3路内插        
        interpolate_branch3: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(10),
                        sEnableIn       => sMk_Reg(10),
                        sDataIn0        => sDataInterpIn2(0),
                        sDataIn1        => sDataInterpIn2(1),
                        sDataIn2        => sDataInterpIn2(2),
                        sDataIn3        => sDataInterpIn2(3),
                        sDataIn4        => sDataInterpIn2(4),
                        sDataIn5        => sDataInterpIn2(5),
                        sDataOut        => sDataOut_Inter(2),
                        sEnableOut      => sEnableOut_Inter(2));
                        
        --第4路内插        
        interpolate_branch4: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(11),
                        sEnableIn       => sMk_Reg(11),
                        sDataIn0        => sDataInterpIn3(0),
                        sDataIn1        => sDataInterpIn3(1),
                        sDataIn2        => sDataInterpIn3(2),
                        sDataIn3        => sDataInterpIn3(3),
                        sDataIn4        => sDataInterpIn3(4),
                        sDataIn5        => sDataInterpIn3(5),
                        sDataOut        => sDataOut_Inter(3),
                        sEnableOut      => sEnableOut_Inter(3));
                        
        --第5路内插        
        interpolate_branch5: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(12),
                        sEnableIn       => sMk_Reg(12),
                        sDataIn0        => sDataInterpIn4(0),
                        sDataIn1        => sDataInterpIn4(1),
                        sDataIn2        => sDataInterpIn4(2),
                        sDataIn3        => sDataInterpIn4(3),
                        sDataIn4        => sDataInterpIn4(4),
                        sDataIn5        => sDataInterpIn4(5),
                        sDataOut        => sDataOut_Inter(4),
                        sEnableOut      => sEnableOut_Inter(4));
                        
        --第6路内插        
        interpolate_branch6: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(13),
                        sEnableIn       => sMk_Reg(13),
                        sDataIn0        => sDataInterpIn5(0),
                        sDataIn1        => sDataInterpIn5(1),
                        sDataIn2        => sDataInterpIn5(2),
                        sDataIn3        => sDataInterpIn5(3),
                        sDataIn4        => sDataInterpIn5(4),
                        sDataIn5        => sDataInterpIn5(5),
                        sDataOut        => sDataOut_Inter(5),
                        sEnableOut      => sEnableOut_Inter(5));
                        
        --第7路内插        
        interpolate_branch7: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(14),
                        sEnableIn       => sMk_Reg(14),
                        sDataIn0        => sDataInterpIn6(0),
                        sDataIn1        => sDataInterpIn6(1),
                        sDataIn2        => sDataInterpIn6(2),
                        sDataIn3        => sDataInterpIn6(3),
                        sDataIn4        => sDataInterpIn6(4),
                        sDataIn5        => sDataInterpIn6(5),
                        sDataOut        => sDataOut_Inter(6),
                        sEnableOut      => sEnableOut_Inter(6));
                        
        --第8路内插        
        interpolate_branch8: ParallelFractionDecimate_branch generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu_Reg(15),
                        sEnableIn       => sMk_Reg(15),
                        sDataIn0        => sDataInterpIn7(0),
                        sDataIn1        => sDataInterpIn7(1),
                        sDataIn2        => sDataInterpIn7(2),
                        sDataIn3        => sDataInterpIn7(3),
                        sDataIn4        => sDataInterpIn7(4),
                        sDataIn5        => sDataInterpIn7(5),
                        sDataOut        => sDataOut_Inter(7),
                        sEnableOut      => sEnableOut_Inter(7));
                        
        --输出数据fifo缓存        
        Output_Fifo: Parallel8TapFifo   generic map (kCountWidth ,kDataWidth )
                port map   (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sDataIn0        => sDataOut_Inter(7),
                        sDataIn1        => sDataOut_Inter(6),
                        sDataIn2        => sDataOut_Inter(5),
                        sDataIn3        => sDataOut_Inter(4),
                        sDataIn4        => sDataOut_Inter(3),
                        sDataIn5        => sDataOut_Inter(2),
                        sDataIn6        => sDataOut_Inter(1),
                        sDataIn7        => sDataOut_Inter(0),
                        sEnableIn0      => sEnableOut_Inter(7),
                        sEnableIn1      => sEnableOut_Inter(6),
                        sEnableIn2      => sEnableOut_Inter(5),
                        sEnableIn3      => sEnableOut_Inter(4),
                        sEnableIn4      => sEnableOut_Inter(3),
                        sEnableIn5      => sEnableOut_Inter(2),
                        sEnableIn6      => sEnableOut_Inter(1),
                        sEnableIn7      => sEnableOut_Inter(0),
                        sDataOut0       => sDataOut7,
                        sDataOut1       => sDataOut6,
                        sDataOut2       => sDataOut5,
                        sDataOut3       => sDataOut4,
                        sDataOut4       => sDataOut3,
                        sDataOut5       => sDataOut2,
                        sDataOut6       => sDataOut1,
                        sDataOut7       => sDataOut0,
                        sEnableOut      => sEnableOut
                        );
                        
      

        --**************************************进程Input_Data开始**********************************************                
        --进程Input_Data主要功能是完成输入数据缓存和一些共用参数的初始化********************
        Input_Data:process(aReset, Clk_in, sEnable)
        begin
                if aReset=true then
                        
                        for i in 0 to 1 loop
                                sDataIn0_Reg(i)         <= (others => '0');
                                sDataIn1_Reg(i)         <= (others => '0');
                                sDataIn2_Reg(i)         <= (others => '0');
                                sDataIn3_Reg(i)         <= (others => '0');
                                sDataIn4_Reg(i)         <= (others => '0');
                                sDataIn5_Reg(i)         <= (others => '0');
                                sDataIn6_Reg(i)         <= (others => '0');
                                sDataIn7_Reg(i)         <= (others => '0');
                        end loop;
                        for i in 0 to 7 loop
                                sSign_Reg(i)	  <= false;
								--sEnableOut_Inter(i) <= false;
                                --sDataOut_Inter(i) <= (others => '0');
                        end loop;
                        for i in 0 to 15 loop
                                sMu_Reg(i)        <= (others => '0');
                                sMk_Reg(i)        <= false;
                        end loop;
						 
--                        for i in 0 to 1 loop
--                        	sDataIn0_Reg(i)	  <= (others => '0');
--                        	sDataIn1_Reg(i)	  <= (others => '0');
--                        	sDataIn2_Reg(i)	  <= (others => '0');
--                        	sDataIn3_Reg(i)	  <= (others => '0');
--                        	sDataIn4_Reg(i)	  <= (others => '0');
--                        	sDataIn5_Reg(i)	  <= (others => '0');
--                        	sDataIn6_Reg(i)	  <= (others => '0');
--                        	sDataIn7_Reg(i)	  <= (others => '0');
--                        end loop;
                        	
                        for i in 0 to 5 loop
                        	sDataInterpIn0(i) <= (others => '0');
                        	sDataInterpIn1(i) <= (others => '0');
                        	sDataInterpIn2(i) <= (others => '0');
                        	sDataInterpIn3(i) <= (others => '0');
                        	sDataInterpIn4(i) <= (others => '0');
                        	sDataInterpIn5(i) <= (others => '0');
                        	sDataInterpIn6(i) <= (others => '0');
                        	sDataInterpIn7(i) <= (others => '0');
                        end loop;
                        --sEnable_Reg   <= false;
                        
                elsif rising_edge(Clk_in) then
                        if sEnable then
                                -- stores the input data
                                sDataIn0_Reg(0) <= sDataIn0;
                                sDataIn1_Reg(0) <= sDataIn1;
                                sDataIn2_Reg(0) <= sDataIn2;
                                sDataIn3_Reg(0) <= sDataIn3;
                                sDataIn4_Reg(0) <= sDataIn4;
                                sDataIn5_Reg(0) <= sDataIn5;
                                sDataIn6_Reg(0) <= sDataIn6;
                                sDataIn7_Reg(0) <= sDataIn7;
                                
                                sDataIn0_Reg(1) <= sDataIn0_Reg(0);
                                sDataIn1_Reg(1) <= sDataIn1_Reg(0);
                                sDataIn2_Reg(1) <= sDataIn2_Reg(0);
                                sDataIn3_Reg(1) <= sDataIn3_Reg(0);
                                sDataIn4_Reg(1) <= sDataIn4_Reg(0);
                                sDataIn5_Reg(1) <= sDataIn5_Reg(0);
                                sDataIn6_Reg(1) <= sDataIn6_Reg(0);
                                sDataIn7_Reg(1) <= sDataIn7_Reg(0);
                                
                                sMu_Reg(0)      <= sMu0;
                                sMu_Reg(1)      <= sMu1;
                                sMu_Reg(2)      <= sMu2;
                                sMu_Reg(3)      <= sMu3;
                                sMu_Reg(4)      <= sMu4;
                                sMu_Reg(5)      <= sMu5;
                                sMu_Reg(6)      <= sMu6;
                                sMu_Reg(7)      <= sMu7;
                                
                                sMk_Reg(0)    <= sMk0;
                                sMk_Reg(1)    <= sMk1;
                                sMk_Reg(2)    <= sMk2;
                                sMk_Reg(3)    <= sMk3;
                                sMk_Reg(4)    <= sMk4;
                                sMk_Reg(5)    <= sMk5;
                                sMk_Reg(6)    <= sMk6;
                                sMk_Reg(7)    <= sMk7 ;
                                
                                sSign_Reg(0)  <= sSign0;
                                sSign_Reg(1)  <= sSign1;
                                sSign_Reg(2)  <= sSign2;
                                sSign_Reg(3)  <= sSign3;
                                sSign_Reg(4)  <= sSign4;
                                sSign_Reg(5)  <= sSign5;
                                sSign_Reg(6)  <= sSign6;
                                sSign_Reg(7)  <= sSign7;
                                --sEnable_Reg   <= sEnable;
                                
                                --得到八路插值运算所需要的数据
                                --第一路
                                if sSign_Reg(0)=false then
	                                sDataInterpIn0(0)     <= sDataIn3_Reg(0);
		                        sDataInterpIn0(1)     <= sDataIn2_Reg(0);
		                        sDataInterpIn0(2)     <= sDataIn1_Reg(0);
		                        sDataInterpIn0(3)     <= sDataIn0_Reg(0);
		                        sDataInterpIn0(4)     <= sDataIn7_Reg(1);
		                        sDataInterpIn0(5)     <= sDataIn6_Reg(1);
		                else
	                                sDataInterpIn0(0)     <= sDataIn2_Reg(0);
		                        sDataInterpIn0(1)     <= sDataIn1_Reg(0);
		                        sDataInterpIn0(2)     <= sDataIn0_Reg(0);
		                        sDataInterpIn0(3)     <= sDataIn7_Reg(1);
		                        sDataInterpIn0(4)     <= sDataIn6_Reg(1);
		                        sDataInterpIn0(5)     <= sDataIn5_Reg(1);
				end if;
				
				--第二路
                                if sSign_Reg(1)=false then
	                                sDataInterpIn1(0)     <= sDataIn4_Reg(0);
		                        sDataInterpIn1(1)     <= sDataIn3_Reg(0);
		                        sDataInterpIn1(2)     <= sDataIn2_Reg(0);
		                        sDataInterpIn1(3)     <= sDataIn1_Reg(0);
		                        sDataInterpIn1(4)     <= sDataIn0_Reg(0);
		                        sDataInterpIn1(5)     <= sDataIn7_Reg(1);
		                else
	                                sDataInterpIn1(0)     <= sDataIn3_Reg(0);
		                        sDataInterpIn1(1)     <= sDataIn2_Reg(0);
		                        sDataInterpIn1(2)     <= sDataIn1_Reg(0);
		                        sDataInterpIn1(3)     <= sDataIn0_Reg(0);
		                        sDataInterpIn1(4)     <= sDataIn7_Reg(1);
		                        sDataInterpIn1(5)     <= sDataIn6_Reg(1);
				end if;
				
				--第三路
                                if sSign_Reg(2)=false then
	                                sDataInterpIn2(0)     <= sDataIn5_Reg(0);
		                        sDataInterpIn2(1)     <= sDataIn4_Reg(0);
		                        sDataInterpIn2(2)     <= sDataIn3_Reg(0);
		                        sDataInterpIn2(3)     <= sDataIn2_Reg(0);
		                        sDataInterpIn2(4)     <= sDataIn1_Reg(0);
		                        sDataInterpIn2(5)     <= sDataIn0_Reg(0);
		                else
	                                sDataInterpIn2(0)     <= sDataIn4_Reg(0);
		                        sDataInterpIn2(1)     <= sDataIn3_Reg(0);
		                        sDataInterpIn2(2)     <= sDataIn2_Reg(0);
		                        sDataInterpIn2(3)     <= sDataIn1_Reg(0);
		                        sDataInterpIn2(4)     <= sDataIn0_Reg(0);
		                        sDataInterpIn2(5)     <= sDataIn7_Reg(1);
				end if;
				
				--第四路
                                if sSign_Reg(3)=false then
	                                sDataInterpIn3(0)     <= sDataIn6_Reg(0);
		                        sDataInterpIn3(1)     <= sDataIn5_Reg(0);
		                        sDataInterpIn3(2)     <= sDataIn4_Reg(0);
		                        sDataInterpIn3(3)     <= sDataIn3_Reg(0);
		                        sDataInterpIn3(4)     <= sDataIn2_Reg(0);
		                        sDataInterpIn3(5)     <= sDataIn1_Reg(0);
		                else
	                                sDataInterpIn3(0)     <= sDataIn5_Reg(0);
		                        sDataInterpIn3(1)     <= sDataIn4_Reg(0);
		                        sDataInterpIn3(2)     <= sDataIn3_Reg(0);
		                        sDataInterpIn3(3)     <= sDataIn2_Reg(0);
		                        sDataInterpIn3(4)     <= sDataIn1_Reg(0);
		                        sDataInterpIn3(5)     <= sDataIn0_Reg(0);
				end if;
				
				--第五路
                                if sSign_Reg(4)=false then
	                                sDataInterpIn4(0)     <= sDataIn7_Reg(0);
		                        sDataInterpIn4(1)     <= sDataIn6_Reg(0);
		                        sDataInterpIn4(2)     <= sDataIn5_Reg(0);
		                        sDataInterpIn4(3)     <= sDataIn4_Reg(0);
		                        sDataInterpIn4(4)     <= sDataIn3_Reg(0);
		                        sDataInterpIn4(5)     <= sDataIn2_Reg(0);
		                else
	                                sDataInterpIn4(0)     <= sDataIn6_Reg(0);
		                        sDataInterpIn4(1)     <= sDataIn5_Reg(0);
		                        sDataInterpIn4(2)     <= sDataIn4_Reg(0);
		                        sDataInterpIn4(3)     <= sDataIn3_Reg(0);
		                        sDataInterpIn4(4)     <= sDataIn2_Reg(0);
		                        sDataInterpIn4(5)     <= sDataIn1_Reg(0);
				end if;
				
				--第六路
                                if sSign_Reg(5)=false then
	                                sDataInterpIn5(0)     <= sDataIn0;
		                        sDataInterpIn5(1)     <= sDataIn7_Reg(0);
		                        sDataInterpIn5(2)     <= sDataIn6_Reg(0);
		                        sDataInterpIn5(3)     <= sDataIn5_Reg(0);
		                        sDataInterpIn5(4)     <= sDataIn4_Reg(0);
		                        sDataInterpIn5(5)     <= sDataIn3_Reg(0);
		                else
	                                sDataInterpIn5(0)     <= sDataIn7_Reg(0);
		                        sDataInterpIn5(1)     <= sDataIn6_Reg(0);
		                        sDataInterpIn5(2)     <= sDataIn5_Reg(0);
		                        sDataInterpIn5(3)     <= sDataIn4_Reg(0);
		                        sDataInterpIn5(4)     <= sDataIn3_Reg(0);
		                        sDataInterpIn5(5)     <= sDataIn2_Reg(0);
				end if;
				
				--第七路
                                if sSign_Reg(6)=false then
	                                sDataInterpIn6(0)     <= sDataIn1;
		                        sDataInterpIn6(1)     <= sDataIn0;
		                        sDataInterpIn6(2)     <= sDataIn7_Reg(0);
		                        sDataInterpIn6(3)     <= sDataIn6_Reg(0);
		                        sDataInterpIn6(4)     <= sDataIn5_Reg(0);
		                        sDataInterpIn6(5)     <= sDataIn4_Reg(0);
		                else
	                                sDataInterpIn6(0)     <= sDataIn0;
		                        sDataInterpIn6(1)     <= sDataIn7_Reg(0);
		                        sDataInterpIn6(2)     <= sDataIn6_Reg(0);
		                        sDataInterpIn6(3)     <= sDataIn5_Reg(0);
		                        sDataInterpIn6(4)     <= sDataIn4_Reg(0);
		                        sDataInterpIn6(5)     <= sDataIn3_Reg(0);
				end if;
				
				--第八路
                                if sSign_Reg(7)=false then
	                                sDataInterpIn7(0)     <= sDataIn2;
		                        sDataInterpIn7(1)     <= sDataIn1;
		                        sDataInterpIn7(2)     <= sDataIn0;
		                        sDataInterpIn7(3)     <= sDataIn7_Reg(0);
		                        sDataInterpIn7(4)     <= sDataIn6_Reg(0);
		                        sDataInterpIn7(5)     <= sDataIn5_Reg(0);
		                else
	                                sDataInterpIn7(0)     <= sDataIn1;
		                        sDataInterpIn7(1)     <= sDataIn0;
		                        sDataInterpIn7(2)     <= sDataIn7_Reg(0);
		                        sDataInterpIn7(3)     <= sDataIn6_Reg(0);
		                        sDataInterpIn7(4)     <= sDataIn5_Reg(0);
		                        sDataInterpIn7(5)     <= sDataIn4_Reg(0);
				end if;
                        else    
                                sMk_Reg(0)    <= false;
                                sMk_Reg(1)    <= false;
                                sMk_Reg(2)    <= false;
                                sMk_Reg(3)    <= false;
                                sMk_Reg(4)    <= false;
                                sMk_Reg(5)    <= false;
                                sMk_Reg(6)    <= false;
                                sMk_Reg(7)    <= false;
                                sMu_Reg(0)      <= (others => '0');
                                sMu_Reg(1)      <= (others => '0');
                                sMu_Reg(2)      <= (others => '0');
                                sMu_Reg(3)      <= (others => '0');
                                sMu_Reg(4)      <= (others => '0');
                                sMu_Reg(5)      <= (others => '0');
                                sMu_Reg(6)      <= (others => '0');
                                sMu_Reg(7)      <= (others => '0');
                        end if;
                        for i in 8 to 15 loop
                        	sMu_Reg(i)	<= sMu_Reg(i-8);
                        end loop;
                        for i in 8 to 15 loop
                        	sMk_Reg(i)	<= sMk_Reg(i-8);
                        end loop;
                end if;
        end process;
        --****************************************进程Input_Data结束****************************************  


end rtl;