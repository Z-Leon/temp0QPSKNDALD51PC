library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ldpc_buffer_block	 is         
port(
   clock     : in  std_logic;
   reset     : in  std_logic;
   data      : in  std_logic_vector(127 downto 0);
   rdaddress : in  std_logic_vector(95 downto 0);
   wraddress : in  std_logic_vector(111 downto 0);
   wren      : in  std_logic;
   q         : out  std_logic_vector(127 downto 0)
   );	 
end	ldpc_buffer_block;

architecture rtl of ldpc_buffer_block is
    component ldpc_out_ram  is
     port(
	   clock     : in std_logic;
      data      : in std_logic_vector(7 downto 0);
      
      rdaddress : in std_logic_vector(5 downto 0);
      wraddress : in std_logic_vector(5 downto 0);
      
      wren      : in std_logic;
      q         :out std_logic_vector(7 downto 0)
	    );	
    end component;
 begin
     
ldpc_out_buffer1 : ldpc_out_ram  
port map(
   clock=>clock,
   data=>data(7 downto 0),
   rdaddress=>rdaddress(5 downto 0),
   wraddress=>wraddress(5 downto 0),
   wren=>wren,
   q=>q(7 downto 0)
);

ldpc_out_buffer2 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(15 downto 8),
   rdaddress=>rdaddress(11 downto 6),
   wraddress=>wraddress(12 downto 7),
   wren=>wren,
   q=>q(15 downto 8)
);

ldpc_out_buffer3 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(23 downto 16),
   rdaddress=>rdaddress(17 downto 12),
   wraddress=>wraddress(19 downto 14),
   wren=>wren,
   q=>q(23 downto 16)
);

ldpc_out_buffer4 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(31 downto 24),
   rdaddress=>rdaddress(23 downto 18),
   wraddress=>wraddress(26 downto 21),
   wren=>wren,
   q=>q(31 downto 24)
);

ldpc_out_buffer5 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(39 downto 32),
   rdaddress=>rdaddress(29 downto 24),
   wraddress=>wraddress(33 downto 28),
   wren=>wren,
   q=>q(39 downto 32)
);

ldpc_out_buffer6 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(47 downto 40),
   rdaddress=>rdaddress(35 downto 30),
   wraddress=>wraddress(40 downto 35),
   wren=>wren,
   q=>q(47 downto 40)
);

ldpc_out_buffer7 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(55 downto 48),
   rdaddress=>rdaddress(41 downto 36),
   wraddress=>wraddress(47 downto 42),
   wren=>wren,
   q=>q(55 downto 48)
);

ldpc_out_buffer8 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(63 downto 56),
   rdaddress=>rdaddress(47 downto 42),
   wraddress=>wraddress(54 downto 49),
   wren=>wren,
   q=>q(63 downto 56)
);

ldpc_out_buffer9 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(71 downto 64),
   rdaddress=>rdaddress(53 downto 48),
   wraddress=>wraddress(61 downto 56),
   wren=>wren,
   q=>q(71 downto 64)
);

ldpc_out_buffer10 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(79 downto 72),
   rdaddress=>rdaddress(59 downto 54),
   wraddress=>wraddress(68 downto 63),
   wren=>wren,
   q=>q(79 downto 72)
);

ldpc_out_buffer11 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(87 downto 80),
   rdaddress=>rdaddress(65 downto 60),
   wraddress=>wraddress(75 downto 70),
   wren=>wren,
   q=>q(87 downto 80)
);

ldpc_out_buffer12 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(95 downto 88),
   rdaddress=>rdaddress(71 downto 66),
   wraddress=>wraddress(82 downto 77),
   wren=>wren,
   q=>q(95 downto 88)
);

ldpc_out_buffer13 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(103 downto 96),
   rdaddress=>rdaddress(77 downto 72),
   wraddress=>wraddress(89 downto 84),
   wren=>wren,
   q=>q(103 downto 96)
);

ldpc_out_buffer14 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(111 downto 104),
   rdaddress=>rdaddress(83 downto 78),
   wraddress=>wraddress(96 downto 91),
   wren=>wren,
   q=>q(111 downto 104)
);

ldpc_out_buffer15 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(119 downto 112),
   rdaddress=>rdaddress(89 downto 84),
   wraddress=>wraddress(103 downto 98),
   wren=>wren,
   q=>q(119 downto 112)
);

ldpc_out_buffer16 : ldpc_out_ram
port map(
   clock=>clock,
   data=>data(127 downto 120),
   rdaddress=>rdaddress(95 downto 90),
   wraddress=>wraddress(110 downto 105),
   wren=>wren,
   q=>q(127 downto 120)
);
end rtl;