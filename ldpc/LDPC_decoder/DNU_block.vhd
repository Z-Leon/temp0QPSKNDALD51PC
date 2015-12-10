library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity	DNU_block	 is         
port(
	 clk   : in std_logic;
	 reset : in std_logic;
	 data_in  :in std_logic_vector(511 downto 0); 
	 DNU_eop : in std_logic;
	 
	 decision :out std_logic
	 );	 
end	DNU_block;

architecture rtl of DNU_block is 
    signal decision_reg :std_logic; 
    signal decision_out :std_logic_vector(1 downto 0);
  component DNU_p is
    port(
	 clk    : in std_logic;
	 reset 	: in std_logic;
	 data_in  :in std_logic_vector(255 downto 0); 
	 i_eop 	: in std_logic;
	 decision :out std_logic
	      );
  end component;  
 
  begin  
   DNU_p_inst1:DNU_p 
    port map (
	  clk=>clk,
	  reset=>reset,
	  data_in=>data_in(255 downto 0),
	  i_eop=>DNU_eop,
	  decision=>decision_out(0)
	    );
	 
	DNU_p_inst2:DNU_p 
    port map(
	  clk=>clk,
	  reset=>reset,
	  data_in=>data_in(511 downto 256),
	  i_eop=>DNU_eop,
	  decision=>decision_out(1)
	  );
	process(clk,reset) 
	  begin
	   if (reset='1') then
		 decision_reg <= '0';
	   elsif rising_edge(clk) then
		 decision_reg <= decision_reg or decision_out(0) or decision_out(1);
      end if;
   end process;
   
	 decision<= not decision_reg;
  end rtl;
