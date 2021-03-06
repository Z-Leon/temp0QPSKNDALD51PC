--*********************************************************************************
-- Author : Zaichu Yang
-- Project: 600Mbps Parallel Digital Demodulator
-- Date   : 2008.6.6
--
-- Purpose: 
--        Generate the value u and mk based on time error.
--
-- Revision History:
--      2008.6.6        first rev.
--      2010.6.11       v2版本,添加8路插值点类型指示作为输出，支持小于4倍采样率时钟恢复
--*********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TED_ControlP8_v2 is 
        generic(
                kInSize   : positive := 16;  --bit width of the time error     
                kOutSize  : positive := 10   --bit width of u                  
                );
        port   (
                aReset       : in std_logic;
                Clk_in       : in std_logic;
                sEnable      : in std_logic;
                sLoopFilter  : in signed (kInSize-1 downto 0);
                
                sMu0         : out unsigned (kOutSize-1 downto 0);  --mu为无符号数，是为了适应PolyInterpP8插值文件的定义。串行代码为有符号数，略为精确
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
end TED_ControlP8_v2;
-- 		 InterpType: 插值点类型（11:最佳点 01:过零点 00,10: 过渡点)
--     InterpType_ori : 第一个点的原始插值点类型（未丢点、留点）（即如果该八个点未出现跳变，则InterpType0 = InterpType_ori，否则InterpType0需要更改）
--     flag : 0 正常     1 丢点（过采样）     2 留点（欠采样）

architecture rtl of TED_ControlP8_v2 is
        type InputRegArray is array (natural range <>) of signed (kInSize+4 downto 0);
        signal sInputReg        : InputRegArray (9 downto 0);
        signal sMuAcc_Inter     : InputRegArray (8 downto 0);
        signal sMuAcc_Inter_next : signed (kInSize+4 downto 0);
        
        type OutputRegArray is array (natural range <>) of signed (kInSize-1 downto 0);
        signal sMuOutReg        : OutputRegArray (8 downto 0);
        signal sMuOutReg_next   : signed (kInSize-1 downto 0);
        
        signal  sEnable_Inter   : std_logic_vector (7 downto 0);
		signal  sSign_Inter		: std_logic_vector (8 downto 0);
		
		signal  flag_d2: integer range 0 to 3 :=0;
		signal JumpPosition : integer range 0 to 7 :=0;
		Type InterpTypeArray is array (natural range <>) of unsigned(1 downto 0);
		signal InterpType_d1, InterpType_d2,InterpType_d3: InterpTypeArray( 7 downto 0);
	  
begin

        process (aReset,Clk_in)
            --variable aJumpSign0     : std_logic:='0';
            variable aJumpSign1       : std_logic:='0';   
            variable aJumpSign3	  : std_logic_vector (8 downto 0) :="000000000"; 
        	variable aSign 	  	  : std_logic_vector (8 downto 0) :="000000000";
        	--variable sMuAcc6_InterSign: std_logic_vector (5 downto 0) :="000000";
        	variable sMuAcc7_InterSign: std_logic_vector (5 downto 0) :="000000";
        	variable flag : integer range 0 to 3 :=0;
                --variable aEnableSign    : std_logic_vector(7 downto 0); 
        begin
          if aReset='1' then
				--aJumpSign1		:= '0';
				aJumpSign3	  	:="000000000"; 
				aSign 	  	  	:="000000000";
				--sMuAcc6_InterSign:="000000";
				sMuAcc7_InterSign:="000000";
				for i in 0 to 8 loop
               		sMuAcc_Inter(i) <= (others => '0');
            	 	sMuOutReg(i)    <= (others => '0');
            	end loop;
	            for i in 0 to 7 loop
	               sInputReg(i)    <= (others => '0');
	            end loop;
	            --sEnable_Inter           <= "00000000";
	 			--sSign_Inter				<= (others => '0');
	            sMu0                    <= (others => '0');
	            sMu1                    <= (others => '0');
	            sMu2                    <= (others => '0');
	            sMu3                    <= (others => '0');
	            sMu4                    <= (others => '0');
	            sMu5                    <= (others => '0');
	            sMu6                    <= (others => '0');
	            sMu7                    <= (others => '0');
	            
				flag := 0;
				JumpPosition <= 0;
				InterpType_d1(0)<="00";
				InterpType_d1(1)<="01";
				InterpType_d1(2)<="10";
				InterpType_d1(3)<="11";
				InterpType_d1(4)<="00";
				InterpType_d1(5)<="01";
				InterpType_d1(6)<="10";
				InterpType_d1(7)<="11";
				InterpType_d2(0)<="00";
				InterpType_d2(1)<="01";
				InterpType_d2(2)<="10";
				InterpType_d2(3)<="11";
				InterpType_d2(4)<="00";
				InterpType_d2(5)<="01";
				InterpType_d2(6)<="10";
				InterpType_d2(7)<="11";
				for i in 0 to 7 loop 
					InterpType_d2(i) <= "00";
					--InterpType_d3(i) <= "00";
				end loop;
				sMuAcc_Inter_next <=(others => '0');
				sMuOutReg_next    <= (others => '0');
				flag_d2 <= 0;
				InterpType_ori <= "00";
				flag_out <= "00";
				InterpType0<="00";
				InterpType1<="01";
				InterpType2<="10";
				InterpType3<="11";
				InterpType4<="00";
				InterpType5<="01";
				InterpType6<="10";
				InterpType7<="11";
						
          elsif rising_edge(Clk_in) then
            if sEnable='1' then
                    
                    ---------------------------
                    --  the first pipeline
                    ---------------------------
                    
                    for i in 0 to 9 loop
                            sInputReg(i)    <= sLoopFilter*to_signed(i+1,5);
                    end loop;
                    
                    --  0到7 为本周期的8路数据，8为上一周期的最后一路数据
                    for i in 0 to 8 loop
                    	aJumpSign3(i)	:= sMuAcc_Inter(i)(kInsize-1);            -- (kInSize+4 downto kInSize-1) 是整数部分,后面为小数部分
                    end loop;
                    for i in 0 to 8 loop
                    	aSign(i)	:= sMuAcc_Inter(i)(kInSize+4); 
                    end loop;
                    
                    --  aSign为最高位符号位, aJumpSign3为整数部分的最低位, 通过这两个变量来得到flag
                    --     flag : 0 正常     1 丢点（过采样）     2 留点（欠采样）
                    if aSign = "000000000" or aSign = "111111111" then
                    	if aJumpSign3="000000000" or  aJumpSign3="111111111" then
                    		flag := 0;
                    	elsif aJumpSign3(8)='0' then
                    		flag := 1;
                    	else
                    		flag := 2;
                    	end if;
                    else
                    	if aJumpSign3(8)='0' then
                    		flag := 2;
                    	else
                    		flag := 1;
                    	end if;
                    end if; 
        
                    -- sMuAcc7_InterSign的意义在于保证sMuAcc_Inter的整数部分大于1时，下一个周期整数部分为1；sMuAcc_Inter的整数部分小于-1时，下一个周期整数部分为-1,
                    -- 即sMuAcc_Inter的变化范围为-1~1
                    for i in 0 to 5 loop
                    	sMuAcc7_InterSign(i)	:= sMuAcc_Inter(7)(kInSize+4);
                    end loop;
                    
                    -- mu值为sMuAcc_Inter(i)的分数部分
                    if flag = 0 then
                    	 			for i in 0 to 7 loop
                                   sMuAcc_Inter(i)  <= signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(i);
                            end loop;  
                            sMuAcc_Inter_next <=    signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(8); 	
                    elsif flag = 1 then
                            sMuAcc_Inter(0)  <= signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0));
			                    	for i in 1 to 7 loop
			                           		sMuAcc_Inter(i)  <= signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(i-1);
			                    	end loop;
			                    	sMuAcc_Inter_next <=    signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(7);
			              else
			              				for i in 0 to 7 loop
                                   sMuAcc_Inter(i)  <= signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(i+1);
                            end loop;
                            sMuAcc_Inter_next <=    signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0))+sInputReg(9);
                    end if;
                    sMuAcc_Inter(8)	  <= signed(sMuAcc7_InterSign) & (sMuAcc_Inter(7)(kInSize-2 downto 0));   -- sMuAcc_Inter_last
                    
                    --     InterpType_d1 : 原始插值点类型
                    --     InterpType_ori : 第一个点的原始插值点类型
                    if flag = 0 then
                    	for i in 0 to 7 loop
                    		InterpType_d1(i) <= InterpType_d1(i);                   
                      end loop;
                    elsif flag = 1 then
                    	for i in 0 to 7 loop
                    		InterpType_d1(i) <= InterpType_d1(i)+3;     -- 上一个周期丢点，则本周期的各路插值点类型较上一周期各路插值点类型推迟1位                          
                      end loop;
                    else
                    	for i in 0 to 7 loop
                    		InterpType_d1(i) <= InterpType_d1(i)+1;       -- 上一个周期留点，则本周期的各路插值点类型较上一周期各路插值点类型提前1位                   
                      end loop;
                    end if;
                
                    
                    ---------------------------
                    --  the second pipeline
                    ----------------------------
                    
                    for i in 0 to 7 loop
                    		InterpType_d2(i) <= InterpType_d1(i);                   
                    end loop;
                    
                    flag_d2 <= flag;
                    
                    case aJumpSign3 is 
                    		when "011111111" | "100000000" =>
                    					JumpPosition <= 0;
                    		when "011111110" | "100000001" =>
                    					JumpPosition <= 1;
                    		when "011111100" | "100000011" =>
                    					JumpPosition <= 2;
                    		when "011111000" | "100000111" =>
                    					JumpPosition <= 3;
                    		when "011110000" | "100001111" =>
                    					JumpPosition <= 4;
                    		when "011100000" | "100011111" =>
                    					JumpPosition <= 5;
                    		when "011000000" | "100111111" =>
                    					JumpPosition <= 6;
                    		when "010000000" | "101111111" =>
                    					JumpPosition <= 7;
                    		when others =>
                    					JumpPosition <=0;
                    end case;
                    --  0: 上一周期最后1路与本周期第0路之间产生mu值跳变 ( aJumpSign3(8)与aJumpSign3(0) )
                    --  1: 本周期第0路与本周期第1路之间产生mu值跳变
                    --  2: 本周期第1路与本周期第2路之间产生mu值跳变
                    --  3: 本周期第2路与本周期第3路之间产生mu值跳变
                    --  4: 本周期第3路与本周期第4路之间产生mu值跳变
                    --  5: 本周期第4路与本周期第5路之间产生mu值跳变
                    --  6: 本周期第5路与本周期第6路之间产生mu值跳变
                    --  7: 本周期第6路与本周期第7路之间产生mu值跳变         
                                                 
                    for i in 0 to 8 loop
                            sMuOutReg(i)    <= sMuAcc_Inter(i)(kInSize+4) & sMuAcc_Inter(i)(kInSize-2 downto 0); --get the fraction part
                    end loop;
                    sMuOutReg_next <= sMuAcc_Inter_next(kInSize+4) & sMuAcc_Inter_next(kInSize-2 downto 0);
                            
                    
                    -----------------------------
                    --  the third pipeline
                    -----------------------------
                    
                    --  该pipeline的理解可参看串行时钟环v2，或笔记
                    InterpType_ori <= InterpType_d2(0);
                    if flag_d2 = 0 then
                    		flag_out <= "00";
                    elsif flag_d2 = 1 then
                    		flag_out <= "01";
                    else
                    		flag_out <= "10";
                    end if;
                    
                    if flag_d2 = 0 then
	                    	for i in 0 to 7 loop
	                    		InterpType0 <= InterpType_d2(0);
          								InterpType1 <= InterpType_d2(1);
          								InterpType2 <= InterpType_d2(2);
          								InterpType3 <= InterpType_d2(3);
          								InterpType4 <= InterpType_d2(4);
          								InterpType5 <= InterpType_d2(5);
          								InterpType6 <= InterpType_d2(6);
          								InterpType7 <= InterpType_d2(7);                   
	                      end loop;
                    elsif flag_d2 = 1 then
                    		case JumpPosition is
                    					when 0 =>
                    								InterpType0 <= "00";
                    								InterpType1 <= InterpType_d2(0);
                    								InterpType2 <= InterpType_d2(1);
                    								InterpType3 <= InterpType_d2(2);
                    								InterpType4 <= InterpType_d2(3);
                    								InterpType5 <= InterpType_d2(4);
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    				 when 1 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= "00";
                    								InterpType2 <= InterpType_d2(1);
                    								InterpType3 <= InterpType_d2(2);
                    								InterpType4 <= InterpType_d2(3);
                    								InterpType5 <= InterpType_d2(4);
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    				 when 2 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= "00";
                    								InterpType3 <= InterpType_d2(2);
                    								InterpType4 <= InterpType_d2(3);
                    								InterpType5 <= InterpType_d2(4);
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    				 when 3 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= "00";
                    								InterpType4 <= InterpType_d2(3);
                    								InterpType5 <= InterpType_d2(4);
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    					when 4 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= "00";
                    								InterpType5 <= InterpType_d2(4);
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    					when 5 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= InterpType_d2(4);
                    								InterpType5 <= "00";
                    								InterpType6 <= InterpType_d2(5);
                    								InterpType7 <= InterpType_d2(6);
                    					when 6 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= InterpType_d2(4);
                    								InterpType5 <= InterpType_d2(5);
                    								InterpType6 <= "00";
                    								InterpType7 <= InterpType_d2(6);
                    					when 7 =>
                    								InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= InterpType_d2(4);
                    								InterpType5 <= InterpType_d2(5);
                    								InterpType6 <= InterpType_d2(6);
                    								InterpType7 <= "00";
                    				 when others=>
                    				        InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= InterpType_d2(4);
                    								InterpType5 <= InterpType_d2(5);
                    								InterpType6 <= InterpType_d2(6);
                    								InterpType7 <= InterpType_d2(7);
                    		end case;
                    else
                    		case JumpPosition is
                    				 when 0 =>
                    				 				InterpType0 <= unsigned( InterpType_d2(0)(1 downto 1) & '1' ); 
                    				 				InterpType1 <= InterpType_d2(2);
                    				 				InterpType2 <= InterpType_d2(3);
                    				 				InterpType3 <= InterpType_d2(4);
                    				 				InterpType4 <= InterpType_d2(5);
                    				 				InterpType5 <= InterpType_d2(6);
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 1 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= unsigned( InterpType_d2(1)(1 downto 1) & '1' );
                    				 				InterpType2 <= InterpType_d2(3);
                    				 				InterpType3 <= InterpType_d2(4);
                    				 				InterpType4 <= InterpType_d2(5);
                    				 				InterpType5 <= InterpType_d2(6);
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 2 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= unsigned( (InterpType_d2(2)(1 downto 1)) & '1' ); 
                    				 				InterpType3 <= InterpType_d2(4);
                    				 				InterpType4 <= InterpType_d2(5);
                    				 				InterpType5 <= InterpType_d2(6);
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);			
                    				 when 3 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= InterpType_d2(2);
                    				 				InterpType3 <= unsigned( (InterpType_d2(3)(1 downto 1)) & '1' ); 
                    				 				InterpType4 <= InterpType_d2(5);
                    				 				InterpType5 <= InterpType_d2(6);
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 4 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= InterpType_d2(2);
                    				 				InterpType3 <= InterpType_d2(3); 
                    				 				InterpType4 <= unsigned( (InterpType_d2(4)(1 downto 1)) & '1' ); 
                    				 				InterpType5 <= InterpType_d2(6);
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 5 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= InterpType_d2(2);
                    				 				InterpType3 <= InterpType_d2(3);
                    				 				InterpType4 <= InterpType_d2(4);
                    				 				InterpType5 <= unsigned( (InterpType_d2(5)(1 downto 1)) & '1' ); 
                    				 				InterpType6 <= InterpType_d2(7);
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 6 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= InterpType_d2(2);
                    				 				InterpType3 <= InterpType_d2(3); 
                    				 				InterpType4 <= InterpType_d2(4);
                    				 				InterpType5 <= InterpType_d2(5);
                    				 				InterpType6 <= unsigned( (InterpType_d2(6)(1 downto 1)) & '1' ); 
                    				 				InterpType7 <= InterpType_d2(0);
                    				 when 7 =>
                    				 				InterpType0 <= InterpType_d2(0);
                    				 				InterpType1 <= InterpType_d2(1);
                    				 				InterpType2 <= InterpType_d2(2);
                    				 				InterpType3 <= InterpType_d2(3); 
                    				 				InterpType4 <= InterpType_d2(4);
                    				 				InterpType5 <= InterpType_d2(5);
                    				 				InterpType6 <= InterpType_d2(6);
                    				 				InterpType7 <= unsigned( (InterpType_d2(7)(1 downto 1)) & '1' ); 
                    				 when others=>
                    				        InterpType0 <= InterpType_d2(0);
                    								InterpType1 <= InterpType_d2(1);
                    								InterpType2 <= InterpType_d2(2);
                    								InterpType3 <= InterpType_d2(3);
                    								InterpType4 <= InterpType_d2(4);
                    								InterpType5 <= InterpType_d2(5);
                    								InterpType6 <= InterpType_d2(6);
                    								InterpType7 <= InterpType_d2(7);
                    		end case;
                    end if;
                    					
                    if flag_d2=0 then
                    						sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));                            
                            		sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu6    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu7    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));  
                    elsif flag_d2=1 then
                    		case JumpPosition is
                            when 0 =>
                                    sMu0    <= to_unsigned(0,kOutSize);
                                    sMu1    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 1 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= to_unsigned(0,kOutSize);
                                    sMu2    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 2 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= to_unsigned(0,kOutSize);
                                    sMu3    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 3 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= to_unsigned(0,kOutSize);
                                    sMu4    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 4 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= to_unsigned(0,kOutSize);
                                    sMu5    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 5 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= to_unsigned(0,kOutSize);
                                    sMu6    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 6 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= to_unsigned(0,kOutSize);
                                    sMu7    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                            when 7 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= to_unsigned(0,kOutSize);
                            when others =>                            	
                            		sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));                            
                            		sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu6    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu7    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));                            	
                        end case;
                    else
                    		case JumpPosition is
                            when 0 =>
                                                                                                   
                                    if InterpType_d2(0)(0 downto 0) = "1" then
                                    	sMu0    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu0    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu1    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1)); 
                                    sMu2    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));       
                                    sMu3    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 1 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));                                                                 
                                    if InterpType_d2(1)(0 downto 0) = "1" then
                                    	sMu1    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu1    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu2    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));       
                                    sMu3    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 2 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));                                    
                                    if InterpType_d2(2)(0 downto 0) = "1" then
                                    	sMu2    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu2    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu3    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 3 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    if InterpType_d2(3)(0 downto 0) = "1" then
                                    	sMu3    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu3    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu4    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 4 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    if InterpType_d2(4)(0 downto 0) = "1" then
                                    	sMu4    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu4    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 5 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    if InterpType_d2(5)(0 downto 0) = "1" then
                                    	sMu5    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu5    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;                                    
                                    sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 6 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    if InterpType_d2(6)(0 downto 0) = "1" then
                                    	sMu6    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu6    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                                    sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                            when 7 =>
                                    sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));
                                    sMu6    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));
                                    if InterpType_d2(7)(0 downto 0) = "1" then
                                    	sMu7    <= to_unsigned(0,kOutSize)-unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));
                                    else
                                    	sMu7    <= unsigned(sMuOutReg_next(kInSize-2 downto kInSize-kOutSize-1));
                                    end if;
                            when others =>                            	
                            		sMu0    <= unsigned(sMuOutReg(0)(kInSize-2 downto kInSize-kOutSize-1));                            
                            		sMu1    <= unsigned(sMuOutReg(1)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu2    <= unsigned(sMuOutReg(2)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu3    <= unsigned(sMuOutReg(3)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu4    <= unsigned(sMuOutReg(4)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu5    <= unsigned(sMuOutReg(5)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu6    <= unsigned(sMuOutReg(6)(kInSize-2 downto kInSize-kOutSize-1));                            	
                            		sMu7    <= unsigned(sMuOutReg(7)(kInSize-2 downto kInSize-kOutSize-1));                            	
                        end case;
                    end if;
                    
                    
                    
                   
            else
                    null;
            end if;
                end if;
        end process;  
   
end rtl;