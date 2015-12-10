--*********************************************************************************
-- Author : Zaichu Yang
-- Project: 600Mbps Parallel Digital Demodulator
-- Date   : 2008.6.4
--
-- Purpose: 
--        Time recovery with Gardner TED.
--
-- Revision History:
--      2008.6.4        first rev.
--      2010.08.15      新版本v2，可支持小于4倍采样率的时钟恢复，捕捉带-4‰~5‰ 
--                      (Author: Jiang Long)
--                      备注：（1）丢点控制部分可参考串行时钟环TimingRecovery_v2
--													  （2）输入sEnable可用性未作验证，待与变采样率模块联合调试
--                      					ParallelFractionDecimate_branch_v2处有隐患，Rom未受sEnable控制（修改为带enable的Rom）
--      2011.03         修改sEnable部分，及上面备注(2)里提到的。未充分测试
--*********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity TimerecoveryP8_v2 is
        generic (
                kDecimateRate   : positive := 13; -- bit width of Fraction decimate
                kCountWidth     : positive := 4;  -- bit width of the Counter,it is used in Interpolator.(attention: this parameter must be 4 under 8 parallel condition)
                kDelay          : positive :=10;   -- delay of the Interpolate Controller.
                kDataWidth      : positive :=8;
                kErrorWidth     : positive :=16;
                kKpSize         : positive :=3;
                kKiSize         : positive :=3);  -- bit width of the input data.
        port (
                aReset          : in std_logic;
                Clk_in          : in std_logic;
                sEnable         : in std_logic;
                
                sDataInPhase0   : in signed (kDataWidth-1 downto 0);
                sDataInPhase1   : in signed (kDataWidth-1 downto 0);
                sDataInPhase2   : in signed (kDataWidth-1 downto 0);
                sDataInPhase3   : in signed (kDataWidth-1 downto 0);
                sDataInPhase4   : in signed (kDataWidth-1 downto 0);
                sDataInPhase5   : in signed (kDataWidth-1 downto 0);
                sDataInPhase6   : in signed (kDataWidth-1 downto 0);
                sDataInPhase7   : in signed (kDataWidth-1 downto 0);

                sDataQuadPhase0   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase1   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase2   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase3   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase4   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase5   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase6   : in signed (kDataWidth-1 downto 0);
                sDataQuadPhase7   : in signed (kDataWidth-1 downto 0);
                
                -- recovered symbols
                sInPhaseOut0      : out signed(kDataWidth-1 downto 0);
                sInPhaseOut1      : out signed(kDataWidth-1 downto 0);
                sInPhaseOut2      : out signed(kDataWidth-1 downto 0);
                sInPhaseOut3      : out signed(kDataWidth-1 downto 0);
                sQuadPhaseOut0    : out signed(kDataWidth-1 downto 0);
                sQuadPhaseOut1    : out signed(kDataWidth-1 downto 0);
                sQuadPhaseOut2    : out signed(kDataWidth-1 downto 0);
                sQuadPhaseOut3    : out signed(kDataWidth-1 downto 0);
                sEnableOut        : out std_logic);
--				sLockSign		  : out std_logic);
end   TimerecoveryP8_v2;              

architecture rtl of TimerecoveryP8_v2 is
 
        component PolyInterpP8_v2 
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
        end component;


        component GardnerTED_P8_v2
        generic(
                kInSize    : positive;
                kOutSize   : positive );
        port(
                aReset     : in std_logic;
                Clk_in     : in std_logic;
                sEnable    : in std_logic;
                
                -- input signal
                sInPhase0    : in signed(kInSize-1 downto 0);     --phase 0 of the input signal
                sInPhase1    : in signed(kInSize-1 downto 0);     --phase 1 of the input signal
                sInPhase2    : in signed(kInSize-1 downto 0);     --phase 2 of the input signal
                sInPhase3    : in signed(kInSize-1 downto 0);     --phase 3 of the input signal
                sInPhase4    : in signed(kInSize-1 downto 0);     --phase 4 of the input signal
                sInPhase5    : in signed(kInSize-1 downto 0);     --phase 5 of the input signal
                sInPhase6    : in signed(kInSize-1 downto 0);     --phase 6 of the input signal
                sInPhase7    : in signed(kInSize-1 downto 0);     --phase 7 of the input signal
                
                sQuadPhase0  : in signed(kInSize-1 downto 0);     --phase 0 of the input signal
                sQuadPhase1  : in signed(kInSize-1 downto 0);     --phase 1 of the input signal
                sQuadPhase2  : in signed(kInSize-1 downto 0);     --phase 2 of the input signal
                sQuadPhase3  : in signed(kInSize-1 downto 0);     --phase 3 of the input signal
                sQuadPhase4  : in signed(kInSize-1 downto 0);     --phase 4 of the input signal
                sQuadPhase5  : in signed(kInSize-1 downto 0);     --phase 5 of the input signal
                sQuadPhase6  : in signed(kInSize-1 downto 0);     --phase 6 of the input signal
                sQuadPhase7  : in signed(kInSize-1 downto 0);     --phase 7 of the input signal
                
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
                
                -- output signal
                sTimingError0 : out signed(kOutSize-1 downto 0);   -- phase 0 of the output signal
                sTimingError1 : out signed(kOutSize-1 downto 0)   -- phase 1 of the output signal
   
                );
        end component;

        --Interpolate Control
       
        
        component TED_ControlP8_v2 
        generic(
                kInSize   : positive := 16;  --bit width of the time error     
                kOutSize  : positive := 10   --bit width of u                  
                );
        port   (
                aReset       : in std_logic;
                Clk_in       : in std_logic;
                sEnable      : in std_logic;
                sLoopFilter  : in signed (kInSize-1 downto 0);
                
                sMu0         : out unsigned (kOutSize-1 downto 0);
                sMu1         : out unsigned (kOutSize-1 downto 0);
                sMu2         : out unsigned (kOutSize-1 downto 0);
                sMu3         : out unsigned (kOutSize-1 downto 0);
                sMu4         : out unsigned (kOutSize-1 downto 0);
                sMu5         : out unsigned (kOutSize-1 downto 0);
                sMu6         : out unsigned (kOutSize-1 downto 0);
                sMu7         : out unsigned (kOutSize-1 downto 0);
                
                InterpType0   : out unsigned ( 1 downto 0);
                InterpType1   : out unsigned ( 1 downto 0);
                InterpType2   : out unsigned ( 1 downto 0);
                InterpType3   : out unsigned ( 1 downto 0);
                InterpType4   : out unsigned ( 1 downto 0);
                InterpType5   : out unsigned ( 1 downto 0);                
                InterpType6   : out unsigned ( 1 downto 0);
                InterpType7   : out unsigned ( 1 downto 0);
                InterpType_ori : out unsigned ( 1 downto 0);
                flag_out       : out unsigned( 1 downto 0)
             
                );
        end component;
        
        component LoopFilterP8  
                generic(
                        kInSize   : positive := 16;
                        kOutSize  : positive := 16;
                        kKpSize   : positive := 3;
                        kKiSize   : positive := 3);
                port(
                        aReset       : in std_logic;
                        Clk_in       : in std_logic;
                        sEnable      : in std_logic;
                        cKp          : in unsigned(kKpSize-1 downto 0);
                        cKi          : in unsigned(kKiSize-1 downto 0);
                        cTimingErrorI: in signed(kInSize-1 downto 0);
                        cTimingErrorQ: in signed(kInSize-1 downto 0);
                        cLoopFilter  : out signed(kOutSize-1 downto 0));
        end component;
        
        component Parallel8TapFifo_v2 
        generic(
                kCountWidth     : positive := 4;  -- 计数器的宽度
                kDataWidth      : positive :=8);  -- 输入数据宽度
        port   (
                aReset          : in  std_logic;
                Clk_in          : in  std_logic;
                sEnable         : in std_logic;
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataIn6        : in  signed (kDataWidth-1 downto 0);
                sDataIn7        : in  signed (kDataWidth-1 downto 0);
                InterpType0   : in unsigned ( 1 downto 0);
                InterpType1   : in unsigned ( 1 downto 0);
                InterpType2   : in unsigned ( 1 downto 0);
                InterpType3   : in unsigned ( 1 downto 0);
                InterpType4   : in unsigned ( 1 downto 0);
                InterpType5   : in unsigned ( 1 downto 0);                
                InterpType6   : in unsigned ( 1 downto 0);
                InterpType7   : in unsigned ( 1 downto 0);
                
                sDataOut0       : Out  signed (kDataWidth-1 downto 0);
                sDataOut1       : Out  signed (kDataWidth-1 downto 0);
                sDataOut2       : Out  signed (kDataWidth-1 downto 0);
                sDataOut3       : Out  signed (kDataWidth-1 downto 0);
                
                sEnableOut      : Out  std_logic
                );
				end component;



        --declare internal signal
        signal DecRateFraction_Inter     : unsigned (kDecimateRate-1 downto 0);
        signal ReDecRateFraction_Inter   : unsigned (kDecimateRate-1 downto 0);
        
        type InterpolatorOutArray is array (natural range <> ) of signed (kDataWidth-1 downto 0);
        signal sMatchFilterI_Inter   : InterpolatorOutArray (7 downto 0);
        signal sMatchFilterQ_Inter   : InterpolatorOutArray (7 downto 0);
        
        signal sMatchFilterI_Reg,sMatchFilterQ_Reg	: InterpolatorOutArray (7 downto 0);

        signal sMinusDCI_Inter   	 : InterpolatorOutArray (7 downto 0);
        signal sMinusDCQ_Inter   	 : InterpolatorOutArray (7 downto 0);
 
        signal sInterpolatorOutI_Inter   : InterpolatorOutArray (7 downto 0);
        signal sInterpolatorOutQ_Inter   : InterpolatorOutArray (7 downto 0);
        
        signal sDecTwoPhaseI_Inter       : InterpolatorOutArray (3 downto 0);
        signal sDecTwoPhaseQ_Inter       : InterpolatorOutArray (3 downto 0);
        signal sEnDecTwoPhaseI_Inter     : boolean;
        signal sEnDecTwoPhaseQ_Inter     : boolean;
        
        signal sDecTwoPhaseLPFI_Inter    : InterpolatorOutArray (1 downto 0);
        signal sDecTwoPhaseLPFQ_Inter    : InterpolatorOutArray (1 downto 0);
        
        signal sTimeErrorI               : signed (kErrorWidth-1 downto 0); --this parameter equal to TimeError divided by 2
        signal sTimeErrorQ               : signed (kErrorWidth-1 downto 0); --this parameter equal to TimeError divided by 2
        
        signal sLoopFilter               : signed (kErrorWidth-1 downto 0);
        signal sLoopFilter_mid           : signed(kErrorWidth-1 downto 0);
        
        type MuArray is array (natural range <>) of unsigned(kDecimateRate-kCountWidth-1 downto 0);
        signal sMu_TEDControl            : MuArray (7 downto 0);
        
        type BooleanArray is array (natural range <>) of boolean;
        signal sMk_TEDControl            : BooleanArray (7 downto 0);
        signal sSign_TEDControl          : BooleanArray (7 downto 0);
        
        signal cKp                       : unsigned (kKpSize-1 downto 0);
        signal cKi                       : unsigned (kKiSize-1 downto 0);
        
--        signal sLockSign_mid			 : std_logic;
        signal m_count1					 : integer range 0 to 2048;
    
        signal sMu_TEDControl2            : MuArray (7 downto 0);
        
        signal      InterpType0   :  unsigned ( 1 downto 0);
        signal      InterpType1   :  unsigned ( 1 downto 0);
        signal      InterpType2   :  unsigned ( 1 downto 0);
        signal      InterpType3   :  unsigned ( 1 downto 0);
        signal      InterpType4   :  unsigned ( 1 downto 0);
        signal      InterpType5   :  unsigned ( 1 downto 0);                
        signal      InterpType6   :  unsigned ( 1 downto 0);
        signal      InterpType7   :  unsigned ( 1 downto 0);
        signal      InterpType_ori   :  unsigned ( 1 downto 0);
        signal      flag   :  unsigned ( 1 downto 0); 
        signal      InterpType0_d   :  unsigned ( 1 downto 0);
        signal      InterpType1_d   :  unsigned ( 1 downto 0);
        signal      InterpType2_d   :  unsigned ( 1 downto 0);
        signal      InterpType3_d   :  unsigned ( 1 downto 0);
        signal      InterpType4_d   :  unsigned ( 1 downto 0);
        signal      InterpType5_d   :  unsigned ( 1 downto 0);                
        signal      InterpType6_d   :  unsigned ( 1 downto 0);
        signal      InterpType7_d   :  unsigned ( 1 downto 0);
        signal      InterpType_ori_d   :  unsigned ( 1 downto 0);
        signal      flag_d   :  unsigned ( 1 downto 0);
        
        signal FifoOut0_I, FifoOut1_I, FifoOut2_I, FifoOut3_I : signed(kDataWidth-1 downto 0);
        signal FifoOut0_Q, FifoOut1_Q, FifoOut2_Q, FifoOut3_Q : signed(kDataWidth-1 downto 0);
        signal FifoOut_enable_I , FifoOut_enable_Q : std_logic;
		  --signal aReset, aReset_0 : std_logic;

begin
		
		-- Get sync reset from async reset input
		-- cascaded reset structure    参看《Best Practices for Incremental Compilation Partitions and Floorplan Assignments》
--		process(aReset_ext,Clk_in)
--		begin
--			if aReset_ext = '1' then
--				aReset_0 <= '1';
--				aReset <= '1';
--			elsif rising_edge( Clk_in ) then
--				aReset_0 <= '0';
--				aReset <= aReset_0;
--			end if;
--		end process;
		
-- InterpType: 插值点类型（11:最佳点 01:过零点 00,10: 过渡点)
-- InterpType的一般顺序为00,01,10,11,00..., 即过渡点、过零点、过渡点、最佳点、过渡点...的顺序
-- 但若Mu值出现跳变，则需要根据情况来调整，完成丢点或留点的操作. 参看笔记
        InPhase_ParallelInterpolator: PolyInterpP8_v2 
                generic map(kDecimateRate,kCountWidth,kDataWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        
                        sEnable         => sEnable,--sEnablePolyInterp_Delay,--sEnableMinusDCI,
                        
                        sMu0            => sMu_TEDControl(0),
                        sMu1            => sMu_TEDControl(1),
                        sMu2            => sMu_TEDControl(2),
                        sMu3            => sMu_TEDControl(3),
                        sMu4            => sMu_TEDControl(4),
                        sMu5            => sMu_TEDControl(5),
                        sMu6            => sMu_TEDControl(6),
                        sMu7            => sMu_TEDControl(7),
                        
                        sDataIn0        => sDataInPhase0,--sMinusDCI_Inter(0),
                        sDataIn1        => sDataInPhase1,--sMinusDCI_Inter(1),
                        sDataIn2        => sDataInPhase2,--sMinusDCI_Inter(2),
                        sDataIn3        => sDataInPhase3,--sMinusDCI_Inter(3),
                        sDataIn4        => sDataInPhase4,--sMinusDCI_Inter(4),
                        sDataIn5        => sDataInPhase5,--sMinusDCI_Inter(5),
                        sDataIn6        => sDataInPhase6,--sMinusDCI_Inter(6),
                        sDataIn7        => sDataInPhase7,--sMinusDCI_Inter(7),
                        
				                InterpType_ori  => InterpType_ori,
				                InterpType0   => InterpType0,
				                InterpType1   => InterpType1,
				                InterpType2   => InterpType2,
				                InterpType3   => InterpType3,
				                InterpType4   => InterpType4,
				                InterpType5   => InterpType5,         
				                InterpType6   => InterpType6,
				                InterpType7   => InterpType7,
				                flag          => flag,
                        
                        sDataOut0       => sInterpolatorOutI_Inter(0),
                        sDataOut1       => sInterpolatorOutI_Inter(1),
                        sDataOut2       => sInterpolatorOutI_Inter(2),
                        sDataOut3       => sInterpolatorOutI_Inter(3),
                        sDataOut4       => sInterpolatorOutI_Inter(4),
                        sDataOut5       => sInterpolatorOutI_Inter(5),
                        sDataOut6       => sInterpolatorOutI_Inter(6),
                        sDataOut7       => sInterpolatorOutI_Inter(7),
                        
                        InterpType_ori_out => InterpType_ori_d,
				                InterpType0_out   => InterpType0_d,
				                InterpType1_out   => InterpType1_d,
				                InterpType2_out   => InterpType2_d,
				                InterpType3_out   => InterpType3_d,
				                InterpType4_out   => InterpType4_d,
				                InterpType5_out   => InterpType5_d,           
				                InterpType6_out   => InterpType6_d,
				                InterpType7_out   => InterpType7_d,
				                flag_out          => flag_d
                        );


        QuadPhase_ParallelInterpolator: PolyInterpP8_v2 
                generic map(kDecimateRate,kCountWidth,kDataWidth)
                port map (
                        aReset          => aReset,
                        Clk_in          => Clk_in,
                        
                        sEnable         => sEnable,--sEnablePolyInterp_Delay,--sEnableMinusDCQ,
                        
                        sMu0            => sMu_TEDControl(0),
                        sMu1            => sMu_TEDControl(1),
                        sMu2            => sMu_TEDControl(2),
                        sMu3            => sMu_TEDControl(3),
                        sMu4            => sMu_TEDControl(4),
                        sMu5            => sMu_TEDControl(5),
                        sMu6            => sMu_TEDControl(6),
                        sMu7            => sMu_TEDControl(7),
                        
                        sDataIn0        => sDataQuadPhase0,--sMinusDCQ_Inter(0),
                        sDataIn1        => sDataQuadPhase1,--sMinusDCQ_Inter(1),
                        sDataIn2        => sDataQuadPhase2,--sMinusDCQ_Inter(2),
                        sDataIn3        => sDataQuadPhase3,--sMinusDCQ_Inter(3),
                        sDataIn4        => sDataQuadPhase4,--sMinusDCQ_Inter(4),
                        sDataIn5        => sDataQuadPhase5,--sMinusDCQ_Inter(5),
                        sDataIn6        => sDataQuadPhase6,--sMinusDCQ_Inter(6),
                        sDataIn7        => sDataQuadPhase7,--sMinusDCQ_Inter(7),
                        
                        InterpType_ori  => InterpType_ori,
				                InterpType0   => InterpType0,
				                InterpType1   => InterpType1,
				                InterpType2   => InterpType2,
				                InterpType3   => InterpType3,
				                InterpType4   => InterpType4,
				                InterpType5   => InterpType5,         
				                InterpType6   => InterpType6,
				                InterpType7   => InterpType7,
				                flag          => flag,
                        
                        sDataOut0       => sInterpolatorOutQ_Inter(0),
                        sDataOut1       => sInterpolatorOutQ_Inter(1),
                        sDataOut2       => sInterpolatorOutQ_Inter(2),
                        sDataOut3       => sInterpolatorOutQ_Inter(3),
                        sDataOut4       => sInterpolatorOutQ_Inter(4),
                        sDataOut5       => sInterpolatorOutQ_Inter(5),
                        sDataOut6       => sInterpolatorOutQ_Inter(6),
                        sDataOut7       => sInterpolatorOutQ_Inter(7),
                        
                        InterpType_ori_out => open,
				                InterpType0_out   => open,
				                InterpType1_out   => open,
				                InterpType2_out   => open,
				                InterpType3_out   => open,
				                InterpType4_out   => open,
				                InterpType5_out   => open,           
				                InterpType6_out   => open,
				                InterpType7_out   => open,
				                flag_out          => open
                        );
                                                
--      输出模块，调整为4路输出
        OutputFifo_I: Parallel8TapFifo_v2 
        generic map(
                kCountWidth,  -- 计数器的宽度
                kDataWidth )  -- 输入数据宽度
        port   map(
                aReset          => aReset,
                Clk_in          => Clk_in,
                sEnable         => sEnable,
                sDataIn0        => sInterpolatorOutI_Inter(7),
                sDataIn1        => sInterpolatorOutI_Inter(6),
                sDataIn2        => sInterpolatorOutI_Inter(5),
                sDataIn3        => sInterpolatorOutI_Inter(4),
                sDataIn4        => sInterpolatorOutI_Inter(3),
                sDataIn5        => sInterpolatorOutI_Inter(2),
                sDataIn6        => sInterpolatorOutI_Inter(1),
                sDataIn7        => sInterpolatorOutI_Inter(0),
                InterpType0   => InterpType7_d,
                InterpType1   => InterpType6_d,
                InterpType2   => InterpType5_d,
                InterpType3   => InterpType4_d,
                InterpType4   => InterpType3_d,
                InterpType5   => InterpType2_d,                
                InterpType6   => InterpType1_d,
                InterpType7   => InterpType0_d,
                
                sDataOut0       => FifoOut3_I,
                sDataOut1       => FifoOut2_I,
                sDataOut2       => FifoOut1_I,
                sDataOut3       => FifoOut0_I,
                
                sEnableOut      => FifoOut_enable_I
                );
       OutputFifo_Q: Parallel8TapFifo_v2 
        generic map(
                kCountWidth ,  -- 计数器的宽度
                kDataWidth  )  -- 输入数据宽度
        port   map(
                aReset          => aReset,
                Clk_in          => Clk_in,
                sEnable         => sEnable,
                sDataIn0        => sInterpolatorOutQ_Inter(7),
                sDataIn1        => sInterpolatorOutQ_Inter(6),
                sDataIn2        => sInterpolatorOutQ_Inter(5),
                sDataIn3        => sInterpolatorOutQ_Inter(4),
                sDataIn4        => sInterpolatorOutQ_Inter(3),
                sDataIn5        => sInterpolatorOutQ_Inter(2),
                sDataIn6        => sInterpolatorOutQ_Inter(1),
                sDataIn7        => sInterpolatorOutQ_Inter(0),
                InterpType0   => InterpType7_d,
                InterpType1   => InterpType6_d,
                InterpType2   => InterpType5_d,
                InterpType3   => InterpType4_d,
                InterpType4   => InterpType3_d,
                InterpType5   => InterpType2_d,                
                InterpType6   => InterpType1_d,
                InterpType7   => InterpType0_d,
                
                sDataOut0       => FifoOut3_Q,
                sDataOut1       => FifoOut2_Q,
                sDataOut2       => FifoOut1_Q,
                sDataOut3       => FifoOut0_Q,
                
                sEnableOut      => open
                );

				               
                        

                        
                        
        entity_GardnerTED: GardnerTED_P8_v2
        generic map(kDataWidth,kErrorWidth)
        port map(
                aReset          => aReset,
                Clk_in          => Clk_in,
                sEnable         => sEnable,
                

                sInPhase0       => sInterpolatorOutI_Inter(0),
                sInPhase1       => sInterpolatorOutI_Inter(1),
                sInPhase2       => sInterpolatorOutI_Inter(2),
                sInPhase3       => sInterpolatorOutI_Inter(3),
                sInPhase4       => sInterpolatorOutI_Inter(4),
                sInPhase5       => sInterpolatorOutI_Inter(5),
                sInPhase6       => sInterpolatorOutI_Inter(6),
                sInPhase7       => sInterpolatorOutI_Inter(7),
                

                sQuadPhase0     => sInterpolatorOutQ_Inter(0),
                sQuadPhase1     => sInterpolatorOutQ_Inter(1),
                sQuadPhase2     => sInterpolatorOutQ_Inter(2),
                sQuadPhase3     => sInterpolatorOutQ_Inter(3),
                sQuadPhase4     => sInterpolatorOutQ_Inter(4),
                sQuadPhase5     => sInterpolatorOutQ_Inter(5),
                sQuadPhase6     => sInterpolatorOutQ_Inter(6),
                sQuadPhase7     => sInterpolatorOutQ_Inter(7),
                
                InterpType_ori => InterpType_ori_d,
                InterpType0   => InterpType0_d,
                InterpType1   => InterpType1_d,
                InterpType2   => InterpType2_d,
                InterpType3   => InterpType3_d,
                InterpType4  => InterpType4_d,
                InterpType5  => InterpType5_d,           
                InterpType6   => InterpType6_d,
                InterpType7   => InterpType7_d,
                flag          => flag_d,
        
                -- output signal
                sTimingError0   => sTimeErrorI,
                sTimingError1   => sTimeErrorQ
   
                );

        

                        

        TEDLoopFilter: LoopFilterP8  
                generic map(kErrorWidth,kErrorWidth,kKpSize,kKiSize)
                port map(
                        aReset       => aReset,
                        Clk_in       => Clk_in,
                        sEnable      => sEnable,
                        cKp          => cKp,
                        cKi          => cKi,
                        cTimingErrorI=> sTimeErrorI,
                        cTimingErrorQ=> sTimeErrorQ,
                        cLoopFilter  => sLoopFilter
						);
                                

--     InterpType_ori : 第一个点的原始插值点类型（未丢点、留点）（即如果该八个点未出现跳变，则InterpType0 = InterpType_ori，否则InterpType0需要更改）
--     flag : 0 正常     1 丢点（过采样）     2 留点（欠采样）               
       TEDControl_v2: TED_ControlP8_v2  
                generic map(kErrorWidth ,kDecimateRate-kCountWidth)
                port  map (
                        aReset       => aReset,
                        Clk_in       => Clk_in,
                        sEnable      => sEnable,--sEnableMinusDCI,
                        sLoopFilter  => sLoopFilter,
                        
                        sMu0         => sMu_TEDControl(0),
                        sMu1         => sMu_TEDControl(1),
                        sMu2         => sMu_TEDControl(2),
                        sMu3         => sMu_TEDControl(3),
                        sMu4         => sMu_TEDControl(4),
                        sMu5         => sMu_TEDControl(5),
                        sMu6         => sMu_TEDControl(6),
                        sMu7         => sMu_TEDControl(7),
                        
                        InterpType0   => InterpType0,
				                InterpType1   => InterpType1,
				                InterpType2   => InterpType2,
				                InterpType3   => InterpType3,
				                InterpType4   => InterpType4,
				                InterpType5   => InterpType5,            
				                InterpType6   => InterpType6,
				                InterpType7   => InterpType7,
				                InterpType_ori => InterpType_ori,
	                      flag_out       => flag
                        );




        output_process:Process (aReset,Clk_in)
        begin
                if aReset='1' then
                    sInPhaseOut0    <= (others => '0');
                    sInPhaseOut1    <= (others => '0');
                    sInPhaseOut2    <= (others => '0');
                    sInPhaseOut3    <= (others => '0');
                    sQuadPhaseOut0  <= (others => '0');
                    sQuadPhaseOut1  <= (others => '0');
                    sQuadPhaseOut2  <= (others => '0');
                    sQuadPhaseOut3  <= (others => '0');
                    sEnableOut      <= '0';
							cKp             <= (others => '0');
							cKi             <= (others => '0');
					
                elsif rising_edge(Clk_in) then
					sInPhaseOut0    <= FifoOut0_I;
                    sInPhaseOut1    <= FifoOut1_I;
                    sInPhaseOut2    <= FifoOut2_I;
                    sInPhaseOut3    <= FifoOut3_I;
                    sQuadPhaseOut0    <= FifoOut0_Q;
                    sQuadPhaseOut1    <= FifoOut1_Q;
                    sQuadPhaseOut2    <= FifoOut2_Q;
                    sQuadPhaseOut3    <= FifoOut3_Q;
                    sEnableOut      <= FifoOut_enable_I;
                    cKp             <= to_unsigned(5,kKpSize);
					cKi             <= to_unsigned(6,kKiSize);

                    
                end if;
        end Process;
        


                        
end rtl;