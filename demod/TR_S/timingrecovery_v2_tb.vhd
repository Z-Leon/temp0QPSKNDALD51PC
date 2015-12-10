LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;

use std.textio.all;
use IEEE.std_logic_textio.all;
 
ENTITY timingrecovery_v2_tb  IS 
  GENERIC (
    kvalidctrl  : natural   := 0 ;  
    kmusize  : positive   := 16 ;  
    kkpsize  : positive   := 3 ;  
    kinsize  : positive   := 8 ;  
    kmksize  : positive   := 2 ;  
    kkisize  : positive   := 3 ;  
    koutsize  : positive   := 8 ); 
END ; 
 
ARCHITECTURE timingrecovery_tb_arch OF timingrecovery_v2_tb IS
  SIGNAL areset   :  std_logic  ; 
  SIGNAL sdatardyic0_2   :  std_logic  ; 
  SIGNAL sdatavalid   :  std_logic  ; 
  SIGNAL smu   :  std_logic_vector (kmusize - 1 downto 0)  ; 
  SIGNAL samplingclk   :  std_logic  ; 
  SIGNAL repeat_flag   :  std_logic  ; 
  SIGNAL squadphaseout   :  std_logic_vector (koutsize - 1 downto 0)  ; 
  SIGNAL sinphaseout   :  std_logic_vector (koutsize - 1 downto 0)  ; 
  SIGNAL smk   :  std_logic_vector (kmksize - 1 downto 0)  ; 
  SIGNAL squadphase   :  std_logic_vector (kinsize - 1 downto 0)  ; 
  SIGNAL sinphase   :  std_logic_vector (kinsize - 1 downto 0)  ; 
  COMPONENT timingrecovery_v2  
    GENERIC ( 
      kvalidctrl  : natural ; 
      kmusize  : positive ; 
      kkpsize  : positive ; 
      kinsize  : positive ; 
      kmksize  : positive ; 
      kkisize  : positive ; 
      koutsize  : positive  );  
    PORT ( 
      areset  : in std_logic ; 
      sdatavalid  : out std_logic ; 
      smu  : out std_logic_vector (kmusize - 1 downto 0) ; 
      samplingclk  : in std_logic ; 
      squadphaseout  : out std_logic_vector (koutsize - 1 downto 0) ; 
      sinphaseout  : out std_logic_vector (koutsize - 1 downto 0) ; 
      --smk  : out std_logic_vector (kmksize - 1 downto 0) ; 
      squadphase  : in std_logic_vector (kinsize - 1 downto 0) ; 
      sinphase  : in std_logic_vector (kinsize - 1 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : timingrecovery_v2  
    GENERIC MAP ( 
      kvalidctrl  => kvalidctrl  ,
      kmusize  => kmusize  ,
      kkpsize  => kkpsize  ,
      kinsize  => kinsize  ,
      kmksize  => kmksize  ,
      kkisize  => kkisize  ,
      koutsize  => koutsize   )
    PORT MAP ( 
      areset   => areset  ,
      sdatavalid   => sdatavalid  ,
      smu   => smu  ,
      samplingclk   => samplingclk  ,
      squadphaseout   => squadphaseout  ,
      sinphaseout   => sinphaseout  ,
      --smk   => smk  ,
      squadphase   => squadphase  ,
      sinphase   => sinphase   ) ; 
      

		process
      begin
      loop
					SamplingClk <= '0';
					wait for 5 ns;
					SamplingClk <= '1';
					wait for 5 ns;		
					IF (NOW >= 400 us) THEN WAIT; END IF;
			end loop;
		end process;

aReset <= '0', '1' after 5 ns,'0' after 25 ns;

ReadData: process(aReset, SamplingClk)
           
--            file infile : text open read_mode is "D:\random_data_IandQ_4_0196.txt";
            
          -- file infile : text  is in "matlab\Data_matlab_gen.txt";
          file infile : text  is in "matlab\tr_in.txt";
            variable dl : line;
            variable InPhase, QuadPhase : integer;
            begin
            if aReset='1' then
              sInPhase          <= (others => '0');
              sQuadPhase        <= (others => '0');
            elsif rising_edge(SamplingClk) then
              if not endfile(infile) then
                readline(infile, dl);
                read(dl, InPhase);
                sInPhase <= std_logic_vector(to_signed(InPhase,kInSize));
                read(dl, QuadPhase);
                sQuadPhase <= std_logic_vector(to_signed(QuadPhase,kInSize));
              end if;
            end if;
          end process;
  
  
          -- record the timing recovered data to file
RecordRecoveredData:process (aReset,SamplingClk)
       --     file WriteFile : text open write_mode is "D:\result_6.txt";
       
            file WriteFile : text  is out  "matlab\tr_out.txt";
            variable DataLine : line;
            variable WriteData_I : integer;
            variable WriteData_Q : integer;
           
          begin
        --    if aReset='0' then
            --elsif rising_edge(SamplingClk) then
            if rising_edge(SamplingClk) then
                if sDataValid='1' then
    
                   WriteData_I := to_integer(signed(sInPhaseOut));
                   WriteData_Q := to_integer(signed(sQuadPhaseOut));
                   write(DataLine, WriteData_I,left ,8);
                   write(DataLine, WriteData_Q,right,3);
                   writeline(WriteFile, DataLine);
                end if;
            end if;
          end process;
END ; 

