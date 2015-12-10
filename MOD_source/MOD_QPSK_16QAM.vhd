library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MOD_QPSK_16QAM is
generic(kOutSize : positive := 14);
port(
		aReset : in std_logic;
		--mode : in std_logic_vector(1 downto 0);
		--TCXO_1944 : in std_logic;
		--DA_DCO : in std_logic;
		--DA_sdo : in std_logic;
		clk_25	: in std_logic;
		clk_50	: in std_logic;
		clk_150	: in std_logic;
		--data_in  : in std_LOGIC_VECTOR(5 downto 0); -- ddio_in format  (5) clk (4) valid  (3..0) data
		ddio_clk : in std_logic;  -- 100MHz ?
		ddio_din : in std_logic_vector(3 downto 0) ;
		ddio_wren : in std_logic;
		d_src_is_GE : in std_logic;
		with_LDPC 	: in std_logic;

	
		IFData_0	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_1	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_2	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_3    : OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_4	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_5    : OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_6	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_7    : OUT std_logic_vector(kOutSize - 1 downto 0)
		);
end entity;

architecture rtl of MOD_QPSK_16QAM is

component lpm_constant_mode IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
END component;

component PLL_TCXO IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC ;
		c3		: OUT STD_LOGIC
	);
END component;



component PLL_DCO IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC
	);
END component;

component CreateReset2 is
        port (
                Clk_in          : in std_logic;
                --reset_pin       : in std_logic;
				 
                aReset	: out std_logic
                );
end   component; 

component SPI_AD9739 is

port (

	clk : in std_logic;   
	reset : in std_logic;
	sdi : in std_logic;


	sclk : out std_logic;  
	cs : out std_logic;
	sdo : out std_logic    

);
end   component; 

component PN_gen4 is
port(
		aReset 	: in std_logic;
		clk		: in std_logic;
		PN_Dataout	: out std_logic_vector(3 downto 0)
		);
end component;

component PN_gen8 is
port(
		aReset 	: in std_logic;
		clk		: in std_logic;
		PN_Dataout	: out std_logic_vector(7 downto 0)
		);
end component;


component ldpc_encode is
generic( kInSize : positive := 8);
port(
		aReset : in std_logic;
		clkin : in std_logic;
		clkout : in std_logic;
		enablein : in std_logic;
		datain : in std_logic_vector(7 downto 0);
		
		ldpc_out : out std_logic_vector(7 downto 0);
		o_val : out std_logic);
end component;

component mapping_QPSK is
generic(
			kOutSize : positive := 14
			);
port(
		aReset : in std_logic;
		clk : in std_logic;
		val_in : in std_logic;
		datain : in std_logic_vector(3 downto 0);
		dataout_I0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_I1 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q1 : out std_logic_vector(kOutSize - 1 downto 0)
		);
end component;

component mapping_16QAM is
generic(
			kOutSize : positive := 14
			);
port(
		aReset : in std_logic;
		clkin : in std_logic;
		clkout : in std_logic;
		val_in : in std_logic;
		datain : in std_logic_vector(7 downto 0);
		dataout_I0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q0 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_I1 : out std_logic_vector(kOutSize - 1 downto 0);
		dataout_Q1 : out std_logic_vector(kOutSize - 1 downto 0)
		);
end component;


component	shapingfilter_p8_MOD	is
generic(
		kInSize  : positive :=14;
		kOutSize : positive :=14);
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

component interpolation_4 is
generic(
			kInSize : positive := 14
			);
port(
		aReset	: in std_logic;
		ClkIn		: in std_logic;
		ClkOut   : in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kInSize-1 downto 0);
		cDout1	: out std_logic_vector(kInSize-1 downto 0);
		cDout2	: out std_logic_vector(kInSize-1 downto 0);
		cDout3	: out std_logic_vector(kInSize-1 downto 0);
		cDout4	: out std_logic_vector(kInSize-1 downto 0);
		cDout5	: out std_logic_vector(kInSize-1 downto 0);
		cDout6	: out std_logic_vector(kInSize-1 downto 0);
		cDout7	: out std_logic_vector(kInSize-1 downto 0)
		);
end component;

component interpolation_2 is
generic(
			kInSize : positive := 14
			);
port(
		aReset	: in std_logic;
		ClkIn		: in std_logic;
		ClkOut   : in std_logic;
		cDin0	: in std_logic_vector(kInSize-1 downto 0);
		cDin1	: in std_logic_vector(kInSize-1 downto 0);
		cDin2	: in std_logic_vector(kInSize-1 downto 0);
		cDin3	: in std_logic_vector(kInSize-1 downto 0);
		cDin4	: in std_logic_vector(kInSize-1 downto 0);
		cDin5	: in std_logic_vector(kInSize-1 downto 0);
		cDin6	: in std_logic_vector(kInSize-1 downto 0);
		cDin7	: in std_logic_vector(kInSize-1 downto 0);
		cDout0	: out std_logic_vector(kInSize-1 downto 0);
		cDout1	: out std_logic_vector(kInSize-1 downto 0);
		cDout2	: out std_logic_vector(kInSize-1 downto 0);
		cDout3	: out std_logic_vector(kInSize-1 downto 0);
		cDout4	: out std_logic_vector(kInSize-1 downto 0);
		cDout5	: out std_logic_vector(kInSize-1 downto 0);
		cDout6	: out std_logic_vector(kInSize-1 downto 0);
		cDout7	: out std_logic_vector(kInSize-1 downto 0)
		);
end component;

component mode_select is
generic(
			kInSize : positive := 14
	);
port(
		aReset : in std_logic;
		clk    : in std_logic;
		mode	 : in std_logic;
		dataA0 : in std_logic_vector(kInSize - 1 downto 0);
		dataA1 : in std_logic_vector(kInSize - 1 downto 0);
		dataA2 : in std_logic_vector(kInSize - 1 downto 0);
		dataA3 : in std_logic_vector(kInSize - 1 downto 0);
		dataA4 : in std_logic_vector(kInSize - 1 downto 0);
		dataA5 : in std_logic_vector(kInSize - 1 downto 0);
		dataA6 : in std_logic_vector(kInSize - 1 downto 0);
		dataA7 : in std_logic_vector(kInSize - 1 downto 0);
		dataB0 : in std_logic_vector(kInSize - 1 downto 0);
		dataB1 : in std_logic_vector(kInSize - 1 downto 0);
		dataB2 : in std_logic_vector(kInSize - 1 downto 0);
		dataB3 : in std_logic_vector(kInSize - 1 downto 0);
		dataB4 : in std_logic_vector(kInSize - 1 downto 0);
		dataB5 : in std_logic_vector(kInSize - 1 downto 0);
		dataB6 : in std_logic_vector(kInSize - 1 downto 0);
		dataB7 : in std_logic_vector(kInSize - 1 downto 0);
		
		dataout0 : out std_logic_vector(kInSize - 1 downto 0);
		dataout1 : out std_logic_vector(kInSize - 1 downto 0);
		dataout2 : out std_logic_vector(kInSize - 1 downto 0);
		dataout3 : out std_logic_vector(kInSize - 1 downto 0);
		dataout4 : out std_logic_vector(kInSize - 1 downto 0);
		dataout5 : out std_logic_vector(kInSize - 1 downto 0);
		dataout6 : out std_logic_vector(kInSize - 1 downto 0);
		dataout7 : out std_logic_vector(kInSize - 1 downto 0)
		);
end component;

component UpConvert is 
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
end component;

component datareg4_2 is
	generic(
		kInSize	 : positive := 14;
		kOutSize : positive := 60
	   );
	port(
		aReset	: in  std_logic;
		clk	: in  std_logic;
		cDin0	: in  std_logic_vector (kInSize-1 downto 0);
		cDin1	: in  std_logic_vector (kInSize-1 downto 0);
		cDin2	: in  std_logic_vector (kInSize-1 downto 0);
		cDin3	: in  std_logic_vector (kInSize-1 downto 0);
		cDout	: out std_logic_vector (kOutSize-1 downto 0)
		
		);
end component;

component datareg4 is
	generic(
		kInSize	 : positive := 14;
		kOutSize : positive := 56
	   );
	port(
		aReset	: in  std_logic;
		clk	: in  std_logic;
		cDin0	: in  std_logic_vector (kInSize-1 downto 0);
		cDin1	: in  std_logic_vector (kInSize-1 downto 0);
		cDin2	: in  std_logic_vector (kInSize-1 downto 0);
		cDin3	: in  std_logic_vector (kInSize-1 downto 0);
		cDout	: out std_logic_vector (kOutSize-1 downto 0)
		
		);
end component;

component diff_code_p2 is
port(
      aReset          : in  std_logic; 
      clk             : in  std_logic;
      datain_i        : in  std_logic_vector(1 downto 0);
      datain_q        : in  std_logic_vector(1 downto 0);
     
      dataout_i       : out  std_logic_vector(1 downto 0);
      dataout_q       : out  std_logic_vector(1 downto 0)
      );
end component;		

component lvds_tx_DA IS
	PORT
	(
		tx_in		: IN STD_LOGIC_VECTOR (115 DOWNTO 0);
		tx_inclock		: IN STD_LOGIC ;
		tx_out		: OUT STD_LOGIC_VECTOR (28 DOWNTO 0)
	);
END component;

component fifo_preLDPC IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
END component;





component	P8toP4_bit	is
port(
		aReset	: in std_logic;
		clk_in		: in std_logic;
		clk_out		: in std_logic;
		data_in	: in std_logic_vector(7 downto 0);
		valid_in	: in std_logic;

		data_out	: out std_logic_vector(3 downto 0);
		valid_out	: out std_logic
		);
end	component;

component tx_ldpc is  -- define entity
	port
	(   clk          :  in std_logic;
	    reset        :  in std_logic;
	    i_data		 :  in std_logic_vector(7 downto 0);
	    d_src_is_GE  :  in std_logic;
	
	    o_val        : out std_logic;
	    o_data       : out std_logic_vector(8 downto 1);
		o_sop        : out std_logic;
		o_eop        : out std_logic;

		pre_fifo_rden	: out std_logic		       
		
	 );
end component;

component diff_code_p2_ed2 is
port(
      aReset          : in  std_logic; 
      clk             : in  std_logic;
      datain_i        : in  std_logic_vector(1 downto 0);
      datain_q        : in  std_logic_vector(1 downto 0);
     
      dataout_i       : out  std_logic_vector(1 downto 0);
      dataout_q       : out  std_logic_vector(1 downto 0)
      );
end component ;



component fifo_preLDPC_4to8 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrfull		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
END component;

signal PN_Dataout_155 : std_logic_vector(7 downto 0);
signal data_mapping_I0_155,data_mapping_Q0_155,data_mapping_I1_155,data_mapping_Q1_155 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I0_155,data_shaping_I1_155,data_shaping_I2_155,data_shaping_I3_155 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I4_155,data_shaping_I5_155,data_shaping_I6_155,data_shaping_I7_155 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q0_155,data_shaping_Q1_155,data_shaping_Q2_155,data_shaping_Q3_155 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q4_155,data_shaping_Q5_155,data_shaping_Q6_155,data_shaping_Q7_155 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I0_155_inter,data_shaping_I1_155_inter,data_shaping_I2_155_inter,data_shaping_I3_155_inter : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I4_155_inter,data_shaping_I5_155_inter,data_shaping_I6_155_inter,data_shaping_I7_155_inter : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q0_155_inter,data_shaping_Q1_155_inter,data_shaping_Q2_155_inter,data_shaping_Q3_155_inter : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q4_155_inter,data_shaping_Q5_155_inter,data_shaping_Q6_155_inter,data_shaping_Q7_155_inter : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I0,data_shaping_I1,data_shaping_I2,data_shaping_I3 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_I4,data_shaping_I5,data_shaping_I6,data_shaping_I7 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q0,data_shaping_Q1,data_shaping_Q2,data_shaping_Q3 : std_logic_vector(kOutSize - 1 downto 0);
signal data_shaping_Q4,data_shaping_Q5,data_shaping_Q6,data_shaping_Q7 : std_logic_vector(kOutSize - 1 downto 0);
--signal IFData_0,IFData_1,IFData_2,IFData_3,IFData_4,IFData_5,IFData_6,IFData_7 : std_logic_vector(kOutSize - 1 downto 0);
signal clk_sample_800,clk_sample_1600,clk_sample_200 : std_logic;
signal lvds_in : std_logic_vector(115 downto 0);
--signal tx_out : std_logic_vector(28 downto 0);
signal clk_7776,clk_15552,clk_2M,clk_1944 : std_logic;
--signal aReset,aReset_gen,ldpc_val : std_logic;
signal ldpc_out : std_logic_vector(7 downto 0);
signal PN_Dataout_622_mux : std_logic_vector(7 downto 0);
--signal mode : std_logic_vector(1 downto 0);
signal PN_Dataout_4, PN_Dataout_4_0, PN_Dataout_4_1 : std_logic_vector(3 downto 0);

signal diff_code_datain_i  : std_logic_vector(1 downto 0);
signal diff_code_datain_q  : std_logic_vector(1 downto 0);
signal diff_code_dataout_i : std_logic_vector(1 downto 0);
signal diff_code_dataout_q : std_logic_vector(1 downto 0);

signal aclr_preL,rdempty_preL,wrfull_preL  : std_logic;
signal data_in_l : std_LOGIC_VECTOR(4 downto 0);
signal d_LDPC_out, d_LDPC_out_0,d_LDPC_out_pre : std_LOGIC_VECTOR(7 downto 0);
signal PN_LDPC_out_q,PN_LDPC_out_i : std_LOGIC_VECTOR(1 downto 0);
signal d_LDPC_out_P4, d_LDPC_out_P4_t : std_loGIC_VECTOR(3 downto 0);
signal d_from_GE : std_logic_vector(3 downto 0) ;
signal  d_not_LDPC : std_logic_vector(3 downto 0) ;
signal wrfull_preL_GE, aclr_preL_GE, pre_fifo_rden : std_logic;
signal d_LDPC_from_GE : std_logic_vector(7 downto 0) ;
signal pre_fifo_rden_4to8 : std_logic;
signal ddio_wren_reg : std_logic;
signal ddio_din_reg : std_logic_vector(3 downto 0) ;
signal wrusedw_preLDPC : std_logic_vector(10 downto 0) ;
signal rdusedw_preLDPC : std_logic_vector(9 downto 0) ;
	signal rdreq_start : std_logic;


begin


fifo_preLDPC_inst: fifo_preLDPC 
	PORT map
	(
		aclr		=> aReset,
		data		=> ddio_din, --data_in_l(3 downto 0),
		rdclk		=> clk_50,
		rdreq		=> '1',
		wrclk		=> ddio_clk, --data_in(5),
		wrreq		=> ddio_wren, --data_in_l(4),
		q		   	=> d_from_GE,
		rdempty		=> open,--rdempty_preL,
		rdusedw		=> open,
		wrfull		=> open --wrfull_preL
	);

--aclr_preL <= aReset; --wrfull_preL or aReset;

fifo_preLDPC_4to8_inst: fifo_preLDPC_4to8 
	PORT map
	(
		aclr		=> aReset,
		data		=> ddio_din, --data_in_l(3 downto 0),
		rdclk		=> clk_25,
		rdreq		=> pre_fifo_rden_4to8,
		wrclk		=> ddio_clk, --data_in(5),
		wrreq		=> ddio_wren, --data_in_l(4),
		q			=> d_LDPC_from_GE,
		rdempty		=> open,
		rdusedw 	=> rdusedw_preLDPC,
		wrfull		=> open, --wrfull_preL_GE
		wrusedw		=> open

	);

	--process( aReset, clk_25)
	--begin
	--	if aReset='1' then
	--		rdreq_start <= '0';
	--		pre_fifo_rden_4to8 <= '0';
	--	elsif rising_edge(clk_25) then	
	--		if unsigned(rdusedw_preLDPC) < to_unsigned(4, rdusedw_preLDPC'length) then
	--			pre_fifo_rden_4to8 <= '0';
	--			rdreq_start <= '0';
	--		elsif  rdreq_start='0' then
	--			if unsigned(rdusedw_preLDPC) >= to_unsigned(256, rdusedw_preLDPC'length) then
	--				rdreq_start <= '1';
	--				pre_fifo_rden_4to8 <= pre_fifo_rden;
	--			else
	--				rdreq_start <= '0';
	--				pre_fifo_rden_4to8 <= '0';
	--			end if;
	--		else
	--			pre_fifo_rden_4to8 <= pre_fifo_rden;
	--			rdreq_start <= rdreq_start;
	--		end if;
	--	end if;
	--end process;

	process( aReset, clk_25)
	begin
		if aReset='1' then
			pre_fifo_rden_4to8 <= '0';
		elsif rising_edge(clk_25) then	
				if unsigned(rdusedw_preLDPC) >= to_unsigned(64, rdusedw_preLDPC'length) then
					pre_fifo_rden_4to8 <= pre_fifo_rden;
				else
					pre_fifo_rden_4to8 <= '0';
				end if;
		end if;
	end process;


   tx_ldpc_inst: tx_ldpc 
	port map
	(   clk          => clk_25,
	    reset        => aReset,
	    i_data		=> d_LDPC_from_GE,
	    d_src_is_GE	=> d_src_is_GE,
	
	    o_val        => open,
	    o_data       => d_LDPC_out,
		o_sop         => open,
		o_eop         => open,
		pre_fifo_rden	=> pre_fifo_rden       
		
	 );


P8toP4_bit_inst:	P8toP4_bit	
port map(
		aReset	=> aReset,
		clk_in		=> clk_25,
		clk_out		=> clk_50,
		data_in		=> d_LDPC_out(0) & d_LDPC_out(1) & d_LDPC_out(2) & d_LDPC_out(3) & d_LDPC_out(4) & d_LDPC_out(5) & d_LDPC_out(6) & d_LDPC_out(7),
		valid_in		=> '1',

		data_out		=> d_LDPC_out_P4,
		valid_out	=> open
		);
		
PN_gen4_inst : PN_gen4 
port map(
		aReset 	=> aReset,
		clk		=> clk_50,
		PN_Dataout	=> PN_Dataout_4
		);

d_src_GEorSELF : process( clk_50, aReset )
begin
  if( aReset = '1' ) then
    d_not_LDPC <= (others => '0');
  elsif( rising_edge(clk_50) ) then
  	if d_src_is_GE='1' then
  		d_not_LDPC <= d_from_GE;
  	else 
  		d_not_LDPC <= PN_Dataout_4;
  	end if;
  end if ;
end process ; -- d_src_GEorSELF


 
inst_diff_code: diff_code_p2 
port map(
      aReset          => aReset ,
      clk             => clk_50 ,
      datain_i        => d_not_LDPC(2) & d_not_LDPC(0) ,
      datain_q        => d_not_LDPC(3) & d_not_LDPC(1) , 
     
      dataout_i       => diff_code_dataout_i ,
      dataout_q       => diff_code_dataout_q
      );

-- LDPC does not need diff encoding
process(clk_50)
begin
	if rising_edge(clk_50) then
		if with_LDPC='1' then
			PN_LDPC_out_i <= d_LDPC_out_P4(2) & d_LDPC_out_P4(0);
			PN_LDPC_out_q <= d_LDPC_out_P4(3) & d_LDPC_out_P4(1);
		else
			PN_LDPC_out_i <= diff_code_dataout_i;
			PN_LDPC_out_q <= diff_code_dataout_q;
		end if;
	end if;
end process;		

mapping_QPSK_inst_155 : mapping_QPSK 
generic map(14)
port map(
		aReset 	=> aReset,
		clk 	=> clk_50,
		val_in => '1',
		--datain 	=> PN_Dataout_4(0) & PN_Dataout_4(1) & PN_Dataout_4(2) & PN_Dataout_4(3),
		datain 	=> PN_LDPC_out_q(0) & PN_LDPC_out_i(0) & PN_LDPC_out_q(1) & PN_LDPC_out_i(1),
		dataout_I0 => data_mapping_I0_155,
		dataout_Q0 => data_mapping_Q0_155,
		dataout_I1 => data_mapping_I1_155,
		dataout_Q1 => data_mapping_Q1_155
		);		
				
shapingfilter_p8_instI_622 :	shapingfilter_p8_MOD
generic map(
		14,
		14)
port map(
		aReset	=> aReset,
		Clk		=> clk_50,
		cDin0		=> data_mapping_I0_155,
		cDin1		=> (others => '0'),
		cDin2		=> (others => '0'),
		cDin3		=> (others => '0'),
		cDin4		=> data_mapping_I1_155,
		cDin5		=> (others => '0'),
		cDin6		=> (others => '0'),
		cDin7		=> (others => '0'),
		cDout0	=> data_shaping_I0_155,
		cDout1	=> data_shaping_I1_155,
		cDout2	=> data_shaping_I2_155,
		cDout3	=> data_shaping_I3_155,
		cDout4	=> data_shaping_I4_155,
		cDout5	=> data_shaping_I5_155,
		cDout6	=> data_shaping_I6_155,
		cDout7	=> data_shaping_I7_155
		);		
		
shapingfilter_p8_instQ_622 :	shapingfilter_p8_MOD
generic map(
		14,
		14)
port map(
		aReset	=> aReset,
		Clk		=> clk_50,
		cDin0		=> data_mapping_Q0_155,
		cDin1		=> (others => '0'),
		cDin2		=> (others => '0'),
		cDin3		=> (others => '0'),
		cDin4		=> data_mapping_Q1_155,
		cDin5		=> (others => '0'),
		cDin6		=> (others => '0'),
		cDin7		=> (others => '0'),
		cDout0	=> data_shaping_Q0_155,
		cDout1	=> data_shaping_Q1_155,
		cDout2	=> data_shaping_Q2_155,
		cDout3	=> data_shaping_Q3_155,
		cDout4	=> data_shaping_Q4_155,
		cDout5	=> data_shaping_Q5_155,
		cDout6	=> data_shaping_Q6_155,
		cDout7	=> data_shaping_Q7_155
		);	
		
		
interpolation_2_InstI : interpolation_2
generic map(
			14
			)
port map(
		aReset	=> aReset,
		ClkIn		=> clk_50,
		ClkOut   => clk_150,
		cDin0		=> data_shaping_I0_155,
		cDin1		=> data_shaping_I1_155,
		cDin2		=> data_shaping_I2_155,
		cDin3		=> data_shaping_I3_155,
		cDin4		=> data_shaping_I4_155,
		cDin5		=> data_shaping_I5_155,
		cDin6		=> data_shaping_I6_155,
		cDin7		=> data_shaping_I7_155,
		cDout0	=> data_shaping_I0_155_inter,
		cDout1	=> data_shaping_I1_155_inter,
		cDout2	=> data_shaping_I2_155_inter,
		cDout3	=> data_shaping_I3_155_inter,
		cDout4	=> data_shaping_I4_155_inter,
		cDout5	=> data_shaping_I5_155_inter,
		cDout6	=> data_shaping_I6_155_inter,
		cDout7	=> data_shaping_I7_155_inter
		);	

interpolation_2_InstQ : interpolation_2
generic map(
			14
			)
port map(
		aReset	=> aReset,
		ClkIn		=> clk_50,
		ClkOut   => clk_150,
		cDin0		=> data_shaping_Q0_155,
		cDin1		=> data_shaping_Q1_155,
		cDin2		=> data_shaping_Q2_155,
		cDin3		=> data_shaping_Q3_155,
		cDin4		=> data_shaping_Q4_155,
		cDin5		=> data_shaping_Q5_155,
		cDin6		=> data_shaping_Q6_155,
		cDin7		=> data_shaping_Q7_155,
		cDout0	=> data_shaping_Q0_155_inter,
		cDout1	=> data_shaping_Q1_155_inter,
		cDout2	=> data_shaping_Q2_155_inter,
		cDout3	=> data_shaping_Q3_155_inter,
		cDout4	=> data_shaping_Q4_155_inter,
		cDout5	=> data_shaping_Q5_155_inter,
		cDout6	=> data_shaping_Q6_155_inter,
		cDout7	=> data_shaping_Q7_155_inter
		);		
		
UpConvert_inst : UpConvert 
    generic map(
      14,
      14,
      16
     )
    port map(
      aReset            => aReset,
      Clk               => clk_150,
      pInPhaseIn0         => data_shaping_I0_155_inter,
		pInPhaseIn1       => data_shaping_I1_155_inter,
		pInPhaseIn2       => data_shaping_I2_155_inter,
		pInPhaseIn3       => data_shaping_I3_155_inter,
		pInPhaseIn4       => data_shaping_I4_155_inter,
		pInPhaseIn5       => data_shaping_I5_155_inter,
		pInPhaseIn6       => data_shaping_I6_155_inter,
		pInPhaseIn7       => data_shaping_I7_155_inter,
		
      pQuadPhaseIn0       => data_shaping_Q0_155_inter,
		pQuadPhaseIn1     => data_shaping_Q1_155_inter,
		pQuadPhaseIn2     => data_shaping_Q2_155_inter,
		pQuadPhaseIn3     => data_shaping_Q3_155_inter,
		pQuadPhaseIn4     => data_shaping_Q4_155_inter,
		pQuadPhaseIn5     => data_shaping_Q5_155_inter,
		pQuadPhaseIn6     => data_shaping_Q6_155_inter,
		pQuadPhaseIn7     => data_shaping_Q7_155_inter,
		
      
	   IFData_0				=> IFData_0,
	   IFData_1				=> IFData_1,
		IFData_2			=> IFData_2,
		IFData_3			=> IFData_3,
		IFData_4			=> IFData_4,
		IFData_5			=> IFData_5,
		IFData_6			=> IFData_6,
		IFData_7			=> IFData_7
     );

--datareg4_2_inst : datareg4_2
--	generic map(
--		14,
--		60
--	   )
--	port map(
--		aReset	=> aReset,
--		clk	=> clk_150,
--		cDin0	=> IFData_0,
--		cDin1	=> IFData_2,
--		cDin2	=> IFData_4,
--		cDin3	=> IFData_6,
--		cDout	=> lvds_in(115 downto 56)	
--		);	  
--
--datareg4_inst : datareg4
--	generic map(
--		14,
--		56
--	   )
--	port map(
--		aReset	=> aReset,
--		clk	=> clk_150,
--		cDin0	=> IFData_1,
--		cDin1	=> IFData_3,
--		cDin2	=> IFData_5,
--		cDin3	=> IFData_7,
--		cDout	=> lvds_in(55 downto 0)	
--		);	  		
--		
--lvds_tx_DA_inst : lvds_tx_DA 
--	PORT map
--	(
--		tx_in		=> lvds_in,
--		tx_inclock		=> clk_150,
--		tx_out		=> tx_out
--	);
	  
end rtl;