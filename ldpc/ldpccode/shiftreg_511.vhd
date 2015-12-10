    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

	entity shiftreg_511 is
	port
	(
		reset   :    in std_logic;
		clk     :    in std_logic;
		
		load_data   :   in std_logic_vector(510 downto 0);
		load_val    :   in std_logic;
		shift_val   :   in std_logic;
		
		shiftreg_out:   out std_logic_vector(510 downto 0)
	);
	end  shiftreg_511;
	
	architecture rtl of shiftreg_511 is
	
	signal temp_shiftreg_out :  std_logic_vector(510 downto 0);
	
	begin
		
		shiftreg_out <= temp_shiftreg_out;
		
		process ( reset , clk )
		begin
			if ( reset='1' ) then
				temp_shiftreg_out <= (others=>'0');
			elsif rising_edge(clk) then
				if ( load_val = '1' ) then
					temp_shiftreg_out <= load_data;
				elsif ( shift_val = '1' ) then
					temp_shiftreg_out(510 downto 8) <=  temp_shiftreg_out(502 downto 0);
					temp_shiftreg_out(7 downto 0)   <=  temp_shiftreg_out(510 downto 503);
				else
					temp_shiftreg_out <= temp_shiftreg_out;
				end if;
			end if;
		end process;
	end rtl;