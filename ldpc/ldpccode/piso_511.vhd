	library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
    
	entity piso_511 is
	port
	(
		reset    :  in std_logic;
		clk      :  in std_logic;
		
		info_in  :  in std_logic_vector(510 downto 0);
		gen_in   :  in std_logic_vector(510 downto 0);
		
		piso_out  :  out std_logic
	);
	end piso_511;
	
	architecture rtl of piso_511 is
	
	function xor_br( s : std_logic_vector(7 downto 0) ) return std_logic is
	variable result1 : std_logic;
	variable result2 : std_logic;
	variable result3 : std_logic;
	variable result4 : std_logic;
	variable result5 : std_logic;
	variable result6 : std_logic;
	variable result  : std_logic;
	begin
		result1 := s(0) xor s(1);
		result2 := s(2) xor s(3);
		result3 := s(4) xor s(5);
		result4 := s(6) xor s(7);
		result5 := result1 xor result2;
		result6 := result3 xor result4;
		result  := result5 xor result6;
	    return result;
	end function;
	
	signal xor_reg       :  std_logic_vector(63 downto 0);
	signal xor_reg_dly1  :  std_logic_vector(7 downto 0);
	signal xor_reg_dly2  :  std_logic;
	signal and_reg       :  std_logic_vector(510 downto 0);
	
	begin
	
		and_reg  <=  info_in and gen_in;
		
		piso_out <= xor_reg_dly2;
		
		process ( reset , clk )
		begin
		  if ( reset = '1' ) then 
			xor_reg <= (others=>'0');
			xor_reg_dly1 <= (others=>'0');
			xor_reg_dly2 <= '0';
		  elsif rising_edge(clk) then                                    
                xor_reg(63)<= xor_br ('0' & and_reg(510 downto 504));
				xor_reg(62)<= xor_br (and_reg(503 downto 496)); 
				xor_reg(61)<= xor_br (and_reg(495 downto 488));
				xor_reg(60)<= xor_br (and_reg(487 downto 480));
				xor_reg(59)<= xor_br (and_reg(479 downto 472));
				xor_reg(58)<= xor_br (and_reg(471 downto 464));
				xor_reg(57)<= xor_br (and_reg(463 downto 456));
				xor_reg(56)<= xor_br (and_reg(455 downto 448));
				xor_reg(55)<= xor_br (and_reg(447 downto 440));
				xor_reg(54)<= xor_br (and_reg(439 downto 432));
				xor_reg(53)<= xor_br (and_reg(431 downto 424));
				xor_reg(52)<= xor_br (and_reg(423 downto 416));
				xor_reg(51)<= xor_br (and_reg(415 downto 408));
				xor_reg(50)<= xor_br (and_reg(407 downto 400));
				xor_reg(49)<= xor_br (and_reg(399 downto 392));
				xor_reg(48)<= xor_br (and_reg(391 downto 384));
				xor_reg(47)<= xor_br (and_reg(383 downto 376));
				xor_reg(46)<= xor_br (and_reg(375 downto 368));
				xor_reg(45)<= xor_br (and_reg(367 downto 360));
				xor_reg(44)<= xor_br (and_reg(359 downto 352));
				xor_reg(43)<= xor_br (and_reg(351 downto 344));
				xor_reg(42)<= xor_br (and_reg(343 downto 336));
				xor_reg(41)<= xor_br (and_reg(335 downto 328));
				xor_reg(40)<= xor_br (and_reg(327 downto 320));
				xor_reg(39)<= xor_br (and_reg(319 downto 312));
				xor_reg(38)<= xor_br (and_reg(311 downto 304));
				xor_reg(37)<= xor_br (and_reg(303 downto 296));
				xor_reg(36)<= xor_br (and_reg(295 downto 288));
				xor_reg(35)<= xor_br (and_reg(287 downto 280));
				xor_reg(34)<= xor_br (and_reg(279 downto 272));
				xor_reg(33)<= xor_br (and_reg(271 downto 264));
				xor_reg(32)<= xor_br (and_reg(263 downto 256));
				xor_reg(31)<= xor_br (and_reg(255 downto 248));
				xor_reg(30)<= xor_br (and_reg(247 downto 240));
				xor_reg(29)<= xor_br (and_reg(239 downto 232));
				xor_reg(28)<= xor_br (and_reg(231 downto 224));
				xor_reg(27)<= xor_br (and_reg(223 downto 216));
				xor_reg(26)<= xor_br (and_reg(215 downto 208));
				xor_reg(25)<= xor_br (and_reg(207 downto 200));
				xor_reg(24)<= xor_br (and_reg(199 downto 192));
				xor_reg(23)<= xor_br (and_reg(191 downto 184));
				xor_reg(22)<= xor_br (and_reg(183 downto 176));
				xor_reg(21)<= xor_br (and_reg(175 downto 168));
				xor_reg(20)<= xor_br (and_reg(167 downto 160));
				xor_reg(19)<= xor_br (and_reg(159 downto 152));
				xor_reg(18)<= xor_br (and_reg(151 downto 144));
				xor_reg(17)<= xor_br (and_reg(143 downto 136));  
				xor_reg(16)<= xor_br (and_reg(135 downto 128)); 
				xor_reg(15)<= xor_br (and_reg(127 downto 120));
				xor_reg(14)<= xor_br (and_reg(119 downto 112));
				xor_reg(13)<= xor_br (and_reg(111 downto 104));
				xor_reg(12)<= xor_br (and_reg(103 downto 96));
				xor_reg(11)<= xor_br (and_reg(95 downto 88));
				xor_reg(10)<= xor_br (and_reg(87 downto 80));
				xor_reg(9)<= xor_br (and_reg(79 downto 72));
				xor_reg(8)<= xor_br (and_reg(71 downto 64));
				xor_reg(7)<= xor_br (and_reg(63 downto 56));
				xor_reg(6)<= xor_br (and_reg(55 downto 48));
				xor_reg(5)<= xor_br (and_reg(47 downto 40));
				xor_reg(4)<= xor_br (and_reg(39 downto 32));
				xor_reg(3)<= xor_br (and_reg(31 downto 24));
				xor_reg(2)<= xor_br (and_reg(23 downto 16));
				xor_reg(1)<= xor_br (and_reg(15 downto 8));
				xor_reg(0)<= xor_br (and_reg(7 downto 0));
				
				xor_reg_dly1(7) <= xor_br (xor_reg(63 downto 56));
				xor_reg_dly1(6) <= xor_br (xor_reg(55 downto 48));
				xor_reg_dly1(5) <= xor_br (xor_reg(47 downto 40));
				xor_reg_dly1(4) <= xor_br (xor_reg(39 downto 32));
				xor_reg_dly1(3) <= xor_br (xor_reg(31 downto 24));
				xor_reg_dly1(2) <= xor_br (xor_reg(23 downto 16));
				xor_reg_dly1(1) <= xor_br (xor_reg(15 downto 8));
				xor_reg_dly1(0) <= xor_br (xor_reg(7 downto 0));
				
				xor_reg_dly2 <= xor_br (xor_reg_dly1);
		  end if;
		 end process;

	end rtl;
