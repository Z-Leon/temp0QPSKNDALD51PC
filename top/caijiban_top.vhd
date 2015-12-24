


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity caijiban_top is
port
(
 --dac interface
   dac_dataclko : in  std_logic                     ;
   --dac_dataclki : out std_logic                     ;
   dac_data     : out std_logic_vector(14 downto 0) ;
   dac_reset    : out std_logic                     ;
   dac_irq      : out std_logic                     ;
   dac_cs       : out std_logic                     ;
   dac_sdio     : out std_logic                     ;
   dac_sclk     : out std_logic                     ;
   dac_sdo      : out std_logic                     ;
   dac_mode     : out std_logic                     ;


 --adc interface
   adc_fsr      : out std_logic                     ;
   adc_ddrph    : out std_logic                     ;
   adc_des      : out std_logic                     ;
   adc_ndm      : out std_logic                     ;
   adc_rst      : out std_logic                     ;
   adc_sdo      : in  std_logic                     ;
   adc_sclk     : out std_logic                     ;
   adc_sdi      : out std_logic                     ;
   adc_scs      : out std_logic                     ;
   adc_dclki    : in  std_logic                     ;
   adc_dclkq    : in  std_logic                     ;
   adc_di       : in  std_logic_vector(11 downto 0) ;
   adc_dq       : in  std_logic_vector(11 downto 0) ;

	clk_toFPGA2  : out std_logic;
	d_fromFPGA2	 : in std_logic_vector(5 downto 0); -- ddio_in format  (5) clk (4) valid  (3..0) data
	d_toFPGA2	 : out std_logic_vector(5 downto 0); --(5)clk  (4)valid
  LED_out : out std_logic_vector(1 downto 0)  -- D5,D2


);
end entity caijiban_top ;

architecture rtl of caijiban_top is

component adin is
port(
   --control interface
   adc_fsr            : out std_logic                     ;
   adc_ddrph          : out std_logic                     ;
   adc_des            : out std_logic                     ;
   adc_ndm            : out std_logic                     ;
   adc_rst            : out std_logic                     ;
   adc_sdo            : in  std_logic                     ;
   adc_sclk           : out std_logic                     ;
   adc_sdi            : out std_logic                     ;
   adc_scs            : out std_logic                     ;
   --data clk interface
   adc_dclki          :  in std_logic                     ;
   adc_dclkq          :  in std_logic                     ;
   adc_di             :  in std_logic_vector(11 downto 0) ;
   adc_dq             :  in std_logic_vector(11 downto 0) ;
   --adc usr interface
   adc_d0             : out std_logic_vector(11 downto 0) ;
   adc_d1             : out std_logic_vector(11 downto 0) ;
   adc_d2             : out std_logic_vector(11 downto 0) ;
   adc_d3             : out std_logic_vector(11 downto 0) ;
   adc_d4             : out std_logic_vector(11 downto 0) ;
   adc_d5             : out std_logic_vector(11 downto 0) ;
   adc_d6             : out std_logic_vector(11 downto 0) ;
   adc_d7             : out std_logic_vector(11 downto 0) ;
   data_rx_outclock   : out std_logic
);
end component ;


component dacout is
port(
 -- usr interface
  dac_usr_clk    : out std_logic                      ;
  dac_usr_data   : in  std_logic_vector(111 downto 0) ;
  use_test_data  : in  std_logic                      ;

 -- dac chip interface
 dac_dataclko  : in  std_logic                     ;
 --dac_dataclki  : out std_logic                     ;
 dac_data      : out std_logic_vector(14 downto 0) ;
 dac_reset     : out std_logic                     ;
 dac_irq       : out std_logic                     ;
 dac_cs        : out std_logic                     ;
 dac_sdio      : out std_logic                     ;
 dac_sclk      : out std_logic                     ;
 dac_sdo       : out std_logic                     ;
 dac_mode      : out std_logic      ;
 clk_toFPGA2	  : out std_logic--20MHz
);
end component ;


component MOD_QPSK_16QAM is
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
		IFData_3  : OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_4	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_5  : OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_6	: OUT std_logic_vector(kOutSize - 1 downto 0);
		IFData_7  : OUT std_logic_vector(kOutSize - 1 downto 0)
		);
end component;

component	Demod_Para	is
generic	(
			kInSize  : positive :=8
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
		val_mux : out std_logic;
    LED_out : out std_logic_vector(1 downto 0)

		);
end component;


component cpm is
port
(
	adc_if_clk_out : in  std_logic ; -- 100MHZ
	adc_demo_clk   : out std_logic ; -- 100MHZ
	adc_demo_p_clk : out std_logic ; -- 50MHZ
	adc_demo_r_clk : out std_logic ; -- 75MHZ
	adc_demo_r_clk_half : out std_logic ; -- 37.5MHz
	adc_demo_rst   : out std_logic ;
	dac_if_clk_out : in  std_logic ; -- 150MHZ
	dac_out_clk    : out std_logic ; -- 150MHZ
	dac_source_clk : out std_logic ; -- 50MHZ
	dac_source_clk_25 : out std_logic; -- 25MHz, 2015/3/4 for LDPC Encoder Source Self-Gen
   dac_source_clk_100 : out std_logic;
	dac_source_rst : out std_logic
);
end component;


component rom_DAsin IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component cnst_ifLDPC IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component rom_dsource IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

component ddio_toF2 IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		datain_h		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		datain_l		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		outclock		: IN STD_LOGIC ;
		dataout		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
END component;

component ddioin_buffer is
  port (
  	aReset	: in std_logic;
  	ddio_clk	: in std_logic;  --100MHz
  	ddio_din	: in std_logic_vector(4 downto 0);
  	rdclk		: in std_logic;  --100MHz

  	d_out 		: out std_logic_vector(4 downto 0)

  ) ;
end component ;


  signal   dac_usr_clk    : std_logic                      ;
  signal   dac_usr_data   : std_logic_vector(111 downto 0) ;
  signal   use_test_data  : std_logic                      ;

	signal  dac_if_clk_out  :  std_logic                     ; -- 150MHZ
	signal  dac_out_clk     :  std_logic                     ; -- 150MHZ
	signal  dac_source_clk  :  std_logic                     ; -- 50MHZ
	signal  dac_source_rst  :  std_logic                     ;

	signal  dac_inp0_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp1_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp2_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp3_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp4_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp5_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp6_data     : std_logic_vector(13 downto 0) ;
	signal  dac_inp7_data     : std_logic_vector(13 downto 0) ;

  -- adc signal
  signal  data_rx_outclock  : std_logic        	            ;
  signal 	adc_demo_clk      : std_logic                     ;
	signal  adc_demo_p_clk    : std_logic                     ;
	signal  adc_demo_rst      : std_logic                     ;
  signal adc_demo_r_clk : std_logic ;

  signal demo_err_test      : std_logic                     ;
  signal adc_d0			        : std_logic_vector(11 downto 0) ;
	signal adc_d1			        : std_logic_vector(11 downto 0) ;
	signal adc_d2			        : std_logic_vector(11 downto 0) ;
	signal adc_d3             : std_logic_vector(11 downto 0) ;
	signal adc_d4			        : std_logic_vector(11 downto 0) ;
	signal adc_d5             : std_logic_vector(11 downto 0) ;
	signal adc_d6             : std_logic_vector(11 downto 0) ;
	signal adc_d7             : std_logic_vector(11 downto 0) ;


	signal demo_adc_d0        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d1        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d2        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d3        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d4        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d5        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d6        : std_logic_vector(7 downto 0) ;
  signal demo_adc_d7        : std_logic_vector(7 downto 0) ;

  signal dac_source_clk_25, adc_demo_r_clk_half : std_logic;
  signal d_src_is_GE, with_LDPC : std_logic;

  signal data_in_l : std_logic_vector(4 downto 0) ;

  signal dat_mux : std_logic_vector(3 downto 0) ;
  signal val_mux : std_logic;

  signal dac_source_clk_100 : std_logic;
  signal dout_ddioin_buffer : std_logic_vector(4 downto 0) ;


begin

rom_DAsin_inst: rom_DAsin
	PORT map
	(
		result(0)		=> use_test_data
	);

rom_dsource_inst: rom_dsource
	PORT map
	(
		result(0)		=> d_src_is_GE
	);


cnst_ifLDPC_inst: cnst_ifLDPC
	PORT map
	(
		result(0) => with_LDPC
	);


-- inst cpm
inst_cpm: cpm
port map
(
	adc_if_clk_out => data_rx_outclock ,  -- 100MHZ
	adc_demo_clk   => adc_demo_clk     ,  -- 100MHZ
	adc_demo_p_clk => adc_demo_p_clk   ,  -- 50MHZ
	adc_demo_r_clk => adc_demo_r_clk   , --75MHZ
	adc_demo_r_clk_half => adc_demo_r_clk_half, -- 37.5MHz
	adc_demo_rst   => adc_demo_rst     ,
	dac_if_clk_out => dac_if_clk_out   ,  -- 150MHZ
	dac_out_clk    => dac_out_clk      ,  -- 150MHZ
	dac_source_clk => dac_source_clk   ,  -- 50MHZ
	dac_source_clk_25 => dac_source_clk_25,  -- 25MHz, 2015/3/4 for LDPC Encoder Source Self-Gen
    dac_source_clk_100 => dac_source_clk_100,
	dac_source_rst => dac_source_rst
);


 -- inst dac module
dacout_inst: dacout
port map
(
 -- usr interface
 dac_usr_clk      => dac_if_clk_out,
 dac_usr_data     => dac_usr_data  ,
 use_test_data    => use_test_data ,
 -- dac chip interface
 --dac_dataclki     => dac_dataclki  ,
 dac_dataclko     => dac_dataclko  ,
 dac_data         => dac_data      ,
 dac_reset        => dac_reset     ,
 dac_irq          => dac_irq       ,
 dac_cs           => dac_cs        ,
 dac_sdio         => dac_sdio      ,
 dac_sclk         => dac_sclk      ,
 dac_sdo          => dac_sdo       ,
 dac_mode         => dac_mode      ,
 clk_toFPGA2		=> clk_toFPGA2
);


--ddio_fromF2_inst: ddio_fromF2
--	PORT map
--	(
--		aclr		=> dac_source_rst,
--		datain		=> d_fromFPGA2(4 downto 0),
--		inclock		=> d_fromFPGA2(5),
--		dataout_h		=> open,
--		dataout_l		=> data_in_l
--	);

ddioin_buffer_inst: ddioin_buffer
  port map(
  	aReset		=> dac_source_rst,
  	ddio_clk	=> d_fromFPGA2(5),
  	ddio_din	=> d_fromFPGA2(4 downto 0),
  	rdclk		=> dac_source_clk_100,

  	d_out 		=> dout_ddioin_buffer

  ) ;


dac_mod_inst: MOD_QPSK_16QAM
generic map
  (kOutSize => 14)
port map
  (
		aReset    => dac_source_rst ,
		clk_25	 => dac_source_clk_25,
		clk_50	  => dac_source_clk ,  -- 50MHZ
		clk_150	  => dac_out_clk    ,  -- 150MHZ
		--data_in  : in std_LOGIC_VECTOR(5 downto 0); -- ddio_in format  (5) clk (4) valid  (3..0) data
		ddio_clk  	=> dac_source_clk_100,
		ddio_din 	=> dout_ddioin_buffer(3 downto 0),
		ddio_wren 	=> dout_ddioin_buffer(4),
		d_src_is_GE => d_src_is_GE,
		with_LDPC => with_LDPC,
		IFData_0	=> dac_inp0_data  ,
		IFData_1	=> dac_inp1_data  ,
		IFData_2	=> dac_inp2_data  ,
		IFData_3  => dac_inp3_data  ,
		IFData_4	=> dac_inp4_data  ,
		IFData_5  => dac_inp5_data  ,
		IFData_6	=> dac_inp6_data  ,
		IFData_7  => dac_inp7_data
		);


	dac_usr_data	<= (dac_inp0_data(13)) & dac_inp0_data(12 downto 0) &
             	     (dac_inp1_data(13)) & dac_inp1_data(12 downto 0) &
							     (dac_inp2_data(13)) & dac_inp2_data(12 downto 0) &
							     (dac_inp3_data(13)) & dac_inp3_data(12 downto 0) &
							     (dac_inp4_data(13)) & dac_inp4_data(12 downto 0) &
							     (dac_inp5_data(13)) & dac_inp5_data(12 downto 0) &
							     (dac_inp6_data(13)) & dac_inp6_data(12 downto 0) &
							     (dac_inp7_data(13)) & dac_inp7_data(12 downto 0);




 -- inst adc moduel
adcin_inst: adin
port map
(
 --control interface
 adc_fsr          => adc_fsr          ,
 adc_ddrph        => adc_ddrph        ,
 adc_des          => adc_des          ,
 adc_ndm          => adc_ndm          ,
 adc_rst          => adc_rst          ,
 adc_sdo          => adc_sdo          ,
 adc_sclk         => adc_sclk         ,
 adc_sdi          => adc_sdi          ,
 adc_scs          => adc_scs          ,
 --data clk interface
 adc_dclki        => adc_dclki        ,
 adc_dclkq        => adc_dclkq        ,
 adc_di           => adc_di           ,
 adc_dq           => adc_dq           ,
 --adc usr interface
 adc_d0           => adc_d0           ,
 adc_d1           => adc_d1           ,
 adc_d2           => adc_d2           ,
 adc_d3           => adc_d3           ,
 adc_d4           => adc_d4           ,
 adc_d5           => adc_d5           ,
 adc_d6           => adc_d6           ,
 adc_d7           => adc_d7           ,
 data_rx_outclock => data_rx_outclock

);

-- adc output is binary offset format
-- convert binary offset data to two complete format
demo_adc_d0 <= (not adc_d0(11)) & adc_d0(10 downto 4) ;
demo_adc_d1 <= (not adc_d1(11)) & adc_d1(10 downto 4) ;
demo_adc_d2 <= (not adc_d2(11)) & adc_d2(10 downto 4) ;
demo_adc_d3 <= (not adc_d3(11)) & adc_d3(10 downto 4) ;
demo_adc_d4 <= (not adc_d4(11)) & adc_d4(10 downto 4) ;
demo_adc_d5 <= (not adc_d5(11)) & adc_d5(10 downto 4) ;
demo_adc_d6 <= (not adc_d6(11)) & adc_d6(10 downto 4) ;
demo_adc_d7 <= (not adc_d7(11)) & adc_d7(10 downto 4) ;

demo_inst:	Demod_Para
generic	map
   (
			kInSize  => 8
		)
port map
	(
		aReset    => adc_demo_rst        ,
		clk_100   => adc_demo_clk        ,
		pclk_I		=> adc_demo_p_clk      ,
		rclk       => adc_demo_r_clk ,
		rclk_half		=> adc_demo_r_clk_half,

		AD_d0			=> demo_adc_d0 ,
		AD_d1			=> demo_adc_d1 ,
		AD_d2			=> demo_adc_d2 ,
		AD_d3     => demo_adc_d3 ,
		AD_d4			=> demo_adc_d4 ,
		AD_d5     => demo_adc_d5 ,
		AD_d6     => demo_adc_d6 ,
		AD_d7     => demo_adc_d7 ,

		with_LDPC => with_LDPC,

		--err_test 	=> open,--demo_err_test,
		--d_toFPGA2	 : out std_logic_vector(5 downto 0)
		dat_mux => dat_mux,
		val_mux => val_mux,
    LED_out => LED_out

		);

	ddio_toF2_inst: ddio_toF2
	PORT map
	(
		aclr		=> adc_demo_rst,
		datain_h		=> ( '1' & val_mux & dat_mux(3) & dat_mux(2) & dat_mux(1) & dat_mux(0) ),
		datain_l		=> ( '0' & val_mux & dat_mux(3) & dat_mux(2) & dat_mux(1) & dat_mux(0) ),
		outclock		=> adc_demo_r_clk,
		dataout		=> d_toFPGA2
	);



end architecture rtl ;
