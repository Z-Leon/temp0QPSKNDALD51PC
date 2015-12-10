-------------------------------------------------------------------------------
--
-- ����: ���ٳ�
-- ������Ŀ: QPSK���ٲ��н��
-- ʱ��: 2007.12.28
--
-- ���ܣ��������fifo
--
-- ˵����
--     kCountWidth���������ģ�����8·���й̶�Ϊ4
-------------------------------------------------------------------------------
--
-- Revision History:
-- 2008.1.4 First revision
-- 2008.6.30 Second revision
--        ��λ������8���ڵ���Ϊ4���ڣ�ÿ�δ���2bit���Լ���4����ʱ
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Parallel8TapFifo is
        generic(
                kCountWidth     : positive := 4;  -- �������Ŀ��
                kDataWidth      : positive :=8);  -- �������ݿ��
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
                sEnableOut      : Out  boolean
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
        
        signal sData_Reg_Pre	: DataInArray (7 downto 0);--����֮ǰ��������
        

        type EnableInArray is Array (natural range <>) of boolean;
        signal sEnable_Reg0     : std_logic_vector (6 downto 0);
        signal sEnable_Reg1     : std_logic_vector (6 downto 0);
        signal sEnable_Reg2     : std_logic_vector (6 downto 0);
        signal sEnable_Reg3     : std_logic_vector (6 downto 0);
        signal sEnable_Reg4     : std_logic_vector (6 downto 0);
        signal sEnable_Reg5     : std_logic_vector (6 downto 0);
        signal sEnable_Reg6     : std_logic_vector (6 downto 0);
        signal sEnable_Reg7     : std_logic_vector (6 downto 0);
                
        type CounterArray   is Array (natural range <>) of unsigned (kCountWidth - 1 downto 0);
        signal sCounter         : CounterArray (7 downto 0);
        signal sDataOutReg      : DataInArray (15 downto 0);
        signal sStartPoint      : integer range 0 to 16;
begin

        process(aReset, Clk_in)
                --variable sStartPoint: integer range 0 to 16:=0;
                variable vEnable0,vEnable1,vEnable2,vEnable3 : unsigned (1 downto 0);
        begin
                if aReset=true then
                        for i in 0 to 7 loop
                                sData_Reg0(i)         <= (others => '0');
                                sData_Reg1(i)         <= (others => '0');
                                sData_Reg2(i)         <= (others => '0');
                                sData_Reg3(i)         <= (others => '0');
                                sData_Reg4(i)         <= (others => '0');
                                sData_Reg5(i)         <= (others => '0');
                                sData_Reg6(i)         <= (others => '0');
                                sData_Reg7(i)         <= (others => '0');
                                
                                sData_Reg_Pre(i)	  <= (others => '0');
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
                        sStartPoint                   <= 0;
                        sEnableOut                    <= false;   
                        
                        vEnable0					 := (others => '0');   
                        vEnable1					 := (others => '0');   
                        vEnable2					 := (others => '0');   
                        vEnable3					 := (others => '0');   
                          
                elsif rising_edge(Clk_in) then 
                		--��ʹ���ź�ת��Ϊstd_logic���ͣ����ڴ�����ͬ����������
                		if   sEnableIn0 then
                			sEnable_Reg0(0) <= '1';
                		else
                			sEnable_Reg0(0) <= '0';
                		end if;
                		if   sEnableIn1 then
                			sEnable_Reg1(0) <= '1';
                		else
                			sEnable_Reg1(0) <= '0';
                		end if;
                		if   sEnableIn2 then
                			sEnable_Reg2(0) <= '1';
                		else
                			sEnable_Reg2(0) <= '0';
                		end if;
                		if   sEnableIn3 then
                			sEnable_Reg3(0) <= '1';
                		else
                			sEnable_Reg3(0) <= '0';
                		end if;
                		if   sEnableIn4 then
                			sEnable_Reg4(0) <= '1';
                		else
                			sEnable_Reg4(0) <= '0';
                		end if;
                		if   sEnableIn5 then
                			sEnable_Reg5(0) <= '1';
                		else
                			sEnable_Reg5(0) <= '0';
                		end if;
                		if   sEnableIn6 then
                			sEnable_Reg6(0) <= '1';
                		else
                			sEnable_Reg6(0) <= '0';
                		end if;
                		if   sEnableIn7 then
                			sEnable_Reg7(0) <= '1';
                		else
                			sEnable_Reg7(0) <= '0';
                		end if;
                		
--                       sEnable_Reg1(0) <= sEnableIn1;
--                       sEnable_Reg2(0) <= sEnableIn2;
--                       sEnable_Reg3(0) <= sEnableIn3;
--                       sEnable_Reg4(0) <= sEnableIn4;
--                       sEnable_Reg5(0) <= sEnableIn5;
--                       sEnable_Reg6(0) <= sEnableIn6;
--                       sEnable_Reg7(0) <= sEnableIn7;
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
                                      
                        sData_Reg_Pre(0)	<=  sDataIn0; 
                        sData_Reg_Pre(1)	<=  sDataIn1; 
                        sData_Reg_Pre(2)	<=  sDataIn2; 
                        sData_Reg_Pre(3)	<=  sDataIn3; 
                        sData_Reg_Pre(4)	<=  sDataIn4; 
                        sData_Reg_Pre(5)	<=  sDataIn5; 
                        sData_Reg_Pre(6)	<=  sDataIn6; 
                        sData_Reg_Pre(7)	<=  sDataIn7; 
                        
                        
                        --��һ��
                        vEnable0	:= unsigned'(sEnable_Reg0(0)& sEnable_Reg1(0));
                        case vEnable0 is
                            when "11" => 
                                sCounter(0)     <= to_unsigned(8,kCountWidth);
                                sData_Reg0(0)   <= sData_Reg_Pre(0);
                                sData_Reg0(1)   <= sData_Reg_Pre(1);
                                sData_Reg0(2)   <= sData_Reg_Pre(2);
                                sData_Reg0(3)   <= sData_Reg_Pre(3);
                                sData_Reg0(4)   <= sData_Reg_Pre(4);
                                sData_Reg0(5)   <= sData_Reg_Pre(5);
                                sData_Reg0(6)   <= sData_Reg_Pre(6);
                                sData_Reg0(7)   <= sData_Reg_Pre(7); 
                            when "01" =>
                                sCounter(0)     <= to_unsigned(7,kCountWidth);
                                sData_Reg0(0)   <= sData_Reg_Pre(0);
                                sData_Reg0(1)   <= sData_Reg_Pre(1);
                                sData_Reg0(2)   <= sData_Reg_Pre(2);
                                sData_Reg0(3)   <= sData_Reg_Pre(3);
                                sData_Reg0(4)   <= sData_Reg_Pre(4);
                                sData_Reg0(5)   <= sData_Reg_Pre(5);
                                sData_Reg0(6)   <= sData_Reg_Pre(6);
                                sData_Reg0(7)   <= sData_Reg_Pre(7); 
                        	when "10" => 
                                sCounter(0)     <= to_unsigned(7,kCountWidth);
                                sData_Reg0(0)   <= sData_Reg_Pre(0);
                                sData_Reg0(1)   <= sData_Reg_Pre(0);
                                sData_Reg0(2)   <= sData_Reg_Pre(2);
                                sData_Reg0(3)   <= sData_Reg_Pre(3);
                                sData_Reg0(4)   <= sData_Reg_Pre(4);
                                sData_Reg0(5)   <= sData_Reg_Pre(5);
                                sData_Reg0(6)   <= sData_Reg_Pre(6);
                                sData_Reg0(7)   <= sData_Reg_Pre(7); 
                            when others => 
                                sCounter(0)     <= to_unsigned(6,kCountWidth);
                                sData_Reg0(0)   <= sData_Reg_Pre(0);
                                sData_Reg0(1)   <= sData_Reg_Pre(1);
                                sData_Reg0(2)   <= sData_Reg_Pre(2);
                                sData_Reg0(3)   <= sData_Reg_Pre(3);
                                sData_Reg0(4)   <= sData_Reg_Pre(4);
                                sData_Reg0(5)   <= sData_Reg_Pre(5);
                                sData_Reg0(6)   <= sData_Reg_Pre(6);
                                sData_Reg0(7)   <= sData_Reg_Pre(7); 
                         end case;
                                
                        --�ڶ���
                        vEnable1	:= unsigned'(sEnable_Reg2(1)&sEnable_Reg3(1));
                        case vEnable1 is
                            when "11" => 
                                sCounter(1)     <= sCounter(0);
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(1);
                                sData_Reg1(2)   <= sData_Reg0(2);
                                sData_Reg1(3)   <= sData_Reg0(3);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                            when "01" =>
                                sCounter(1)     <= sCounter(0)-1;
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(0);
                                sData_Reg1(2)   <= sData_Reg0(1);
                                sData_Reg1(3)   <= sData_Reg0(3);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                            when "10" =>
                                sCounter(1)     <= sCounter(0)-1;
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(0);
                                sData_Reg1(2)   <= sData_Reg0(1);
                                sData_Reg1(3)   <= sData_Reg0(2);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                         	when others=>  
                                sCounter(1)     <= sCounter(0)-2;
                                sData_Reg1(0)   <= sData_Reg0(0);
                                sData_Reg1(1)   <= sData_Reg0(0);
                                sData_Reg1(2)   <= sData_Reg0(0);
                                sData_Reg1(3)   <= sData_Reg0(1);
                                sData_Reg1(4)   <= sData_Reg0(4);
                                sData_Reg1(5)   <= sData_Reg0(5);
                                sData_Reg1(6)   <= sData_Reg0(6);
                                sData_Reg1(7)   <= sData_Reg0(7);
                        end case;

                        --������
                        vEnable2	:= unsigned'(sEnable_Reg4(2)&sEnable_Reg5(2));
                        case vEnable2 is
                        	when "11" =>
                                sCounter(2)     <= sCounter(1);
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(1);
                                sData_Reg2(2)   <= sData_Reg1(2);
                                sData_Reg2(3)   <= sData_Reg1(3);
                                sData_Reg2(4)   <= sData_Reg1(4);
                                sData_Reg2(5)   <= sData_Reg1(5);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                            when "01" =>
                                sCounter(2)     <= sCounter(1)-1;
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(0);
                                sData_Reg2(2)   <= sData_Reg1(1);
                                sData_Reg2(3)   <= sData_Reg1(2);
                                sData_Reg2(4)   <= sData_Reg1(3);
                                sData_Reg2(5)   <= sData_Reg1(5);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                            when "10" =>
                                sCounter(2)     <= sCounter(1)-1;
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(0);
                                sData_Reg2(2)   <= sData_Reg1(1);
                                sData_Reg2(3)   <= sData_Reg1(2);
                                sData_Reg2(4)   <= sData_Reg1(3);
                                sData_Reg2(5)   <= sData_Reg1(4);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                         	when others =>
                                sCounter(2)     <= sCounter(1)-2;
                                sData_Reg2(0)   <= sData_Reg1(0);
                                sData_Reg2(1)   <= sData_Reg1(0);
                                sData_Reg2(2)   <= sData_Reg1(0);
                                sData_Reg2(3)   <= sData_Reg1(1);
                                sData_Reg2(4)   <= sData_Reg1(2);
                                sData_Reg2(5)   <= sData_Reg1(3);
                                sData_Reg2(6)   <= sData_Reg1(6);
                                sData_Reg2(7)   <= sData_Reg1(7);
                        end case;
                         
                        --���ļ�
                        vEnable3	:= unsigned'(sEnable_Reg6(3)&sEnable_Reg7(3));
                        case vEnable3 is
                        	when "11" => 
                                sCounter(3)     <= sCounter(2);
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(1);
                                sData_Reg3(2)   <= sData_Reg2(2);
                                sData_Reg3(3)   <= sData_Reg2(3);
                                sData_Reg3(4)   <= sData_Reg2(4);
                                sData_Reg3(5)   <= sData_Reg2(5);
                                sData_Reg3(6)   <= sData_Reg2(6);
                                sData_Reg3(7)   <= sData_Reg2(7);
                        	when "01" => 
                                sCounter(3)     <= sCounter(2)-1;
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(0);
                                sData_Reg3(2)   <= sData_Reg2(1);
                                sData_Reg3(3)   <= sData_Reg2(2);
                                sData_Reg3(4)   <= sData_Reg2(3);
                                sData_Reg3(5)   <= sData_Reg2(4);
                                sData_Reg3(6)   <= sData_Reg2(5);
                                sData_Reg3(7)   <= sData_Reg2(7);
                        	when "10" => 
                                sCounter(3)     <= sCounter(2)-1;
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(0);
                                sData_Reg3(2)   <= sData_Reg2(1);
                                sData_Reg3(3)   <= sData_Reg2(2);
                                sData_Reg3(4)   <= sData_Reg2(3);
                                sData_Reg3(5)   <= sData_Reg2(4);
                                sData_Reg3(6)   <= sData_Reg2(5);
                                sData_Reg3(7)   <= sData_Reg2(6);
                        	when others  => 
                                sCounter(3)     <= sCounter(2)-2;
                                sData_Reg3(0)   <= sData_Reg2(0);
                                sData_Reg3(1)   <= sData_Reg2(0);
                                sData_Reg3(2)   <= sData_Reg2(0);
                                sData_Reg3(3)   <= sData_Reg2(1);
                                sData_Reg3(4)   <= sData_Reg2(2);
                                sData_Reg3(5)   <= sData_Reg2(3);
                                sData_Reg3(6)   <= sData_Reg2(4);
                                sData_Reg3(7)   <= sData_Reg2(5);
                        end case;
                         
                        
                        --���弶
                        if sStartPoint >= 8 then
                                sDataOut0       <= sDataOutReg(7);
                                sDataOut1       <= sDataOutReg(6);
                                sDataOut2       <= sDataOutReg(5);
                                sDataOut3       <= sDataOutReg(4);
                                sDataOut4       <= sDataOutReg(3);
                                sDataOut5       <= sDataOutReg(2);
                                sDataOut6       <= sDataOutReg(1);
                                sDataOut7       <= sDataOutReg(0);
                                sEnableOut      <= true;
                                --for i in 8 to 15 loop
                                        --sDataOutReg(i-8)        <= sDataOutReg(i);
                                --end loop;
                                case sStartPoint is
                                        when 8 => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sData_Reg3(7-i);
                                                  end loop;
                                        when 9 => for i in 1 to 8 loop
                                                           sDataOutReg(i)       <= sData_Reg3(8-i);
                                                  end loop;
                                                  sDataOutReg(0)                <= sDataOutReg(8);
                                        when 10 => for i in 2 to 9 loop
                                                           sDataOutReg(i)       <= sData_Reg3(9-i);
                                                   end loop;
                                                   for i in 0 to 1 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                                   
                                        when 11 => for i in 3 to 10 loop
                                                           sDataOutReg(i)       <= sData_Reg3(10-i);
                                                   end loop;
                                                   for i in 0 to 2 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when 12 => for i in 4 to 11 loop
                                                           sDataOutReg(i)       <= sData_Reg3(11-i);
                                                   end loop;
                                                   for i in 0 to 3 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when 13 => for i in 5 to 12 loop
                                                           sDataOutReg(i)       <= sData_Reg3(12-i);
                                                   end loop;
                                                   for i in 0 to 4 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when 14 => for i in 6 to 13 loop
                                                           sDataOutReg(i)       <= sData_Reg3(13-i);
                                                   end loop;
                                                   for i in 0 to 5 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when 15 => for i in 7 to 14 loop
                                                           sDataOutReg(i)       <= sData_Reg3(14-i);
                                                   end loop;
                                                   for i in 0 to 6 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when 16 => for i in 8 to 15 loop
                                                           sDataOutReg(i)       <= sData_Reg3(15-i);
                                                   end loop;
                                                   for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(i+8);
                                                   end loop;
                                        when others => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(7-i);
                                                       end loop;
                                end case;
                                sStartPoint     <= sStartPoint - 8 + conv_integer(std_logic_vector(sCounter(3)));
                         else
                                sEnableOut      <= false;
                                case sStartPoint is
                                        when 0 => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sData_Reg3(7-i);
                                                       end loop;
                                        when 1 => for i in 1 to 8 loop
                                                           sDataOutReg(i)       <= sData_Reg3(8-i);
                                                       end loop;
                                        when 2 => for i in 2 to 9 loop
                                                           sDataOutReg(i)       <= sData_Reg3(9-i);
                                                       end loop;
                                        when 3 => for i in 3 to 10 loop
                                                           sDataOutReg(i)       <= sData_Reg3(10-i);
                                                       end loop;
                                        when 4 => for i in 4 to 11 loop
                                                           sDataOutReg(i)       <= sData_Reg3(11-i);
                                                       end loop;
                                        when 5 => for i in 5 to 12 loop
                                                           sDataOutReg(i)       <= sData_Reg3(12-i);
                                                       end loop;
                                        when 6 => for i in 6 to 13 loop
                                                           sDataOutReg(i)       <= sData_Reg3(13-i);
                                                       end loop;
                                        when 7 => for i in 7 to 14 loop
                                                           sDataOutReg(i)       <= sData_Reg3(14-i);
                                                       end loop;
                                        when others => for i in 0 to 7 loop
                                                           sDataOutReg(i)       <= sDataOutReg(7-i);
                                                       end loop;
                                 end case;
                                 sStartPoint    <= sStartPoint+conv_integer(std_logic_vector(sCounter(3)));
                         end if;
                        
                end if;
        end process;
                             

end rtl;