library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	ch_message_block	 is         
port(
   
   clock: in std_logic;
   reset: in std_logic;
   ch_address_reset : in std_logic;
   data  : in std_logic_vector(31 downto 0);
   i_val : in std_logic;
   i_sop : in std_logic;
   i_eop : in std_logic;
   wren  : in std_logic;
   q     : out std_logic_vector(511 downto 0)
	);	 
end	ch_message_block;

architecture rtl of ch_message_block is

  component ch_address_gen is
     port(
	   clk       : in std_logic;
	   reset     : in std_logic;
	 
	   rdaddress_reset : in std_logic;
	   val       :       in std_logic;
      
      ch_waddress : out std_logic_vector(5 downto 0); 
	   ch_raddress : out std_logic_vector(95 downto 0)
	    );	
  end component;

  component ch_message_ram is
     port(
	   clock    : in std_logic;
	   data     : in std_logic_vector(31 downto 0);
	   rdaddress: in std_logic_vector(6 downto 0);
	   wraddress : in std_logic_vector(6 downto 0);
	   wren    : in std_logic;
	   q :out std_logic_vector(31 downto 0)
	    );	
  end component;

signal wren_reg:std_logic_vector(15 downto 0);
signal counter,counter_dly :std_logic_vector(5 downto 0);
signal counter_p,counter_p_dly :std_logic_vector(5 downto 0);

signal data_zerofill :std_logic_vector(31 downto 0);

signal data_reg1,data_reg2,data_reg3,data_reg4,data_reg5,data_reg6 :std_logic_vector(31 downto 0);

signal val_zerofill_dly :std_logic;
signal val_reg1,val_reg2,val_reg3,val_reg4,val_reg5,val_reg6:std_logic;

signal rdaddress_reset :std_logic;
signal wpingpong,rpingpong :std_logic;
signal rdaddress :std_logic_vector(95 downto 0);
signal wraddress :std_logic_vector(5 downto 0);

signal val_zerofill:std_logic;
signal val_zerofill_reg1:std_logic;
signal val_zerofill_reg2:std_logic;

signal wren_ram :std_logic_vector(15 downto 0);

signal rdaddress_reset_gen :std_logic;
signal rdaddress_ram1,rdaddress_ram2,rdaddress_ram3,rdaddress_ram4,rdaddress_ram5,rdaddress_ram6,rdaddress_ram7,rdaddress_ram8 :std_logic_vector(6 downto 0);
signal rdaddress_ram9,rdaddress_ram10,rdaddress_ram11,rdaddress_ram12,rdaddress_ram13,rdaddress_ram14,rdaddress_ram15,rdaddress_ram16 :std_logic_vector(6 downto 0);  
signal wraddress_ram :std_logic_vector(6 downto 0);

begin
  process(clock,reset)
    begin
    if (reset='1') then 
		 counter<="000000";
		 counter_dly<="000000";
		 counter_p<="000000";
		 counter_p_dly<="000000";
    elsif (i_sop='1') then
		 counter<="000000";
		 counter_dly<="000000";
		 counter_p<="000000";
		 counter_p_dly<="000000";
	 elsif (clock'event and clock='1') then
         if ((wren and val_zerofill)='1') then
			counter <= counter + 1;
			end if;
		   if (counter="111111")and(wren='1')and(val_zerofill='1') then
			counter_p <= counter_p + 1;
			end if;
			
		   counter_dly <= counter;
		   counter_p_dly <= counter_p;
	  
	  end if;
	end process;
	 
  process(clock,reset)
    begin
    if (reset='1') then 
     rdaddress_reset<='0';
    elsif (clock'event and clock='1') then
		 if((counter_dly = "111111") and (counter_p_dly="001111")) then 
			rdaddress_reset <= '1';
	     else
		   rdaddress_reset <= '0';
         end if;
     end if;
  end process;
  
  process(clock,reset)
    begin
     if (reset='1') then 
         wren_reg<=x"0001";
     elsif (clock'event and clock='1') then
         if (i_sop='1') then 
			wren_reg<=x"0001";
	      else
			  if (counter_dly = "111111") and (val_zerofill_dly='1') and (wren='1') then
				wren_reg <= wren_reg(14 downto 0) & wren_reg(15);
			  else
				wren_reg <= wren_reg;
			  end if;
		 end if;
     end if;
  end process;
  
  process (clock,reset)
    begin
    if (reset='1') then 
      wpingpong <= '0';
		rpingpong <= '1';
    elsif (clock'event and clock='1') then
      if (i_eop='1') then 
			wpingpong <=not wpingpong;
			rpingpong <=not rpingpong;
	     else
		   wpingpong <= wpingpong;
			rpingpong <= rpingpong;
      end if;
     end if;
   end process;
   
   process(clock,reset)
    begin
    if (reset='1') then 
      data_reg1 <= (others=>'0');
		data_reg2 <= (others=>'0');
		data_reg3 <= (others=>'0');
		data_reg4 <= (others=>'0');
		data_reg5 <= (others=>'0');
		data_reg6 <= (others=>'0');
		
		val_reg1 <= '0';
		val_reg2 <= '0';
		val_reg3 <= '0';
		val_reg4 <= '0';
		val_reg5 <= '0';
		val_reg6 <= '0';
	  elsif (clock'event and clock='1') then
           if (i_sop='1') then
					data_reg1 <= data;
					data_reg2 <="0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111";
					data_reg3 <="0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111";
					data_reg4 <="0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111";
					data_reg5 <="0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111";
					data_reg6 <="0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111"&"0111";
					
					val_reg1 <= i_val;
					val_reg2 <= '1';
					val_reg3 <= '1';
					val_reg4 <= '1';
					val_reg5 <= '1';
					val_reg6 <= '1';
		    else
			 if(i_val='1') then
			   data_reg1 <= data;
				end if;
			 if(val_reg1='1') then
				data_reg2 <= data_reg1;
			  end if;
			  
			 if(val_reg2='1') then
				data_reg3 <= data_reg2;
			  end if;
				
			 if(val_reg3='1') then
				data_reg4 <= data_reg3;
			  end if;
			  
			 if(val_reg4='1') then
				data_reg5 <= data_reg4;
			  end if;
			  
			 if(val_reg5='1') then
				data_reg6 <= data_reg5;
			 end if;
			   val_reg1 <= i_val;
			   val_reg2 <= val_reg1;
			   val_reg3 <= val_reg2;
			   val_reg4 <= val_reg3;
			   val_reg5 <= val_reg4;
			   val_reg6 <= val_reg5;
			 end if;
	  end if;
  end process;
  
  process(counter_p,val_reg3,val_reg4,val_reg5)
  begin
      if(counter_p<=5) then
         val_zerofill <= val_reg3;
      elsif(counter_p<=13) then
         val_zerofill <= val_reg4;
      else
         val_zerofill <= val_reg5;
      end if;
  end process;
	
 --val_zerofill_reg1<=val_reg4 when (counter_p<="001101") else val_reg5;
 --val_zerofill_reg2<=val_reg3 when (counter_p<="000101") else val_zerofill_reg1;
 --val_zerofill<=val_zerofill_reg2;
  
  process(clock,reset)
    begin 
     if (reset='1') then
       data_zerofill <= (others=>'0');
       val_zerofill_dly <= '0';
     elsif(clock'event and clock='1') then
       val_zerofill_dly <= val_zerofill;
      case counter_p is
          when "000000" =>
		      data_zerofill <= data_reg3(23 downto 0) & data_reg4(31 downto 24) ;
		  when "000001" =>
		      data_zerofill <= data_reg3(19 downto 0) & data_reg4(31 downto 20) ;
		  when "000010" =>
	         data_zerofill <= data_reg3(15 downto 0) & data_reg4(31 downto 16) ;
	      when "000011" =>
	         data_zerofill <= data_reg3(11 downto 0) & data_reg4(31 downto 12) ;
		  when "000100" =>
	         data_zerofill <= data_reg3(7 downto 0) & data_reg4(31 downto 8) ;
		  when "000101" =>
	         data_zerofill <= data_reg3(3 downto 0) & data_reg4(31 downto 4) ;
		  when "000110" =>
            data_zerofill <= data_reg4(31 downto 0);
		  when "000111" =>
		      data_zerofill <= data_reg4(27 downto 0) & data_reg5(31 downto 28) ;
	      when "001000" =>
		      data_zerofill <= data_reg4(23 downto 0) & data_reg5(31 downto 24) ;
	      when "001001" =>
	         data_zerofill <= data_reg4(19 downto 0) & data_reg5(31 downto 20) ;
	      when "001010" =>
	         data_zerofill <= data_reg4(15 downto 0) & data_reg5(31 downto 16) ;
	      when "001011" =>
	         data_zerofill <= data_reg4(11 downto 0) & data_reg5(31 downto 12) ;
		  when "001100" =>
	         data_zerofill <= data_reg4(7 downto 0) & data_reg5(31 downto 8) ;
		  when "001101" =>
		      data_zerofill <= data_reg4(3 downto 0) & data_reg5(31 downto 4) ;
		  when "001110" =>
	         data_zerofill <= data_reg5(31 downto 0);
		  when "001111" =>
	         data_zerofill <= data_reg5(27 downto 0) & data_reg6(31 downto 28) ;
		  when others =>
	         data_zerofill <= data_reg3(23 downto 0) & data_reg4(31 downto 24) ;
	     end case;
	   end if;
	 end process;
  
  rdaddress_reset_gen<=(rdaddress_reset or ch_address_reset);     
  ch_address_gen_inst:ch_address_gen
         port map(
         clk=>clock,
         reset=>reset,
         rdaddress_reset=>rdaddress_reset_gen,
         val=>val_zerofill_dly,
	      ch_waddress=>wraddress,
	      ch_raddress=>rdaddress
	      );
	
   wren_ram<=wren_reg 
            and(wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren & wren) 
            and(val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly & val_zerofill_dly);  
  --assign wren_ram = wren_reg & {16{wren}} & {16{val_zerofill_dly}};
   rdaddress_ram1<=rpingpong & rdaddress(5 downto 0);
   wraddress_ram<=wpingpong & wraddress;
   ch_message_ram1 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram1,
           wraddress=>wraddress_ram,
           wren=>wren_ram(0),
           q=>q(511 downto 480)
           );
    rdaddress_ram2<=rpingpong & rdaddress(11 downto 6);
    ch_message_ram2 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram2,
           wraddress=>wraddress_ram,
           wren=>wren_ram(1) ,
           q=>q(479 downto 448)
           );
    rdaddress_ram3<=rpingpong & rdaddress(17 downto 12);        
    ch_message_ram3 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram3,
           wraddress=>wraddress_ram,
           wren=>wren_ram(2),
           q=>q(447 downto 416)
           );
            
    rdaddress_ram4<=rpingpong & rdaddress(23 downto 18);      
    ch_message_ram4 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram4,
           wraddress=>wraddress_ram,
           wren=>wren_ram(3) ,
           q=>q(415 downto 384)
           );
           
    rdaddress_ram5<=rpingpong & rdaddress(17 downto 12); 
    ch_message_ram5 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram5,
           wraddress=>wraddress_ram,
           wren=>wren_ram(4) ,
           q=>q(383 downto 352)
           );
           
    rdaddress_ram6<=rpingpong & rdaddress(17 downto 12); 
    ch_message_ram6 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram6,
           wraddress=>wraddress_ram,
           wren=>wren_ram(5) ,
           q=>q(351 downto 320)
           );
           
    rdaddress_ram7<=rpingpong & rdaddress(41 downto 36);        
    ch_message_ram7 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram7,
           wraddress=>wraddress_ram,
           wren=>wren_ram(6) ,
           q=>q(319 downto 288)
           );
           
    rdaddress_ram8<=rpingpong & rdaddress(47 downto 42); 
    ch_message_ram8 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram8,
           wraddress=>wraddress_ram,
           wren=>wren_ram(7) ,
           q=>q(287 downto 256)
           );
           
    rdaddress_ram9<=rpingpong & rdaddress(53 downto 48); 
    ch_message_ram9 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram9,
           wraddress=>wraddress_ram,
           wren=>wren_ram(8) ,
           q=>q(255 downto 224)
           );
           
    rdaddress_ram10<=rpingpong & rdaddress(59 downto 54); 
    ch_message_ram10 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram10,
           wraddress=>wraddress_ram,
           wren=>wren_ram(9) ,
           q=>q(223 downto 192)
           );
           
    rdaddress_ram11<=rpingpong & rdaddress(65 downto 60); 
    ch_message_ram11 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram11,
           wraddress=>wraddress_ram,
           wren=>wren_ram(10) ,
           q=>q(191 downto 160)
           );
           
    rdaddress_ram12<=rpingpong & rdaddress(71 downto 66); 
    ch_message_ram12 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram12,
           wraddress=>wraddress_ram,
           wren=>wren_ram(11),
           q=>q(159 downto 128)
           );
           
    rdaddress_ram13<=rpingpong & rdaddress(77 downto 72);
    ch_message_ram13 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram13,
           wraddress=>wraddress_ram,
           wren=>wren_ram(12),
           q=>q(127 downto 96)
           );
           
    rdaddress_ram14<=rpingpong & rdaddress(83 downto 78);                 
    ch_message_ram14 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram14,
           wraddress=>wraddress_ram,
           wren=>wren_ram(13),
           q=>q(95 downto 64)
           ); 
           
    rdaddress_ram15<=rpingpong & rdaddress(89 downto 84);
    ch_message_ram15 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram15,
           wraddress=>wraddress_ram,
           wren=>wren_ram(14),
           q=>q(63 downto 32)
           );
    
    rdaddress_ram16<=rpingpong & rdaddress(95 downto 90);
    ch_message_ram16 :ch_message_ram
         port map(
           clock=>clock,
           data=>data_zerofill,
           rdaddress=>rdaddress_ram16,
           wraddress=>wraddress_ram,
           wren=>wren_ram(15),        --wren=>wren_ram(15)
           q=>q(31 downto 0)
           );  
 end rtl;     