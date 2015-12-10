-------------------------------------------------------------------------------
--
-- 作者: 杨再初
-- 所属项目: QPSK高速并行解调
-- 时间: 2007.12.28
--
-- 功能：输出数据fifo
--
-- 说明：
--     kCountWidth不能随便更改，对于8路并行固定为4
-------------------------------------------------------------------------------
--
-- Revision History:
-- 2008.1.4 First revision
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Parallel8TapFifo_v2 is
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
end Parallel8TapFifo_v2;

architecture rtl of Parallel8TapFifo_v2 is
        type DataInArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sData_Reg0       : DataInArray (7 downto 0);
        signal sData_Reg1       : DataInArray (7 downto 0);
        signal sData_Reg2       : DataInArray (7 downto 0);
        signal sData_Reg3       : DataInArray (7 downto 0);
        signal sData_Reg4       : DataInArray (7 downto 0);
        signal sData_Reg5       : DataInArray (7 downto 0);
        signal sData_Reg6       : DataInArray (7 downto 0);
        signal sData_Reg7       : DataInArray (7 downto 0);

--        type EnableInArray is Array (natural range <>) of boolean;
--        signal sEnable_Reg0     : EnableInArray (6 downto 0);
--        signal sEnable_Reg1     : EnableInArray (6 downto 0);
--        signal sEnable_Reg2     : EnableInArray (6 downto 0);
--        signal sEnable_Reg3     : EnableInArray (6 downto 0);
--        signal sEnable_Reg4     : EnableInArray (6 downto 0);
--        signal sEnable_Reg5     : EnableInArray (6 downto 0);
--        signal sEnable_Reg6     : EnableInArray (6 downto 0);
--        signal sEnable_Reg7     : EnableInArray (6 downto 0);
        
        type InterpTypeArray is Array (natural range <>) of unsigned( 1 downto 0 );
        signal InterpType_Reg0     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg1     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg2     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg3     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg4     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg5     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg6     : InterpTypeArray (6 downto 0);
        signal InterpType_Reg7     : InterpTypeArray (6 downto 0);
                        
        type CounterArray   is Array (natural range <>) of unsigned (kCountWidth - 1 downto 0);
        signal sCounter         : CounterArray (7 downto 0);
        signal sDataOutReg      : DataInArray (15 downto 0);

begin

        process(aReset, Clk_in)
                variable sStartPoint: integer range 0 to 16:=0;
        begin
                if aReset='1' then
                        for i in 0 to 7 loop
                                sData_Reg0(i)         <= (others => '0');
                                sData_Reg1(i)         <= (others => '0');
                                sData_Reg2(i)         <= (others => '0');
                                sData_Reg3(i)         <= (others => '0');
                                sData_Reg4(i)         <= (others => '0');
                                sData_Reg5(i)         <= (others => '0');
                                sData_Reg6(i)         <= (others => '0');
                                sData_Reg7(i)         <= (others => '0');
                        end loop;
                        for i in 0 to 6 loop
                                InterpType_Reg0(i)       <= (others => '0');
                                InterpType_Reg1(i)       <= (others => '0');
                                InterpType_Reg2(i)       <= (others => '0');
                                InterpType_Reg3(i)       <= (others => '0');
                                InterpType_Reg4(i)       <= (others => '0');
                                InterpType_Reg5(i)       <= (others => '0');
                                InterpType_Reg6(i)       <= (others => '0');
                                InterpType_Reg7(i)       <= (others => '0');
                        end loop;
                        for i in 0 to 7 loop
                                sCounter(i)           <= to_unsigned(7-i,kCountWidth);
                        end loop;
                        for i in 0 to 7 loop
                                sDataOutReg(i)        <= (others => '0');
                        end loop;
                        sStartPoint                   := 0;
						sEnableOut                    <= '0';        
						sDataOut0       <= (others => '0');
						sDataOut1       <= (others => '0');
						sDataOut2       <= (others => '0');
						sDataOut3       <= (others => '0');
                elsif rising_edge(Clk_in) then   
                	if sEnable='1' then
                       InterpType_Reg0(0) <= InterpType0;
                       InterpType_Reg1(0) <= InterpType1;
                       InterpType_Reg2(0) <= InterpType2;
                       InterpType_Reg3(0) <= InterpType3;
                       InterpType_Reg4(0) <= InterpType4;
                       InterpType_Reg5(0) <= InterpType5;
                       InterpType_Reg6(0) <= InterpType6;
                       InterpType_Reg7(0) <= InterpType7;
                       for i in 1 to 6 loop
                                InterpType_Reg0(i) <= InterpType_Reg0(i-1);
                                InterpType_Reg1(i) <= InterpType_Reg1(i-1);
                                InterpType_Reg2(i) <= InterpType_Reg2(i-1);
                                InterpType_Reg3(i) <= InterpType_Reg3(i-1);
                                InterpType_Reg4(i) <= InterpType_Reg4(i-1);
                                InterpType_Reg5(i) <= InterpType_Reg5(i-1);
                                InterpType_Reg6(i) <= InterpType_Reg6(i-1);
                                InterpType_Reg7(i) <= InterpType_Reg7(i-1);   
                        end loop;
                                        
                        --第一级
                        if InterpType0="11" then
                                sCounter(0)     <= to_unsigned(8,kCountWidth);
                                sData_Reg0(0)   <= sDataIn0;
                                sData_Reg0(1)   <= sDataIn1;
                                sData_Reg0(2)   <= sDataIn2;
                                sData_Reg0(3)   <= sDataIn3;
                                sData_Reg0(4)   <= sDataIn4;
                                sData_Reg0(5)   <= sDataIn5;
                                sData_Reg0(6)   <= sDataIn6;
                                sData_Reg0(7)   <= sDataIn7; 
                        else
                                sCounter(0)     <= to_unsigned(7,kCountWidth);
                                sData_Reg0(0)   <= sDataIn0;
                                sData_Reg0(1)   <= sDataIn1;
                                sData_Reg0(2)   <= sDataIn2;
                                sData_Reg0(3)   <= sDataIn3;
                                sData_Reg0(4)   <= sDataIn4;
                                sData_Reg0(5)   <= sDataIn5;
                                sData_Reg0(6)   <= sDataIn6;
                                sData_Reg0(7)   <= sDataIn7;
                         end if;
                                
                        --第二级
                        if InterpType_Reg1(0)="11" then
                                sCounter(1)     <= sCounter(0);
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(1);
                                sData_Reg1(2)   <= sData_Reg0(2);
                                sData_Reg1(3)   <= sData_Reg0(3);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                         else
                                sCounter(1)     <= sCounter(0)-1;
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(0);
                                sData_Reg1(2)   <= sData_Reg0(2);
                                sData_Reg1(3)   <= sData_Reg0(3);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                        end if;

                        --第三级
                        if InterpType_Reg2(1)="11" then
                                sCounter(2)     <= sCounter(1);
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(1);
                                sData_Reg2(2)   <= sData_Reg1(2);
                                sData_Reg2(3)   <= sData_Reg1(3);
                                sData_Reg2(4)   <= sData_Reg1(4);
                                sData_Reg2(5)   <= sData_Reg1(5);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                         else
                                sCounter(2)     <= sCounter(1)-1;
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(0);
                                sData_Reg2(2)   <= sData_Reg1(1);
                                sData_Reg2(3)   <= sData_Reg1(3);
                                sData_Reg2(4)   <= sData_Reg1(4);
                                sData_Reg2(5)   <= sData_Reg1(5);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                        end if;
                         
                        --第四级
                        if InterpType_Reg3(2)="11" then
                                sCounter(3)     <= sCounter(2);
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(1);
                                sData_Reg3(2)   <= sData_Reg2(2);
                                sData_Reg3(3)   <= sData_Reg2(3);
                                sData_Reg3(4)   <= sData_Reg2(4);
                                sData_Reg3(5)   <= sData_Reg2(5);
                                sData_Reg3(6)   <= sData_Reg2(6);
                                sData_Reg3(7)   <= sData_Reg2(7);
                         else
                                sCounter(3)     <= sCounter(2)-1;
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(0);
                                sData_Reg3(2)   <= sData_Reg2(1);
                                sData_Reg3(3)   <= sData_Reg2(2);
                                sData_Reg3(4)   <= sData_Reg2(4);
                                sData_Reg3(5)   <= sData_Reg2(5);
                                sData_Reg3(6)   <= sData_Reg2(6);
                                sData_Reg3(7)   <= sData_Reg2(7);
                        end if;
                         
                        --第五级
                        if InterpType_Reg4(3)="11" then
                                sCounter(4)     <= sCounter(3);
                                sData_Reg4(0)   <= sData_Reg3(0);
                                sData_Reg4(1)   <= sData_Reg3(1);
                                sData_Reg4(2)   <= sData_Reg3(2);
                                sData_Reg4(3)   <= sData_Reg3(3);
                                sData_Reg4(4)   <= sData_Reg3(4);
                                sData_Reg4(5)   <= sData_Reg3(5);
                                sData_Reg4(6)   <= sData_Reg3(6);
                                sData_Reg4(7)   <= sData_Reg3(7);
                         else
                                sCounter(4)     <= sCounter(3)-1;
                                sData_Reg4(0)   <= sData_Reg3(0);
                                sData_Reg4(1)   <= sData_Reg3(0);
                                sData_Reg4(2)   <= sData_Reg3(1);
                                sData_Reg4(3)   <= sData_Reg3(2);
                                sData_Reg4(4)   <= sData_Reg3(3);
                                sData_Reg4(5)   <= sData_Reg3(5);
                                sData_Reg4(6)   <= sData_Reg3(6);
                                sData_Reg4(7)   <= sData_Reg3(7);
                        end if;
                        
                        --第六级
                        if InterpType_Reg5(4)="11" then
                                sCounter(5)     <= sCounter(4);
                                sData_Reg5(0)   <= sData_Reg4(0);
                                sData_Reg5(1)   <= sData_Reg4(1);
                                sData_Reg5(2)   <= sData_Reg4(2);
                                sData_Reg5(3)   <= sData_Reg4(3);
                                sData_Reg5(4)   <= sData_Reg4(4);
                                sData_Reg5(5)   <= sData_Reg4(5);
                                sData_Reg5(6)   <= sData_Reg4(6);
                                sData_Reg5(7)   <= sData_Reg4(7);
                         else
                                sCounter(5)     <= sCounter(4)-1;
                                sData_Reg5(0)   <= sData_Reg4(0);
                                sData_Reg5(1)   <= sData_Reg4(0);
                                sData_Reg5(2)   <= sData_Reg4(1);
                                sData_Reg5(3)   <= sData_Reg4(2);
                                sData_Reg5(4)   <= sData_Reg4(3);
                                sData_Reg5(5)   <= sData_Reg4(4);
                                sData_Reg5(6)   <= sData_Reg4(6);
                                sData_Reg5(7)   <= sData_Reg4(7);
                        end if;

                        --第七级
                        if InterpType_Reg6(5)="11" then
                                sCounter(6)     <= sCounter(5);
                                sData_Reg6(0)   <= sData_Reg5(0);
                                sData_Reg6(1)   <= sData_Reg5(1);
                                sData_Reg6(2)   <= sData_Reg5(2);
                                sData_Reg6(3)   <= sData_Reg5(3);
                                sData_Reg6(4)   <= sData_Reg5(4);
                                sData_Reg6(5)   <= sData_Reg5(5);
                                sData_Reg6(6)   <= sData_Reg5(6);
                                sData_Reg6(7)   <= sData_Reg5(7);
                         else
                                sCounter(6)     <= sCounter(5)-1;
                                sData_Reg6(0)   <= sData_Reg5(0);
                                sData_Reg6(1)   <= sData_Reg5(0);
                                sData_Reg6(2)   <= sData_Reg5(1);
                                sData_Reg6(3)   <= sData_Reg5(2);
                                sData_Reg6(4)   <= sData_Reg5(3);
                                sData_Reg6(5)   <= sData_Reg5(4);
                                sData_Reg6(6)   <= sData_Reg5(5);
                                sData_Reg6(7)   <= sData_Reg5(7);
                        end if;

                        --第八级
                        if InterpType_Reg7(6)="11" then
                                sCounter(7)     <= sCounter(6);
                                sData_Reg7(0)   <= sData_Reg6(0);
                                sData_Reg7(1)   <= sData_Reg6(1);
                                sData_Reg7(2)   <= sData_Reg6(2);
                                sData_Reg7(3)   <= sData_Reg6(3);
                                sData_Reg7(4)   <= sData_Reg6(4);
                                sData_Reg7(5)   <= sData_Reg6(5);
                                sData_Reg7(6)   <= sData_Reg6(6);
                                sData_Reg7(7)   <= sData_Reg6(7);
                         else
                                sCounter(7)     <= sCounter(6)-1;
                                sData_Reg7(0)   <= sData_Reg6(0);
                                sData_Reg7(1)   <= sData_Reg6(0);
                                sData_Reg7(2)   <= sData_Reg6(1);
                                sData_Reg7(3)   <= sData_Reg6(2);
                                sData_Reg7(4)   <= sData_Reg6(3);
                                sData_Reg7(5)   <= sData_Reg6(4);
                                sData_Reg7(6)   <= sData_Reg6(5);
                                sData_Reg7(7)   <= sData_Reg6(6);
                        end if;
                        
                        --第九级
                        if sStartPoint >= 4 then
                                sDataOut0       <= sDataOutReg(3);
                                sDataOut1       <= sDataOutReg(2);
                                sDataOut2       <= sDataOutReg(1);
                                sDataOut3       <= sDataOutReg(0);
                                sEnableOut      <= '1';
                                for i in 4 to 7 loop
                                        sDataOutReg(i-4)        <= sDataOutReg(i);
                                end loop;
                                case sStartPoint is
                                        when 4 => for i in 0 to 3 loop
                                                           sDataOutReg(i)       <= sData_Reg7(7-i);
                                                       end loop;
                                        when 5 => for i in 1 to 4 loop
                                                           sDataOutReg(i)       <= sData_Reg7(8-i);
                                                       end loop;
                                        when 6 => for i in 2 to 5 loop
                                                           sDataOutReg(i)       <= sData_Reg7(9-i);
                                                       end loop;
                                        when 7 => for i in 3 to 6 loop
                                                           sDataOutReg(i)       <= sData_Reg7(10-i);
                                                       end loop;
                                        when 8 => for i in 4 to 7 loop
                                                           sDataOutReg(i)       <= sData_Reg7(11-i);
                                                       end loop;
                                        when others => for i in 0 to 3 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i);
                                                       end loop;
                                end case;
                                sStartPoint     := sStartPoint - 4 + conv_integer(std_logic_vector(sCounter(7)));
                         else
                                sEnableOut      <= '0';
                                case sStartPoint is
                                        when 0 => for i in 0 to 3 loop
                                                           sDataOutReg(i)       <= sData_Reg7(7-i);
                                                       end loop;
                                        when 1 => for i in 1 to 4 loop
                                                           sDataOutReg(i)       <= sData_Reg7(8-i);
                                                       end loop;
                                        when 2 => for i in 2 to 5 loop
                                                           sDataOutReg(i)       <= sData_Reg7(9-i);
                                                       end loop;
                                        when 3 => for i in 3 to 6 loop
                                                           sDataOutReg(i)       <= sData_Reg7(10-i);
                                                       end loop;
                                        when others => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i);
                                                       end loop;
                                 end case;
                                 sStartPoint    := sStartPoint+conv_integer(std_logic_vector(sCounter(7)));
                         end if;
                         
                	else
                		sEnableOut <= '0';
                	end if;

                        
                end if;
        end process;
                             

end rtl;