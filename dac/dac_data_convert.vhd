


library ieee;                                              
use ieee.std_logic_1164.all;                               
use ieee.numeric_std.all;                                  
                                                           
entity dac_data_convert is                                         
	generic(                                                 
		kInSize	 : positive := 14;                             
		kOutSize : positive := 120                             
	   );                                                    
	port(                                                    
		aReset	: in  std_logic;                               
		clk	: in  std_logic;                                   
		cDin0	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin1	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin2	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin3	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin4	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin5	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin6	: in  std_logic_vector (kInSize-1 downto 0);     
		cDin7	: in  std_logic_vector (kInSize-1 downto 0);     
		cDout	: out std_logic_vector (kOutSize-1 downto 0)     
		                                                       
		);                                                     
end entity dac_data_convert;                                              
		                                                       
architecture rtl of dac_data_convert is                            
signal cout_m:  std_logic_vector (kOutSize-1 downto 0);    
begin                                                      
                                                           
                                                           
process( aReset, clk )                                     
begin                                                      
	if aReset = '1' then                                     
		cout_m <= ( others=>'0');                              
	elsif rising_edge( clk ) then                            
		for i in 0 to kInSize-1 loop                           			
			cout_m(8*i+7) <= cDin7(i);                           
			cout_m(8*i+6) <= cDin6(i);                           
			cout_m(8*i+5) <= cDin5(i);                           
			cout_m(8*i+4) <= cDin4(i);                           
			cout_m(8*i+3) <= cDin3(i);                           
			cout_m(8*i+2) <= cDin2(i);                           
			cout_m(8*i+1) <= cDin1(i);                           
			cout_m(8*i)   <= cDin0(i);   	                           
		end loop; 
		cout_m(8*kInSize+7) <= '0';
		cout_m(8*kInSize+6) <= '1';
		cout_m(8*kInSize+5) <= '0';
		cout_m(8*kInSize+4) <= '1';
		cout_m(8*kInSize+3) <= '0';
		cout_m(8*kInSize+2) <= '1';
		cout_m(8*kInSize+1) <= '0';
		cout_m(8*kInSize)   <= '1';                                             
	end if;                                                  
end process;                                               
cDout <= cout_m;--(not cout_m(27)) &  cout_m(26 downto 0); 
                                                           
end architecture rtl;	                                                 
                                                           
	                                                         
		                                                       