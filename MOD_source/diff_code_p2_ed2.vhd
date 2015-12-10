-- 2015-03-06  Diff encode for wuyc's soft-decode module

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity diff_code_p2_ed2 is
port(
      aReset          : in  std_logic; 
      clk             : in  std_logic;
      datain_i        : in  std_logic_vector(1 downto 0);
      datain_q        : in  std_logic_vector(1 downto 0);
     
      dataout_i       : out  std_logic_vector(1 downto 0);
      dataout_q       : out  std_logic_vector(1 downto 0)
      );
end entity diff_code_p2_ed2 ;
	
architecture rtl of diff_code_p2_ed2 is 
	
	signal code_in_0       : std_logic_vector(1 downto 0) ;
	signal code_in_1       : std_logic_vector(1 downto 0) ;
	signal code_out_0      : std_logic_vector(1 downto 0) ;
	signal code_out_1      : std_logic_vector(1 downto 0) ;
  signal code_in_1_delay : std_logic_vector(1 downto 0) ;		
  			
  					
begin 
	 process(datain_i(0),datain_q(0))
	 begin
		if datain_i(0)='1' then
			code_in_0 <= datain_i(0) & (not(datain_q(0)));
		else
			code_in_0 <= datain_i(0) & datain_q(0);
		end if;
	 end process;
	 
	 process(datain_i(1),datain_q(1))
	 begin
		if datain_i(1)='1' then
			code_in_1 <= datain_i(1) & (not(datain_q(1)));
		else
			code_in_1 <= datain_i(1) & datain_q(1);
		end if;
	 end process;
	 
--	 code_in_0 <= datain_i(0) & datain_q(0);
--	 code_in_1 <= datain_i(1) & datain_q(1);	
	 	
	 process(clk,aReset)
	 begin 
	 	 if (aReset = '1') then
	 	 	   code_in_1_delay <= (others=>'0') ;
	 	 	   code_out_0      <= (others=>'0') ;
	 	 	   code_out_1      <= (others=>'0') ;
	 	 elsif (rising_edge(clk)) then 
	 	 	   code_out_0      <= code_in_0+code_out_1 ;
	 	 	   code_out_1      <= code_in_1+code_in_0+code_out_1;
				
	 	 end if ;
	 end process;
	 
process(aReset,clk)
	begin
		if ( aReset = '1' ) then
			dataout_i <= (others=>'0');
			dataout_q <= (others=>'0');
		elsif rising_edge(clk) then
			case code_out_0 is
				when "00" =>
					dataout_i(0) <= '0';
					dataout_q(0) <= '0';
				when "01" =>
					dataout_i(0) <= '0';
					dataout_q(0) <= '1';
				when "10" =>
					dataout_i(0) <= '1';
					dataout_q(0) <= '1';
				when "11" =>
					dataout_i(0) <= '1';
					dataout_q(0) <= '0';
			end case;	
			
			case code_out_1 is
				when "00" =>
					dataout_i(1) <= '0';
					dataout_q(1) <= '0';
				when "01" =>
					dataout_i(1) <= '0';
					dataout_q(1) <= '1';
				when "10" =>
					dataout_i(1) <= '1';
					dataout_q(1) <= '1';
				when "11" =>
					dataout_i(1) <= '1';
					dataout_q(1) <= '0';
			end case;	
	end if;
end process;
	 
	
	
end architecture rtl ;
	