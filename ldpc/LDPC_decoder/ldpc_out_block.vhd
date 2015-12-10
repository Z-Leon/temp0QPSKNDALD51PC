library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ldpc_out_block	 is         
port(
   clock     : in  std_logic;
   reset     : in  std_logic;
   
   data      : in  std_logic_vector(127 downto 0);
   rdaddress : in  std_logic_vector(5 downto 0);
   wraddress : in  std_logic_vector(95 downto 0);
   wren      : in  std_logic;
   q         : out std_logic_vector(7 downto 0)
   );	 
end	ldpc_out_block;

architecture rtl of ldpc_out_block is
    
    type qout is array (15 downto 0) of std_logic_vector(7 downto 0);
    
    signal q_out:qout;
    
    signal q_reg,q_dly1,q_dly2,q_dly3 :std_logic_vector(7 downto 0);
    signal rden :std_logic_vector(15 downto 0);
    signal counter,counter_dly1,counter_dly2,counter_dly3 :std_logic_vector(5 downto 0);
    signal counter_p:std_logic_vector(5 downto 0);
    
    component ldpc_out_ram  is
     port(
	   clock     : in std_logic;
      data      : in std_logic_vector(7 downto 0);
      
      rdaddress : in std_logic_vector(5 downto 0);
      wraddress : in std_logic_vector(5 downto 0);
      
      wren      : in std_logic;
      q         : out std_logic_vector(7 downto 0)
	    );	
    end component;
    
  begin
    process(clock,reset)
    begin
       if (reset='1') then
          counter <=(others=>'0');
		    counter_dly1<=(others=>'0');
		    counter_dly2<=(others=>'0');
		    counter_dly3<=(others=>'0');
		  elsif (clock'event and clock='1') then
		       if (wren='0') then 
		        counter <=counter + 1;
		        else
		        counter <="000000";
		        end if;
		        counter_dly1 <=counter;
		        counter_dly2 <=counter_dly1;
		        counter_dly3 <=counter_dly2;
		  end if;
    end process; 
    
    process(clock,reset)
    begin
       if (reset='1') then
          rden <="1000000000000000";
		  elsif (clock'event and clock='1') then
		     if((wren='0') and (counter=63)) then 
		       rden <=rden(0)&rden(15 downto 1);
		     else
		       rden <=rden;
		     end if;
		  end if;
    end process; 
    
    process(clock,reset)
    begin
       if (reset='1') then
          q_reg <="00000000";
		  elsif (clock'event and clock='1') then
		      case rden is
		         when "0000000000000001" =>
		            q_reg <=q_out(0);
			      when "0000000000000010" => 
			         q_reg <=q_out(1);
			      when "0000000000000100" => 
			         q_reg <=q_out(2);
			      when "0000000000001000" => 
			         q_reg <=q_out(3);
			      when "0000000000010000" =>
			         q_reg <=q_out(4);
			      when "0000000000100000" =>
			         q_reg <=q_out(5);
			      when "0000000001000000" =>
			         q_reg <=q_out(6);
			      when "0000000010000000" => 
			         q_reg <=q_out(7);
			      when "0000000100000000" =>
			         q_reg <=q_out(8);
			      when "0000001000000000" => 
			         q_reg <=q_out(9);
			      when "0000010000000000" =>
			         q_reg <=q_out(10);
			      when "0000100000000000" => 
			         q_reg <=q_out(11);
			      when "0001000000000000" => 
			         q_reg <=q_out(12);
			      when "0010000000000000" =>
			         q_reg <=q_out(13);
			      when "0100000000000000" => 
			         q_reg <=q_out(14);
			      when "1000000000000000" => 
			         q_reg <=q_out(15);
			      when others =>
                  q_reg <=q_out(0);
		      end case;
		    end if;
		  end process;
		  
	 process(clock,reset)
    begin
       if (reset='1') then
          q_dly1 <="00000000";
		    q_dly2 <="00000000";
		    q_dly3 <="00000000";
		  elsif (clock'event and clock='1') then
		     q_dly1 <=q_reg;
		     q_dly2 <=q_dly1;
		     q_dly3 <=q_dly2;
		  end if;
    end process;  
		       
    process(clock,reset)
    begin
       if (reset='1') then
          q <="00000000";
		    counter_p <="000000";
		  elsif (clock'event and clock='1') then
		   case counter_p is
		       when "000000" =>	
					q <=q_dly2(1 downto 0) & q_dly3(7 downto 2);
					if (counter_dly3 =63) then
					  counter_p <=counter_p + 1;
					else
					  counter_p <=counter_p;
					end if;
				 when "000001"=> 
					if(counter_dly3 =0) then
						q <=q_dly2(2 downto 0) & q_dly3(6 downto 2);
					else
						q <=q_dly2(2 downto 0) & q_dly3(7 downto 3);
					end if;
					if (counter_dly3 =63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				 when "000010"=> 
					if(counter_dly3 =0) then
						q <=q_dly2(3 downto 0) & q_dly3(6 downto 3);
					else
						q <=q_dly2(3 downto 0) & q_dly3(7 downto 4);
					end if;
					if (counter_dly3 =63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				 when "000011"=> 
					if(counter_dly3 =0) then
						q <=q_dly2(4 downto 0) & q_dly3(6 downto 4);
					else
						q <=q_dly2(4 downto 0) & q_dly3(7 downto 5);
					end if;
					if (counter_dly3 =63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				 when "000100"=> 
					if(counter_dly3 =0) then
						q <=q_dly2(5 downto 0) & q_dly3(6 downto 5);
					else
						q <=q_dly2(5 downto 0) & q_dly3(7 downto 6);
					end if;
					if (counter_dly3 =63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "000101"=> 
					if(counter_dly3 =0) then
						q <=q_dly2(6 downto 0) & q_dly3(6);
					else
						q <=q_dly2(6 downto 0) & q_dly3(7);
					end if;
					if (counter_dly3 =63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "000110"=> 
						q <=q_dly2(7 downto 0);	
					
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;	
					end if;
				  when "000111"=> 
					if(counter_dly2=0) then
						q <=q_dly1(0) & q_dly2(6 downto 0);
					else
						q <=q_dly1(0) & q_dly2(7 downto 1);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
				   end if;
				  when "001000"=> 
					if(counter_dly2=0) then
						q <=q_dly1(1 downto 0) & q_dly2(6 downto 1);
					else
						q <=q_dly1(1 downto 0) & q_dly2(7 downto 2);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
				   end if;
				  when "001001"=> 
					if(counter_dly2=0) then
						q <=q_dly1(2 downto 0) & q_dly2(6 downto 2);
					else
						q <=q_dly1(2 downto 0) & q_dly2(7 downto 3);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "001010"=> 
					if(counter_dly2=0) then
						q <=q_dly1(3 downto 0) & q_dly2(6 downto 3);
					else
						q <=q_dly1(3 downto 0) & q_dly2(7 downto 4);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
				   end if;
				  when "001011"=> 
					if(counter_dly2=0) then
						q <=q_dly1(4 downto 0) & q_dly2(6 downto 4);
					else
						q <=q_dly1(4 downto 0) & q_dly2(7 downto 5);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "001100"=> 
					if(counter_dly2=0) then
						q <=q_dly1(5 downto 0) & q_dly2(6 downto 5);
					else
						q <=q_dly1(5 downto 0) & q_dly2(7 downto 6);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "001101"=> 
					if(counter_dly2=0) then
						q <=q_dly1(6 downto 0) & q_dly2(6);
					else
						q <=q_dly1(6 downto 0) & q_dly2(7);
					end if;
					if (counter_dly2=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "001110"=>
					  q <=q_dly1(7 downto 0); 
					if (counter_dly1=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "001111"=> 
					if(counter_dly1=0) then
						q <=q_reg(0) & q_dly1(6 downto 0);
					else
						q <=q_reg(0) & q_dly1(7 downto 1);
					end if;
					if (counter_dly1=63) then
						counter_p <=counter_p + 1;
					else
						counter_p <=counter_p;
					end if;
				  when "010000"=> 
					 q <="00" & q_dly1(6 downto 1);
				  when others=> 
					 q <=q_dly2(1 downto 0) & q_dly3(7 downto 2); 
					if (counter_dly3 =63) then
					 counter_p <=counter_p + 1;
					else
					 counter_p <=counter_p;
					end if;	
				  end case;
				end if;
		    end process;
	
		ldpc_out_ram1:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(7 downto 0),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(5 downto 0),
		   wren=>wren,
		   q=>q_out(0)
		);
		ldpc_out_ram2:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(15 downto 8),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(11 downto 6),
		   wren=>wren,
		   q=>q_out(1)
		);
		ldpc_out_ram3:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(23 downto 16),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(17 downto 12),
		   wren=>wren,
		   q=>q_out(2)
		);
		ldpc_out_ram4:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(31 downto 24),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(23 downto 18),
		   wren=>wren,
		   q=>q_out(3)
		);
		ldpc_out_ram5:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(39 downto 32),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(29 downto 24),
		   wren=>wren,
		   q=>q_out(4)
		);
		ldpc_out_ram6:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(47 downto 40),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(35 downto 30),
		   wren=>wren,
		   q=>q_out(5)
		);
		ldpc_out_ram7:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(55 downto 48),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(41 downto 36),
		   wren=>wren,
		   q=>q_out(6)
		);
		ldpc_out_ram8:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(63 downto 56),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(47 downto 42),
		   wren=>wren,
		   q=>q_out(7)
		);
		ldpc_out_ram9:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(71 downto 64),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(53 downto 48),
		   wren=>wren,
		   q=>q_out(8)
		);
		ldpc_out_ram10:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(79 downto 72),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(59 downto 54),
		   wren=>wren,
		   q=>q_out(9)
		);
		ldpc_out_ram11:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(87 downto 80),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(65 downto 60),
		   wren=>wren,
		   q=>q_out(10)
		);
		ldpc_out_ram12   : ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(95 downto 88),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(71 downto 66),
		   wren=>wren,
		   q=>q_out(11)
		);
		ldpc_out_ram13:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(103 downto 96),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(77 downto 72),
		   wren=>wren,
		   q=>q_out(12)
		);
		ldpc_out_ram14:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(111 downto 104),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(83 downto 78),
		   wren=>wren,
		   q=>q_out(13)
		);
		ldpc_out_ram15:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(119 downto 112),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(89 downto 84),
		   wren=>wren,
		   q=>q_out(14)
		);
		ldpc_out_ram16:ldpc_out_ram  
		port map(
		   clock=>clock,
		   data=>data(127 downto 120),
		   rdaddress=>rdaddress,
		   wraddress=>wraddress(95 downto 90),
		   wren=>wren,
		   q=>q_out(15)
		); 
end rtl;  