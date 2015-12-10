--与原程序比较更改了data_magnitude的获取，有每脉冲更新改成了组合逻辑赋值
--以及cmp_dly_6由cmp_dly_5的值的获取过程

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity	CNU	is         
port(
     clk     : in  std_logic;
	  reset   : in  std_logic;
	  data_in : in  std_logic_vector(127 downto 0);
	  data_out: out  std_logic_vector(127 downto 0)
      );	 
end	CNU;
  
architecture rtl of CNU is
 signal xor_reg1 :std_logic_vector(7 downto 0);
 signal xor_reg2 :std_logic_vector(1 downto 0);
 signal MSB_dly1,MSB_dly2,MSB_dly3,MSB_dly4,MSB_dly5,MSB_dly6,MSB_dly7,MSB_dly8 :std_logic_vector(31 downto 0); 
 
 type cmpdlyindatamagnitude is array (31 downto 0) of std_logic_vector(2 downto 0);
 signal cmp_dly_in     : cmpdlyindatamagnitude;
 signal index_dly_in   : std_logic_vector(15 downto 0);
 signal data_magnitude : cmpdlyindatamagnitude;
 
 type cmpdly1 is array (15 downto 0) of std_logic_vector(2 downto 0);
 type indexdly1 is array (7 downto 0) of std_logic_vector(1 downto 0);
 signal cmp_dly_1:cmpdly1;
 signal index_dly_1:indexdly1;

 
 type cmpdly2 is array (7 downto 0) of std_logic_vector(2 downto 0);
 type indexdly2 is array (3 downto 0) of std_logic_vector(2 downto 0);
 signal cmp_dly_2:cmpdly2;
 signal index_dly_2:indexdly2;
 
 type cmpdly3 is array (3 downto 0) of std_logic_vector(2 downto 0);
 type indexdly3 is array (1 downto 0) of std_logic_vector(3 downto 0);
 signal cmp_dly_3  :cmpdly3;
 signal index_dly_3 :indexdly3;
 
 type cmpdly4 is array (1 downto 0) of std_logic_vector(2 downto 0);
 signal cmp_dly_4 :cmpdly4;
 signal index_dly_4 :std_logic_vector(4 downto 0);

 
 type cmpdly5 is array (1 downto 0) of std_logic_vector(2 downto 0); 
 signal cmp_dly_5  :cmpdly5; 
 
 signal index_dly_5 :std_logic_vector(4 downto 0);
 
 type cmpdly6 is array (31 downto 0) of std_logic_vector(2 downto 0); 
 signal cmp_dly_6  :cmpdly6; 
 
   component CNU_cmp_in is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        data_in1: in std_logic_vector(2 downto 0);
	        data_in2: in std_logic_vector(2 downto 0);
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic
		     );
	  end component;
	  
	 component CNU_cmp_concatenate_1 is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1_A : in std_logic_vector(2 downto 0);
	        data_in2_A : in std_logic_vector(2 downto 0);
	        min_index_A: in std_logic;
	        
	        data_in1_B : in std_logic_vector(2 downto 0);
	        data_in2_B : in std_logic_vector(2 downto 0);
	        min_index_B: in std_logic;
	        
	        
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic_vector(1 downto 0)
		     );
	  end component;
	  
	  component CNU_cmp_concatenate_2 is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1_A : in std_logic_vector(2 downto 0);
	        data_in2_A : in std_logic_vector(2 downto 0);
	        min_index_A: in std_logic_vector(1 downto 0);
	        
	        data_in1_B : in std_logic_vector(2 downto 0);
	        data_in2_B : in std_logic_vector(2 downto 0);
	        min_index_B: in std_logic_vector(1 downto 0);
	        
	        
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic_vector(2 downto 0)
		     );
	  end component;
	  
	  component CNU_cmp_concatenate_3 is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1_A : in std_logic_vector(2 downto 0);
	        data_in2_A : in std_logic_vector(2 downto 0);
	        min_index_A: in std_logic_vector(2 downto 0);
	        
	        data_in1_B : in std_logic_vector(2 downto 0);
	        data_in2_B : in std_logic_vector(2 downto 0);
	        min_index_B: in std_logic_vector(2 downto 0);
	        
	        
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic_vector(3 downto 0)
		     );
	  end component;
	  
	   component CNU_cmp_concatenate_4 is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic;
	        
	        data_in1_A : in std_logic_vector(2 downto 0);
	        data_in2_A : in std_logic_vector(2 downto 0);
	        min_index_A: in std_logic_vector(3 downto 0);
	        
	        data_in1_B : in std_logic_vector(2 downto 0);
	        data_in2_B : in std_logic_vector(2 downto 0);
	        min_index_B: in std_logic_vector(3 downto 0);
	        
	        
	        min1: out std_logic_vector(2 downto 0);
	        min2: out std_logic_vector(2 downto 0);
	        min_index: out std_logic_vector(4 downto 0)
		     );
	  end component;
	  
	   component CNU_normalization is
        port( 
           clk     : in  std_logic;
	        reset   : in  std_logic; 
	        data_in : in std_logic_vector(2 downto 0);
	        data_out: out std_logic_vector(2 downto 0)
	          );
	   end component;
   
  begin
      
  process(clk,reset)
     begin
      if (reset='1') then
         	xor_reg1 <= "00000000";
		    xor_reg2 <= "00";
	   elsif (clk'event and clk='1') then
		    xor_reg1(0) <= data_in(15) xor data_in(11) xor data_in(7) xor data_in(3);
		    xor_reg1(1) <= data_in(31) xor data_in(27) xor data_in(23) xor data_in(19);
		    xor_reg1(2) <= data_in(47) xor data_in(43) xor data_in(39) xor data_in(35);
		    xor_reg1(3) <= data_in(63) xor data_in(59) xor data_in(55) xor data_in(51);
		    xor_reg1(4) <= data_in(79) xor data_in(75) xor data_in(71) xor data_in(67);
		    xor_reg1(5) <= data_in(95) xor data_in(91) xor data_in(87) xor data_in(83);
		    xor_reg1(6) <= data_in(111) xor data_in(107) xor data_in(103) xor data_in(99);
		    xor_reg1(7) <= data_in(127) xor data_in(123) xor data_in(119) xor data_in(115);
		
		    xor_reg2(0) <= xor_reg1(3) xor xor_reg1(2) xor xor_reg1(1) xor xor_reg1(0);
		    xor_reg2(1) <= xor_reg1(7) xor xor_reg1(6) xor xor_reg1(5) xor xor_reg1(4);
	  end if;
   end process;
   
   process(clk,reset)
     begin
      		if (reset='1') then
			   MSB_dly1 <=(others=>'0');
				MSB_dly2 <=(others=>'0');
				MSB_dly3 <=(others=>'0');
				MSB_dly4 <=(others=>'0');
				MSB_dly5 <=(others=>'0');
				MSB_dly6 <=(others=>'0');
				MSB_dly7 <=(others=>'0');
				MSB_dly8 <=(others=>'0');
			elsif (clk'event and clk='1') then
				 MSB_dly1 <= data_in(127) & data_in(123) & data_in(119) & data_in(115) & 
							 data_in(111) & data_in(107) & data_in(103) & data_in(99) & 
							 data_in(95) & data_in(91) & data_in(87) & data_in(83) & 
							 data_in(79) & data_in(75) & data_in(71) & data_in(67) & 
							 data_in(63) & data_in(59) & data_in(55) & data_in(51) & 
							 data_in(47) & data_in(43) & data_in(39) & data_in(35) & 
							 data_in(31) & data_in(27) & data_in(23) & data_in(19) & 
							 data_in(15) & data_in(11) & data_in(7) & data_in(3);
				 MSB_dly2 <= MSB_dly1;
				 MSB_dly3 <=((xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) &
							(xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) & (xor_reg2(1) xor xor_reg2(0)) )  xor  MSB_dly2;
				 MSB_dly4 <= MSB_dly3;
				 MSB_dly5 <= MSB_dly4;
				 MSB_dly6 <= MSB_dly5;
				 MSB_dly7 <= MSB_dly6;
				 MSB_dly8 <= MSB_dly7;
		end if;
   end process;
   
 process(clk,reset)
	begin
	if (reset='1') then
			   data_magnitude(0) <= "000";
				data_magnitude(1) <= "000";
				data_magnitude(2) <= "000";
				data_magnitude(3) <= "000";
				data_magnitude(4) <= "000";
				data_magnitude(5) <= "000";
				data_magnitude(6) <= "000";
				data_magnitude(7) <= "000";
				data_magnitude(8) <= "000";
				data_magnitude(9) <= "000";
				data_magnitude(10) <= "000";
				data_magnitude(11) <= "000";
				data_magnitude(12) <= "000";
				data_magnitude(13) <= "000";
				data_magnitude(14) <= "000";
	     		  data_magnitude(15) <= "000";
				data_magnitude(16) <= "000";
				data_magnitude(17) <= "000";
				data_magnitude(18) <= "000";
				data_magnitude(19) <= "000";
				data_magnitude(20) <= "000";
				data_magnitude(21) <= "000";
				data_magnitude(22) <= "000";
				data_magnitude(23) <= "000";
				data_magnitude(24) <= "000";
				data_magnitude(25) <= "000";
				data_magnitude(26) <= "000";
				data_magnitude(27) <= "000";
				data_magnitude(28) <= "000";
				data_magnitude(29) <= "000";
				data_magnitude(30) <= "000";
				data_magnitude(31) <= "000";
			 elsif (clk'event and clk='1') then
			
			 if (data_in(3)='1')then
              data_magnitude(0)<=not(data_in(2 downto 0));
            else
	           data_magnitude(0)<=data_in(2 downto 0);
	           end if;
           	
          if (data_in(7)='1')then
              data_magnitude(1)<=not(data_in(6 downto 4));
            else
	           data_magnitude(1)<=data_in(6 downto 4);
	           end if;
           	
          if (data_in(11)='1')then
              data_magnitude(2)<=not(data_in(10 downto 8));
            else
	           data_magnitude(2)<=data_in(10 downto 8);
	           end if;
           	
          if (data_in(15)='1')then
              data_magnitude(3)<=not(data_in(14 downto 12));
            else
	           data_magnitude(3)<=data_in(14 downto 12);
	           end if;
           	
          if (data_in(19)='1')then
              data_magnitude(4)<=not(data_in(18 downto 16));
            else
	           data_magnitude(4)<=data_in(18 downto 16);
	           end if;
           	
          if (data_in(23)='1')then
              data_magnitude(5)<=not(data_in(22 downto 20));
            else
	           data_magnitude(5)<=data_in(22 downto 20);
	           end if;
           	
          if (data_in(27)='1')then
              data_magnitude(6)<=not(data_in(26 downto 24));
            else
	           data_magnitude(6)<=data_in(26 downto 24);
	           end if;
           	
          if (data_in(31)='1')then
              data_magnitude(7)<=not(data_in(30 downto 28));
            else
	           data_magnitude(7)<=data_in(30 downto 28);
	           end if;
           	
          if (data_in(35)='1')then
              data_magnitude(8)<=not(data_in(34 downto 32));
            else
	           data_magnitude(8)<=data_in(34 downto 32);
	           end if;
           	
          if (data_in(39)='1')then
              data_magnitude(9)<=not(data_in(38 downto 36));
            else
	           data_magnitude(9)<=data_in(38 downto 36);
	           end if;
           	
          if (data_in(43)='1')then
              data_magnitude(10)<=not(data_in(42 downto 40));
            else
	           data_magnitude(10)<=data_in(42 downto 40);
	           end if;
           	
          if (data_in(47)='1')then
              data_magnitude(11)<=not(data_in(46 downto 44));
            else
	           data_magnitude(11)<=data_in(46 downto 44);
	           end if;
           	
          if (data_in(51)='1')then
              data_magnitude(12)<=not(data_in(50 downto 48));
            else
	           data_magnitude(12)<=data_in(50 downto 48);
	           end if;
           	
          if (data_in(55)='1')then
              data_magnitude(13)<=not(data_in(54 downto 52));
            else
	           data_magnitude(13)<=data_in(54 downto 52);
	           end if;
           	
          if (data_in(59)='1')then
              data_magnitude(14)<=not(data_in(58 downto 56));
            else
	           data_magnitude(14)<=data_in(58 downto 56);
	           end if;
           	
          if (data_in(63)='1')then
              data_magnitude(15)<=not(data_in(62 downto 60));
            else
	           data_magnitude(15)<=data_in(62 downto 60);
	           end if;
           	
          if (data_in(67)='1')then
              data_magnitude(16)<=not(data_in(66 downto 64));
            else
	           data_magnitude(16)<=data_in(66 downto 64);
	           end if;
           	
          if (data_in(71)='1')then
              data_magnitude(17)<=not(data_in(70 downto 68));
            else
	           data_magnitude(17)<=data_in(70 downto 68);
	           end if;
           	
          if (data_in(75)='1')then
              data_magnitude(18)<=not(data_in(74 downto 72));
            else
	           data_magnitude(18)<=data_in(74 downto 72);
	           end if;
           	
          if (data_in(79)='1')then
              data_magnitude(19)<=not(data_in(78 downto 76));
            else
	           data_magnitude(19)<=data_in(78 downto 76);
	           end if;
           	
          if (data_in(83)='1')then
              data_magnitude(20)<=not(data_in(82 downto 80));
            else
	           data_magnitude(20)<=data_in(82 downto 80);
	           end if;
           	
          if (data_in(87)='1')then
              data_magnitude(21)<=not(data_in(86 downto 84));
            else
	           data_magnitude(21)<=data_in(86 downto 84);
	           end if;
           	
          if (data_in(91)='1')then
              data_magnitude(22)<=not(data_in(90 downto 88));
            else
	           data_magnitude(22)<=data_in(90 downto 88);
	           end if;
           	
          if (data_in(95)='1')then
              data_magnitude(23)<=not(data_in(94 downto 92));
            else
	           data_magnitude(23)<=data_in(94 downto 92);
	           end if;
           	
          if (data_in(99)='1')then
              data_magnitude(24)<=not(data_in(98 downto 96));
            else
	           data_magnitude(24)<=data_in(98 downto 96);
	           end if;
           	
          if (data_in(103)='1')then
              data_magnitude(25)<=not(data_in(102 downto 100));
            else
	           data_magnitude(25)<=data_in(102 downto 100);
	           end if;
           	
          if (data_in(107)='1')then
              data_magnitude(26)<=not(data_in(106 downto 104));
            else
	           data_magnitude(26)<=data_in(106 downto 104);
	           end if;
           	
          if (data_in(111)='1')then
              data_magnitude(27)<=not(data_in(110 downto 108));
            else
	           data_magnitude(27)<=data_in(110 downto 108);
	           end if;
           	
          if (data_in(115)='1')then
              data_magnitude(28)<=not(data_in(114 downto 112));
            else
	           data_magnitude(28)<=data_in(114 downto 112);
	           end if;
           	
          if (data_in(119)='1')then
              data_magnitude(29)<=not(data_in(118 downto 116));
            else
	           data_magnitude(29)<=data_in(118 downto 116);
	           end if;
           	
          if (data_in(123)='1')then
              data_magnitude(30)<=not(data_in(122 downto 120));
            else
	           data_magnitude(30)<=data_in(122 downto 120);
	           end if;
           	
          if (data_in(127)='1')then
              data_magnitude(31)<=not(data_in(126 downto 124));
            else
	           data_magnitude(31)<=data_in(126 downto 124);
	       end if; 
			end if;
		end process;
	         
			CNU_cmp_in_inst1  :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(0),
				 data_in2=>data_magnitude(1),
				 min1=>cmp_dly_in(0),
				 min2=>cmp_dly_in(1),
				 min_index=>index_dly_in(0)
				  );
			
			CNU_cmp_in_inst2  :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(2),
				 data_in2=>data_magnitude(3),
				 min1=>cmp_dly_in(2),
				 min2=>cmp_dly_in(3),
				 min_index=>index_dly_in(1)
				  );
			
			CNU_cmp_in_inst3 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(4),
				 data_in2=>data_magnitude(5),
				 min1=>cmp_dly_in(4),
				 min2=>cmp_dly_in(5),
				 min_index=>index_dly_in(2)
				  );
			
			CNU_cmp_in_inst4 :CNU_cmp_in 
			port map(	
					 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(6),
				 data_in2=>data_magnitude(7),
				 min1=>cmp_dly_in(6),
				 min2=>cmp_dly_in(7),
				 min_index=>index_dly_in(3)
				  );
			
			CNU_cmp_in_inst5 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(8),
				 data_in2=>data_magnitude(9),
				 min1=>cmp_dly_in(8),
				 min2=>cmp_dly_in(9),
				 min_index=>index_dly_in(4)
				  );
			
			CNU_cmp_in_inst6 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(10),
				 data_in2=>data_magnitude(11),
				 min1=>cmp_dly_in(10),
				 min2=>cmp_dly_in(11),
				 min_index=>index_dly_in(5)
				  );
			
			CNU_cmp_in_inst7 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(12),
				 data_in2=>data_magnitude(13),
				 min1=>cmp_dly_in(12),
				 min2=>cmp_dly_in(13),
				 min_index=>index_dly_in(6)
				  );
			
			CNU_cmp_in_inst8 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(14),
				 data_in2=>data_magnitude(15),
				 min1=>cmp_dly_in(14),
				 min2=>cmp_dly_in(15),
				 min_index=>index_dly_in(7)
				  );
			
			CNU_cmp_in_inst9 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(16),
				 data_in2=>data_magnitude(17),
				 min1=>cmp_dly_in(16),
				 min2=>cmp_dly_in(17),
				 min_index=>index_dly_in(8)
		        );
			
			CNU_cmp_in_inst10 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(18),
				 data_in2=>data_magnitude(19),
				 min1=>cmp_dly_in(18),
				 min2=>cmp_dly_in(19),
				 min_index=>index_dly_in(9)
				  );
			
			CNU_cmp_in_inst11 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(20),
				 data_in2=>data_magnitude(21),
				 min1=>cmp_dly_in(20),
				 min2=>cmp_dly_in(21),
				 min_index=>index_dly_in(10)
				  );
			
			CNU_cmp_in_inst12 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(22),
				 data_in2=>data_magnitude(23),
				 min1=>cmp_dly_in(22),
				 min2=>cmp_dly_in(23),
				 min_index=>index_dly_in(11)
				  );
			
			CNU_cmp_in_inst13 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(24),
				 data_in2=>data_magnitude(25),
				 min1=>cmp_dly_in(24),
				 min2=>cmp_dly_in(25),
				 min_index=>index_dly_in(12)
				  );
			
			CNU_cmp_in_inst14 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(26),
				 data_in2=>data_magnitude(27),
				 min1=>cmp_dly_in(26),
				 min2=>cmp_dly_in(27),
				 min_index=>index_dly_in(13)
				  );
			
			CNU_cmp_in_inst15 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(28),
				 data_in2=>data_magnitude(29),
				 min1=>cmp_dly_in(28),
				 min2=>cmp_dly_in(29),
				 min_index=>index_dly_in(14)
				  );
			CNU_cmp_in_inst16 :CNU_cmp_in 
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1=>data_magnitude(30),
				 data_in2=>data_magnitude(31),
				 min1=>cmp_dly_in(30),
				 min2=>cmp_dly_in(31),
				 min_index=>index_dly_in(15)
				  );
			
			
			CNU_cmp_concatenate_1_inst1 : CNU_cmp_concatenate_1  
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(0),
				 data_in2_A=>cmp_dly_in(1),
				 min_index_A=>index_dly_in(0),
				 data_in1_B=>cmp_dly_in(2),
				 data_in2_B=>cmp_dly_in(3),
				 min_index_B=>index_dly_in(1),
				 min1=>cmp_dly_1(0),
				 min2=>cmp_dly_1(1),
				 min_index=>index_dly_1(0)
				  );
			CNU_cmp_concatenate_1_inst2 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(4),
				 data_in2_A=>cmp_dly_in(5),
				 min_index_A=>index_dly_in(2),
				 data_in1_B=>cmp_dly_in(6),
				 data_in2_B=>cmp_dly_in(7),
				 min_index_B=>index_dly_in(3),
				 min1=>cmp_dly_1(2),
				 min2=>cmp_dly_1(3),
				 min_index=>index_dly_1(1)
				  );
			CNU_cmp_concatenate_1_inst3 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(8),
				 data_in2_A=>cmp_dly_in(9),
				 min_index_A=>index_dly_in(4),
				 data_in1_B=>cmp_dly_in(10),
				 data_in2_B=>cmp_dly_in(11),
				 min_index_B=>index_dly_in(5),
				 min1=>cmp_dly_1(4),
				 min2=>cmp_dly_1(5),
				 min_index=>index_dly_1(2)
				  );
			CNU_cmp_concatenate_1_inst4 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(12),
				 data_in2_A=>cmp_dly_in(13),
				 min_index_A=>index_dly_in(6),
				 data_in1_B=>cmp_dly_in(14),
				 data_in2_B=>cmp_dly_in(15),
				 min_index_B=>index_dly_in(7),
				 min1=>cmp_dly_1(6),
				 min2=>cmp_dly_1(7),
				 min_index=>index_dly_1(3)
				  );
			CNU_cmp_concatenate_1_inst5 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(16),
				 data_in2_A=>cmp_dly_in(17),
				 min_index_A=>index_dly_in(8),
				 data_in1_B=>cmp_dly_in(18),
				 data_in2_B=>cmp_dly_in(19),
				 min_index_B=>index_dly_in(9),
				 min1=>cmp_dly_1(8),
				 min2=>cmp_dly_1(9),
				 min_index=>index_dly_1(4)
				  );
			CNU_cmp_concatenate_1_inst6 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(20),
				 data_in2_A=>cmp_dly_in(21),
				 min_index_A=>index_dly_in(10),
				 data_in1_B=>cmp_dly_in(22),
				 data_in2_B=>cmp_dly_in(23),
				 min_index_B=>index_dly_in(11),
				 min1=>cmp_dly_1(10),
				 min2=>cmp_dly_1(11),
				 min_index=>index_dly_1(5)
				  );
			CNU_cmp_concatenate_1_inst7 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(24),
				 data_in2_A=>cmp_dly_in(25),
				 min_index_A=>index_dly_in(12),
				 data_in1_B=>cmp_dly_in(26),
				 data_in2_B=>cmp_dly_in(27),
				 min_index_B=>index_dly_in(13),
				 min1=>cmp_dly_1(12),
				 min2=>cmp_dly_1(13),
				 min_index=>index_dly_1(6)
				  );
			CNU_cmp_concatenate_1_inst8 : CNU_cmp_concatenate_1
			port map(
				 clk=>clk,
				 reset=>reset,
				 data_in1_A=>cmp_dly_in(28),
				 data_in2_A=>cmp_dly_in(29),
				 min_index_A=>index_dly_in(14),
				 data_in1_B=>cmp_dly_in(30),
				 data_in2_B=>cmp_dly_in(31),
				 min_index_B=>index_dly_in(15),
				 min1=>cmp_dly_1(14),
				 min2=>cmp_dly_1(15),
				 min_index=>index_dly_1(7)
				  );
			
			CNU_cmp_concatenate_2_inst1 :CNU_cmp_concatenate_2
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_1(0),
				data_in2_A=>cmp_dly_1(1),
				min_index_A=>index_dly_1(0),
				data_in1_B=>cmp_dly_1(2),
				data_in2_B=>cmp_dly_1(3),
				min_index_B=>index_dly_1(1),
				min1=>cmp_dly_2(0),
				min2=>cmp_dly_2(1),
				min_index=>index_dly_2(0)
				   );
			CNU_cmp_concatenate_2_inst2  :CNU_cmp_concatenate_2
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_1(4),
				data_in2_A=>cmp_dly_1(5),
				min_index_A=>index_dly_1(2),
				data_in1_B=>cmp_dly_1(6),
				data_in2_B=>cmp_dly_1(7),
				min_index_B=>index_dly_1(3),
				min1=>cmp_dly_2(2),
				min2=>cmp_dly_2(3),
				min_index=>index_dly_2(1)
				   );
			CNU_cmp_concatenate_2_inst3  :CNU_cmp_concatenate_2
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_1(8),
				data_in2_A=>cmp_dly_1(9),
				min_index_A=>index_dly_1(4),
				data_in1_B=>cmp_dly_1(10),
				data_in2_B=>cmp_dly_1(11),
				min_index_B=>index_dly_1(5),
				min1=>cmp_dly_2(4),
				min2=>cmp_dly_2(5),
				min_index=>index_dly_2(2)
				   );
			CNU_cmp_concatenate_2_inst4 :CNU_cmp_concatenate_2
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_1(12),
				data_in2_A=>cmp_dly_1(13),
				min_index_A=>index_dly_1(6),
				data_in1_B=>cmp_dly_1(14),
				data_in2_B=>cmp_dly_1(15),
				min_index_B=>index_dly_1(7),
				min1=>cmp_dly_2(6),
				min2=>cmp_dly_2(7),
				min_index=>index_dly_2(3)
				   );
			
			
			
			CNU_cmp_concatenate_3_inst1 :CNU_cmp_concatenate_3 
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_2(0),
				data_in2_A=>cmp_dly_2(1),
				min_index_A=>index_dly_2(0),
				data_in1_B=>cmp_dly_2(2),
				data_in2_B=>cmp_dly_2(3),
				min_index_B=>index_dly_2(1),
				min1=>cmp_dly_3(0),
				min2=>cmp_dly_3(1),
				min_index=>index_dly_3(0)
				   );
			CNU_cmp_concatenate_3_inst2 :CNU_cmp_concatenate_3 
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_2(4),
				data_in2_A=>cmp_dly_2(5),
				min_index_A=>index_dly_2(2),
				data_in1_B=>cmp_dly_2(6),
				data_in2_B=>cmp_dly_2(7),
				min_index_B=>index_dly_2(3),
				min1=>cmp_dly_3(2),
				min2=>cmp_dly_3(3),
				min_index=>index_dly_3(1)
				   );
			
			
			 CNU_cmp_concatenate_4_inst1:CNU_cmp_concatenate_4
			 port map(
				clk=>clk,
				reset=>reset,
				data_in1_A=>cmp_dly_3(0),
				data_in2_A=>cmp_dly_3(1),
				min_index_A=>index_dly_3(0),
				data_in1_B=>cmp_dly_3(2),
				data_in2_B=>cmp_dly_3(3),
				min_index_B=>index_dly_3(1),
				min1=>cmp_dly_4(0),
				min2=>cmp_dly_4(1),
				min_index=>index_dly_4
				   );
			
			
			CNU_normalization_inst1:CNU_normalization  
			 port map(
				clk=>clk,
				reset=>reset,
				data_in=>cmp_dly_4(0),
				data_out=>cmp_dly_5(0)
				   );
			
			CNU_normalization_inst2 :CNU_normalization  
			 port map(
				clk=>clk,
				reset=>reset,
				data_in=>cmp_dly_4(1),
				data_out=>cmp_dly_5(1)
				   );
			
		 process(clk , reset)
			 begin
			  if (reset='1') then
					index_dly_5 <= "00000";
			elsif (clk'event and clk='1') then
				index_dly_5 <= index_dly_4;
			end if;
		  end process;
		  
		process(clk, reset)
      	 begin
      		 if (reset='1') then
				cmp_dly_6(0) <= "000";
				cmp_dly_6(1) <= "000";
				cmp_dly_6(2) <= "000";
				cmp_dly_6(3) <= "000";
				cmp_dly_6(4) <= "000";
				cmp_dly_6(5) <= "000";
				cmp_dly_6(6) <= "000";
				cmp_dly_6(7) <= "000";
				cmp_dly_6(8) <= "000";
				cmp_dly_6(9) <= "000";
				cmp_dly_6(10) <= "000";
				cmp_dly_6(11) <= "000";
				cmp_dly_6(12) <= "000";
				cmp_dly_6(13) <= "000";
				cmp_dly_6(14) <= "000";
				cmp_dly_6(15) <= "000";
				cmp_dly_6(16) <= "000";
				cmp_dly_6(17) <= "000";
				cmp_dly_6(18) <= "000";
				cmp_dly_6(19) <= "000";
				cmp_dly_6(20) <= "000";
				cmp_dly_6(21) <= "000";
				cmp_dly_6(22) <= "000";
				cmp_dly_6(23) <= "000";
				cmp_dly_6(24) <= "000";
				cmp_dly_6(25) <= "000";
				cmp_dly_6(26) <= "000";
				cmp_dly_6(27) <= "000";
				cmp_dly_6(28) <= "000";
				cmp_dly_6(29) <= "000";
				cmp_dly_6(30) <= "000";
				cmp_dly_6(31) <= "000";
          elsif (clk'event and clk='1') then
				if (index_dly_5 =0)then
             cmp_dly_6(0)<=cmp_dly_5(1);
            else
	           cmp_dly_6(0)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =1)then
             cmp_dly_6(1)<=cmp_dly_5(1);
            else
	           cmp_dly_6(1)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =2)then
             cmp_dly_6(2)<=cmp_dly_5(1);
            else
	           cmp_dly_6(2)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =3)then
             cmp_dly_6(3)<=cmp_dly_5(1);
            else
	           cmp_dly_6(3)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =4)then
             cmp_dly_6(4)<=cmp_dly_5(1);
            else
	           cmp_dly_6(4)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =5)then
             cmp_dly_6(5)<=cmp_dly_5(1);
            else
	           cmp_dly_6(5)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =6)then
             cmp_dly_6(6)<=cmp_dly_5(1);
            else
	           cmp_dly_6(6)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =7)then
             cmp_dly_6(7)<=cmp_dly_5(1);
            else
	           cmp_dly_6(7)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =8)then
             cmp_dly_6(8)<=cmp_dly_5(1);
            else
	           cmp_dly_6(8)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =9)then
             cmp_dly_6(9)<=cmp_dly_5(1);
            else
	           cmp_dly_6(9)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =10)then
             cmp_dly_6(10)<=cmp_dly_5(1);
            else
	           cmp_dly_6(10)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =11)then
             cmp_dly_6(11)<=cmp_dly_5(1);
            else
	           cmp_dly_6(11)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =12)then
             cmp_dly_6(12)<=cmp_dly_5(1);
            else
	           cmp_dly_6(12)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =13)then
             cmp_dly_6(13)<=cmp_dly_5(1);
            else
	           cmp_dly_6(13)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =14)then
             cmp_dly_6(14)<=cmp_dly_5(1);
            else
	           cmp_dly_6(14)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =15)then
             cmp_dly_6(15)<=cmp_dly_5(1);
            else
	           cmp_dly_6(15)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =16)then
             cmp_dly_6(16)<=cmp_dly_5(1);
            else
	           cmp_dly_6(16)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =17)then
             cmp_dly_6(17)<=cmp_dly_5(1);
            else
	           cmp_dly_6(17)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =18)then
             cmp_dly_6(18)<=cmp_dly_5(1);
            else
	           cmp_dly_6(18)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =19)then
             cmp_dly_6(19)<=cmp_dly_5(1);
            else
	           cmp_dly_6(19)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =20)then
             cmp_dly_6(20)<=cmp_dly_5(1);
            else
	           cmp_dly_6(20)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =21)then
             cmp_dly_6(21)<=cmp_dly_5(1);
            else
	           cmp_dly_6(21)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =22)then
             cmp_dly_6(22)<=cmp_dly_5(1);
            else
	           cmp_dly_6(22)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =23)then
             cmp_dly_6(23)<=cmp_dly_5(1);
            else
	           cmp_dly_6(23)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =24)then
             cmp_dly_6(24)<=cmp_dly_5(1);
            else
	           cmp_dly_6(24)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =25)then
             cmp_dly_6(25)<=cmp_dly_5(1);
            else
	           cmp_dly_6(25)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =26)then
             cmp_dly_6(26)<=cmp_dly_5(1);
            else
	           cmp_dly_6(26)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =27)then
             cmp_dly_6(27)<=cmp_dly_5(1);
            else
	           cmp_dly_6(27)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =28)then
             cmp_dly_6(28)<=cmp_dly_5(1);
            else
	           cmp_dly_6(28)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =29)then
             cmp_dly_6(29)<=cmp_dly_5(1);
            else
	           cmp_dly_6(29)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =30)then
             cmp_dly_6(30)<=cmp_dly_5(1);
            else
	           cmp_dly_6(30)<=cmp_dly_5(0);
	           end if;
           	
          if (index_dly_5 =31)then
             cmp_dly_6(31)<=cmp_dly_5(1);
            else
	           cmp_dly_6(31)<=cmp_dly_5(0);
	           end if;
	           
          end if;
		  end process;
		  
			data_out(3 downto 0)<=MSB_dly8(0) & cmp_dly_6(0);
			data_out(7 downto 4)<=MSB_dly8(1) & cmp_dly_6(1);
			data_out(11 downto 8)<=MSB_dly8(2) & cmp_dly_6(2);
			data_out(15 downto 12)<=MSB_dly8(3) & cmp_dly_6(3);
			data_out(19 downto 16)<=MSB_dly8(4) & cmp_dly_6(4);
			data_out(23 downto 20)<=MSB_dly8(5) & cmp_dly_6(5);
			data_out(27 downto 24)<=MSB_dly8(6) & cmp_dly_6(6);
			data_out(31 downto 28)<=MSB_dly8(7) & cmp_dly_6(7);
			data_out(35 downto 32)<=MSB_dly8(8) & cmp_dly_6(8);
			data_out(39 downto 36)<=MSB_dly8(9) & cmp_dly_6(9);
			data_out(43 downto 40)<=MSB_dly8(10) & cmp_dly_6(10);
			data_out(47 downto 44)<=MSB_dly8(11) & cmp_dly_6(11);
			data_out(51 downto 48)<=MSB_dly8(12) & cmp_dly_6(12);
			data_out(55 downto 52)<=MSB_dly8(13) & cmp_dly_6(13);
			data_out(59 downto 56)<=MSB_dly8(14) & cmp_dly_6(14);
			data_out(63 downto 60)<=MSB_dly8(15) & cmp_dly_6(15);
			data_out(67 downto 64)<=MSB_dly8(16) & cmp_dly_6(16);
			data_out(71 downto 68)<=MSB_dly8(17) & cmp_dly_6(17);
			data_out(75 downto 72)<=MSB_dly8(18) & cmp_dly_6(18);
			data_out(79 downto 76)<=MSB_dly8(19) & cmp_dly_6(19);
			data_out(83 downto 80)<=MSB_dly8(20) & cmp_dly_6(20);
			data_out(87 downto 84)<=MSB_dly8(21) & cmp_dly_6(21);
			data_out(91 downto 88)<=MSB_dly8(22) & cmp_dly_6(22);
			data_out(95 downto 92)<=MSB_dly8(23) & cmp_dly_6(23);
			data_out(99 downto 96)<=MSB_dly8(24) & cmp_dly_6(24);
			data_out(103 downto 100)<=MSB_dly8(25) & cmp_dly_6(25);
			data_out(107 downto 104)<=MSB_dly8(26) & cmp_dly_6(26);
			data_out(111 downto 108)<=MSB_dly8(27) & cmp_dly_6(27);
			data_out(115 downto 112)<=MSB_dly8(28) & cmp_dly_6(28);
			data_out(119 downto 116)<=MSB_dly8(29) & cmp_dly_6(29);
			data_out(123 downto 120)<=MSB_dly8(30) & cmp_dly_6(30);
			data_out(127 downto 124)<=MSB_dly8(31) & cmp_dly_6(31);
				  
		end rtl;  
