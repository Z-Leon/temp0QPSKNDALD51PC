library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	message_block	 is         
port(
   
   address_a: in std_logic_vector(223 downto 0);
   address_b: in std_logic_vector(223 downto 0);
   clock    : in std_logic;
   
   data_a   : in std_logic_vector(1023 downto 0);
   data_b   : in std_logic_vector(1023 downto 0);
   wren_a   : in std_logic;
   wren_b   : in std_logic;
   q_a      : out std_logic_vector(1023 downto 0);
   q_b      : out std_logic_vector(1023 downto 0)
	);	 
end	message_block;

architecture rtl of message_block is
   component message_ram is
     port(
	   address_a:in std_logic_vector(6 downto 0);
      address_b:in std_logic_vector(6 downto 0);
      clock    :in std_logic;
      data_a   :in std_logic_vector(31 downto 0);
      data_b   :in std_logic_vector(31 downto 0);
      
      wren_a   :in std_logic;
      wren_b   :in std_logic;
      q_a      :out std_logic_vector(31 downto 0);
      q_b      :out std_logic_vector(31 downto 0)
	  );	 
	end component;  
	 
	 begin
	    
   		 message_ram1:message_ram
		 port map(
		  address_a=>address_a(6 downto 0),
		  address_b=>address_b(6 downto 0),
		  clock=>clock,
		  data_a=>data_a(31 downto 0),
		  data_b=>data_b(31 downto 0),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(31 downto 0),
		  q_b=>q_b(31 downto 0)
		   );
		 message_ram2:message_ram
		 port map(
		  address_a=>address_a(13 downto 7),
		  address_b=>address_b(13 downto 7),
		  clock=>clock,
		  data_a=>data_a(63 downto 32),
		  data_b=>data_b(63 downto 32),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(63 downto 32),
		  q_b=>q_b(63 downto 32)
		   );
		 message_ram3:message_ram
		 port map(
		  address_a=>address_a(20 downto 14),
		  address_b=>address_b(20 downto 14),
		  clock=>clock,
		  data_a=>data_a(95 downto 64),
		  data_b=>data_b(95 downto 64),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(95 downto 64),
		  q_b=>q_b(95 downto 64)
		   );
		 message_ram4:message_ram
		 port map(
		  address_a=>address_a(27 downto 21),
		  address_b=>address_b(27 downto 21),
		  clock=>clock,
		  data_a=>data_a(127 downto 96),
		  data_b=>data_b(127 downto 96),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(127 downto 96),
		  q_b=>q_b(127 downto 96)
		   );
		 message_ram5:message_ram
		 port map(
		  address_a=>address_a(34 downto 28),
		  address_b=>address_b(34 downto 28),
		  clock=>clock,
		  data_a=>data_a(159 downto 128),
		  data_b=>data_b(159 downto 128),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(159 downto 128),
		  q_b=>q_b(159 downto 128)
		   );
		 message_ram6:message_ram
		 port map(
		  address_a=>address_a(41 downto 35),
		  address_b=>address_b(41 downto 35),
		  clock=>clock,
		  data_a=>data_a(191 downto 160),
		  data_b=>data_b(191 downto 160),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(191 downto 160),
		  q_b=>q_b(191 downto 160)
		   );
		 message_ram7:message_ram
		 port map(
		  address_a=>address_a(48 downto 42),
		  address_b=>address_b(48 downto 42),
		  clock=>clock,
		  data_a=>data_a(223 downto 192),
		  data_b=>data_b(223 downto 192),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(223 downto 192),
		  q_b=>q_b(223 downto 192)
		   );
		 message_ram8:message_ram
		 port map(
		  address_a=>address_a(55 downto 49),
		  address_b=>address_b(55 downto 49),
		  clock=>clock,
		  data_a=>data_a(255 downto 224),
		  data_b=>data_b(255 downto 224),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(255 downto 224),
		  q_b=>q_b(255 downto 224)
		   );
		 message_ram9:message_ram
		 port map(
		  address_a=>address_a(62 downto 56),
		  address_b=>address_b(62 downto 56),
		  clock=>clock,
		  data_a=>data_a(287 downto 256),
		  data_b=>data_b(287 downto 256),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(287 downto 256),
		  q_b=>q_b(287 downto 256)
		   );
		 message_ram10:message_ram
		 port map(
		  address_a=>address_a(69 downto 63),
		  address_b=>address_b(69 downto 63),
		  clock=>clock,
		  data_a=>data_a(319 downto 288),
		  data_b=>data_b(319 downto 288),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(319 downto 288),
		  q_b=>q_b(319 downto 288)
		   );
		 message_ram11:message_ram
		 port map(
		  address_a=>address_a(76 downto 70),
		  address_b=>address_b(76 downto 70),
		  clock=>clock,
		  data_a=>data_a(351 downto 320),
		  data_b=>data_b(351 downto 320),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(351 downto 320),
		  q_b=>q_b(351 downto 320)
		   );
		 message_ram12:message_ram
		 port map(
		  address_a=>address_a(83 downto 77),
		  address_b=>address_b(83 downto 77),
		  clock=>clock,
		  data_a=>data_a(383 downto 352),
		  data_b=>data_b(383 downto 352),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(383 downto 352),
		  q_b=>q_b(383 downto 352)
		   );
		 message_ram13:message_ram
		 port map(
		  address_a=>address_a(90 downto 84),
		  address_b=>address_b(90 downto 84),
		  clock=>clock,
		  data_a=>data_a(415 downto 384),
		  data_b=>data_b(415 downto 384),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(415 downto 384),
		  q_b=>q_b(415 downto 384)
		   );
		 message_ram14:message_ram
		 port map(
		  address_a=>address_a(97 downto 91),
		  address_b=>address_b(97 downto 91),
		  clock=>clock,
		  data_a=>data_a(447 downto 416),
		  data_b=>data_b(447 downto 416),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(447 downto 416),
		  q_b=>q_b(447 downto 416)
		   );
		 message_ram15:message_ram
		 port map(
		  address_a=>address_a(104 downto 98),
		  address_b=>address_b(104 downto 98),
		  clock=>clock,
		  data_a=>data_a(479 downto 448),
		  data_b=>data_b(479 downto 448),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(479 downto 448),
		  q_b=>q_b(479 downto 448)
		   );
		 message_ram16:message_ram
		 port map(
		  address_a=>address_a(111 downto 105),
		  address_b=>address_b(111 downto 105),
		  clock=>clock,
		  data_a=>data_a(511 downto 480),
		  data_b=>data_b(511 downto 480),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(511 downto 480),
		  q_b=>q_b(511 downto 480)
		   );
		 message_ram17:message_ram
		 port map(
		  address_a=>address_a(118 downto 112),
		  address_b=>address_b(118 downto 112),
		  clock=>clock,
		  data_a=>data_a(543 downto 512),
		  data_b=>data_b(543 downto 512),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(543 downto 512),
		  q_b=>q_b(543 downto 512)
		   );
		 message_ram18:message_ram
		 port map(
		  address_a=>address_a(125 downto 119),
		  address_b=>address_b(125 downto 119),
		  clock=>clock,
		  data_a=>data_a(575 downto 544),
		  data_b=>data_b(575 downto 544),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(575 downto 544),
		  q_b=>q_b(575 downto 544)
		   );
		 message_ram19:message_ram
		 port map(
		  address_a=>address_a(132 downto 126),
		  address_b=>address_b(132 downto 126),
		  clock=>clock,
		  data_a=>data_a(607 downto 576),
		  data_b=>data_b(607 downto 576),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(607 downto 576),
		  q_b=>q_b(607 downto 576)
		   );
		 message_ram20:message_ram
		 port map(
		  address_a=>address_a(139 downto 133),
		  address_b=>address_b(139 downto 133),
		  clock=>clock,
		  data_a=>data_a(639 downto 608),
		  data_b=>data_b(639 downto 608),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(639 downto 608),
		  q_b=>q_b(639 downto 608)
		   );
		 message_ram21:message_ram
		 port map(
		  address_a=>address_a(146 downto 140),
		  address_b=>address_b(146 downto 140),
		  clock=>clock,
		  data_a=>data_a(671 downto 640),
		  data_b=>data_b(671 downto 640),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(671 downto 640),
		  q_b=>q_b(671 downto 640)
		   );
		 message_ram22:message_ram
		 port map(
		  address_a=>address_a(153 downto 147),
		  address_b=>address_b(153 downto 147),
		  clock=>clock,
		  data_a=>data_a(703 downto 672),
		  data_b=>data_b(703 downto 672),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(703 downto 672),
		  q_b=>q_b(703 downto 672)
		   );
		 message_ram23:message_ram
		 port map(
		  address_a=>address_a(160 downto 154),
		  address_b=>address_b(160 downto 154),
		  clock=>clock,
		  data_a=>data_a(735 downto 704),
		  data_b=>data_b(735 downto 704),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(735 downto 704),
		  q_b=>q_b(735 downto 704)
		   );
		 message_ram24:message_ram
		 port map(
		  address_a=>address_a(167 downto 161),
		  address_b=>address_b(167 downto 161),
		  clock=>clock,
		  data_a=>data_a(767 downto 736),
		  data_b=>data_b(767 downto 736),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(767 downto 736),
		  q_b=>q_b(767 downto 736)
		   );
		 message_ram25:message_ram
		 port map(
		  address_a=>address_a(174 downto 168),
		  address_b=>address_b(174 downto 168),
		  clock=>clock,
		  data_a=>data_a(799 downto 768),
		  data_b=>data_b(799 downto 768),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(799 downto 768),
		  q_b=>q_b(799 downto 768)
		   );
		 message_ram26:message_ram
		 port map(
		  address_a=>address_a(181 downto 175),
		  address_b=>address_b(181 downto 175),
		  clock=>clock,
		  data_a=>data_a(831 downto 800),
		  data_b=>data_b(831 downto 800),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(831 downto 800),
		  q_b=>q_b(831 downto 800)
		   );
		 message_ram27:message_ram
		 port map(
		  address_a=>address_a(188 downto 182),
		  address_b=>address_b(188 downto 182),
		  clock=>clock,
		  data_a=>data_a(863 downto 832),
		  data_b=>data_b(863 downto 832),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(863 downto 832),
		  q_b=>q_b(863 downto 832)
		   );
		 message_ram28:message_ram
		 port map(
		  address_a=>address_a(195 downto 189),
		  address_b=>address_b(195 downto 189),
		  clock=>clock,
		  data_a=>data_a(895 downto 864),
		  data_b=>data_b(895 downto 864),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(895 downto 864),
		  q_b=>q_b(895 downto 864)
		   );
		 message_ram29:message_ram
		 port map(
		  address_a=>address_a(202 downto 196),
		  address_b=>address_b(202 downto 196),
		  clock=>clock,
		  data_a=>data_a(927 downto 896),
		  data_b=>data_b(927 downto 896),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(927 downto 896),
		  q_b=>q_b(927 downto 896)
		   );
		 message_ram30:message_ram
		 port map(
		  address_a=>address_a(209 downto 203),
		  address_b=>address_b(209 downto 203),
		  clock=>clock,
		  data_a=>data_a(959 downto 928),
		  data_b=>data_b(959 downto 928),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(959 downto 928),
		  q_b=>q_b(959 downto 928)
		   );
		 message_ram31:message_ram
		 port map(
		  address_a=>address_a(216 downto 210),
		  address_b=>address_b(216 downto 210),
		  clock=>clock,
		  data_a=>data_a(991 downto 960),
		  data_b=>data_b(991 downto 960),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(991 downto 960),
		  q_b=>q_b(991 downto 960)
		   );
		 message_ram32:message_ram
		 port map(
		  address_a=>address_a(223 downto 217),
		  address_b=>address_b(223 downto 217),
		  clock=>clock,
		  data_a=>data_a(1023 downto 992),
		  data_b=>data_b(1023 downto 992),
		  wren_a=>wren_a,
		  wren_b=>wren_b,
		  q_a=>q_a(1023 downto 992),
		  q_b=>q_b(1023 downto 992)
		   );
	  end rtl;