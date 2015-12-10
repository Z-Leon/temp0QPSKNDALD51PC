library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ldpc_buffer_align	 is         
port(
   clk         : in std_logic;
   reset       : in std_logic;
   mux_control : in std_logic;
   ch_message  : in std_logic_vector(511 downto 0);
   data_in     : in std_logic_vector(511 downto 0);
   data_out    : out std_logic_vector(127 downto 0)
	);	 
end	ldpc_buffer_align;

architecture rtl of ldpc_buffer_align is
    
  signal data_reg1,data_reg2 :std_logic_vector(127 downto 0);
  signal data_align :std_logic_vector(127 downto 0);
 
 begin 
  
  data_out <= data_reg2;
  
  process(clk,reset)
      begin
      if (reset='1') then
          data_reg1 <=(others=>'0');
		    data_reg2 <=(others=>'0');
		   elsif (clk'event and clk='1') then
		    data_reg1 <= data_align;
		    data_reg2 <= data_reg1;
		end if;
  end process;
 
 data_align(0) <=not(ch_message(3))  when  mux_control='1' else not(data_in(3));
 data_align(1) <=not(ch_message(7))  when  mux_control='1' else not(data_in(7));
 data_align(2) <=not(ch_message(11))  when  mux_control='1' else not(data_in(11));
 data_align(3) <=not(ch_message(15))  when  mux_control='1' else not(data_in(15));
 data_align(4) <=not(ch_message(19))  when  mux_control='1' else not(data_in(19));
 data_align(5) <=not(ch_message(23))  when  mux_control='1' else not(data_in(23));
 data_align(6) <=not(ch_message(27))  when  mux_control='1' else not(data_in(27));
 data_align(7) <=not(ch_message(31))  when  mux_control='1' else not(data_in(31));
 data_align(8) <=not(ch_message(35))  when  mux_control='1' else not(data_in(35));
 data_align(9) <=not(ch_message(39))  when  mux_control='1' else not(data_in(39));
 data_align(10) <=not(ch_message(43))  when  mux_control='1' else not(data_in(43));
 data_align(11) <=not(ch_message(47))  when  mux_control='1' else not(data_in(47));
 data_align(12) <=not(ch_message(51))  when  mux_control='1' else not(data_in(51));
 data_align(13) <=not(ch_message(55))  when  mux_control='1' else not(data_in(55));
 data_align(14) <=not(ch_message(59))  when  mux_control='1' else not(data_in(59));
 data_align(15) <=not(ch_message(63))  when  mux_control='1' else not(data_in(63));
 data_align(16) <=not(ch_message(67))  when  mux_control='1' else not(data_in(67));
 data_align(17) <=not(ch_message(71))  when  mux_control='1' else not(data_in(71));
 data_align(18) <=not(ch_message(75))  when  mux_control='1' else not(data_in(75));
 data_align(19) <=not(ch_message(79))  when  mux_control='1' else not(data_in(79));
 data_align(20) <=not(ch_message(83))  when  mux_control='1' else not(data_in(83));
 data_align(21) <=not(ch_message(87))  when  mux_control='1' else not(data_in(87));
 data_align(22) <=not(ch_message(91))  when  mux_control='1' else not(data_in(91));
 data_align(23) <=not(ch_message(95))  when  mux_control='1' else not(data_in(95));
 data_align(24) <=not(ch_message(99))  when  mux_control='1' else not(data_in(99));
 data_align(25) <=not(ch_message(103))  when  mux_control='1' else not(data_in(103));
 data_align(26) <=not(ch_message(107))  when  mux_control='1' else not(data_in(107));
 data_align(27) <=not(ch_message(111))  when  mux_control='1' else not(data_in(111));
 data_align(28) <=not(ch_message(115))  when  mux_control='1' else not(data_in(115));
 data_align(29) <=not(ch_message(119))  when  mux_control='1' else not(data_in(119));
 data_align(30) <=not(ch_message(123))  when  mux_control='1' else not(data_in(123));
 data_align(31) <=not(ch_message(127))  when  mux_control='1' else not(data_in(127));
 data_align(32) <=not(ch_message(131))  when  mux_control='1' else not(data_in(131));
 data_align(33) <=not(ch_message(135))  when  mux_control='1' else not(data_in(135));
 data_align(34) <=not(ch_message(139))  when  mux_control='1' else not(data_in(139));
 data_align(35) <=not(ch_message(143))  when  mux_control='1' else not(data_in(143));
 data_align(36) <=not(ch_message(147))  when  mux_control='1' else not(data_in(147));
 data_align(37) <=not(ch_message(151))  when  mux_control='1' else not(data_in(151));
 data_align(38) <=not(ch_message(155))  when  mux_control='1' else not(data_in(155));
 data_align(39) <=not(ch_message(159))  when  mux_control='1' else not(data_in(159));
 data_align(40) <=not(ch_message(163))  when  mux_control='1' else not(data_in(163));
 data_align(41) <=not(ch_message(167))  when  mux_control='1' else not(data_in(167));
 data_align(42) <=not(ch_message(171))  when  mux_control='1' else not(data_in(171));
 data_align(43) <=not(ch_message(175))  when  mux_control='1' else not(data_in(175));
 data_align(44) <=not(ch_message(179))  when  mux_control='1' else not(data_in(179));
 data_align(45) <=not(ch_message(183))  when  mux_control='1' else not(data_in(183));
 data_align(46) <=not(ch_message(187))  when  mux_control='1' else not(data_in(187));
 data_align(47) <=not(ch_message(191))  when  mux_control='1' else not(data_in(191));
 data_align(48) <=not(ch_message(195))  when  mux_control='1' else not(data_in(195));
 data_align(49) <=not(ch_message(199))  when  mux_control='1' else not(data_in(199));
 data_align(50) <=not(ch_message(203))  when  mux_control='1' else not(data_in(203));
 data_align(51) <=not(ch_message(207))  when  mux_control='1' else not(data_in(207));
 data_align(52) <=not(ch_message(211))  when  mux_control='1' else not(data_in(211));
 data_align(53) <=not(ch_message(215))  when  mux_control='1' else not(data_in(215));
 data_align(54) <=not(ch_message(219))  when  mux_control='1' else not(data_in(219));
 data_align(55) <=not(ch_message(223))  when  mux_control='1' else not(data_in(223));
 data_align(56) <=not(ch_message(227))  when  mux_control='1' else not(data_in(227));
 data_align(57) <=not(ch_message(231))  when  mux_control='1' else not(data_in(231));
 data_align(58) <=not(ch_message(235))  when  mux_control='1' else not(data_in(235));
 data_align(59) <=not(ch_message(239))  when  mux_control='1' else not(data_in(239));
 data_align(60) <=not(ch_message(243))  when  mux_control='1' else not(data_in(243));
 data_align(61) <=not(ch_message(247))  when  mux_control='1' else not(data_in(247));
 data_align(62) <=not(ch_message(251))  when  mux_control='1' else not(data_in(251));
 data_align(63) <=not(ch_message(255))  when  mux_control='1' else not(data_in(255));
 data_align(64) <=not(ch_message(259))  when  mux_control='1' else not(data_in(259));
 data_align(65) <=not(ch_message(263))  when  mux_control='1' else not(data_in(263));
 data_align(66) <=not(ch_message(267))  when  mux_control='1' else not(data_in(267));
 data_align(67) <=not(ch_message(271))  when  mux_control='1' else not(data_in(271));
 data_align(68) <=not(ch_message(275))  when  mux_control='1' else not(data_in(275));
 data_align(69) <=not(ch_message(279))  when  mux_control='1' else not(data_in(279));
 data_align(70) <=not(ch_message(283))  when  mux_control='1' else not(data_in(283));
 data_align(71) <=not(ch_message(287))  when  mux_control='1' else not(data_in(287));
 data_align(72) <=not(ch_message(291))  when  mux_control='1' else not(data_in(291));
 data_align(73) <=not(ch_message(295))  when  mux_control='1' else not(data_in(295));
 data_align(74) <=not(ch_message(299))  when  mux_control='1' else not(data_in(299));
 data_align(75) <=not(ch_message(303))  when  mux_control='1' else not(data_in(303));
 data_align(76) <=not(ch_message(307))  when  mux_control='1' else not(data_in(307));
 data_align(77) <=not(ch_message(311))  when  mux_control='1' else not(data_in(311));
 data_align(78) <=not(ch_message(315))  when  mux_control='1' else not(data_in(315));
 data_align(79) <=not(ch_message(319))  when  mux_control='1' else not(data_in(319));
 data_align(80) <=not(ch_message(323))  when  mux_control='1' else not(data_in(323));
 data_align(81) <=not(ch_message(327))  when  mux_control='1' else not(data_in(327));
 data_align(82) <=not(ch_message(331))  when  mux_control='1' else not(data_in(331));
 data_align(83) <=not(ch_message(335))  when  mux_control='1' else not(data_in(335));
 data_align(84) <=not(ch_message(339))  when  mux_control='1' else not(data_in(339));
 data_align(85) <=not(ch_message(343))  when  mux_control='1' else not(data_in(343));
 data_align(86) <=not(ch_message(347))  when  mux_control='1' else not(data_in(347));
 data_align(87) <=not(ch_message(351))  when  mux_control='1' else not(data_in(351));
 data_align(88) <=not(ch_message(355))  when  mux_control='1' else not(data_in(355));
 data_align(89) <=not(ch_message(359))  when  mux_control='1' else not(data_in(359));
 data_align(90) <=not(ch_message(363))  when  mux_control='1' else not(data_in(363));
 data_align(91) <=not(ch_message(367))  when  mux_control='1' else not(data_in(367));
 data_align(92) <=not(ch_message(371))  when  mux_control='1' else not(data_in(371));
 data_align(93) <=not(ch_message(375))  when  mux_control='1' else not(data_in(375));
 data_align(94) <=not(ch_message(379))  when  mux_control='1' else not(data_in(379));
 data_align(95) <=not(ch_message(383))  when  mux_control='1' else not(data_in(383));
 data_align(96) <=not(ch_message(387))  when  mux_control='1' else not(data_in(387));
 data_align(97) <=not(ch_message(391))  when  mux_control='1' else not(data_in(391));
 data_align(98) <=not(ch_message(395))  when  mux_control='1' else not(data_in(395));
 data_align(99) <=not(ch_message(399))  when  mux_control='1' else not(data_in(399));
 data_align(100) <=not(ch_message(403))  when  mux_control='1' else not(data_in(403));
 data_align(101) <=not(ch_message(407))  when  mux_control='1' else not(data_in(407));
 data_align(102) <=not(ch_message(411))  when  mux_control='1' else not(data_in(411));
 data_align(103) <=not(ch_message(415))  when  mux_control='1' else not(data_in(415));
 data_align(104) <=not(ch_message(419))  when  mux_control='1' else not(data_in(419));
 data_align(105) <=not(ch_message(423))  when  mux_control='1' else not(data_in(423));
 data_align(106) <=not(ch_message(427))  when  mux_control='1' else not(data_in(427));
 data_align(107) <=not(ch_message(431))  when  mux_control='1' else not(data_in(431));
 data_align(108) <=not(ch_message(435))  when  mux_control='1' else not(data_in(435));
 data_align(109) <=not(ch_message(439))  when  mux_control='1' else not(data_in(439));
 data_align(110) <=not(ch_message(443))  when  mux_control='1' else not(data_in(443));
 data_align(111) <=not(ch_message(447))  when  mux_control='1' else not(data_in(447));
 data_align(112) <=not(ch_message(451))  when  mux_control='1' else not(data_in(451));
 data_align(113) <=not(ch_message(455))  when  mux_control='1' else not(data_in(455));
 data_align(114) <=not(ch_message(459))  when  mux_control='1' else not(data_in(459));
 data_align(115) <=not(ch_message(463))  when  mux_control='1' else not(data_in(463));
 data_align(116) <=not(ch_message(467))  when  mux_control='1' else not(data_in(467));
 data_align(117) <=not(ch_message(471))  when  mux_control='1' else not(data_in(471));
 data_align(118) <=not(ch_message(475))  when  mux_control='1' else not(data_in(475));
 data_align(119) <=not(ch_message(479))  when  mux_control='1' else not(data_in(479));
 data_align(120) <=not(ch_message(483))  when  mux_control='1' else not(data_in(483));
 data_align(121) <=not(ch_message(487))  when  mux_control='1' else not(data_in(487));
 data_align(122) <=not(ch_message(491))  when  mux_control='1' else not(data_in(491));
 data_align(123) <=not(ch_message(495))  when  mux_control='1' else not(data_in(495));
 data_align(124) <=not(ch_message(499))  when  mux_control='1' else not(data_in(499));
 data_align(125) <=not(ch_message(503))  when  mux_control='1' else not(data_in(503));
 data_align(126) <=not(ch_message(507))  when  mux_control='1' else not(data_in(507));
 data_align(127) <=not(ch_message(511))  when  mux_control='1' else not(data_in(511));
  
end rtl;