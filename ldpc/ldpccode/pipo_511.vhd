	library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


	entity pipo_511 is
	port
	(
		reset    :   in std_logic;
		clk      :   in std_logic;
		
		info_in  :   in std_logic_vector(510 downto 0);
		gen_in   :   in std_logic_vector(510 downto 0);
		
		pipo_out :   out std_logic_vector(7 downto 0)
	);
	end pipo_511;
	
	architecture rtl of pipo_511 is

	signal	g0 : std_logic_vector(510 downto 0);               
	signal	g1 : std_logic_vector(510 downto 0);  
	signal	g2 : std_logic_vector(510 downto 0); 
	signal	g3 : std_logic_vector(510 downto 0); 
	signal	g4 : std_logic_vector(510 downto 0);
	signal	g5 : std_logic_vector(510 downto 0); 
	signal	g6 : std_logic_vector(510 downto 0); 
	signal	g7 : std_logic_vector(510 downto 0); 
	
	component piso_511
	port
	(
		reset    :  in std_logic;
		clk      :  in std_logic;
		
		info_in  :  in std_logic_vector(510 downto 0);
		gen_in   :  in std_logic_vector(510 downto 0);
		
		piso_out  :  out std_logic
	);
	end component;
	
	begin
		g0  <=  gen_in;   
		g1  <=  g0(509 downto 0) & g0(510);
		g2  <=  g1(509 downto 0) & g1(510);
		g3  <=  g2(509 downto 0) & g2(510);
		g4  <=  g3(509 downto 0) & g3(510);
		g5  <=  g4(509 downto 0) & g4(510);
		g6  <=  g5(509 downto 0) & g5(510);
		g7  <=  g6(509 downto 0) & g6(510);
		
		

		piso_511_0  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g0,
			piso_out  =>  pipo_out(0)
		);
		
		piso_511_1  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g1,
			piso_out  =>  pipo_out(1)
		);
		
		piso_511_2  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g2,
			piso_out  =>  pipo_out(2)
		);
		
		piso_511_3  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g3,
			piso_out  =>  pipo_out(3)
		);
		
		piso_511_4  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g4,
			piso_out  =>  pipo_out(4)
		);
		
		piso_511_5  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g5,
			piso_out  =>  pipo_out(5)
		);
		
		piso_511_6  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g6,
			piso_out  =>  pipo_out(6)
		);
		
		piso_511_7  :  piso_511
		port map
		(
			reset     =>  reset,
			clk       =>  clk,
			info_in   =>  info_in,
			gen_in    =>  g7,
			piso_out  =>  pipo_out(7)
		);
	end rtl;
	