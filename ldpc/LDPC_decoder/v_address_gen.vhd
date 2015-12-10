library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity	v_address_gen	 is         
port( 
   clk    : in std_logic;
   reset  : in std_logic;
   v_address_a    : out std_logic_vector(223 downto 0);
	v_address_b    : out std_logic_vector(223 downto 0);
	v_address_a_dly: out std_logic_vector(223 downto 0);
	v_address_b_dly: out std_logic_vector(223 downto 0)
	);	 
end	v_address_gen;

architecture rtl of v_address_gen is
   signal v_address_a0    : unsigned(223 downto 0);
	signal v_address_b0    : unsigned(223 downto 0);
	signal v_address_a_dly0: unsigned(223 downto 0);
	signal v_address_b_dly0: unsigned(223 downto 0);
   
   begin
   process(clk,reset)
    begin
       if (reset='1') then
          v_address_a0 <=(conv_unsigned(0,7))  --1s
							&(conv_unsigned(62,7))  --4s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(60,7))  --8s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(45,7))  --1s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(62,7))  --7s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(57,7))  --3s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(61,7))  --6s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(38,7))  --6s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(59,7))  --4s
							&(conv_unsigned(51,7))  --5s
							&(conv_unsigned(47,7))  --6s
							&(conv_unsigned(39,7))  --2s
							&(conv_unsigned(31,7))  --4s
							&(conv_unsigned(37,7))  --1s
							&(conv_unsigned(28,7))  --6s
							&(conv_unsigned(57,7))  --8s
							&(conv_unsigned(39,7))  --7s
							&(conv_unsigned(29,7))  --7s
							&(conv_unsigned(26,7))  --2s
							&(conv_unsigned(51,7))  --8s
							&(conv_unsigned(40,7))  --1s
							&(conv_unsigned(33,7))  --4s
							&(conv_unsigned(18,7))  --4s
							&(conv_unsigned(57,7))  --5s,revised
							&(conv_unsigned(39,7));  --8s 
							
		v_address_b0 <= (conv_unsigned(105,7))  --8s
							&(conv_unsigned(98,7))  --1s
							&(conv_unsigned(83,7))  --8s
							&(conv_unsigned(74,7))  --1s
							&(conv_unsigned(78,7))  --8s
							&(conv_unsigned(76,7))  --7s
							&(conv_unsigned(84,7))  --1s
							&(conv_unsigned(83,7))  --1s
							&(conv_unsigned(89,7))  --5s
							&(conv_unsigned(86,7))  --7s
							&(conv_unsigned(102,7))  --1s
							&(conv_unsigned(92,7))  --7s
							&(conv_unsigned(78,7))  --1s
							&(conv_unsigned(70,7))  --7s
							&(conv_unsigned(97,7))  --1s
							&(conv_unsigned(95,7))  --3s
							&(conv_unsigned(69,7))  --1s
							&(conv_unsigned(68,7))  --7s
							&(conv_unsigned(73,7))  --5s
							&(conv_unsigned(68,7))  --2s
							&(conv_unsigned(75,7))  --4s
							&(conv_unsigned(67,7))  --7s
							&(conv_unsigned(78,7))  --4s
							&(conv_unsigned(72,7))  --3s
							&(conv_unsigned(74,7))  --2s
		 					&(conv_unsigned(71,7))  --5s
							&(conv_unsigned(80,7))  --5s
							&(conv_unsigned(79,7))  --6s
							&(conv_unsigned(69,7))  --5s
							&(conv_unsigned(69,7))  --2s
							&(conv_unsigned(80,7))  --2s
							&(conv_unsigned(76,7));  --2s					
		 
		v_address_a_dly0 <=(conv_unsigned(0,7))  --1s
							&(conv_unsigned(62,7))  --4s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(60,7))  --8s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(45,7))  --1s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(62,7))  --7s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(57,7))  --3s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(61,7))  --6s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(38,7))  --6s
							&(conv_unsigned(0,7))  --1s
							&(conv_unsigned(59,7))  --4s
							&(conv_unsigned(51,7))  --5s
							&(conv_unsigned(47,7))  --6s
							&(conv_unsigned(39,7))  --2s
							&(conv_unsigned(31,7))  --4s
							&(conv_unsigned(37,7))  --1s
							&(conv_unsigned(28,7))  --6s
							&(conv_unsigned(57,7))  --8s
							&(conv_unsigned(39,7))  --7s
							&(conv_unsigned(29,7))  --7s
							&(conv_unsigned(26,7))  --2s
							&(conv_unsigned(51,7))  --8s
							&(conv_unsigned(40,7))  --1s
							&(conv_unsigned(33,7))  --4s
							&(conv_unsigned(18,7))  --4s
							&(conv_unsigned(57,7))  --5s
							&(conv_unsigned(39,7));  --8s
							
		v_address_b_dly0 <=(conv_unsigned(105,7))  --8s
							&(conv_unsigned(98,7))  --1s
							&(conv_unsigned(83,7))  --8s
							&(conv_unsigned(74,7))  --1s
							&(conv_unsigned(78,7))  --8s
							&(conv_unsigned(76,7))  --7s
							&(conv_unsigned(84,7))  --1s
							&(conv_unsigned(83,7))  --1s
							&(conv_unsigned(89,7))  --5s
							&(conv_unsigned(86,7))  --7s
							&(conv_unsigned(102,7))  --1s
							&(conv_unsigned(92,7))  --7s
							&(conv_unsigned(78,7))  --1s
							&(conv_unsigned(70,7))  --7s
							&(conv_unsigned(97,7))  --1s
							&(conv_unsigned(95,7))  --3s
							&(conv_unsigned(69,7))  --1s
							&(conv_unsigned(68,7))  --7s
							&(conv_unsigned(73,7))  --5s
							&(conv_unsigned(68,7))  --2s
							&(conv_unsigned(75,7))  --4s
							&(conv_unsigned(67,7))  --7s
							&(conv_unsigned(78,7))  --4s
							&(conv_unsigned(72,7))  --3s
							&(conv_unsigned(74,7))  --2s
		 					&(conv_unsigned(71,7))  --5s
							&(conv_unsigned(80,7))  --5s
							&(conv_unsigned(79,7))  --6s
							&(conv_unsigned(69,7))  --5s
							&(conv_unsigned(69,7))  --2s
							&(conv_unsigned(80,7))  --2s
							&(conv_unsigned(76,7));  --2s					
			
		  elsif (clk'event and clk='1') then
		      v_address_a0(5 downto 0) <= v_address_a0(5 downto 0) + 1;
				v_address_b0(5 downto 0) <= v_address_b0(5 downto 0) + 1;
				v_address_a0(12 downto 7) <= v_address_a0(12 downto 7) + 1;
				v_address_b0(12 downto 7) <= v_address_b0(12 downto 7) + 1;
				v_address_a0(19 downto 14) <= v_address_a0(19 downto 14) + 1;
				v_address_b0(19 downto 14) <= v_address_b0(19 downto 14) + 1;
				v_address_a0(26 downto 21) <= v_address_a0(26 downto 21) + 1;
				v_address_b0(26 downto 21) <= v_address_b0(26 downto 21) + 1;
				v_address_a0(33 downto 28) <= v_address_a0(33 downto 28) + 1;
				v_address_b0(33 downto 28) <= v_address_b0(33 downto 28) + 1;
				v_address_a0(40 downto 35) <= v_address_a0(40 downto 35) + 1;
				v_address_b0(40 downto 35) <= v_address_b0(40 downto 35) + 1;
				v_address_a0(47 downto 42) <= v_address_a0(47 downto 42) + 1;
				v_address_b0(47 downto 42) <= v_address_b0(47 downto 42) + 1;
				v_address_a0(54 downto 49) <= v_address_a0(54 downto 49) + 1;
				v_address_b0(54 downto 49) <= v_address_b0(54 downto 49) + 1;
				v_address_a0(61 downto 56) <= v_address_a0(61 downto 56) + 1;
				v_address_b0(61 downto 56) <= v_address_b0(61 downto 56) + 1;
				v_address_a0(68 downto 63) <= v_address_a0(68 downto 63) + 1;
				v_address_b0(68 downto 63) <= v_address_b0(68 downto 63) + 1;
				v_address_a0(75 downto 70) <= v_address_a0(75 downto 70) + 1;
				v_address_b0(75 downto 70) <= v_address_b0(75 downto 70) + 1;
				v_address_a0(82 downto 77) <= v_address_a0(82 downto 77) + 1;
				v_address_b0(82 downto 77) <= v_address_b0(82 downto 77) + 1;
				v_address_a0(89 downto 84) <= v_address_a0(89 downto 84) + 1;
				v_address_b0(89 downto 84) <= v_address_b0(89 downto 84) + 1;
				v_address_a0(96 downto 91) <= v_address_a0(96 downto 91) + 1;
				v_address_b0(96 downto 91) <= v_address_b0(96 downto 91) + 1;
				v_address_a0(103 downto 98) <= v_address_a0(103 downto 98) + 1;
				v_address_b0(103 downto 98) <= v_address_b0(103 downto 98) + 1;
				v_address_a0(110 downto 105) <= v_address_a0(110 downto 105) + 1;
				v_address_b0(110 downto 105) <= v_address_b0(110 downto 105) + 1;
				v_address_a0(117 downto 112) <= v_address_a0(117 downto 112) + 1;
				v_address_b0(117 downto 112) <= v_address_b0(117 downto 112) + 1;
				v_address_a0(124 downto 119) <= v_address_a0(124 downto 119) + 1;
				v_address_b0(124 downto 119) <= v_address_b0(124 downto 119) + 1;
				v_address_a0(131 downto 126) <= v_address_a0(131 downto 126) + 1;
				v_address_b0(131 downto 126) <= v_address_b0(131 downto 126) + 1;
				v_address_a0(138 downto 133) <= v_address_a0(138 downto 133) + 1;
				v_address_b0(138 downto 133) <= v_address_b0(138 downto 133) + 1;
				v_address_a0(145 downto 140) <= v_address_a0(145 downto 140) + 1;
				v_address_b0(145 downto 140) <= v_address_b0(145 downto 140) + 1;
				v_address_a0(152 downto 147) <= v_address_a0(152 downto 147) + 1;
				v_address_b0(152 downto 147) <= v_address_b0(152 downto 147) + 1;
				v_address_a0(159 downto 154) <= v_address_a0(159 downto 154) + 1;
				v_address_b0(159 downto 154) <= v_address_b0(159 downto 154) + 1;
				v_address_a0(166 downto 161) <= v_address_a0(166 downto 161) + 1;
				v_address_b0(166 downto 161) <= v_address_b0(166 downto 161) + 1;
				v_address_a0(173 downto 168) <= v_address_a0(173 downto 168) + 1;
				v_address_b0(173 downto 168) <= v_address_b0(173 downto 168) + 1;
				v_address_a0(180 downto 175) <= v_address_a0(180 downto 175) + 1;
				v_address_b0(180 downto 175) <= v_address_b0(180 downto 175) + 1;
				v_address_a0(187 downto 182) <= v_address_a0(187 downto 182) + 1;
				v_address_b0(187 downto 182) <= v_address_b0(187 downto 182) + 1;
				v_address_a0(194 downto 189) <= v_address_a0(194 downto 189) + 1;
				v_address_b0(194 downto 189) <= v_address_b0(194 downto 189) + 1;
				v_address_a0(201 downto 196) <= v_address_a0(201 downto 196) + 1;
				v_address_b0(201 downto 196) <= v_address_b0(201 downto 196) + 1;
				v_address_a0(208 downto 203) <= v_address_a0(208 downto 203) + 1;
				v_address_b0(208 downto 203) <= v_address_b0(208 downto 203) + 1;
				v_address_a0(215 downto 210) <= v_address_a0(215 downto 210) + 1;
				v_address_b0(215 downto 210) <= v_address_b0(215 downto 210) + 1;
				v_address_a0(222 downto 217) <= v_address_a0(222 downto 217) + 1;
				v_address_b0(222 downto 217) <= v_address_b0(222 downto 217) + 1;
			
				v_address_a_dly0(5 downto 0) <=  v_address_a0(5 downto 0) - 10;
				v_address_b_dly0(5 downto 0) <=  v_address_b0(5 downto 0) - 10;
				v_address_a_dly0(12 downto 7) <=  v_address_a0(12 downto 7) - 10;
				v_address_b_dly0(12 downto 7) <=  v_address_b0(12 downto 7) - 10;
				v_address_a_dly0(19 downto 14) <=  v_address_a0(19 downto 14) - 10;
				v_address_b_dly0(19 downto 14) <=  v_address_b0(19 downto 14) - 10;
				v_address_a_dly0(26 downto 21) <=  v_address_a0(26 downto 21) - 10;
				v_address_b_dly0(26 downto 21) <=  v_address_b0(26 downto 21) - 10;
				v_address_a_dly0(33 downto 28) <=  v_address_a0(33 downto 28) - 10;
				v_address_b_dly0(33 downto 28) <=  v_address_b0(33 downto 28) - 10;
				v_address_a_dly0(40 downto 35) <=  v_address_a0(40 downto 35) - 10;
				v_address_b_dly0(40 downto 35) <=  v_address_b0(40 downto 35) - 10;
				v_address_a_dly0(47 downto 42) <=  v_address_a0(47 downto 42) - 10;
				v_address_b_dly0(47 downto 42) <=  v_address_b0(47 downto 42) - 10;
				v_address_a_dly0(54 downto 49) <=  v_address_a0(54 downto 49) - 10;
				v_address_b_dly0(54 downto 49) <=  v_address_b0(54 downto 49) - 10;
				v_address_a_dly0(61 downto 56) <=  v_address_a0(61 downto 56) - 10;
				v_address_b_dly0(61 downto 56) <=  v_address_b0(61 downto 56) - 10;
				v_address_a_dly0(68 downto 63) <=  v_address_a0(68 downto 63) - 10;
				v_address_b_dly0(68 downto 63) <=  v_address_b0(68 downto 63) - 10;
				v_address_a_dly0(75 downto 70) <=  v_address_a0(75 downto 70) - 10;
				v_address_b_dly0(75 downto 70) <=  v_address_b0(75 downto 70) - 10;
				v_address_a_dly0(82 downto 77) <=  v_address_a0(82 downto 77) - 10;
				v_address_b_dly0(82 downto 77) <=  v_address_b0(82 downto 77) - 10;
				v_address_a_dly0(89 downto 84) <=  v_address_a0(89 downto 84) - 10;
				v_address_b_dly0(89 downto 84) <=  v_address_b0(89 downto 84) - 10;
				v_address_a_dly0(96 downto 91) <=  v_address_a0(96 downto 91) - 10;
				v_address_b_dly0(96 downto 91) <=  v_address_b0(96 downto 91) - 10;
				v_address_a_dly0(103 downto 98) <=  v_address_a0(103 downto 98) - 10;
				v_address_b_dly0(103 downto 98) <=  v_address_b0(103 downto 98) - 10;
				v_address_a_dly0(110 downto 105) <=  v_address_a0(110 downto 105) - 10;
				v_address_b_dly0(110 downto 105) <=  v_address_b0(110 downto 105) - 10;
				v_address_a_dly0(117 downto 112) <=  v_address_a0(117 downto 112) - 10;
				v_address_b_dly0(117 downto 112) <=  v_address_b0(117 downto 112) - 10;
				v_address_a_dly0(124 downto 119) <=  v_address_a0(124 downto 119) - 10;
				v_address_b_dly0(124 downto 119) <=  v_address_b0(124 downto 119) - 10;
				v_address_a_dly0(131 downto 126) <=  v_address_a0(131 downto 126) - 10;
				v_address_b_dly0(131 downto 126) <=  v_address_b0(131 downto 126) - 10;
				v_address_a_dly0(138 downto 133) <=  v_address_a0(138 downto 133) - 10;
				v_address_b_dly0(138 downto 133) <=  v_address_b0(138 downto 133) - 10;
				v_address_a_dly0(145 downto 140) <=  v_address_a0(145 downto 140) - 10;
				v_address_b_dly0(145 downto 140) <=  v_address_b0(145 downto 140) - 10;
				v_address_a_dly0(152 downto 147) <=  v_address_a0(152 downto 147) - 10;
				v_address_b_dly0(152 downto 147) <=  v_address_b0(152 downto 147) - 10;
				v_address_a_dly0(159 downto 154) <=  v_address_a0(159 downto 154) - 10;
				v_address_b_dly0(159 downto 154) <=  v_address_b0(159 downto 154) - 10;
				v_address_a_dly0(166 downto 161) <=  v_address_a0(166 downto 161) - 10;
				v_address_b_dly0(166 downto 161) <=  v_address_b0(166 downto 161) - 10;
				v_address_a_dly0(173 downto 168) <=  v_address_a0(173 downto 168) - 10;
				v_address_b_dly0(173 downto 168) <=  v_address_b0(173 downto 168) - 10;
				v_address_a_dly0(180 downto 175) <=  v_address_a0(180 downto 175) - 10;
				v_address_b_dly0(180 downto 175) <=  v_address_b0(180 downto 175) - 10;
				v_address_a_dly0(187 downto 182) <=  v_address_a0(187 downto 182) - 10;
				v_address_b_dly0(187 downto 182) <=  v_address_b0(187 downto 182) - 10;
				v_address_a_dly0(194 downto 189) <=  v_address_a0(194 downto 189) - 10;
				v_address_b_dly0(194 downto 189) <=  v_address_b0(194 downto 189) - 10;
				v_address_a_dly0(201 downto 196) <=  v_address_a0(201 downto 196) - 10;
				v_address_b_dly0(201 downto 196) <=  v_address_b0(201 downto 196) - 10;
				v_address_a_dly0(208 downto 203) <=  v_address_a0(208 downto 203) - 10;
				v_address_b_dly0(208 downto 203) <=  v_address_b0(208 downto 203) - 10;
				v_address_a_dly0(215 downto 210) <=  v_address_a0(215 downto 210) - 10;
				v_address_b_dly0(215 downto 210) <=  v_address_b0(215 downto 210) - 10;
				v_address_a_dly0(222 downto 217) <=  v_address_a0(222 downto 217) - 10;
				v_address_b_dly0(222 downto 217) <=  v_address_b0(222 downto 217) - 10;
		  end if;
    end process; 
     v_address_a<=std_logic_vector(v_address_a0);
	  v_address_b<=std_logic_vector(v_address_b0);
	  v_address_a_dly<=std_logic_vector(v_address_a_dly0);
	  v_address_b_dly<=std_logic_vector(v_address_b_dly0);
	 end rtl;