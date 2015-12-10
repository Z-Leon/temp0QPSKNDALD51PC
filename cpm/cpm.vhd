
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cpm is 
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
end entity cpm;
architecture rtl of cpm is
	
component dac_out_clk_pll IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END component;
	
component adc_out_clk_pll IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
	   c2    : out std_logic ;
		locked		: OUT STD_LOGIC 
	);
END component;


signal dac_clk_pll_lock : std_logic                    ;
signal dac_rst_cnt      : std_logic_vector(4 downto 0) ;
signal dac_rst_s        : std_logic                    ;
signal dac_source_clk_s : std_logic                    ;

signal adc_clk_pll_lock : std_logic                    ;
signal adc_rst_cnt      : std_logic_vector(4 downto 0) ;
signal adc_rst_s        : std_logic                    ;
signal adc_source_clk_s : std_logic                    ;       
signal adc_demo_p_clk_s : std_logic                    ;


begin 
	
	
dac_clk_pll_inst: dac_out_clk_pll 
port map
	(
		inclk0		=> dac_if_clk_out    ,
		c0		    => dac_source_clk_25,
		c1		    => dac_source_clk_s  ,
		c2			 => dac_source_clk_100,
		locked		=> dac_clk_pll_lock  
	);
	
dac_out_clk     <=  dac_if_clk_out   ;
dac_source_clk  <=  dac_source_clk_s ;	
	

	                                 
adc_out_clk_inst: adc_out_clk_pll 
port map
	(
		inclk0		=> adc_if_clk_out         ,
		c0		    => adc_demo_r_clk_half                 ,  --37.5MHz
		c1		    => adc_demo_p_clk_s       ,  -- 50MHZ
		c2        => adc_demo_r_clk   ,  -- 75MHz
		locked		=> adc_clk_pll_lock 
	);
	
adc_demo_clk    <= adc_if_clk_out   ;
adc_demo_p_clk  <= adc_demo_p_clk_s ;
--adc_demo_p_clk  <= adc_if_clk_out ;	

--dac rst control
process(dac_source_clk_s, dac_clk_pll_lock)
begin 
	 if (dac_clk_pll_lock = '0') then 
	 	   dac_rst_cnt <= (others =>'0') ;
	 elsif (rising_edge(dac_source_clk_s)) then 
	 	  if (dac_rst_cnt = "11111") then 
	 	  	dac_rst_cnt <= dac_rst_cnt;
	 	  else
	 	  	dac_rst_cnt <= dac_rst_cnt+1;
	 	  end if;
	 	end if;
end process;

process(dac_source_clk_s,dac_clk_pll_lock)
begin 
	 if (dac_clk_pll_lock = '0') then 
	 	   dac_rst_s <= '1' ;
	 elsif (rising_edge(dac_source_clk_s)) then 
	 	  if (dac_rst_cnt > "10000") then 
	 	  	dac_rst_s <= '0' ;
	 	  else
	 	  	dac_rst_s <= '1' ;
	 	  end if;
	 	end if;
end process;
	 	  
dac_source_rst <= dac_rst_s	;

	
-- adc demo reset control

process(adc_demo_p_clk_s,adc_clk_pll_lock)
begin 
	 if (adc_clk_pll_lock = '0') then 
	 	   adc_rst_cnt <= (others =>'0') ;
	 elsif (rising_edge(adc_demo_p_clk_s)) then 
	 	  if (adc_rst_cnt = "11111") then 
	 	  	adc_rst_cnt <= adc_rst_cnt;
	 	  else
	 	  	adc_rst_cnt <= adc_rst_cnt+1;
	 	  end if;
	 	end if;
end process;

process(adc_demo_p_clk_s,adc_clk_pll_lock)
begin 
	 if (adc_clk_pll_lock = '0') then 
	 	   adc_rst_s <= '1' ;
	 elsif (rising_edge(adc_demo_p_clk_s)) then 
	 	  if (adc_rst_cnt > "10000") then 
	 	  	adc_rst_s <= '0' ;
	 	  else
	 	  	adc_rst_s <= '1' ;
	 	  end if;
	 	end if;
end process;
	 	  
adc_demo_rst <= adc_rst_s	;
	
	
	
	
	
end architecture rtl ;
	