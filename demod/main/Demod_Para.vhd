--*********************************************************************************

--author	: JL
--date		: 2011.10.28
--purpose	:
--            the top-level file of Demodulator with parellel algorithm.
--*********************************************************************************
--version	: V1.0
--*********************************************************************************
--Modified  : 2015-01 for PingLiuCeng Proj
--*********************************************************************************


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	Demod_Para	is
generic	(
			kInSize  : positive :=12
		);
port	(
		aReset          : in  std_logic; 
		clk_100         : in  std_logic;
		pclk_I			: in  std_logic;  -- 50MHz
		rclk           : in std_logic ; --75MHZ
		rclk_half		: in std_logic; -- 37.5MHz
		
		AD_d0			: in std_logic_vector(kInSize-1 downto 0);
		AD_d1			: in std_logic_vector(kInSize-1 downto 0);
		AD_d2			: in std_logic_vector(kInSize-1 downto 0);
		AD_d3           : in std_logic_vector(kInSize-1 downto 0);
		AD_d4			: in std_logic_vector(kInSize-1 downto 0);
		AD_d5           : in std_logic_vector(kInSize-1 downto 0);
		AD_d6           : in std_logic_vector(kInSize-1 downto 0);
		AD_d7           : in std_logic_vector(kInSize-1 downto 0);

		with_LDPC		: in std_logic;
		
		--err_test 	: out std_logic;
		--d_toFPGA2	 : out std_logic_vector(5 downto 0)
		dat_mux : out std_logic_vector(3 downto 0) ;
		val_mux : out std_logic
		
		);
end	Demod_Para;
architecture rtl of	Demod_Para	is 

	--------------------------component declare(start)------------------------

 	--carrier recovery
	component Carrierrecovery_P2 is 
	  generic(kDataWidth  : positive := 8;
		  kErrWidth   :positive  :=12;
		  kSinWidth   : positive :=16);
	  port(               
		aReset            : in std_logic;
		Clk               : in std_logic;
						
		-- Input data from timing recovery module
		sEnableIn         : in std_logic;
		sInPhase0         : in std_logic_vector(kDataWidth-1 downto 0);
		sInPhase1         : in std_logic_vector(kDataWidth-1 downto 0);
		sQuadPhase0       : in std_logic_vector(kDataWidth-1 downto 0);
		sQuadPhase1       : in std_logic_vector(kDataWidth-1 downto 0);
		
		-- Loop status signal, when '1' locked, otherwise not locked
		--sLockSign         : out std_logic;
		
		-- output data ready signal and data
		sEnableOut        : out std_logic;
		sInPhaseOut0      : out std_logic_vector(kDataWidth-1 downto 0);
		sInPhaseOut1      : out std_logic_vector(kDataWidth-1 downto 0);
		sQuadPhaseOut0    : out std_logic_vector(kDataWidth-1 downto 0);
		sQuadPhaseOut1    : out std_logic_vector(kDataWidth-1 downto 0));
	end component;
	
	component PN_ERR_Detect IS
		 PORT
		(
		   aReset	:		IN std_logic;
		   ClockIn:  	IN  STD_LOGIC;
		   Enable	: 	In	std_logic; 
		   DataIn	:  	IN  STD_LOGIC; 
		   SyncFlag:  Out  STD_LOGIC;
		   Error    : out std_logic;
		   ErrResult: Out  STD_LOGIC_VECTOR(31 DOWNTO 0) 
			);
	END component;
	
	
	component TimerecoveryP8_v2 is
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
	end   component;  
			
	
	component Diff_Decoder_P2 is 
    port (
      aReset          : in  std_logic; 
      clk             : in  std_logic;
      datain_i        : in  std_logic_vector(1 downto 0);
      datain_q        : in  std_logic_vector(1 downto 0);
      datain_valid    : in  std_logic;
      
      dataout_i       : out  std_logic_vector(1 downto 0);
      dataout_q       : out  std_logic_vector(1 downto 0);
      dataout_valid   : out  std_logic        
     );
	end component;
	
	
	component fifo_4_2 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdusedw		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
	END component;
	
	
	component DownConvert is 
    generic (
      kInSize      : positive := 12;
      kOutSize     : positive := 12;
      kNCOSize	   : positive := 16
     );
    port (
		--mode : in std_logic_vector(1 downto 0);
      aReset            : in std_logic;   
      clk               : in std_logic; 
      AD_sample0        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample1        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample2        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample3        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample4        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample5        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample6        : in std_logic_vector (kInsize-1 downto 0);
	  AD_sample7        : in std_logic_vector (kInsize-1 downto 0);
		
	  InPhase0			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase1			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase2			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase3			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase4			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase5			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase6			: out std_logic_vector (kOutsize-1 downto 0);
	  InPhase7			: out std_logic_vector (kOutsize-1 downto 0);
	  
	  QuadPhase0		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase1		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase2		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase3		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase4		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase5		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase6		: out std_logic_vector (kOutsize-1 downto 0);
	  QuadPhase7		: out std_logic_vector (kOutsize-1 downto 0)
     );
end component;

component	LPF_P8_D2	is
	 generic(
		kInSize  : positive :=12;
		kOutSize : positive :=8);
port(
		aReset	: in std_logic;
		Clk		: in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kOutSize-1 downto 0);
		cDout1	: out std_logic_vector(kOutSize-1 downto 0);
		cDout2	: out std_logic_vector(kOutSize-1 downto 0);
		cDout3	: out std_logic_vector(kOutSize-1 downto 0)
		);
end	component;

component	P4toP8_8	is
	 generic(
		kDataWidth  : positive :=8 );
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in1		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in2		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in3		: in std_logic_vector(kDataWidth-1 downto 0);
		data_in4		: in std_logic_vector(kDataWidth-1 downto 0);
		valid_in	: in std_logic;

		data_out1		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out2		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out3		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out4		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out5		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out6		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out7		: out std_logic_vector(kDataWidth-1 downto 0);
		data_out8		: out std_logic_vector(kDataWidth-1 downto 0);
		valid_out	: out std_logic
		);
end	component;

component	shapingfilter_p8	is
	 generic(
		kInSize  : positive :=8;
		kOutSize : positive :=8);
port(
		aReset	: in std_logic;
		Clk		: in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kOutSize-1 downto 0);
		cDout1	: out std_logic_vector(kOutSize-1 downto 0);
		cDout2	: out std_logic_vector(kOutSize-1 downto 0);
		cDout3	: out std_logic_vector(kOutSize-1 downto 0);
		cDout4	: out std_logic_vector(kOutSize-1 downto 0);
		cDout5	: out std_logic_vector(kOutSize-1 downto 0);
		cDout6	: out std_logic_vector(kOutSize-1 downto 0);
		cDout7	: out std_logic_vector(kOutSize-1 downto 0)
		);
end	component;

--component ddio_toF2 IS
--	PORT
--	(
--		aclr		: IN STD_LOGIC ;
--		datain_h		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
--		datain_l		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
--		outclock		: IN STD_LOGIC ;
--		dataout		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
--	);
--END component;

component equ_lms is
port( clk,rst_n,en_in:in std_logic;
		jietiaofangshi : in std_logic_vector(3 downto 0);
      I0_in,Q0_in,I1_in,Q1_in:in std_logic_vector(7 downto 0);
      I0_out,Q0_out,I1_out,Q1_out:out std_logic_vector(7 downto 0);
      en_out:out std_logic
      );
end component;

component demapping_select_CCSDS_soft is   --(3)wei yingpanjuezhi    (2 downto 0) jueduizhi
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		demapping_Mode	: in std_logic;
		datain_i0	: in std_logic_vector(7 downto 0);
		datain_i1	: in std_logic_vector(7 downto 0);
		datain_q0	: in std_logic_vector(7 downto 0);
		datain_q1	: in std_logic_vector(7 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(3 downto 0);
		dataout_i1       : out  std_logic_vector(3 downto 0);
		dataout_q0       : out  std_logic_vector(3 downto 0);
		dataout_q1       : out  std_logic_vector(3 downto 0);
		dataout_valid   : out  std_logic 
	);
end component;

component Decoder_Diff_soft_QPSK is
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		Decode_Mode	: in std_logic_vector(2 downto 0);
		datain_i0	: in std_logic_vector(3 downto 0);
		datain_i1	: in std_logic_vector(3 downto 0);
		datain_q0	: in std_logic_vector(3 downto 0);
		datain_q1	: in std_logic_vector(3 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(3 downto 0);
		dataout_i1       : out  std_logic_vector(3 downto 0);
		dataout_q0       : out  std_logic_vector(3 downto 0);
		dataout_q1       : out  std_logic_vector(3 downto 0);
		dataout_valid   : out  std_logic 
	);
end component;

component data_4to8 is
port(
		aReset : in std_logic;
		clk : in std_logic;
		clkout : in std_logic;
		data_in0 : in std_logic_vector(3 downto 0);
		data_in1 : in std_logic_vector(3 downto 0);
		data_in2 : in std_logic_vector(3 downto 0);
		data_in3 : in std_logic_vector(3 downto 0);
		valid : in std_logic;
		
		data_out0 : out std_logic_vector(3 downto 0);
		data_out1 : out std_logic_vector(3 downto 0);
		data_out2 : out std_logic_vector(3 downto 0);
		data_out3 : out std_logic_vector(3 downto 0);
		data_out4 : out std_logic_vector(3 downto 0);
		data_out5 : out std_logic_vector(3 downto 0);
		data_out6 : out std_logic_vector(3 downto 0);
		data_out7 : out std_logic_vector(3 downto 0);
		validout : out std_logic);
end component;

component	phase_frame_p	 is         
port(
	 clk       : in std_logic;
	 reset     : in std_logic;
	 
	 data_in    : in std_logic_vector(32 downto 1);
	 data_in_val: in std_logic;
	 c_asm : in std_logic_vector(32 downto 1);
	 i_framelengthsub1: in std_logic_vector(10 downto 1);
	 
	 dataout    : out std_logic_vector(32 downto 1);
	 o_sop      : out std_logic;  
    o_val      : out std_logic;  
    o_eop      : out std_logic;  
    o_state    : out std_logic_vector(3 downto 1)
     );	 
end	component;

component P8toP8_LDPC is
port(
		aReset : in std_logic;
		clkin : in std_logic;
		clkout : in std_logic;
		i_data : in std_logic_vector(31 downto 0);
		i_sop  : in std_logic;
		i_valid: in std_logic;
		i_eop  : in std_logic;
		
		o_data : out std_logic_vector(31 downto 0);
      o_valid : out std_logic;
      o_sop  : out std_logic;
      o_eop  : out std_logic
);
end component;

component	ldpc_decoder	 is         
port(
	 clk        :in std_logic;
	 reset      :in std_logic;
	 
	 ldpc_in    :in std_logic_vector(31 downto 0);
	 i_val      :in std_logic;
	 i_sop      :in std_logic;
	 i_eop      :in std_logic;
	 
	 ldpc_out   :out std_logic_vector(7 downto 0); 
	 o_val      :out std_logic;
	 o_sop      :out std_logic;
	 o_eop      :out std_logic;
	 decode_succeed:out std_logic
	 );	 
end	component;

component cnst_dmp IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component cnst_rst IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component cnst_muxCrEql IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;
	

component phase_rotate_QPSK is   
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		phase_set	: in std_logic_vector(1 downto 0) ;
		datain_i0	: in std_logic_vector(7 downto 0);
		datain_i1	: in std_logic_vector(7 downto 0);
		datain_q0	: in std_logic_vector(7 downto 0);
		datain_q1	: in std_logic_vector(7 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(7 downto 0);
		dataout_i1       : out  std_logic_vector(7 downto 0);
		dataout_q0       : out  std_logic_vector(7 downto 0);
		dataout_q1       : out  std_logic_vector(7 downto 0);
		dataout_valid   : out  std_logic 
	);
end component;
component cnst_phase_rotate IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
END component;	

component Demod_preCR is
	generic(
		kInSize : positive := 8;
		kDataWidth : positive := 8 );
	port (
		aReset          : in  std_logic; 
		clk_100         : in  std_logic;
		pclk_I			: in  std_logic;  -- 50MHz
		rclk           : in std_logic ; --75MHZ
		rclk_half		: in std_logic; -- 37.5MHz
		
		AD_d0			: in std_logic_vector(kInSize-1 downto 0);
		AD_d1			: in std_logic_vector(kInSize-1 downto 0);
		AD_d2			: in std_logic_vector(kInSize-1 downto 0);
		AD_d3           : in std_logic_vector(kInSize-1 downto 0);
		AD_d4			: in std_logic_vector(kInSize-1 downto 0);
		AD_d5           : in std_logic_vector(kInSize-1 downto 0);
		AD_d6           : in std_logic_vector(kInSize-1 downto 0);
		AD_d7           : in std_logic_vector(kInSize-1 downto 0);

		sInPhaseOut0      : out signed(kDataWidth-1 downto 0);
        sInPhaseOut1      : out signed(kDataWidth-1 downto 0);
        sInPhaseOut2      : out signed(kDataWidth-1 downto 0);
        sInPhaseOut3      : out signed(kDataWidth-1 downto 0);
        sQuadPhaseOut0    : out signed(kDataWidth-1 downto 0);
        sQuadPhaseOut1    : out signed(kDataWidth-1 downto 0);
        sQuadPhaseOut2    : out signed(kDataWidth-1 downto 0);
        sQuadPhaseOut3    : out signed(kDataWidth-1 downto 0);
        sEnableOut        : out std_logic

     );
end component;



component fifo_ldpcout_8to4 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
END component;

component Packet_head_seeker is
generic (n_parellel : positive := 8;  -- num of parellel branches
		 n_bit : positive := 4   -- num of bits of every data
	);
  port (
  	aReset	: in std_logic;
  	clk		: in std_logic;
  	d_in	: in std_logic_vector(31 downto 0) ;
  	val_in	: in std_logic;

  	d_out	: out std_logic_vector(31 downto 0) ;
  	val_out		: out std_logic;
  	sop_out		: out std_logic;
  	eop_out		: out std_logic
  ) ;
end component ;


	--------------------------component declare(end)--------------------------

	--************************************************************************
	
	--------------------------signal define(start)----------------------------
	-- Clock
	--signal pclk_I, pclk_Q : std_logic;
	-- Reset
	--signal aReset, aReset_pclk_I, aReset_pclk_I_reg 	: std_logic;
	-- reset signal for 2 ADC chips
	signal  Dclk_rst : std_logic;
	
	type InputDataArray is array (natural range  <>) of std_logic_vector(kInSize-1 downto 0);
	type InputDataArray_8 is array (natural range  <>) of std_logic_vector(8-1 downto 0);
	--type InputData_SignedArray is array (natural range  <>) of signed(kInSize-1 downto 0);

	--signal for Input Stage
	signal AD_I_datain, AD_Q_datain : std_logic_vector(4*kInSize-1 downto 0);
	signal AD_I_LVDS, AD_Q_LVDS, AD_I_t, AD_Q_t: std_logic_vector(8*kInSize-1 downto 0);
	--signal AD_I, AD_Q: InputDataArray (7 downto 0);
	
	--signal for Down Convert
	signal DownCvrt_out_I, DownCvrt_out_Q : InputDataArray(7 downto 0);

	--signal for samplerate,decratefraction and redecratefraction
	type SampleRateArray is array (natural range <>) of std_logic_vector(19 downto 0);
	type DecRateFractionArray is array (natural range <>) of std_logic_vector(12 downto 0);
	
	signal SampleRate,SampleRate0,SampleRate1			: std_logic_vector(19 downto 0);--SampleRateArray(0 downto 0);
	signal DecRateFraction, DecRateFraction0,DecRateFraction1 	: std_logic_vector(12 downto 0);--DecRateFractionArray(0 downto 0);    --	
	signal ReDecRateFraction, ReDecRateFraction0,ReDecRateFraction1	: std_logic_vector(12 downto 0);--DecRateFractionArray(0 downto 0); --
	
	--signal  Dec_Int_out_I, Dec_Int_out_Q, Dec_Frac_out_I, Dec_Frac_out_Q :  InputData_SignedArray( 7 downto 0);         
	--signal  Enable_Dec_Int_out_I, Enable_Dec_Int_out_Q, Enable_Dec_Frac_out_I, Enable_Dec_Frac_out_Q : std_logic;
	
	signal  Init_data : std_logic_vector( 127 downto 0);
	
	--signal for TR
	signal TR_in_I, TR_in_Q     : InputDataArray_8(7 downto 0);
	signal TR_in_I_s, TR_in_Q_s : InputDataArray_8(7 downto 0);		
	signal TR_in_I_p4, TR_in_Q_p4 : InputDataArray_8(3 downto 0);
	signal TR_out_I, TR_out_Q : InputDataArray_8(3 downto 0);
	signal TR_out_enable , TR_in_enable : std_logic;

	--signal for FIFO between TR and CR
	--signal fifo_in_TR : std_logic_vector(8*kInSize-1 downto 0);
	--signal fifo_out_CR : std_logic_vector(4*kInSize-1 downto 0);
	signal fifo_in_TR : std_logic_vector(8*8-1 downto 0);
	signal fifo_out_CR : std_logic_vector(4*8-1 downto 0);

	signal rdreq_CR , wrfull_TR: std_logic;
	signal rdusedw_CR	: std_logic_vector(4 downto 0);
	
	--signal for CR
	signal CR_in_I, CR_in_Q, CR_out_I, CR_out_Q : InputDataArray_8(1 downto 0);
	signal CR_in_enable, CR_out_enable : std_logic;
	
	--signal for Equ
	signal Equ_out_I, Equ_out_Q : InputDataArray_8(1 downto 0);
	signal Equ_out_enable : std_logic;
	
	--signal for differential decode module output
	signal cDataIn_DiffDec, cDataQuad_DiffDec : std_logic_vector(1 downto 0);
	signal cEnable_DiffDec : std_logic;
	
	signal GE_RxClk_Inverse : std_logic;
	signal ff_rx_clk, Clk50M : std_logic;
	signal GE_ctrl_valid, GE_ctrl_sop, GE_ctrl_eop : std_logic;
	signal GE_ctrl_data : std_logic_vector( 31 downto 0 );
	signal aReset_GE : std_logic;
	-- signal for PN23 Error Detect
	
	signal Demapping_soft_QPSK_I0: std_logic_vector( 3 downto 0 );
	signal Demapping_soft_QPSK_I1: std_logic_vector( 3 downto 0 );
	signal Demapping_soft_QPSK_Q0: std_logic_vector( 3 downto 0 );
	signal Demapping_soft_QPSK_Q1: std_logic_vector( 3 downto 0 );
	signal Demapping_soft_QPSK_valid: std_logic;
			signal Decoder_soft_QPSK_I0   :   std_logic_vector(3 downto 0);
		signal Decoder_soft_QPSK_I1   :   std_logic_vector(3 downto 0);
		signal Decoder_soft_QPSK_Q0   :   std_logic_vector(3 downto 0);
		signal Decoder_soft_QPSK_Q1   :   std_logic_vector(3 downto 0);
		signal Decoder_soft_QPSK_valid   :   std_logic ;
		signal RSin_data0 :  std_logic_vector(3 downto 0);
		signal RSin_data1 :  std_logic_vector(3 downto 0);
		signal RSin_data2 :  std_logic_vector(3 downto 0);
		signal RSin_data3 :  std_logic_vector(3 downto 0);
		signal RSin_data4 :  std_logic_vector(3 downto 0);
		signal RSin_data5 :  std_logic_vector(3 downto 0);
		signal RSin_data6 :  std_logic_vector(3 downto 0);
		signal RSin_data7 :  std_logic_vector(3 downto 0);
		signal RSin_valid :  std_logic;
			signal dataout_frame    :  std_logic_vector(32 downto 1);
	signal sop_frame    :  std_logic;  
    signal val_frame    :  std_logic;  
    signal eop_frame    :  std_logic;
	 signal data_decode_in :  std_logic_vector(31 downto 0);
      signal val_decode_in :  std_logic;
      signal sop_decode_in :  std_logic;
      signal eop_decode_in :  std_logic;
			 signal decode_out   : std_logic_vector(7 downto 0); 
	 signal decode_out_val   : std_logic;
	 signal decode_out_sop   : std_logic;
	 signal decode_out_eop   : std_logic; 
	 signal demapping_Mode_0 : std_LOGIC;
	 signal CR_rst : std_logic;
--		signal cnt_ldpc_sop : integer range 0 to 16383 :=0;
--		attribute preserve: boolean;
--		attribute preserve of cnt_ldpc_sop: signal is true;
	signal CREqu_out_I, CREqu_out_Q : InputDataArray_8(1 downto 0);
	signal mux_cr_equ_b , CREqu_out_enable: std_logic;

	signal CREqu_out_t_I,CREqu_out_t_Q : InputDataArray_8(1 downto 0);
	signal CREqu_out_t_enable : std_logic;	
	signal cnst_phase_set : std_logic_vector(1 downto 0) ;

	signal wrfull_ldpcout, rdreq_ldpcout : std_logic;
	signal rdusedw_ldpcout : std_logic_vector(11 downto 0) ;
	signal dat_ldpc_out : std_logic_vector(3 downto 0) ;
	signal val_ldpc_out : std_logic;
	--signal dat_mux : std_logic_vector(3 downto 0) ;
	--signal val_mux : std_logic;
		signal decode_out_t, decode_out_descrm: std_logic_vector(7 downto 0) ;
    signal decode_out_val_t, decode_out_val_descrm : std_logic;
    signal pn23 : std_logic_vector(23 downto 0) ;

signal phase_change, rst_equ : std_logic;
	signal phase_change_d : std_logic_vector(2 downto 0) ;

    signal dataout_frame_1    :  std_logic_vector(32 downto 1);
	signal sop_frame_1    :  std_logic;  
    signal val_frame_1    :  std_logic;  
    signal eop_frame_1    :  std_logic;
    signal dataout_frame_2    :  std_logic_vector(32 downto 1);
	signal sop_frame_2    :  std_logic;  
    signal val_frame_2    :  std_logic;  
    signal eop_frame_2    :  std_logic;

    signal comb_cr_rst : std_logic;
	signal comb_diffdcd_i, comb_diffdcd_q : std_logic_vector(1 downto 0) ;
	signal comb_headseek : std_logic_vector(31 downto 0) ;
	signal comb_aclrff8to4 : std_logic;
	--------------------------signal define(end)------------------------------
begin	
	
	Demod_preCR_inst:  Demod_preCR
	generic map(
		kInSize => 8,
		kDataWidth => 8  )
	port map(
		aReset          => aReset,    
		clk_100         => clk_100,  
		pclk_I			=> pclk_I,
		rclk           	=> rclk,   
		rclk_half		=> rclk_half,
		
		AD_d0			=> AD_d0,
		AD_d1			=> AD_d1,
		AD_d2			=> AD_d2,
		AD_d3           => AD_d3,
		AD_d4			=> AD_d4,
		AD_d5           => AD_d5,
		AD_d6           => AD_d6,
		AD_d7           => AD_d7,

		std_logic_vector(sInPhaseOut0)      => TR_out_I(0),
        std_logic_vector(sInPhaseOut1)      => TR_out_I(1),
        std_logic_vector(sInPhaseOut2)      => TR_out_I(2),
        std_logic_vector(sInPhaseOut3)      => TR_out_I(3),
        std_logic_vector(sQuadPhaseOut0)    => TR_out_Q(0),
        std_logic_vector(sQuadPhaseOut1)    => TR_out_Q(1),
        std_logic_vector(sQuadPhaseOut2)    => TR_out_Q(2),
        std_logic_vector(sQuadPhaseOut3)    => TR_out_Q(3),
        sEnableOut        => TR_out_enable

     );
				
		 
--	----------------------Timer recovery with parallel Gardner algorithm-------------------------start
				 
--	----------------------Timer recovery with parallel Gardner algorithm-------------------------end
	
	fifo_in_TR <= TR_out_Q(3)&TR_out_Q(2)&TR_out_I(3)&TR_out_I(2)&TR_out_Q(1)&TR_out_Q(0)&TR_out_I(1)&TR_out_I(0);
	fifo_4_2_inst: fifo_4_2 
	PORT map
	(
		aclr		=> aReset, -- 		
		data		=> fifo_in_TR,
		rdclk		=> rclk,
		rdreq		=> rdreq_CR,
		wrclk		=> pclk_I,
		wrreq		=> TR_out_enable,
		q		   => fifo_out_CR,
		rdusedw		=> rdusedw_CR,
		wrfull		=> open 
	);
	process(aReset, rclk)
	begin
		if aReset = '1' then
			rdreq_CR <= '0';
			CR_in_enable <= '0';
		elsif rising_edge(rclk) then
			if rdusedw_CR(4 downto 3)="00" then
				rdreq_CR <= '0';
			else
				rdreq_CR <= '1';
			end if;
			CR_in_enable <= rdreq_CR;
		end if;
	end process;
	
	CR_in_I(0) <= fifo_out_CR(7 downto 0);
	CR_in_I(1) <= fifo_out_CR(15 downto 8);
	CR_in_Q(0) <= fifo_out_CR(23 downto 16);
	CR_in_Q(1) <= fifo_out_CR(31 downto 24);
	
--	cnst_rst_inst: cnst_rst 
--	PORT map
--	(
--		result(0)		=> CR_rst
--	);

--	---------------Carrier recovery with parallel structure --------start
	comb_cr_rst <= (aReset or rst_equ);
	Entity_CR: Carrierrecovery_P2  
	  generic map(8,12,16)
	  port map(               
		aReset            => comb_cr_rst, --(aReset or rst_equ),
		Clk               => rclk,
						
		-- Input data from timing recovery module
		sEnableIn         => CR_in_enable,
		sInPhase0         => CR_in_I(0),
		sQuadPhase0       => CR_in_Q(0),
		sInPhase1         => CR_in_I(1),
		sQuadPhase1       => CR_in_Q(1),
		
		-- Loop status signal, when '1' locked, otherwise not locked
		--sLockSign         => open,
		
		-- output data ready signal and data
		sEnableOut        => CR_out_enable,
		sInPhaseOut0      => CR_out_I(0),
		sQuadPhaseOut0    => CR_out_Q(0),
		sInPhaseOut1      => CR_out_I(1),
		sQuadPhaseOut1    => CR_out_Q(1)
		);
	---------------Carrier recovery with parallel structure --------end
----
	--------------- Equalization ------------ start
	equ_lms_inst :  equ_lms 
port map( 
		clk => rclk,
		rst_n => comb_cr_rst, --(aReset or rst_equ),
		en_in => CR_out_enable,
		jietiaofangshi => "0000",
		I0_in => CR_out_I(0),
		Q0_in => CR_out_Q(0),
		I1_in => CR_out_I(1),
		Q1_in => CR_out_Q(1),
		I0_out => Equ_out_I(0),
		Q0_out => Equ_out_Q(0),
		I1_out => Equ_out_I(1),
		Q1_out => Equ_out_Q(1),
		en_out => Equ_out_enable
      );

	mux_cr_equ : process( rclk, aReset )
	begin
	  if( aReset = '1' ) then
	    CREqu_out_I(0) <= (others => '0');
	    CREqu_out_I(1) <= (others => '0');
	    CREqu_out_Q(0) <= (others => '0');
	    CREqu_out_Q(1) <= (others => '0');
	    CREqu_out_enable <= '0';
	  elsif( rising_edge(rclk) ) then
	  	if mux_cr_equ_b='0' then
	  		CREqu_out_I(0) <= Equ_out_I(0);
			CREqu_out_Q(0) <= Equ_out_Q(0);
			CREqu_out_I(1) <= Equ_out_I(1);
			CREqu_out_Q(1) <= Equ_out_Q(1);
			CREqu_out_enable <= Equ_out_enable;
	  	else 
	  		CREqu_out_I(0) <= CR_out_I(0);
			CREqu_out_Q(0) <= CR_out_Q(0);
			CREqu_out_I(1) <= CR_out_I(1);
			CREqu_out_Q(1) <= CR_out_Q(1);
			CREqu_out_enable <= CR_out_enable;
	  	end if;
	  end if ;
	end process ; -- mux_cr_equ

	cnst_muxCrEql_inst: cnst_muxCrEql 
	PORT map
	(
		result(0) => mux_cr_equ_b
	);


	--------------- Equalization ------------ end
----
------********************************************************************************************************

	comb_diffdcd_i <= not(CREqu_out_I(1)(CREqu_out_I(1)'high)) & not(CREqu_out_I(0)(CREqu_out_I(0)'high));
	comb_diffdcd_q <= not(CREqu_out_Q(1)(CREqu_out_Q(1)'high)) & not(CREqu_out_Q(0)(CREqu_out_Q(0)'high));
	Diff_Decoder_P2_inst: Diff_Decoder_P2  
    port map(
      aReset          => aReset,
      clk             => rclk,
      datain_i        => comb_diffdcd_i, --not(CREqu_out_I(1)(CREqu_out_I(1)'high)) & not(CREqu_out_I(0)(CREqu_out_I(0)'high)),
      datain_q        => comb_diffdcd_q, --not(CREqu_out_Q(1)(CREqu_out_Q(1)'high)) & not(CREqu_out_Q(0)(CREqu_out_Q(0)'high)),
      datain_valid    => CREqu_out_enable,
      
      dataout_i       => cDataIn_DiffDec,
      dataout_q       => cDataQuad_DiffDec,
      dataout_valid   => cEnable_DiffDec              
     );
    -- Output serial wire seq : first i0, q0, i1, q1 last

    	PN_ERR_Detect_inst_I1: PN_ERR_Detect 
		 PORT map
		(
		   aReset	=> aReset,
		   ClockIn  => rclk,
		   Enable	=> cEnable_DiffDec,--cEnable_DiffDec,
		   DataIn	=> cDataIn_DiffDec(0),--not(Decoder_soft_QPSK_I0(3)),--cDataIn_DiffDec(1),
		   SyncFlag => open,
	       Error    => open,
		   ErrResult => open
		);
	
	    PN_ERR_Detect_inst_I0: PN_ERR_Detect 
		 PORT map
		(
		   aReset	=> aReset,
		   ClockIn  => rclk,
		   Enable	=> cEnable_DiffDec,
		   DataIn	=> cDataQuad_DiffDec(1),
		   SyncFlag => open,
	       Error    => open,
		   ErrResult => open
		);


	phase_rotate_QPSK_inst : phase_rotate_QPSK  
port map(
		aReset	=> aReset,
		clk		=> rclk,
		phase_set	=> cnst_phase_set,
		datain_i0	=> CREqu_out_I(0),
		datain_i1	=> CREqu_out_I(1),
		datain_q0	=> CREqu_out_Q(0),
		datain_q1	=> CREqu_out_Q(1),
		datain_valid    => CREqu_out_enable,
		
		dataout_i0       => CREqu_out_t_I(0),
		dataout_i1       => CREqu_out_t_I(1),
		dataout_q0       => CREqu_out_t_Q(0),
		dataout_q1       => CREqu_out_t_Q(1),
		dataout_valid   => CREqu_out_t_enable
	);

	--cnst_phase_rotate_inst : cnst_phase_rotate 
	--PORT map
	--(
	--	result		=> cnst_phase_set
	--);


	-- Prevent metastablity
	-- 
	process( rclk, aReset )
	begin
	  if( aReset = '1' ) then
	    phase_change_d <= (others => '0');
	    cnst_phase_set <= (others => '0');
	  elsif( rising_edge(rclk) ) then
	  	phase_change_d(0) <= phase_change;
	  	phase_change_d(1) <= phase_change_d(0);
	  	phase_change_d(2) <= phase_change_d(1);
	  	if phase_change_d(2 downto 1) = "10" then
	  		cnst_phase_set <= std_LOGIC_VECTOR(unsigned(cnst_phase_set) + 1);
	  	else
	  		cnst_phase_set <= cnst_phase_set;
	  	end if;
	  end if ;
	end process ; 


	demapping_select_CCSDS_soft_inst :  demapping_select_CCSDS_soft
port map(
		aReset	=> aReset,
		clk		=> rclk,
		demapping_Mode	=> '0',
		datain_i0	=> CREqu_out_t_I(0),
		datain_i1	=> CREqu_out_t_I(1),
		datain_q0	=> CREqu_out_t_Q(0),
		datain_q1	=> CREqu_out_t_Q(1),
		datain_valid    => CREqu_out_t_enable,
		
		dataout_i0      => Demapping_soft_QPSK_I0,
		dataout_i1      => Demapping_soft_QPSK_I1,
		dataout_q0      => Demapping_soft_QPSK_Q0,
		dataout_q1      => Demapping_soft_QPSK_Q1,
		dataout_valid   => Demapping_soft_QPSK_valid
	);
	
--cnst_dmp_inst :  cnst_dmp 
--	PORT map
--	(
--		result(0) => 	demapping_Mode_0	
--	);	
	
--	Decoder_Diff_soft_QPSK_inst : Decoder_Diff_soft_QPSK 
--port map(
--		aReset	=> aReset,
--		clk		=> rclk,
--		Decode_Mode	=> "011",
--		datain_i0	=> Demapping_soft_QPSK_I0,
--		datain_i1	=> Demapping_soft_QPSK_I1,
--		datain_q0	=> Demapping_soft_QPSK_Q0,
--		datain_q1	=> Demapping_soft_QPSK_Q1,
--		datain_valid    => Demapping_soft_QPSK_valid,
		
--		dataout_i0       => Decoder_soft_QPSK_I0,
--		dataout_i1       => Decoder_soft_QPSK_I1,
--		dataout_q0       => Decoder_soft_QPSK_Q0,
--		dataout_q1       => Decoder_soft_QPSK_Q1,
--		dataout_valid    => Decoder_soft_QPSK_valid 
--	);
	


		data_4to8_inst : data_4to8
port map(
		aReset => aReset,
		clk => rclk,  --75MHz
		clkout => rclk_half,  --37.5MHz
		data_in0 => Demapping_soft_QPSK_I0,
		data_in1 => Demapping_soft_QPSK_Q0,
		data_in2 => Demapping_soft_QPSK_I1,
		data_in3 => Demapping_soft_QPSK_Q1,
		valid => Demapping_soft_QPSK_valid,
		
		data_out0 => RSin_data0,
		data_out1 => RSin_data1,
		data_out2 => RSin_data2,
		data_out3 => RSin_data3,
		data_out4 => RSin_data4,
		data_out5 => RSin_data5,
		data_out6 => RSin_data6,
		data_out7 => RSin_data7,
		validout => RSin_valid
		);


		
--	 phase_frame_p_inst :	phase_frame_p         
--port map(
--	 clk       => rclk_half,
--	 reset     => aReset,
	 
--	 data_in   => RSin_data0 & RSin_data1 & RSin_data2 & RSin_data3 & RSin_data4 & RSin_data5 & RSin_data6 & RSin_data7 ,
--	 data_in_val => RSin_valid,
--	 c_asm => x"352ef853",
--	 i_framelengthsub1 => (others=>'1'),
	 
--	 dataout   => dataout_frame,
--	 o_sop     => sop_frame,
--    o_val      => val_frame,
--    o_eop      => eop_frame,
--    o_state    => open
--     );	

comb_headseek <= RSin_data0 & RSin_data1 & RSin_data2 & RSin_data3 & RSin_data4 & RSin_data5 & RSin_data6 & RSin_data7;
-- Big Endian ??
Packet_head_seeker_inst : Packet_head_seeker 
generic map (n_parellel => 8,  -- num of parellel branches
		 n_bit => 4   -- num of bits of every data
	)
  port map(
  	aReset	=> aReset,
  	clk		=> rclk_half,
  	d_in	=> comb_headseek, --RSin_data0 & RSin_data1 & RSin_data2 & RSin_data3 & RSin_data4 & RSin_data5 & RSin_data6 & RSin_data7 ,
  	val_in	=> RSin_valid,

  	d_out		=> dataout_frame,
  	val_out		=> val_frame,
  	sop_out		=> sop_frame,
  	eop_out		=> eop_frame

  ) ;

  -- If sop_frame doesn't show for a long time , change the phase of constellation after Equ,  or reset Equ
	process( rclk_half, aReset )
	variable cnt_sop_frame_0, cnt_sop_frame_1 : integer range 0 to 4095 ;
	variable cnt_sop_frame_2 : integer range 0 to 65535 ;
	begin
	  if( aReset = '1' ) then
	    cnt_sop_frame_1 := 0;
	    cnt_sop_frame_0 := 0;
	    cnt_sop_frame_2 := 0;
	    phase_change <= '0';
	    rst_equ <= '0' ;
	  elsif( rising_edge(rclk_half) ) then
	  	if cnt_sop_frame_0 = 2000 then
	  		cnt_sop_frame_0 := 0;
	  	else
	  		cnt_sop_frame_0 := cnt_sop_frame_0 + 1;
	  	end if;

	  	if sop_frame = '1' then
	  		cnt_sop_frame_1 := 0;
	  		cnt_sop_frame_2 := 0;
	  	elsif cnt_sop_frame_0 = 2000 then
	  		cnt_sop_frame_1 := cnt_sop_frame_1 + 1;
	  		cnt_sop_frame_2 := cnt_sop_frame_2 + 1;
	  	else
	  		cnt_sop_frame_1 := cnt_sop_frame_1;
	  		cnt_sop_frame_2 := cnt_sop_frame_2;
	  	end if;

	  	if cnt_sop_frame_1 = 4095 then
	  		phase_change <= '1';
	  	else
	  		phase_change <= '0';
	  	end if;

	  	if cnt_sop_frame_2 = 65535 and with_LDPC = '1' then
	  		rst_equ <= '1';
	  	else
	  		rst_equ <= '0';
	  	end if;
	  end if ;
	end process ; 

	--ldpc_header_cnt : process( rclk_half, aReset )
	--begin
	--  if( aReset = '1' ) then
	--    cnt_ldpc_sop <= (others=>'0');
	--	 --err_test <= '0';
	--  elsif( rising_edge(rclk_half) ) then
	--	if sop_frame='0' then 
	--		cnt_ldpc_sop <= cnt_ldpc_sop+1;
	--	else 
	--		cnt_ldpc_sop <= (others=>'0');	
	--	end if ;
--
--	  end if ;
--	end process ; -- ldpc_header_cnt
	  
	P8toP8_LDPC_inst : P8toP8_LDPC
	port map(
		  aReset => aReset,
		  clkin => rclk_half,
		  clkout => rclk,
		  i_data => dataout_frame,
		  i_sop  => sop_frame,    
		  i_valid=> val_frame,    
		  i_eop  => eop_frame,   
		  
		  o_data =>  data_decode_in,
		  o_valid => val_decode_in,
		  o_sop  =>  sop_decode_in,
		  o_eop  =>  eop_decode_in
		  );

	
	ldpc_decoder_inst :	ldpc_decoder        
	port map(
		 clk    => rclk,
		 reset   => aReset,
		 
		 ldpc_in  => data_decode_in,
		 i_val    => val_decode_in, 
		 i_sop    => sop_decode_in, 
		 i_eop    => eop_decode_in, 
		 
		 ldpc_out   => decode_out,
		 o_val      => decode_out_val,
		 o_sop      => open,--decode_out_sop,
		 o_eop      => open,--decode_out_eop,
		 decode_succeed => open
		 );

--------------  de-scrambler ---------------
--        --
--        -- decode_out XOR pn23
--        --
--        pn23_p8_pr : process( rclk, aReset )
--        begin
--          if( aReset = '1' ) then
--            pn23 <= (others => '0');
--          elsif( rising_edge(rclk) ) then
--          	if decode_out_sop='1' or decode_out_eop='1' then
--          		pn23(1) <= '1';
--          		pn23(23 downto 2) <= (others => '0');
--          	elsif decode_out_val_t='1' then
--          		pn23(23 downto 9) <= pn23(15 downto 1);
--				pn23(8 downto 1)  <= pn23(23 downto 16) xor pn23(18 downto 11);
--			else
--				pn23 <= pn23;
--			end if;
--          end if ;
--        end process ; -- pn23_p8_pr

--        desramb_pr : process( rclk, aReset )
--        begin
--          if( aReset = '1' ) then
--            decode_out <= (others => '0');
--            decode_out_val <= '0';
--            decode_out_descrm <= (others => '0');
--            decode_out_val_descrm <= '0';
--          elsif( rising_edge(rclk) ) then
--          	decode_out_descrm <= decode_out_t;
--          	decode_out_val_descrm <= decode_out_val_t;

--          	decode_out <= decode_out_descrm xor pn23(23 downto 16);
--          	decode_out_val <= decode_out_val_descrm;
--          end if ;
--        end process ; -- desramb_pr
--    ---------------------------------------------------	
	

fifo_ldpcout_8to4_inst: fifo_ldpcout_8to4 
	PORT map
	(
		aclr		=> ( wrfull_ldpcout or aReset ),
		data		=> decode_out,
		rdclk		=> rclk,
		rdreq		=> rdreq_ldpcout,
		wrclk		=> rclk,
		wrreq		=> decode_out_val,
		q			=> dat_ldpc_out,
		rdempty		=> open,
		rdusedw		=> rdusedw_ldpcout,
		wrfull		=> wrfull_ldpcout
	);

	rdreq_ldpcout_pr : process( rclk, aReset )
	begin
	  if( aReset = '1' ) then
	    rdreq_ldpcout <= '0';
	    val_ldpc_out <= '0';
	  elsif( rising_edge(rclk) ) then
	  	if unsigned(rdusedw_ldpcout) >= to_unsigned(64,12) then
	  		rdreq_ldpcout <= '1' ;
	  	else
	  		rdreq_ldpcout <= '0';
	  	end if;
	  	val_ldpc_out <= rdreq_ldpcout;
	  end if ;
	end process ; -- rdreq_ldpcout_pr

	MUX_to_out : process( rclk, aReset )
	begin
	  if( aReset = '1' ) then
	    dat_mux <= (others => '0');
	    val_mux <= '0';		
	  elsif( rising_edge(rclk) ) then
	  	if with_LDPC = '1' then
	  		dat_mux <= dat_ldpc_out;
	  		val_mux <= val_ldpc_out;
	  	else
	  		dat_mux <= cDataQuad_DiffDec(1) & cDataIn_DiffDec(1) & cDataQuad_DiffDec(0) & cDataIn_DiffDec(0);
	  		val_mux <= cEnable_DiffDec;
	  	end if;
	  end if ;
	end process ; -- MUX_to_out

	--ddio_toF2_inst: ddio_toF2 
	--PORT map
	--(
	--	aclr		=> aReset,
	--	datain_h		=> ( '1' & val_mux & dat_mux(3) & dat_mux(2) & dat_mux(1) & dat_mux(0) ),
	--	datain_l		=> ( '0' & val_mux & dat_mux(3) & dat_mux(2) & dat_mux(1) & dat_mux(0) ),
	--	outclock		=> rclk,
	--	dataout		=> d_toFPGA2
	--);


	PN_ERR_Detect_inst_Q0: PN_ERR_Detect 
		 PORT map
		(
		   aReset	=> aReset,
		   ClockIn  => rclk,
		   Enable	=> decode_out_val,
		   DataIn	=> decode_out(1),
		   SyncFlag => open,
	       Error    => open,
		   ErrResult => open
		);
	PN_ERR_Detect_inst_Q1: PN_ERR_Detect 
		 PORT map
		(
		   aReset	=> aReset,
		   ClockIn  => rclk,
		   Enable	=> decode_out_val,
		   DataIn	=> decode_out(4),
		   SyncFlag => open,
	       Error    => open,
		   ErrResult => open
		);
	

end rtl;
