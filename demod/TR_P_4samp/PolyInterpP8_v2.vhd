--new-----------------------------------------------------------------------------
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


entity PolyInterpP8_v2 is
        generic(
                kInWidth        : positive := 14; -- bit width of decimate Fraction
                kCountWidth     : positive := 4;  -- bit width of counter
                kDataWidth      : positive :=8);  -- bit width of input and output data
        port   (
                aReset          : in  std_logic;
                Clk_in          : in  std_logic;
                
                sEnable         : in std_logic; --The Enable signal of input data
                
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
                
                InterpType_ori : in unsigned ( 1 downto 0);
                InterpType0   : in unsigned ( 1 downto 0);
                InterpType1   : in unsigned ( 1 downto 0);
                InterpType2   : in unsigned ( 1 downto 0);
                InterpType3   : in unsigned ( 1 downto 0);
                InterpType4   : in unsigned ( 1 downto 0);
                InterpType5   : in unsigned ( 1 downto 0);                
                InterpType6   : in unsigned ( 1 downto 0);
                InterpType7   : in unsigned ( 1 downto 0);
                flag          : in unsigned( 1 downto 0 );
                
                sDataOut0       : out signed (kDataWidth-1 downto 0);
                sDataOut1       : out signed (kDataWidth-1 downto 0);
                sDataOut2       : out signed (kDataWidth-1 downto 0);
                sDataOut3       : out signed (kDataWidth-1 downto 0);
                sDataOut4       : out signed (kDataWidth-1 downto 0);
                sDataOut5       : out signed (kDataWidth-1 downto 0);
                sDataOut6       : out signed (kDataWidth-1 downto 0);
                sDataOut7       : out signed (kDataWidth-1 downto 0);
                
                InterpType_ori_out : out unsigned ( 1 downto 0);
                InterpType0_out   : out unsigned ( 1 downto 0);
                InterpType1_out   : out unsigned ( 1 downto 0);
                InterpType2_out   : out unsigned ( 1 downto 0);
                InterpType3_out   : out unsigned ( 1 downto 0);
                InterpType4_out   : out unsigned ( 1 downto 0);
                InterpType5_out   : out unsigned ( 1 downto 0);                
                InterpType6_out   : out unsigned ( 1 downto 0);
                InterpType7_out  : out unsigned ( 1 downto 0);
                flag_out          : out unsigned( 1 downto 0 ));
end PolyInterpP8_v2;

architecture rtl of PolyInterpP8_v2 is
        
        component ParallelFractionDecimate_branch_v2   
          generic(
                kInWidth        : positive ; -- 抽取率位宽
                kCountWidth     : positive ;  -- 计数器的宽度
                kDataWidth      : positive ;  -- 输入数据宽度
                kRomOutWidth    : positive ); -- ROM 模块输出数据的位宽 
          port   (
                aReset          : in  std_logic;
                Clk_in          : in  std_logic;
                sMuIn           : in  unsigned (kInWidth-kCountWidth-1 downto 0);
                sEnableIn       : in  std_logic;
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataOut        : out signed (kDataWidth-1 downto 0)
                );
        end  component;
        
        component InterpType_delay 
				port(
					aReset : in std_logic;
					clk    : in std_logic;
					sEnable  : in std_logic;
					data_in : in unsigned(1 downto 0);
					data_out : out unsigned(1 downto 0)
					);
				end component;
        
        --***************************
        type EnableArray is Array (natural range <>) of Boolean;
        signal sEnableOut_Inter : EnableArray (7 downto 0);
        --signal sEnable_Reg    : Boolean;
        
        type DataoutArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sDataOut_Inter   :       DataoutArray (7 downto 0);
        
        --用于输入数据缓存
        type DataInArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sDataIn0_Reg     : DataInArray (2 downto 0);
        signal sDataIn1_Reg     : DataInArray (2 downto 0);
        signal sDataIn2_Reg     : DataInArray (2 downto 0);
        signal sDataIn3_Reg     : DataInArray (2 downto 0);
        signal sDataIn4_Reg     : DataInArray (2 downto 0);
        signal sDataIn5_Reg     : DataInArray (2 downto 0);
        signal sDataIn6_Reg     : DataInArray (2 downto 0);
        signal sDataIn7_Reg     : DataInArray (2 downto 0);
        
        --用于存储插值运算的数据
        signal sDataInterpIn0   : DataInArray (5 downto 0);
        signal sDataInterpIn1   : DataInArray (5 downto 0);
        signal sDataInterpIn2   : DataInArray (5 downto 0);
        signal sDataInterpIn3   : DataInArray (5 downto 0);
        signal sDataInterpIn4   : DataInArray (5 downto 0);
        signal sDataInterpIn5   : DataInArray (5 downto 0);
        signal sDataInterpIn6   : DataInArray (5 downto 0);
        signal sDataInterpIn7   : DataInArray (5 downto 0);
        
        type MuInArray is Array (natural range <>) of unsigned (kInWidth-kCountWidth-1 downto 0);
        signal sMu_Reg          : MuInArray (23 downto 0);
        --*****************************
            
        --ROM输出数据的位宽
        constant kRomOutWidth   : integer :=16;

begin
        --第1路内插        
        interpolate_branch1: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu0,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn0(0),
                        sDataIn1        => sDataInterpIn0(1),
                        sDataIn2        => sDataInterpIn0(2),
                        sDataIn3        => sDataInterpIn0(3),
                        sDataIn4        => sDataInterpIn0(4),
                        sDataIn5        => sDataInterpIn0(5),
                        sDataOut        => sDataOut_Inter(0)
                        );

        --第2路内插        
        interpolate_branch2: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu1,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn1(0),
                        sDataIn1        => sDataInterpIn1(1),
                        sDataIn2        => sDataInterpIn1(2),
                        sDataIn3        => sDataInterpIn1(3),
                        sDataIn4        => sDataInterpIn1(4),
                        sDataIn5        => sDataInterpIn1(5),
                        sDataOut        => sDataOut_Inter(1));

        --第3路内插        
        interpolate_branch3: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu2,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn2(0),
                        sDataIn1        => sDataInterpIn2(1),
                        sDataIn2        => sDataInterpIn2(2),
                        sDataIn3        => sDataInterpIn2(3),
                        sDataIn4        => sDataInterpIn2(4),
                        sDataIn5        => sDataInterpIn2(5),
                        sDataOut        => sDataOut_Inter(2));
                        
        --第4路内插        
        interpolate_branch4: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu3,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn3(0),
                        sDataIn1        => sDataInterpIn3(1),
                        sDataIn2        => sDataInterpIn3(2),
                        sDataIn3        => sDataInterpIn3(3),
                        sDataIn4        => sDataInterpIn3(4),
                        sDataIn5        => sDataInterpIn3(5),
                        sDataOut        => sDataOut_Inter(3));
                        
        --第5路内插        
        interpolate_branch5: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu4,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn4(0),
                        sDataIn1        => sDataInterpIn4(1),
                        sDataIn2        => sDataInterpIn4(2),
                        sDataIn3        => sDataInterpIn4(3),
                        sDataIn4        => sDataInterpIn4(4),
                        sDataIn5        => sDataInterpIn4(5),
                        sDataOut        => sDataOut_Inter(4));
                        
        --第6路内插        
        interpolate_branch6: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu5,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn5(0),
                        sDataIn1        => sDataInterpIn5(1),
                        sDataIn2        => sDataInterpIn5(2),
                        sDataIn3        => sDataInterpIn5(3),
                        sDataIn4        => sDataInterpIn5(4),
                        sDataIn5        => sDataInterpIn5(5),
                        sDataOut        => sDataOut_Inter(5));
                        
        --第7路内插        
        interpolate_branch7: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu6,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn6(0),
                        sDataIn1        => sDataInterpIn6(1),
                        sDataIn2        => sDataInterpIn6(2),
                        sDataIn3        => sDataInterpIn6(3),
                        sDataIn4        => sDataInterpIn6(4),
                        sDataIn5        => sDataInterpIn6(5),
                        sDataOut        => sDataOut_Inter(6));
                        
        --第8路内插        
        interpolate_branch8: ParallelFractionDecimate_branch_v2 generic map (kInWidth, kCountWidth,kDataWidth,kRomOutWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        sMuIn           => sMu7,
                        sEnableIn       => sEnable,
                        sDataIn0        => sDataInterpIn7(0),
                        sDataIn1        => sDataInterpIn7(1),
                        sDataIn2        => sDataInterpIn7(2),
                        sDataIn3        => sDataInterpIn7(3),
                        sDataIn4        => sDataInterpIn7(4),
                        sDataIn5        => sDataInterpIn7(5),
                        sDataOut        => sDataOut_Inter(7));
                        
        InterpType_d_ori: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType_ori,
							data_out => InterpType_ori_out );
				InterpType_d0: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType0,
							data_out => InterpType0_out );
				InterpType_d1: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType1,
							data_out => InterpType1_out );
				InterpType_d2: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType2,
							data_out => InterpType2_out );
				InterpType_d3: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType3,
							data_out => InterpType3_out );
				InterpType_d4: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType4,
							data_out => InterpType4_out );
				InterpType_d5: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType5,
							data_out => InterpType5_out );
				InterpType_d6: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType6,
							data_out => InterpType6_out );
				InterpType_d7: InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => InterpType7,
							data_out => InterpType7_out );
				flag_delay : InterpType_delay 
				port map (
							aReset => aReset,
							clk    => Clk_in,
							sEnable  => sEnable,
							data_in => flag,
							data_out => flag_out );

                        
        sDataOut0 <= sDataOut_Inter(0);
        sDataOut1 <= sDataOut_Inter(1);
        sDataOut2 <= sDataOut_Inter(2);
        sDataOut3 <= sDataOut_Inter(3);
        sDataOut4 <= sDataOut_Inter(4);
        sDataOut5 <= sDataOut_Inter(5);
        sDataOut6 <= sDataOut_Inter(6);
        sDataOut7 <= sDataOut_Inter(7);

        --**************************************进程Input_Data开始**********************************************                
        --进程Input_Data主要功能是完成输入数据缓存和一些共用参数的初始化********************
        Input_Data:process(aReset, Clk_in)
        begin
                if aReset='1' then
                        
                        for i in 0 to 2 loop
                                sDataIn0_Reg(i)         <= (others => '0');
                                sDataIn1_Reg(i)         <= (others => '0');
                                sDataIn2_Reg(i)         <= (others => '0');
                                sDataIn3_Reg(i)         <= (others => '0');
                                sDataIn4_Reg(i)         <= (others => '0');
                                sDataIn5_Reg(i)         <= (others => '0');
                                sDataIn6_Reg(i)         <= (others => '0');
                                sDataIn7_Reg(i)         <= (others => '0');
                        end loop;
                        for i in 0 to 23 loop
                                sMu_Reg(i)        <= (others => '0');
                        end loop;
                         
                                                

                                
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
                        if sEnable='1' then
                                -- stores the input data
                                sDataIn0_Reg(0) <= sDataIn0;
                                sDataIn1_Reg(0) <= sDataIn1;
                                sDataIn2_Reg(0) <= sDataIn2;
                                sDataIn3_Reg(0) <= sDataIn3;
                                sDataIn4_Reg(0) <= sDataIn4;
                                sDataIn5_Reg(0) <= sDataIn5;
                                sDataIn6_Reg(0) <= sDataIn6;
                                sDataIn7_Reg(0) <= sDataIn7;
                                
                                for i in 1 to 2 loop
	                                sDataIn0_Reg(i) <= sDataIn0_Reg(i-1);
	                                sDataIn1_Reg(i) <= sDataIn1_Reg(i-1);
	                                sDataIn2_Reg(i) <= sDataIn2_Reg(i-1);
	                                sDataIn3_Reg(i) <= sDataIn3_Reg(i-1);
	                                sDataIn4_Reg(i) <= sDataIn4_Reg(i-1);
	                                sDataIn5_Reg(i) <= sDataIn5_Reg(i-1);
	                                sDataIn6_Reg(i) <= sDataIn6_Reg(i-1);
	                                sDataIn7_Reg(i) <= sDataIn7_Reg(i-1);
                                end loop;
                                 
                                sMu_Reg(0)      <= sMu0;
                                sMu_Reg(1)      <= sMu1;
                                sMu_Reg(2)      <= sMu2;
                                sMu_Reg(3)      <= sMu3;
                                sMu_Reg(4)      <= sMu4;
                                sMu_Reg(5)      <= sMu5;
                                sMu_Reg(6)      <= sMu6;
                                sMu_Reg(7)      <= sMu7;
                                
                                                                
                                --得到八路插值运算所需要的数据
                                --第一路
                                        sDataInterpIn0(0)     <= sDataIn3_Reg(1);
                                        sDataInterpIn0(1)     <= sDataIn2_Reg(1);
                                        sDataInterpIn0(2)     <= sDataIn1_Reg(1);
                                        sDataInterpIn0(3)     <= sDataIn0_Reg(1);
                                        sDataInterpIn0(4)     <= sDataIn7_Reg(2);
                                        sDataInterpIn0(5)     <= sDataIn6_Reg(2);

                                --第二路
                                        sDataInterpIn1(0)     <= sDataIn4_Reg(1);
                                        sDataInterpIn1(1)     <= sDataIn3_Reg(1);
                                        sDataInterpIn1(2)     <= sDataIn2_Reg(1);
                                        sDataInterpIn1(3)     <= sDataIn1_Reg(1);
                                        sDataInterpIn1(4)     <= sDataIn0_Reg(1);
                                        sDataInterpIn1(5)     <= sDataIn7_Reg(2);

                                --第三路
                                        sDataInterpIn2(0)     <= sDataIn5_Reg(1);
                                        sDataInterpIn2(1)     <= sDataIn4_Reg(1);
                                        sDataInterpIn2(2)     <= sDataIn3_Reg(1);
                                        sDataInterpIn2(3)     <= sDataIn2_Reg(1);
                                        sDataInterpIn2(4)     <= sDataIn1_Reg(1);
                                        sDataInterpIn2(5)     <= sDataIn0_Reg(1);

                                --第四路
                                        sDataInterpIn3(0)     <= sDataIn6_Reg(1);
                                        sDataInterpIn3(1)     <= sDataIn5_Reg(1);
                                        sDataInterpIn3(2)     <= sDataIn4_Reg(1);
                                        sDataInterpIn3(3)     <= sDataIn3_Reg(1);
                                        sDataInterpIn3(4)     <= sDataIn2_Reg(1);
                                        sDataInterpIn3(5)     <= sDataIn1_Reg(1);

                                --第五路
                                        sDataInterpIn4(0)     <= sDataIn7_Reg(1);
                                        sDataInterpIn4(1)     <= sDataIn6_Reg(1);
                                        sDataInterpIn4(2)     <= sDataIn5_Reg(1);
                                        sDataInterpIn4(3)     <= sDataIn4_Reg(1);
                                        sDataInterpIn4(4)     <= sDataIn3_Reg(1);
                                        sDataInterpIn4(5)     <= sDataIn2_Reg(1);

                                --第六路
                                        sDataInterpIn5(0)     <= sDataIn0_Reg(0);
                                        sDataInterpIn5(1)     <= sDataIn7_Reg(1);
                                        sDataInterpIn5(2)     <= sDataIn6_Reg(1);
                                        sDataInterpIn5(3)     <= sDataIn5_Reg(1);
                                        sDataInterpIn5(4)     <= sDataIn4_Reg(1);
                                        sDataInterpIn5(5)     <= sDataIn3_Reg(1);

                                --第七路
                                        sDataInterpIn6(0)     <= sDataIn1_Reg(0);
                                        sDataInterpIn6(1)     <= sDataIn0_Reg(0);
                                        sDataInterpIn6(2)     <= sDataIn7_Reg(1);
                                        sDataInterpIn6(3)     <= sDataIn6_Reg(1);
                                        sDataInterpIn6(4)     <= sDataIn5_Reg(1);
                                        sDataInterpIn6(5)     <= sDataIn4_Reg(1);

                                --第八路
                                        sDataInterpIn7(0)     <= sDataIn2_Reg(0);
                                        sDataInterpIn7(1)     <= sDataIn1_Reg(0);
                                        sDataInterpIn7(2)     <= sDataIn0_Reg(0);
                                        sDataInterpIn7(3)     <= sDataIn7_Reg(1);
                                        sDataInterpIn7(4)     <= sDataIn6_Reg(1);
                                        sDataInterpIn7(5)     <= sDataIn5_Reg(1);



								for i in 8 to 15 loop
										sMu_Reg(i)      <= sMu_Reg(i-8);
										sMu_Reg(i+8)      <= sMu_Reg(i);
								end loop;
                        else    
--								for i in 16 to 23 loop
--										sMu_Reg(i)      <= (others => '0');
--								end loop;
								null;
                        end if;
                end if;
        end process;
        --****************************************进程Input_Data结束****************************************  


end rtl;