library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_rotate_QPSK is   
port(
		aReset	: in std_logic;
		clk		: in std_logic;
		phase_set	: in std_logic_vector(1 downto 0) ;
		datain_i0	: in std_logic_vector(7 downto 0);
		datain_i1	: in std_logic_vector(7 downto 0);
		datain_q0	: in std_logic_vector(7 downto 0);
		datain_q1	: in std_logic_vector(7 downto 0);
		datain_valid    : in  std_logic;
		
		dataout_i0       : out  std_logic_vector(7 downto 0);
		dataout_i1       : out  std_logic_vector(7 downto 0);
		dataout_q0       : out  std_logic_vector(7 downto 0);
		dataout_q1       : out  std_logic_vector(7 downto 0);
		dataout_valid   : out  std_logic 
	);
end entity;

architecture rtl of phase_rotate_QPSK is


begin

phase_rotate_bycase : process( clk, aReset )
begin
  if( aReset = '1' ) then
    dataout_i0 <= (others => '0');
    dataout_i1 <= (others => '0');
    dataout_q0 <= (others => '0');
    dataout_q1 <= (others => '0');
    dataout_valid <= '0';
  elsif( rising_edge(clk) ) then
  	if datain_valid = '1' then
	  	case( phase_set ) is 
	  		when "00" =>  
	  			dataout_i0 <= datain_i0;
				dataout_i1 <= datain_i1;
				dataout_q0 <= datain_q0;
				dataout_q1 <= datain_q1;
			when "01" =>  
	  			dataout_i0 <= std_logic_vector(-signed(datain_q0));				
				dataout_q0 <= datain_i0;
				dataout_i1 <= std_logic_vector(-signed(datain_q1));
				dataout_q1 <= datain_i1;
			when "10" =>  
	  			dataout_i0 <= std_logic_vector(-signed(datain_i0));				
				dataout_q0 <= std_logic_vector(-signed(datain_q0));
				dataout_i1 <= std_logic_vector(-signed(datain_i1));
				dataout_q1 <= std_logic_vector(-signed(datain_q1));
			when "11" =>  
	  			dataout_i0 <= datain_q0;				
				dataout_q0 <= std_logic_vector(-signed(datain_i0));
				dataout_i1 <= datain_q1;
				dataout_q1 <= std_logic_vector(-signed(datain_i1));
	  		when others => 
	  			null;
	  	end case ;
	  	dataout_valid <= '1';
	else
		dataout_valid <= '0';
	end if;

  end if ;
end process ; -- phase_rotate_bycase


end rtl;