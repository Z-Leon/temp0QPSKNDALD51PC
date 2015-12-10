library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	decision_block	 is         
port(
   
   address_a: in std_logic_vector(223 downto 0);
   address_b: in std_logic_vector(223 downto 0);
   clock    : in std_logic;
   data_a   : in std_logic_vector(255 downto 0);
   data_b   : in std_logic_vector(255 downto 0);
   wren_a   : in std_logic;
   wren_b   : in std_logic;
   q_a      : out std_logic_vector(255 downto 0);
   q_b      : out std_logic_vector(255 downto 0)
	);	 
end	decision_block;

architecture rtl of decision_block is
    component decision_ram is
     port(
	   address_a:in std_logic_vector(6 downto 0);
      address_b:in std_logic_vector(6 downto 0);
      clock    :in std_logic;
      data_a   :in std_logic_vector(7 downto 0);
      data_b   :in std_logic_vector(7 downto 0);
      
      wren_a   :in std_logic;
      wren_b   :in std_logic;
      q_a      :out std_logic_vector(7 downto 0);
      q_b      :out std_logic_vector(7 downto 0)
	    );	
    end component;
begin
decision_ram1:decision_ram
port map(
    address_a=>address_a(6 downto 0),
    address_b=>address_b(6 downto 0),
    clock=>clock,
    data_a=>data_a(7 downto 0),
    data_b=>data_b(7 downto 0),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(7 downto 0),
    q_b=>q_b(7 downto 0)
    );
    
decision_ram2:decision_ram
port map(
    address_a=>address_a(13 downto 7),
    address_b=>address_b(13 downto 7),
    clock=>clock,
    data_a=>data_a(15 downto 8),
    data_b=>data_b(15 downto 8),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(15 downto 8),
    q_b=>q_b(15 downto 8)
  );
  
 decision_ram3:decision_ram
port map(
    address_a=>address_a(20 downto 14),
    address_b=>address_b(20 downto 14),
    clock=>clock,
    data_a=>data_a(23 downto 16),
    data_b=>data_b(23 downto 16),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(23 downto 16),
    q_b=>q_b(23 downto 16)
);

 decision_ram4:decision_ram
port map(
    address_a=>address_a(27 downto 21),
    address_b=>address_b(27 downto 21),
    clock=>clock,
    data_a=>data_a(31 downto 24),
    data_b=>data_b(31 downto 24),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(31 downto 24),
    q_b=>q_b(31 downto 24)
);

 decision_ram5:decision_ram
port map(
    address_a=>address_a(34 downto 28),
    address_b=>address_b(34 downto 28),
    clock=>clock,
    data_a=>data_a(39 downto 32),
    data_b=>data_b(39 downto 32),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(39 downto 32),
    q_b=>q_b(39 downto 32)
);

 decision_ram6:decision_ram
port map(
    address_a=>address_a(41 downto 35),
    address_b=>address_b(41 downto 35),
    clock=>clock,
    data_a=>data_a(47 downto 40),
    data_b=>data_b(47 downto 40),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(47 downto 40),
    q_b=>q_b(47 downto 40)
);

decision_ram7:decision_ram 
port map(
    address_a=>address_a(48 downto 42),
    address_b=>address_b(48 downto 42),
    clock=>clock,
    data_a=>data_a(55 downto 48),
    data_b=>data_b(55 downto 48),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(55 downto 48),
    q_b=>q_b(55 downto 48)
);

 decision_ram8:decision_ram
port map(
    address_a=>address_a(55 downto 49),
    address_b=>address_b(55 downto 49),
    clock=>clock,
    data_a=>data_a(63 downto 56),
    data_b=>data_b(63 downto 56),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(63 downto 56),
    q_b=>q_b(63 downto 56)
);

 decision_ram9:decision_ram
port map(
    address_a=>address_a(62 downto 56),
    address_b=>address_b(62 downto 56),
    clock=>clock,
    data_a=>data_a(71 downto 64),
    data_b=>data_b(71 downto 64),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(71 downto 64),
    q_b=>q_b(71 downto 64)
);

 decision_ram10:decision_ram
port map(
    address_a=>address_a(69 downto 63),
    address_b=>address_b(69 downto 63),
    clock=>clock,
    data_a=>data_a(79 downto 72),
    data_b=>data_b(79 downto 72),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(79 downto 72),
    q_b=>q_b(79 downto 72)
);

 decision_ram11:decision_ram
port map(
    address_a=>address_a(76 downto 70),
    address_b=>address_b(76 downto 70),
    clock=>clock,
    data_a=>data_a(87 downto 80),
    data_b=>data_b(87 downto 80),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(87 downto 80),
    q_b=>q_b(87 downto 80)
);

 decision_ram12:decision_ram
port map(
    address_a=>address_a(83 downto 77),
    address_b=>address_b(83 downto 77),
    clock=>clock,
    data_a=>data_a(95 downto 88),
    data_b=>data_b(95 downto 88),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(95 downto 88),
    q_b=>q_b(95 downto 88)
);

 decision_ram13:decision_ram
port map(
    address_a=>address_a(90 downto 84),
    address_b=>address_b(90 downto 84),
    clock=>clock,
    data_a=>data_a(103 downto 96),
    data_b=>data_b(103 downto 96),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(103 downto 96),
    q_b=>q_b(103 downto 96)
);

 decision_ram14:decision_ram
port map(
    address_a=>address_a(97 downto 91),
    address_b=>address_b(97 downto 91),
    clock=>clock,
    data_a=>data_a(111 downto 104),
    data_b=>data_b(111 downto 104),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(111 downto 104),
    q_b=>q_b(111 downto 104)
);

 decision_ram15:decision_ram
port map(
    address_a=>address_a(104 downto 98),
    address_b=>address_b(104 downto 98),
    clock=>clock,
    data_a=>data_a(119 downto 112),
    data_b=>data_b(119 downto 112),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(119 downto 112),
    q_b=>q_b(119 downto 112)
);

 decision_ram16:decision_ram
port map(
    address_a=>address_a(111 downto 105),
    address_b=>address_b(111 downto 105),
    clock=>clock,
    data_a=>data_a(127 downto 120),
    data_b=>data_b(127 downto 120),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(127 downto 120),
    q_b=>q_b(127 downto 120)
);

 decision_ram17:decision_ram
port map(
    address_a=>address_a(118 downto 112),
    address_b=>address_b(118 downto 112),
    clock=>clock,
    data_a=>data_a(135 downto 128),
    data_b=>data_b(135 downto 128),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(135 downto 128),
    q_b=>q_b(135 downto 128)
);

 decision_ram18:decision_ram
port map(
    address_a=>address_a(125 downto 119),
    address_b=>address_b(125 downto 119),
    clock=>clock,
    data_a=>data_a(143 downto 136),
    data_b=>data_b(143 downto 136),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(143 downto 136),
    q_b=>q_b(143 downto 136)
);

 decision_ram19:decision_ram
port map(
    address_a=>address_a(132 downto 126),
    address_b=>address_b(132 downto 126),
    clock=>clock,
    data_a=>data_a(151 downto 144),
    data_b=>data_b(151 downto 144),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(151 downto 144),
    q_b=>q_b(151 downto 144)
);

 decision_ram20:decision_ram
port map(
    address_a=>address_a(139 downto 133),
    address_b=>address_b(139 downto 133),
    clock=>clock,
    data_a=>data_a(159 downto 152),
    data_b=>data_b(159 downto 152),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(159 downto 152),
    q_b=>q_b(159 downto 152)
);

 decision_ram21:decision_ram
port map(
    address_a=>address_a(146 downto 140),
    address_b=>address_b(146 downto 140),
    clock=>clock,
    data_a=>data_a(167 downto 160),
    data_b=>data_b(167 downto 160),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(167 downto 160),
    q_b=>q_b(167 downto 160)
);

 decision_ram22:decision_ram
port map(
    address_a=>address_a(153 downto 147),
    address_b=>address_b(153 downto 147),
    clock=>clock,
    data_a=>data_a(175 downto 168),
    data_b=>data_b(175 downto 168),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(175 downto 168),
    q_b=>q_b(175 downto 168)
);

 decision_ram23:decision_ram
port map(
    address_a=>address_a(160 downto 154),
    address_b=>address_b(160 downto 154),
    clock=>clock,
    data_a=>data_a(183 downto 176),
    data_b=>data_b(183 downto 176),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(183 downto 176),
    q_b=>q_b(183 downto 176)
);

decision_ram24:decision_ram 
port map(
    address_a=>address_a(167 downto 161),
    address_b=>address_b(167 downto 161),
    clock=>clock,
    data_a=>data_a(191 downto 184),
    data_b=>data_b(191 downto 184),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(191 downto 184),
    q_b=>q_b(191 downto 184)
);

decision_ram25:decision_ram 
port map(
    address_a=>address_a(174 downto 168),
    address_b=>address_b(174 downto 168),
    clock=>clock,
    data_a=>data_a(199 downto 192),
    data_b=>data_b(199 downto 192),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(199 downto 192),
    q_b=>q_b(199 downto 192)
);

decision_ram26:decision_ram 
port map(
    address_a=>address_a(181 downto 175),
    address_b=>address_b(181 downto 175),
    clock=>clock,
    data_a=>data_a(207 downto 200),
    data_b=>data_b(207 downto 200),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(207 downto 200),
    q_b=>q_b(207 downto 200)
);

decision_ram27:decision_ram 
port map(
    address_a=>address_a(188 downto 182),
    address_b=>address_b(188 downto 182),
    clock=>clock,
    data_a=>data_a(215 downto 208),
    data_b=>data_b(215 downto 208),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(215 downto 208),
    q_b=>q_b(215 downto 208)
);

decision_ram28:decision_ram 
port map(
    address_a=>address_a(195 downto 189),
    address_b=>address_b(195 downto 189),
    clock=>clock,
    data_a=>data_a(223 downto 216),
    data_b=>data_b(223 downto 216),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(223 downto 216),
    q_b=>q_b(223 downto 216)
);

 decision_ram29:decision_ram
port map(
    address_a=>address_a(202 downto 196),
    address_b=>address_b(202 downto 196),
    clock=>clock,
    data_a=>data_a(231 downto 224),
    data_b=>data_b(231 downto 224),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(231 downto 224),
    q_b=>q_b(231 downto 224)
);

 decision_ram30:decision_ram
port map(
    address_a=>address_a(209 downto 203),
    address_b=>address_b(209 downto 203),
    clock=>clock,
    data_a=>data_a(239 downto 232),
    data_b=>data_b(239 downto 232),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(239 downto 232),
    q_b=>q_b(239 downto 232)
);

decision_ram31: decision_ram
port map(
    address_a=>address_a(216 downto 210),
    address_b=>address_b(216 downto 210),
    clock=>clock,
    data_a=>data_a(247 downto 240),
    data_b=>data_b(247 downto 240),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(247 downto 240),
    q_b=>q_b(247 downto 240)
);

decision_ram32: decision_ram
port map(
    address_a=>address_a(223 downto 217),
    address_b=>address_b(223 downto 217),
    clock=>clock,
    data_a=>data_a(255 downto 248),
    data_b=>data_b(255 downto 248),
    wren_a=>wren_a,
    wren_b=>wren_b,
    q_a=>q_a(255 downto 248),
    q_b=>q_b(255 downto 248)
 );

end rtl;