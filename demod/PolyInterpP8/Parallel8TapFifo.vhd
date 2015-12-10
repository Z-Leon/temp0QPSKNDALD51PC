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


entity Parallel8TapFifo is
        generic(
                kCountWidth     : positive := 4;  -- 计数器的宽度
                kDataWidth      : positive :=8);  -- 输入数据宽度
        port   (
                aReset          : in  std_logic;
                Clk_in          : in  std_logic;
                sDataIn0        : in  signed (kDataWidth-1 downto 0);
                sDataIn1        : in  signed (kDataWidth-1 downto 0);
                sDataIn2        : in  signed (kDataWidth-1 downto 0);
                sDataIn3        : in  signed (kDataWidth-1 downto 0);
                sDataIn4        : in  signed (kDataWidth-1 downto 0);
                sDataIn5        : in  signed (kDataWidth-1 downto 0);
                sDataIn6        : in  signed (kDataWidth-1 downto 0);
                sDataIn7        : in  signed (kDataWidth-1 downto 0);
                sEnableIn0      : in std_logic;
                sEnableIn1      : in std_logic;
                sEnableIn2      : in std_logic;
                sEnableIn3      : in std_logic;
                sEnableIn4      : in std_logic;
                sEnableIn5      : in std_logic;
                sEnableIn6      : in std_logic;
                sEnableIn7      : in std_logic;
                sDataOut0       : Out  signed (kDataWidth-1 downto 0);
                sDataOut1       : Out  signed (kDataWidth-1 downto 0);
                sDataOut2       : Out  signed (kDataWidth-1 downto 0);
                sDataOut3       : Out  signed (kDataWidth-1 downto 0);
                sDataOut4       : Out  signed (kDataWidth-1 downto 0);
                sDataOut5       : Out  signed (kDataWidth-1 downto 0);
                sDataOut6       : Out  signed (kDataWidth-1 downto 0);
                sDataOut7       : Out  signed (kDataWidth-1 downto 0);
                sEnableOut      : Out  std_logic
                );
end Parallel8TapFifo;

architecture rtl of Parallel8TapFifo is
        type DataInArray is Array (natural range <>) of signed (kDataWidth-1 downto 0);
        signal sData_Reg0       : DataInArray (7 downto 0);
        signal sData_Reg1       : DataInArray (7 downto 0);
        signal sData_Reg2       : DataInArray (7 downto 0);
        signal sData_Reg3       : DataInArray (7 downto 0);
        signal sData_Reg4       : DataInArray (7 downto 0);
        signal sData_Reg5       : DataInArray (7 downto 0);
        signal sData_Reg6       : DataInArray (7 downto 0);
        signal sData_Reg7       : DataInArray (7 downto 0);

        type EnableInArray is Array (natural range <>) of std_logic;
        signal sEnable_Reg0     : EnableInArray (6 downto 0);
        signal sEnable_Reg1     : EnableInArray (6 downto 0);
        signal sEnable_Reg2     : EnableInArray (6 downto 0);
        signal sEnable_Reg3     : EnableInArray (6 downto 0);
        signal sEnable_Reg4     : EnableInArray (6 downto 0);
        signal sEnable_Reg5     : EnableInArray (6 downto 0);
        signal sEnable_Reg6     : EnableInArray (6 downto 0);
        signal sEnable_Reg7     : EnableInArray (6 downto 0);
                
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
                                sEnable_Reg0(i)       <= '0';
                                sEnable_Reg1(i)       <= '0';
                                sEnable_Reg2(i)       <= '0';
                                sEnable_Reg3(i)       <= '0';
                                sEnable_Reg4(i)       <= '0';
                                sEnable_Reg5(i)       <= '0';
                                sEnable_Reg6(i)       <= '0';
                                sEnable_Reg7(i)       <= '0';
                        end loop;
                        for i in 0 to 7 loop
                                sCounter(i)           <= to_unsigned(7-i,kCountWidth);
                        end loop;
                        for i in 0 to 15 loop
                                sDataOutReg(i)        <= (others => '0');
                        end loop;
                        sStartPoint                   := 0;
						sEnableOut                    <= '0';        
						sDataOut0       <= (others => '0');
						sDataOut1       <= (others => '0');
						sDataOut2       <= (others => '0');
						sDataOut3       <= (others => '0');
						sDataOut4       <= (others => '0');
						sDataOut5       <= (others => '0');
						sDataOut6       <= (others => '0');
						sDataOut7       <= (others => '0');
                elsif rising_edge(Clk_in) then   
                       sEnable_Reg0(0) <= sEnableIn0;
                       sEnable_Reg1(0) <= sEnableIn1;
                       sEnable_Reg2(0) <= sEnableIn2;
                       sEnable_Reg3(0) <= sEnableIn3;
                       sEnable_Reg4(0) <= sEnableIn4;
                       sEnable_Reg5(0) <= sEnableIn5;
                       sEnable_Reg6(0) <= sEnableIn6;
                       sEnable_Reg7(0) <= sEnableIn7;
                       for i in 1 to 6 loop
                                sEnable_Reg0(i) <= sEnable_Reg0(i-1);
                                sEnable_Reg1(i) <= sEnable_Reg1(i-1);
                                sEnable_Reg2(i) <= sEnable_Reg2(i-1);
                                sEnable_Reg3(i) <= sEnable_Reg3(i-1);
                                sEnable_Reg4(i) <= sEnable_Reg4(i-1);
                                sEnable_Reg5(i) <= sEnable_Reg5(i-1);
                                sEnable_Reg6(i) <= sEnable_Reg6(i-1);
                                sEnable_Reg7(i) <= sEnable_Reg7(i-1);   
                        end loop;
                                        
                        --第一级
                        if sEnableIn0='1' then
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
                        if sEnable_Reg1(0)='1' then
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
                        if sEnable_Reg2(1)='1' then
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
                        if sEnable_Reg3(2)='1' then
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
                        if sEnable_Reg4(3)='1' then
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
                        if sEnable_Reg5(4)='1' then
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
                        if sEnable_Reg6(5)='1' then
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
                        if sEnable_Reg7(6)='1' then
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
                        if sStartPoint >= 8 then
                                sDataOut0       <= sDataOutReg(7);
                                sDataOut1       <= sDataOutReg(6);
                                sDataOut2       <= sDataOutReg(5);
                                sDataOut3       <= sDataOutReg(4);
                                sDataOut4       <= sDataOutReg(3);
                                sDataOut5       <= sDataOutReg(2);
                                sDataOut6       <= sDataOutReg(1);
                                sDataOut7       <= sDataOutReg(0);
                                sEnableOut      <= '1';
                                for i in 8 to 15 loop
                                        sDataOutReg(i-8)        <= sDataOutReg(i);
                                end loop;
                                case sStartPoint is
                                        when 8 => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sData_Reg7(7-i);
                                                       end loop;
                                        when 9 => for i in 1 to 8 loop
                                                           sDataOutReg(i)       <= sData_Reg7(8-i);
                                                       end loop;
                                        when 10 => for i in 2 to 9 loop
                                                           sDataOutReg(i)       <= sData_Reg7(9-i);
                                                       end loop;
                                        when 11 => for i in 3 to 10 loop
                                                           sDataOutReg(i)       <= sData_Reg7(10-i);
                                                       end loop;
                                        when 12 => for i in 4 to 11 loop
                                                           sDataOutReg(i)       <= sData_Reg7(11-i);
                                                       end loop;
                                        when 13 => for i in 5 to 12 loop
                                                           sDataOutReg(i)       <= sData_Reg7(12-i);
                                                       end loop;
                                        when 14 => for i in 6 to 13 loop
                                                           sDataOutReg(i)       <= sData_Reg7(13-i);
                                                       end loop;
                                        when 15 => for i in 7 to 14 loop
                                                           sDataOutReg(i)       <= sData_Reg7(14-i);
                                                       end loop;
                                        when 16 => for i in 8 to 15 loop
                                                           sDataOutReg(i)       <= sData_Reg7(15-i);
                                                       end loop;
                                        when others => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i);
                                                       end loop;
                                end case;
                                sStartPoint     := sStartPoint - 8 + conv_integer(std_logic_vector(sCounter(7)));
                         else
                                sEnableOut      <= '0';
                                case sStartPoint is
                                        when 0 => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sData_Reg7(7-i);
                                                       end loop;
                                        when 1 => for i in 1 to 8 loop
                                                           sDataOutReg(i)       <= sData_Reg7(8-i);
                                                       end loop;
                                        when 2 => for i in 2 to 9 loop
                                                           sDataOutReg(i)       <= sData_Reg7(9-i);
                                                       end loop;
                                        when 3 => for i in 3 to 10 loop
                                                           sDataOutReg(i)       <= sData_Reg7(10-i);
                                                       end loop;
                                        when 4 => for i in 4 to 11 loop
                                                           sDataOutReg(i)       <= sData_Reg7(11-i);
                                                       end loop;
                                        when 5 => for i in 5 to 12 loop
                                                           sDataOutReg(i)       <= sData_Reg7(12-i);
                                                       end loop;
                                        when 6 => for i in 6 to 13 loop
                                                           sDataOutReg(i)       <= sData_Reg7(13-i);
                                                       end loop;
                                        when 7 => for i in 7 to 14 loop
                                                           sDataOutReg(i)       <= sData_Reg7(14-i);
                                                       end loop;
                                        when others => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i);
                                                       end loop;
                                 end case;
                                 sStartPoint    := sStartPoint+conv_integer(std_logic_vector(sCounter(7)));
                         end if;
                        
                end if;
        end process;
                             

end rtl;