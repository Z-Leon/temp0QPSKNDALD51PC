
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
---------------------------------------------------
entity UpConvert is 
    generic (
      kInSize      : positive := 14;
      kOutSize     : positive := 14;
      kNCOSize	   : positive := 16
     );
    port (
      aReset            : in std_logic;   
      Clk               : in std_logic;   
      pInPhaseIn0       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn1       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn2       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn3       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn4       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn5       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn6       : in std_logic_vector (kInsize-1 downto 0);
		pInPhaseIn7       : in std_logic_vector (kInsize-1 downto 0);
		
      pQuadPhaseIn0     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn1     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn2     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn3     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn4     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn5     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn6     : in std_logic_vector (kInsize-1 downto 0);
		pQuadPhaseIn7     : in std_logic_vector (kInsize-1 downto 0);
		
      
	   IFData_0			: out std_logic_vector (kOutsize-1 downto 0);
	   IFData_1			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_2			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_3			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_4			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_5			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_6			: out std_logic_vector (kOutsize-1 downto 0);
		IFData_7			: out std_logic_vector (kOutsize-1 downto 0)
     );
end entity;

architecture rtl of UpConvert is   
-------------------------------------------------------
 component Mult 
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
 end component;
------------------------------------------------------
 component NCO_2 
	generic (    
	      kNCOSize  :  positive := 16;
	      kFreSize  :  positive := 11
	       );
	port(
	     Clk		:in std_logic;
	     aReset		: in std_logic;
	     DataValid		: in std_logic;
	     InitialPhase	: in unsigned(kFreSize-1 downto 0);
	     InPhase  		: in unsigned(kFreSize-1 downto 0);
	     I_fac    		: out std_logic_vector(kNCOSize-1 downto 0);
	     Q_fac    		: out std_logic_vector(kNCOSize-1 downto 0);
	     DataRdy  		: out std_logic
	     );
	end component;
-------------------------------------------------------	

component	NCO_200_1200_p8	is
	 generic(
		kDataWidth  : positive :=14 );
port(
		aReset	: in std_logic;
		pclk		: in std_logic;

		sin_p0		: out signed(kDataWidth-1 downto 0);
		sin_p1		: out signed(kDataWidth-1 downto 0);
		sin_p2		: out signed(kDataWidth-1 downto 0);
		sin_p3		: out signed(kDataWidth-1 downto 0);
		sin_p4		: out signed(kDataWidth-1 downto 0);
		sin_p5		: out signed(kDataWidth-1 downto 0);
		sin_p6		: out signed(kDataWidth-1 downto 0);
		sin_p7		: out signed(kDataWidth-1 downto 0);

		cos_p0		: out signed(kDataWidth-1 downto 0);
		cos_p1		: out signed(kDataWidth-1 downto 0);
		cos_p2		: out signed(kDataWidth-1 downto 0);
		cos_p3		: out signed(kDataWidth-1 downto 0);
		cos_p4		: out signed(kDataWidth-1 downto 0);
		cos_p5		: out signed(kDataWidth-1 downto 0);
		cos_p6		: out signed(kDataWidth-1 downto 0);
		cos_p7		: out signed(kDataWidth-1 downto 0)
		);
	end component;

	



----------------------------------------------------------  
-- signal InPhase_buffer , QuadPhase_buffer : std_logic_vector(kOutSize+kNCOSize-1 downto 0); 
 signal InPhase_buffer_0 , QuadPhase_buffer_0 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_1 , QuadPhase_buffer_1 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_2 , QuadPhase_buffer_2 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_3 , QuadPhase_buffer_3 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_4 , QuadPhase_buffer_4 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_5 , QuadPhase_buffer_5 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_6 , QuadPhase_buffer_6 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal InPhase_buffer_7 , QuadPhase_buffer_7 : std_logic_vector(kOutSize+1-1 downto 0); 
 signal  SinCurve_0, CosCurve_0,SinCurve_1, CosCurve_1  : std_logic_vector (15 downto 0);
 signal  SinCurve_2, CosCurve_2,SinCurve_3, CosCurve_3  : std_logic_vector (15 downto 0);
 signal  SinCurve_4, CosCurve_4,SinCurve_5, CosCurve_5  : std_logic_vector (15 downto 0);
 signal  SinCurve_6, CosCurve_6,SinCurve_7, CosCurve_7  : std_logic_vector (15 downto 0);
 signal InPhase_0 , QuadPhase_0,InPhase_1 , QuadPhase_1 : std_logic_vector(kOutSize+kNCOSize-1 downto 0); 
 signal InPhase_2 , QuadPhase_2,InPhase_3 , QuadPhase_3 : std_logic_vector(kOutSize+kNCOSize-1 downto 0); 
 signal InPhase_4 , QuadPhase_4,InPhase_5 , QuadPhase_5 : std_logic_vector(kOutSize+kNCOSize-1 downto 0); 
 signal InPhase_6 , QuadPhase_6,InPhase_7 , QuadPhase_7 : std_logic_vector(kOutSize+kNCOSize-1 downto 0); 
 signal IF_Signal_I1,IF_Signal_I2,IF_Signal_Q1,IF_Signal_Q2 : std_logic_vector(kInSize-1 downto 0);

 --signal IFSignal             : std_logic_vector (kOutsize+kNCOSize-1 downto 0);
 signal IFSignal_0            : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_0             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_1             : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_1             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_2            : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_2             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_3             : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_3             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_4            : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_4             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_5             : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_5             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_6            : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_6             : std_logic_vector (kOutsize-1 downto 0);
 signal IFSignal_7             : std_logic_vector (kOutsize+1-1 downto 0);
 signal IFSignal_tmp_7             : std_logic_vector (kOutsize-1 downto 0);
 

----------------------------------------------------------
 begin  
---------------------------------------------------------
 
--SinCurve_0 <= "0000000000000000";
--SinCurve_1 <= "0100000000000000";
--SinCurve_2 <= "0000000000000000";
--SinCurve_3 <= "1100000000000000";
--SinCurve_4 <= "0000000000000000";
--SinCurve_5 <= "0100000000000000";
--SinCurve_6 <= "0000000000000000";
--SinCurve_7 <= "1100000000000000";
--CosCurve_0 <= "0100000000000000";
--CosCurve_1 <= "0000000000000000";
--CosCurve_2 <= "1100000000000000";
--CosCurve_3 <= "0000000000000000";
--CosCurve_4 <= "0100000000000000";
--CosCurve_5 <= "0000000000000000";
--CosCurve_6 <= "1100000000000000";
--CosCurve_7 <= "0000000000000000";

inst_nco:	NCO_200_1200_p8	
generic map
	 (
		kDataWidth  =>16 
		)
port map(
		aReset	  => aReset     ,
		pclk		  => Clk        ,

		std_logic_vector(sin_p0)		=> SinCurve_0 ,
		std_logic_vector(sin_p1)		=> SinCurve_1 ,
		std_logic_vector(sin_p2)		=> SinCurve_2 ,
		std_logic_vector(sin_p3)		=> SinCurve_3 ,
		std_logic_vector(sin_p4)		=> SinCurve_4 ,
		std_logic_vector(sin_p5)		=> SinCurve_5 ,
		std_logic_vector(sin_p6)		=> SinCurve_6 ,
		std_logic_vector(sin_p7)		=> SinCurve_7 ,

		std_logic_vector(cos_p0)	=> CosCurve_0 ,
		std_logic_vector(cos_p1)	=> CosCurve_1 ,
		std_logic_vector(cos_p2)	=> CosCurve_2 ,
		std_logic_vector(cos_p3)	=> CosCurve_3 ,
		std_logic_vector(cos_p4)	=> CosCurve_4 ,
		std_logic_vector(cos_p5)	=> CosCurve_5 ,
		std_logic_vector(cos_p6)	=> CosCurve_6 ,
		std_logic_vector(cos_p7)	=> CosCurve_7 
		);

 
-- NCO_2_entity_0: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "00000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_0,
--	     Q_fac    		=> SinCurve_0,
--	     DataRdy  		=> open
--	     );
-- 
-- NCO_2_entity_1: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "01000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_1,
--	     Q_fac    		=> SinCurve_1,
--	     DataRdy  		=> open
--	     );
--	
--	NCO_2_entity_2: NCO_2
--	generic map (
--	   kNCOSize  =>  kNCOSize,
--	   kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "10000000000",
--	     InPhase  		=> "00000000000",   ---10000000000
--	     I_fac    		=> CosCurve_2,
--	     Q_fac    		=> SinCurve_2,
--	     DataRdy  		=> open
--	     );
--		  
--	NCO_2_entity_3: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "11000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_3,
--	     Q_fac    		=> SinCurve_3,
--	     DataRdy  		=> open
--	     );
--		  
--	NCO_2_entity_4: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "00000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_4,
--	     Q_fac    		=> SinCurve_4,
--	     DataRdy  		=> open
--	     );
--		  
--	NCO_2_entity_5: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "01000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_5,
--	     Q_fac    		=> SinCurve_5,
--	     DataRdy  		=> open
--	     );
--		  
--	NCO_2_entity_6: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "10000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_6,
--	     Q_fac    		=> SinCurve_6,
--	     DataRdy  		=> open
--	     );
--		  
--	NCO_2_entity_7: NCO_2
--	generic map (
--		kNCOSize  =>  kNCOSize,
--	    kFreSize   =>  11)
--	port map(
--	     Clk		=> clk,
--	     aReset		=> aReset,
--	     DataValid		=> '1',
--	     InitialPhase	=> "11000000000",
--	     InPhase  		=> "00000000000",    ---100000000
--	     I_fac    		=> CosCurve_7,
--	     Q_fac    		=> SinCurve_7,
--	     DataRdy  		=> open
--	     );
--------------------------------------------------

--------------------------------------------------
InPhaseMult_0: Mult
	port map(
		dataa		=> pInPhaseIn0,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_0,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_0    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_1: Mult
	port map(
		dataa		=> pInPhaseIn1,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_1,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_1    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_2: Mult
	port map(
		dataa		=> pInPhaseIn2,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_2,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_2    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_3: Mult
	port map(
		dataa		=> pInPhaseIn3,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_3,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_3    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_4: Mult
	port map(
		dataa		=> pInPhaseIn4,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_4,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_4    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_5: Mult
	port map(
		dataa		=> pInPhaseIn5,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_5,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_5    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_6: Mult
	port map(
		dataa		=> pInPhaseIn6,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_6,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_6    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
InPhaseMult_7: Mult
	port map(
		dataa		=> pInPhaseIn7,  --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> CosCurve_7,  --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		  --: IN STD_LOGIC ;
		result		=> InPhase_7    --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);


QuadPhaseMult_0: Mult
	port map(
		dataa		=> pQuadPhaseIn0, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_0, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_0 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_1: Mult
	port map(
		dataa		=> pQuadPhaseIn1, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_1, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_1 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_2: Mult
	port map(
		dataa		=> pQuadPhaseIn2, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_2, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_2 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_3: Mult
	port map(
		dataa		=> pQuadPhaseIn3, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_3, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_3 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_4: Mult
	port map(
		dataa		=> pQuadPhaseIn4, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_4, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_4 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);

QuadPhaseMult_5: Mult
	port map(
		dataa		=> pQuadPhaseIn5, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_5, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_5 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_6: Mult
	port map(
		dataa		=> pQuadPhaseIn6, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_6, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_6 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);
	
QuadPhaseMult_7: Mult
	port map(
		dataa		=> pQuadPhaseIn7, --: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		=> SinCurve_7, --: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		=> clk,		 --: IN STD_LOGIC ;
		result		=> QuadPhase_7 --: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
	);

 ------------------------------------

--------------------------- Output ----------------
 InPhase_buffer_0 <= InPhase_0( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_1 <= InPhase_1( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17); --3 17
 InPhase_buffer_2 <= InPhase_2( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_3 <= InPhase_3( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_4 <= InPhase_4( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_5 <= InPhase_5( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_6 <= InPhase_6( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 InPhase_buffer_7 <= InPhase_7( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_0 <= QuadPhase_0( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_1 <= QuadPhase_1( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_2 <= QuadPhase_2( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_3 <= QuadPhase_3( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_4 <= QuadPhase_4( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_5 <= QuadPhase_5( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_6 <= QuadPhase_6( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
 QuadPhase_buffer_7 <= QuadPhase_7( kOutSize+kNCOSize-3 downto kOutSize+kNCOSize-17);
--viterbi
-- InPhase_buffer_1 <= InPhase_1( kOutSize+kNCOSize-3+1 downto kOutSize+kNCOSize-17+1);
-- InPhase_buffer_2 <= InPhase_2( kOutSize+kNCOSize-3+1 downto kOutSize+kNCOSize-17+1);
-- QuadPhase_buffer_1 <= QuadPhase_1( kOutSize+kNCOSize-3+1 downto kOutSize+kNCOSize-17+1);
-- QuadPhase_buffer_2 <= QuadPhase_2( kOutSize+kNCOSize-3+1 downto kOutSize+kNCOSize-17+1);

 
 process (clk,aReset)  
  begin
    if(aReset  = '1') then       
      	 IFSignal_0 <= (others => '0');
	     IFSignal_tmp_0 <= (others => '0');
		 IFData_0 <= (others => '0');
	 
         IFSignal_1 <= (others => '0');
	     IFSignal_tmp_1 <= (others => '0');
		 IFData_1 <= (others => '0');
		 
		   IFSignal_2 <= (others => '0');
	     IFSignal_tmp_2 <= (others => '0');
		 IFData_2 <= (others => '0');
		 
		   IFSignal_3 <= (others => '0');
	     IFSignal_tmp_3 <= (others => '0');
		 IFData_3 <= (others => '0');
		 
		   IFSignal_4 <= (others => '0');
	     IFSignal_tmp_4 <= (others => '0');
		 IFData_4 <= (others => '0');
		 
		 IFSignal_5 <= (others => '0');
	     IFSignal_tmp_5 <= (others => '0');
		 IFData_5 <= (others => '0');
		 
		 IFSignal_6 <= (others => '0');
	     IFSignal_tmp_6 <= (others => '0');
		 IFData_6 <= (others => '0');
		 
		 IFSignal_7 <= (others => '0');
	     IFSignal_tmp_7 <= (others => '0');
		 IFData_7 <= (others => '0');
    elsif rising_edge(clk) then
		IFSignal_0		<= signed(InPhase_buffer_0)-signed(QuadPhase_buffer_0);
		IFSignal_tmp_0    <= IFSignal_0(kInSize+1-1 downto 1);
		
		IFSignal_1		<= signed(InPhase_buffer_1)-signed(QuadPhase_buffer_1);
		IFSignal_tmp_1    <= IFSignal_1(kInSize+1-1 downto 1);
		
		IFSignal_2		<= signed(InPhase_buffer_2)-signed(QuadPhase_buffer_2);
		IFSignal_tmp_2    <= IFSignal_2(kInSize+1-1 downto 1);
		
		IFSignal_3		<= signed(InPhase_buffer_3)-signed(QuadPhase_buffer_3);
		IFSignal_tmp_3    <= IFSignal_3(kInSize+1-1 downto 1);
		
		IFSignal_4		<= signed(InPhase_buffer_4)-signed(QuadPhase_buffer_4);
		IFSignal_tmp_4    <= IFSignal_4(kInSize+1-1 downto 1);
		
		IFSignal_5		<= signed(InPhase_buffer_5)-signed(QuadPhase_buffer_5);
		IFSignal_tmp_5    <= IFSignal_5(kInSize+1-1 downto 1);
		
		IFSignal_6		<= signed(InPhase_buffer_6)-signed(QuadPhase_buffer_6);
		IFSignal_tmp_6    <= IFSignal_6(kInSize+1-1 downto 1);
		
		IFSignal_7		<= signed(InPhase_buffer_7)-signed(QuadPhase_buffer_7);
		IFSignal_tmp_7    <= IFSignal_7(kInSize+1-1 downto 1);
		--IFData_1          <= not(IFSignal_tmp_1(13)) & IFSignal_tmp_1(12 downto 0);
		
		IFData_0          <= (IFSignal_tmp_0(13)) & IFSignal_tmp_0(12 downto 0);
		IFData_1          <= (IFSignal_tmp_1(13)) & IFSignal_tmp_1(12 downto 0);
		IFData_2          <= (IFSignal_tmp_2(13)) & IFSignal_tmp_2(12 downto 0);
		IFData_3          <= (IFSignal_tmp_3(13)) & IFSignal_tmp_3(12 downto 0);
		IFData_4          <= (IFSignal_tmp_4(13)) & IFSignal_tmp_4(12 downto 0);
		IFData_5          <= (IFSignal_tmp_5(13)) & IFSignal_tmp_5(12 downto 0);
		IFData_6          <= (IFSignal_tmp_6(13)) & IFSignal_tmp_6(12 downto 0);
		IFData_7          <= (IFSignal_tmp_7(13)) & IFSignal_tmp_7(12 downto 0);

     end if;
  end  process; 
end rtl;

