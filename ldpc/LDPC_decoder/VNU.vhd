library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	VNU	 is         
port(
	 clk        :in std_logic;
	 reset      :in std_logic;
	 
	 channel_in :in std_logic_vector(3 downto 0);
	 data_in    :in std_logic_vector(15 downto 0);
	 
    decision_out :out std_logic_vector(3 downto 0); 
	 data_out  :out std_logic_vector(15 downto 0)
	   );	 
end	VNU;

architecture rtl of VNU is

signal ch_dly1 :std_logic_vector(3 downto 0);
signal ch_dly2 :std_logic_vector(3 downto 0);
signal ch_dly3 :std_logic_vector(4 downto 0);

type addreg1  is array (1 downto 0) of std_logic_vector(5 downto 0);
signal add_reg1 :addreg1;

signal add_reg2 :std_logic_vector(6 downto 0);
signal add_sum  :std_logic_vector(7 downto 0);

type outreg  is array (3 downto 0) of std_logic_vector(7 downto 0);
signal out_reg:outreg;

type recdly123  is array (3 downto 0) of std_logic_vector(4 downto 0);
signal rec_dly1,rec_dly2,rec_dly3 :recdly123;

signal decision_dly1,decision_dly2,decision_dly3:std_logic_vector(3 downto 0);

signal data_in_complement :std_logic_vector(19 downto 0);
 
begin
process(clk, reset)
   begin
    if (reset='1') then
      ch_dly1 <= "0000";
		ch_dly2 <= "0000";
		ch_dly3 <= "00000";
    elsif (clk'event and clk='1') then
      ch_dly1 <= channel_in;
		ch_dly2 <= ch_dly1;
		ch_dly3 <= ch_dly2 & '0' + 1; 
    end if;
end process;

decision_out <= decision_dly2; 

process(clk, reset)
    begin
    if (reset='1') then
       data_in_complement <= x"00000";
    elsif (clk'event and clk='1') then
        if (data_in(3)='1') then
            data_in_complement(4 downto 0) <='1' & not(data_in(2 downto 0)) & '0' + 1;
            else
            data_in_complement(4 downto 0) <=data_in(3 downto 0) & '0' + 1;
        end if;
        if (data_in(7)='1') then
            data_in_complement(9 downto 5) <='1' & not(data_in(6 downto 4))& '0'+ 1 ;
            else
            data_in_complement(9 downto 5) <=data_in(7 downto 4) & '0' + 1;
        end if;
        if (data_in(11)='1') then
            data_in_complement(14 downto 10) <='1' & not(data_in(10 downto 8)) & '0' + 1;
            else
            data_in_complement(14 downto 10) <=data_in(11 downto 8) & '0' + 1;
        end if;
        if (data_in(15)='1') then
            data_in_complement(19 downto 15) <='1' & not(data_in(14 downto 12)) & '0' + 1;
            else
            data_in_complement(19 downto 15) <=data_in(15 downto 12) & '0' + 1;
        end if;
		end if;
	end process;
	
  process(clk, reset)
   begin
     if (reset='1') then
        add_reg1(0) <= "000000";
		add_reg1(1) <= "000000";
		add_reg2    <= "0000000";
		add_sum     <= "00000000";
     elsif (clk'event and clk='1') then
        add_reg1(0) <= (data_in_complement(4) & data_in_complement(4 downto 0)) + (data_in_complement(9) & data_in_complement(9 downto 5));
		add_reg1(1) <= (data_in_complement(14) & data_in_complement(14 downto 10)) + (data_in_complement(19) & data_in_complement(19 downto 15));
		
		add_reg2    <= (add_reg1(0)(5) & add_reg1(0)) + (add_reg1(1)(5) & add_reg1(1));
		
		add_sum     <= (add_reg2(6) & add_reg2) + (ch_dly3(4) & ch_dly3(4) & ch_dly3(4) & ch_dly3);
     end if;
   end process;
    
   process(clk, reset)
   begin
    if (reset='1') then
      decision_dly1 <= "0000";
		decision_dly2 <= "0000";
    elsif (clk'event and clk='1') then
      decision_dly1 <= add_sum(7)&add_sum(7)&add_sum(7)&add_sum(7);
		decision_dly2 <= decision_dly1;
    end if;
   end process; 
   
   process(clk, reset)
    begin
    if (reset='1') then
        rec_dly1(0) <= "00000";
		rec_dly1(1) <= "00000";
		rec_dly1(2) <= "00000";
		rec_dly1(3) <= "00000";
		
		rec_dly2(0) <= "00000";
		rec_dly2(1) <= "00000";
		rec_dly2(2) <= "00000";
		rec_dly2(3) <= "00000";
		
		rec_dly3(0) <= "00000";
		rec_dly3(1) <= "00000";
		rec_dly3(2) <= "00000";
		rec_dly3(3) <= "00000";
    elsif (clk'event and clk='1') then
      rec_dly1(0) <= data_in_complement(4 downto 0);
		rec_dly1(1) <= data_in_complement(9 downto 5);
		rec_dly1(2) <= data_in_complement(14 downto 10);
		rec_dly1(3) <= data_in_complement(19 downto 15);

		
		rec_dly2(0) <= rec_dly1(0);
		rec_dly2(1) <= rec_dly1(1);
		rec_dly2(2) <= rec_dly1(2);
		rec_dly2(3) <= rec_dly1(3);
		
		rec_dly3(0) <= rec_dly2(0);
		rec_dly3(1) <= rec_dly2(1);
		rec_dly3(2) <= rec_dly2(2);
		rec_dly3(3) <= rec_dly2(3);
     end if;
    end process;
    
  process(clk, reset)
   begin
    if (reset='1') then
      out_reg(0) <= "00000000";
		out_reg(1) <= "00000000";
		out_reg(2) <= "00000000";
		out_reg(3) <= "00000000";
    elsif (clk'event and clk='1') then
      out_reg(0) <= add_sum - (rec_dly3(0)(4) & rec_dly3(0)(4) & rec_dly3(0)(4) & rec_dly3(0));
		out_reg(1) <= add_sum - (rec_dly3(1)(4) & rec_dly3(1)(4) & rec_dly3(1)(4) & rec_dly3(1));
		out_reg(2) <= add_sum - (rec_dly3(2)(4) & rec_dly3(2)(4) & rec_dly3(2)(4) & rec_dly3(2));
		out_reg(3) <= add_sum - (rec_dly3(3)(4) & rec_dly3(3)(4) & rec_dly3(3)(4) & rec_dly3(3)); 
    end if;
  end process;
 
  process(clk, reset)
   begin
    if (reset='1') then
      data_out <= x"0000";
    elsif (clk'event and clk='1') then
        if (out_reg(0)(7) ='1') then
              if ((out_reg(0)(6) and out_reg(0)(5) and out_reg(0)(4))='1') then
               data_out(3 downto 0)<='1' & out_reg(0)(3 downto 1);
              else 
               data_out(3 downto 0)<="1000"; 
              end if;
        else
              if ((out_reg(0)(6) or out_reg(0)(5) or out_reg(0)(4))='1') then
               data_out(3 downto 0)<="0111";
              else 
               data_out(3 downto 0)<='0' & out_reg(0)(3 downto 1); 
              end if;
        end if;
        
        if (out_reg(1)(7) ='1') then
              if ((out_reg(1)(6) and out_reg(1)(5)and out_reg(1)(4))='1') then
               data_out(7 downto 4)<='1' & out_reg(1)(3 downto 1);
              else 
               data_out(7 downto 4)<="1000"; 
              end if;
        else
              if ((out_reg(1)(6) or out_reg(1)(5) or out_reg(1)(4))='1') then
               data_out(7 downto 4)<="0111";
              else 
               data_out(7 downto 4)<='0' & out_reg(1)(3 downto 1); 
              end if;
        end if;
        
        if (out_reg(2)(7) ='1') then
              if ((out_reg(2)(6) and out_reg(2)(5)and out_reg(2)(4))='1') then
               data_out(11 downto 8)<='1' & out_reg(2)(3 downto 1);
              else 
               data_out(11 downto 8)<="1000"; 
              end if;
        else
              if ((out_reg(2)(6) or out_reg(2)(5) or out_reg(2)(4))='1') then
               data_out(11 downto 8)<="0111";
              else 
               data_out(11 downto 8)<='0' & out_reg(2)(3 downto 1); 
              end if;
        end if;
        
        if (out_reg(3)(7) ='1') then
              if ((out_reg(3)(6) and out_reg(3)(5)and out_reg(3)(4))='1') then
               data_out(15 downto 12)<='1' & out_reg(3)(3 downto 1);
              else 
               data_out(15 downto 12)<="1000"; 
              end if;
        else
              if ((out_reg(3)(6) or out_reg(3)(5) or out_reg(3)(4))='1') then
               data_out(15 downto 12)<="0111";
              else 
               data_out(15 downto 12)<='0' & out_reg(3)(3 downto 1); 
              end if;
        end if;
      --data_out[3:0]  <= out_reg[0][7] 
		--				 ? ((out_reg[0][6] & out_reg[0][5] & out_reg[0][4]) ? {1'b1,out_reg[0][3:1]} : 4'b1000)
		--				 : ((out_reg[0][6] | out_reg[0][5] | out_reg[0][4]) ? 4'b0111 : {1'b0,out_reg[0][3:1]});
		--data_out[7:4]  <= out_reg[1][7] 
		--				 ? ((out_reg[1][6] & out_reg[1][5] & out_reg[1][4]) ? {1'b1,out_reg[1][3:1]} : 4'b1000)
		--				 : ((out_reg[1][6] | out_reg[1][5] | out_reg[1][4]) ? 4'b0111 : {1'b0,out_reg[1][3:1]});
		--data_out[11:8]  <= out_reg[2][7] 
		--				 ? ((out_reg[2][6] & out_reg[2][5] & out_reg[2][4]) ? {1'b1,out_reg[2][3:1]} : 4'b1000)
		--				 : ((out_reg[2][6] | out_reg[2][5] | out_reg[2][4]) ? 4'b0111 : {1'b0,out_reg[2][3:1]});
		--data_out[15:12] <= out_reg[3][7] 
		--				 ? ((out_reg[3][6] & out_reg[3][5] & out_reg[3][4]) ? {1'b1,out_reg[3][3:1]} : 4'b1000)
		--				 : ((out_reg[3][6] | out_reg[3][5] | out_reg[3][4]) ? 4'b0111 : {1'b0,out_reg[3][3:1]});        
    end if;
end process;  

end rtl;  
