-- 20151210
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use IEEE.std_logic_textio.all;

ENTITY MOD_QPSK_16QAM_rduc_tb  IS 
END ;

architecture rtl_tb of MOD_QPSK_16QAM_rduc_tb is

component MOD_QPSK_16QAM_rduc is
generic(kOutSize : positive := 14);
port(
		aReset : in std_logic;

		clk_25	: in std_logic;
		clk_50	: in std_logic;
		--clk_150	: in std_logic;

		ddio_clk : in std_logic;  -- 100MHz ?
		ddio_din : in std_logic_vector(3 downto 0) ;
		ddio_wren : in std_logic;
		d_src_is_GE : in std_logic;
		with_LDPC 	: in std_logic;
	
		d_out_shp_I0	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I1	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I2	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I3    : OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I4	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I5    : OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I6	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_I7    : OUT std_logic_vector(kOutSize - 1 downto 0);

		d_out_shp_Q0	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q1	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q2	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q3    : OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q4	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q5    : OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q6	: OUT std_logic_vector(kOutSize - 1 downto 0);
		d_out_shp_Q7    : OUT std_logic_vector(kOutSize - 1 downto 0)
		);
end component;

	constant kOutSize : integer := 14;
	signal aReset :  std_logic;
	signal clk_25	:  std_logic;
	signal clk_50	:  std_logic;
	--signal clk_150	:  std_logic;
	signal ddio_clk :  std_logic;  -- 100MHz ?
	signal ddio_din :  std_logic_vector(3 downto 0) ;
	signal ddio_wren :  std_logic;
	signal d_src_is_GE :  std_logic;
	signal with_LDPC 	:  std_logic;
	signal d_out_shp_I0	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I1	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I2	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I3    :  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I4	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I5    :  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I6	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_I7    :  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q0	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q1	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q2	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q3    :  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q4	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q5    :  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q6	:  std_logic_vector(kOutSize - 1 downto 0);
	signal d_out_shp_Q7    :  std_logic_vector(kOutSize - 1 downto 0);


begin

MOD_QPSK_16QAM_rduc_inst :  MOD_QPSK_16QAM_rduc 
generic map(kOutSize => 14)
port map(
		aReset 			=> aReset 	,
		clk_25			=> clk_25	,
		clk_50			=> clk_50	,
		ddio_clk 		=> ddio_clk ,
		ddio_din 		=> ddio_din ,
		ddio_wren 		=> ddio_wren ,
		d_src_is_GE 	=> '0' ,
		with_LDPC 		=> '1' ,
		d_out_shp_I0	=> d_out_shp_I0,
		d_out_shp_I1	=> d_out_shp_I1,
		d_out_shp_I2	=> d_out_shp_I2,
		d_out_shp_I3    => d_out_shp_I3,
		d_out_shp_I4	=> d_out_shp_I4,
		d_out_shp_I5    => d_out_shp_I5,
		d_out_shp_I6	=> d_out_shp_I6,
		d_out_shp_I7    => d_out_shp_I7,
		d_out_shp_Q0	=> d_out_shp_Q0,
		d_out_shp_Q1	=> d_out_shp_Q1,
		d_out_shp_Q2	=> d_out_shp_Q2,
		d_out_shp_Q3    => d_out_shp_Q3,
		d_out_shp_Q4	=> d_out_shp_Q4,
		d_out_shp_Q5    => d_out_shp_Q5,
		d_out_shp_Q6	=> d_out_shp_Q6,
		d_out_shp_Q7    => d_out_shp_Q7
		);

  process
  begin
    clk_25 <= '0';
    wait for 20 ns;
    clk_25 <= '1';
    wait for 20 ns;
  end process;

  process
  begin
    clk_50 <= '0';
    wait for 10 ns;
    clk_50 <= '1';
    wait for 10 ns;
  end process;

  process
  begin
    ddio_clk <= '0';
    wait for 5 ns;
    ddio_clk <= '1';
    wait for 5 ns;
  end process;

  ddio_din <= (others => '0');
  ddio_wren <= '0' ;

  aReset <= '0', '1' after 5 ns,'0' after 100 ns;


    RecordShpingData:process (aReset,clk_50)
       --     file WriteFile : text open write_mode is "D:\result_6.txt";
       
            file WriteFile : text  is out  "..\..\source\Matlab\Mod_out_p8.txt";
            variable DataLine : line;
            variable WriteData_I : integer;
            variable WriteData_Q : integer;
           
          begin
            if rising_edge(clk_50) then
                   WriteData_I := to_integer(signed(d_out_shp_I0));
                   WriteData_Q := to_integer(signed(d_out_shp_Q0));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I1));
                   WriteData_Q := to_integer(signed(d_out_shp_Q1));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I2));
                   WriteData_Q := to_integer(signed(d_out_shp_Q2));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I3));
                   WriteData_Q := to_integer(signed(d_out_shp_Q3));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I4));
                   WriteData_Q := to_integer(signed(d_out_shp_Q4));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I5));
                   WriteData_Q := to_integer(signed(d_out_shp_Q5));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I6));
                   WriteData_Q := to_integer(signed(d_out_shp_Q6));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   WriteData_I := to_integer(signed(d_out_shp_I7));
                   WriteData_Q := to_integer(signed(d_out_shp_Q7));
                   write(DataLine, WriteData_I,left,8);
                   write(DataLine, WriteData_Q,left,8);
                   writeline(WriteFile, DataLine);

                   --d_out_shp_I0
                   --d_out_shp_I1
                   --d_out_shp_I2
                   --d_out_shp_I3
                   --d_out_shp_I4
                   --d_out_shp_I5
                   --d_out_shp_I6
                   --d_out_shp_I7
                   --d_out_shp_Q0
                   --d_out_shp_Q1
                   --d_out_shp_Q2
                   --d_out_shp_Q3
                   --d_out_shp_Q4
                   --d_out_shp_Q5
                   --d_out_shp_Q6
                   --d_out_shp_Q7


            end if;
          end process;




end rtl_tb;