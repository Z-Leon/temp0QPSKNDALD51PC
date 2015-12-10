library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	c_address_gen	 is         
port(
	 clk         : in std_logic;
	 reset       : in std_logic;
	 
	 c_address_a : out std_logic_vector(223 downto 0);
	 c_address_b : out std_logic_vector(223 downto 0);
	 
    c_address_a_dly : out std_logic_vector(223 downto 0); 
	 c_address_b_dly : out std_logic_vector(223 downto 0)
	   );	 
end	c_address_gen;

architecture rtl of c_address_gen is
    
   signal c_address_a0 :  std_logic_vector(223 downto 0);
	signal c_address_b0 :  std_logic_vector(223 downto 0);
	 
   signal c_address_a_dly0 :  std_logic_vector(223 downto 0); 
	signal c_address_b_dly0 :  std_logic_vector(223 downto 0);
	
	begin 
	    
	process(clk,reset) 
    begin
      if (reset='1') then
      c_address_a0 <=(others=>'0');
		c_address_b0 <="1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"& "1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000";
		c_address_a_dly0 <=(others=>'0');
		c_address_b_dly0 <="1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"& "1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000"&"1000000";
      elsif rising_edge(clk) then
      c_address_a0(5 downto 0) <= c_address_a0(5 downto 0) + "000001";
		c_address_b0(5 downto 0) <= c_address_b0(5 downto 0) + "000001";
		c_address_a0(12 downto 7) <= c_address_a0(12 downto 7) + "000001";
		c_address_b0(12 downto 7) <= c_address_b0(12 downto 7) + "000001";
		c_address_a0(19 downto 14) <= c_address_a0(19 downto 14) + "000001";
		c_address_b0(19 downto 14) <= c_address_b0(19 downto 14) + "000001";
		c_address_a0(26 downto 21) <= c_address_a0(26 downto 21) + "000001";
		c_address_b0(26 downto 21) <= c_address_b0(26 downto 21) + "000001";
		c_address_a0(33 downto 28) <= c_address_a0(33 downto 28) + "000001";
		c_address_b0(33 downto 28) <= c_address_b0(33 downto 28) + "000001";
		c_address_a0(40 downto 35) <= c_address_a0(40 downto 35) + "000001";
		c_address_b0(40 downto 35) <= c_address_b0(40 downto 35) + "000001";
		c_address_a0(47 downto 42) <= c_address_a0(47 downto 42) + "000001";
		c_address_b0(47 downto 42) <= c_address_b0(47 downto 42) + "000001";
		c_address_a0(54 downto 49) <= c_address_a0(54 downto 49) + "000001";
		c_address_b0(54 downto 49) <= c_address_b0(54 downto 49) + "000001";
		c_address_a0(61 downto 56) <= c_address_a0(61 downto 56) + "000001";
		c_address_b0(61 downto 56) <= c_address_b0(61 downto 56) + "000001";
		c_address_a0(68 downto 63) <= c_address_a0(68 downto 63) + "000001";
		c_address_b0(68 downto 63) <= c_address_b0(68 downto 63) + "000001";
		c_address_a0(75 downto 70) <= c_address_a0(75 downto 70) + "000001";
		c_address_b0(75 downto 70) <= c_address_b0(75 downto 70) + "000001";
		c_address_a0(82 downto 77) <= c_address_a0(82 downto 77) + "000001";
		c_address_b0(82 downto 77) <= c_address_b0(82 downto 77) + "000001";
		c_address_a0(89 downto 84) <= c_address_a0(89 downto 84) + "000001";
		c_address_b0(89 downto 84) <= c_address_b0(89 downto 84) + "000001";
		c_address_a0(96 downto 91) <= c_address_a0(96 downto 91) + "000001";
		c_address_b0(96 downto 91) <= c_address_b0(96 downto 91) + "000001";
		c_address_a0(103 downto 98) <= c_address_a0(103 downto 98) + "000001";
		c_address_b0(103 downto 98) <= c_address_b0(103 downto 98) + "000001";
		c_address_a0(110 downto 105) <= c_address_a0(110 downto 105) + "000001";
		c_address_b0(110 downto 105) <= c_address_b0(110 downto 105) + "000001";
		c_address_a0(117 downto 112) <= c_address_a0(117 downto 112) + "000001";
		c_address_b0(117 downto 112) <= c_address_b0(117 downto 112) + "000001";
		c_address_a0(124 downto 119) <= c_address_a0(124 downto 119) + "000001";
		c_address_b0(124 downto 119) <= c_address_b0(124 downto 119) + "000001";
		c_address_a0(131 downto 126) <= c_address_a0(131 downto 126) + "000001";
		c_address_b0(131 downto 126) <= c_address_b0(131 downto 126) + "000001";
		c_address_a0(138 downto 133) <= c_address_a0(138 downto 133) + "000001";
		c_address_b0(138 downto 133) <= c_address_b0(138 downto 133) + "000001";
		c_address_a0(145 downto 140) <= c_address_a0(145 downto 140) + "000001";
		c_address_b0(145 downto 140) <= c_address_b0(145 downto 140) + "000001";
		c_address_a0(152 downto 147) <= c_address_a0(152 downto 147) + "000001";
		c_address_b0(152 downto 147) <= c_address_b0(152 downto 147) + "000001";
		c_address_a0(159 downto 154) <= c_address_a0(159 downto 154) + "000001";
		c_address_b0(159 downto 154) <= c_address_b0(159 downto 154) + "000001";
		c_address_a0(166 downto 161) <= c_address_a0(166 downto 161) + "000001";
		c_address_b0(166 downto 161) <= c_address_b0(166 downto 161) + "000001";
		c_address_a0(173 downto 168) <= c_address_a0(173 downto 168) + "000001";
		c_address_b0(173 downto 168) <= c_address_b0(173 downto 168) + "000001";
		c_address_a0(180 downto 175) <= c_address_a0(180 downto 175) + "000001";
		c_address_b0(180 downto 175) <= c_address_b0(180 downto 175) + "000001";
		c_address_a0(187 downto 182) <= c_address_a0(187 downto 182) + "000001";
		c_address_b0(187 downto 182) <= c_address_b0(187 downto 182) + "000001";
		c_address_a0(194 downto 189) <= c_address_a0(194 downto 189) + "000001";
		c_address_b0(194 downto 189) <= c_address_b0(194 downto 189) + "000001";
		c_address_a0(201 downto 196) <= c_address_a0(201 downto 196) + "000001";
		c_address_b0(201 downto 196) <= c_address_b0(201 downto 196) + "000001";
		c_address_a0(208 downto 203) <= c_address_a0(208 downto 203) + "000001";
		c_address_b0(208 downto 203) <= c_address_b0(208 downto 203) + "000001";
		c_address_a0(215 downto 210) <= c_address_a0(215 downto 210) + "000001";
		c_address_b0(215 downto 210) <= c_address_b0(215 downto 210) + "000001";
		c_address_a0(222 downto 217) <= c_address_a0(222 downto 217) + "000001";
		c_address_b0(222 downto 217) <= c_address_b0(222 downto 217) + "000001";

		c_address_a_dly0(5 downto 0) <=  c_address_a0(5 downto 0) - "001001";
		c_address_b_dly0(5 downto 0) <=  c_address_b0(5 downto 0) - "001001";
		c_address_a_dly0(12 downto 7) <=  c_address_a0(12 downto 7) - "001001";
		c_address_b_dly0(12 downto 7) <=  c_address_b0(12 downto 7) - "001001";
		c_address_a_dly0(19 downto 14) <=  c_address_a0(19 downto 14) - "001001";
		c_address_b_dly0(19 downto 14) <=  c_address_b0(19 downto 14) - "001001";
		c_address_a_dly0(26 downto 21) <=  c_address_a0(26 downto 21) - "001001";
		c_address_b_dly0(26 downto 21) <=  c_address_b0(26 downto 21) - "001001";
		c_address_a_dly0(33 downto 28) <=  c_address_a0(33 downto 28) - "001001";
		c_address_b_dly0(33 downto 28) <=  c_address_b0(33 downto 28) - "001001";
		c_address_a_dly0(40 downto 35) <=  c_address_a0(40 downto 35) - "001001";
		c_address_b_dly0(40 downto 35) <=  c_address_b0(40 downto 35) - "001001";
		c_address_a_dly0(47 downto 42) <=  c_address_a0(47 downto 42) - "001001";
		c_address_b_dly0(47 downto 42) <=  c_address_b0(47 downto 42) - "001001";
		c_address_a_dly0(54 downto 49) <=  c_address_a0(54 downto 49) - "001001";
		c_address_b_dly0(54 downto 49) <=  c_address_b0(54 downto 49) - "001001";
		c_address_a_dly0(61 downto 56) <=  c_address_a0(61 downto 56) - "001001";
		c_address_b_dly0(61 downto 56) <=  c_address_b0(61 downto 56) - "001001";
		c_address_a_dly0(68 downto 63) <=  c_address_a0(68 downto 63) - "001001";
		c_address_b_dly0(68 downto 63) <=  c_address_b0(68 downto 63) - "001001";
		c_address_a_dly0(75 downto 70) <=  c_address_a0(75 downto 70) - "001001";
		c_address_b_dly0(75 downto 70) <=  c_address_b0(75 downto 70) - "001001";
		c_address_a_dly0(82 downto 77) <=  c_address_a0(82 downto 77) - "001001";
		c_address_b_dly0(82 downto 77) <=  c_address_b0(82 downto 77) - "001001";
		c_address_a_dly0(89 downto 84) <=  c_address_a0(89 downto 84) - "001001";
		c_address_b_dly0(89 downto 84) <=  c_address_b0(89 downto 84) - "001001";
		c_address_a_dly0(96 downto 91) <=  c_address_a0(96 downto 91) - "001001";
		c_address_b_dly0(96 downto 91) <=  c_address_b0(96 downto 91) - "001001";
		c_address_a_dly0(103 downto 98) <=  c_address_a0(103 downto 98) - "001001";
		c_address_b_dly0(103 downto 98) <=  c_address_b0(103 downto 98) - "001001";
		c_address_a_dly0(110 downto 105) <=  c_address_a0(110 downto 105) - "001001";
		c_address_b_dly0(110 downto 105) <=  c_address_b0(110 downto 105) - "001001";
		c_address_a_dly0(117 downto 112) <=  c_address_a0(117 downto 112) - "001001";
		c_address_b_dly0(117 downto 112) <=  c_address_b0(117 downto 112) - "001001";
		c_address_a_dly0(124 downto 119) <=  c_address_a0(124 downto 119) - "001001";
		c_address_b_dly0(124 downto 119) <=  c_address_b0(124 downto 119) - "001001";
		c_address_a_dly0(131 downto 126) <=  c_address_a0(131 downto 126) - "001001";
		c_address_b_dly0(131 downto 126) <=  c_address_b0(131 downto 126) - "001001";
		c_address_a_dly0(138 downto 133) <=  c_address_a0(138 downto 133) - "001001";
		c_address_b_dly0(138 downto 133) <=  c_address_b0(138 downto 133) - "001001";
		c_address_a_dly0(145 downto 140) <=  c_address_a0(145 downto 140) - "001001";
		c_address_b_dly0(145 downto 140) <=  c_address_b0(145 downto 140) - "001001";
		c_address_a_dly0(152 downto 147) <=  c_address_a0(152 downto 147) - "001001";
		c_address_b_dly0(152 downto 147) <=  c_address_b0(152 downto 147) - "001001";
		c_address_a_dly0(159 downto 154) <=  c_address_a0(159 downto 154) - "001001";
		c_address_b_dly0(159 downto 154) <=  c_address_b0(159 downto 154) - "001001";
		c_address_a_dly0(166 downto 161) <=  c_address_a0(166 downto 161) - "001001";
		c_address_b_dly0(166 downto 161) <=  c_address_b0(166 downto 161) - "001001";
		c_address_a_dly0(173 downto 168) <=  c_address_a0(173 downto 168) - "001001";
		c_address_b_dly0(173 downto 168) <=  c_address_b0(173 downto 168) - "001001";
		c_address_a_dly0(180 downto 175) <=  c_address_a0(180 downto 175) - "001001";
		c_address_b_dly0(180 downto 175) <=  c_address_b0(180 downto 175) - "001001";
		c_address_a_dly0(187 downto 182) <=  c_address_a0(187 downto 182) - "001001";
		c_address_b_dly0(187 downto 182) <=  c_address_b0(187 downto 182) - "001001";
		c_address_a_dly0(194 downto 189) <=  c_address_a0(194 downto 189) - "001001";
		c_address_b_dly0(194 downto 189) <=  c_address_b0(194 downto 189) - "001001";
		c_address_a_dly0(201 downto 196) <=  c_address_a0(201 downto 196) - "001001";
		c_address_b_dly0(201 downto 196) <=  c_address_b0(201 downto 196) - "001001";
		c_address_a_dly0(208 downto 203) <=  c_address_a0(208 downto 203) - "001001";
		c_address_b_dly0(208 downto 203) <=  c_address_b0(208 downto 203) - "001001";
		c_address_a_dly0(215 downto 210) <=  c_address_a0(215 downto 210) - "001001";
		c_address_b_dly0(215 downto 210) <=  c_address_b0(215 downto 210) - "001001";
		c_address_a_dly0(222 downto 217) <=  c_address_a0(222 downto 217) - "001001";
		c_address_b_dly0(222 downto 217) <=  c_address_b0(222 downto 217) - "001001";
      end if;
     end process;
    
    c_address_a<=c_address_a0;
	 c_address_b<=c_address_b0;
	 
    c_address_a_dly<=c_address_a_dly0; 
	 c_address_b_dly<=c_address_b_dly0;
     
end rtl;
