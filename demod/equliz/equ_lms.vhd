library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity equ_lms is
port( clk,rst_n,en_in:in std_logic;
		jietiaofangshi : in std_logic_vector(3 downto 0);
      I0_in,Q0_in,I1_in,Q1_in:in std_logic_vector(7 downto 0);
      I0_out,Q0_out,I1_out,Q1_out:out std_logic_vector(7 downto 0);
      en_out:out std_logic
      );
end equ_lms;

architecture equ_lms of equ_lms is
constant L:integer:=8;
constant N:integer:= 27;--when L=8;
--55; when L=32
constant P_0_5:std_logic_vector(15 downto 0):="0000001000000000";
type word_8_N is array(N downto 0) of std_logic_vector(7 downto 0);
type word_26_L is array(L downto 0)of std_logic_vector(25 downto 0);
type word_18_L is array(L downto 0)of std_logic_vector(17 downto 0);
--type word_32_L_2 is array(L/2 downto 0)of std_logic_vector(31 downto 0);
--type word_32_8 is array(7 downto 0)of std_logic_vector(31 downto 0);
type word_32_9 is array(L downto 0)of std_logic_vector(31 downto 0);
type word_32_4 is array(3 downto 0)of std_logic_vector(31 downto 0);
type word_32_2 is array(1 downto 0)of std_logic_vector(31 downto 0);
type word_16_33 is array(L downto 0)of std_logic_vector(15 downto 0);
type word_8_33 is array(L downto 0)of std_logic_vector(7 downto 0);
signal xn_I,xn_Q:word_8_N;--xn
signal w1_I,w1_Q,w0_I,w0_Q:word_18_L;
--tt1_w1_I,tt1_w1_Q,tt1_w0_I,tt1_w0_Q,tt2_w1_I,tt2_w1_Q,tt2_w0_I,tt2_w0_Q,tt3_w1_I,tt3_w1_Q,tt3_w0_I,tt3_w0_Q
signal m_y0_II,m_y0_IQ,m_y0_QQ,m_y0_QI,m_y1_II,m_y1_IQ,m_y1_QQ,m_y1_QI:word_26_L;
signal a_y0_II,a_y0_IQ,a_y0_QQ,a_y0_QI,a_y1_II,a_y1_IQ,a_y1_QQ,a_y1_QI:word_32_9;
signal a_y0_I1,a_y0_Q1,a_y1_I1,a_y1_Q1:word_32_9;
signal a_y0_I2,a_y0_Q2,a_y1_I2,a_y1_Q2:word_32_4;
signal a_y0_I3,a_y0_Q3,a_y1_I3,a_y1_Q3:word_32_2;
--signal a_y0_I4,a_y0_Q4,a_y1_I4,a_y1_Q4:word_32_4;
--signal a_y0_I5,a_y0_Q5,a_y1_I5,a_y1_Q5:word_32_2;
signal a_y0_I6,a_y0_Q6,a_y1_I6,a_y1_Q6:std_logic_vector(31 downto 0);
signal y0_I,y0_Q,y1_I,y1_Q:std_logic_vector(31 downto 0);
signal t_y0_I2,t_y0_Q2,t_y1_I2,t_y1_Q2,t_y0_I3,t_y0_Q3,t_y1_I3,t_y1_Q3:std_logic_vector(31 downto 0);
--signal t_y0_I4,t_y0_Q4,t_y1_I4,t_y1_Q4,t_y0_I5,t_y0_Q5,t_y1_I5,t_y1_Q5,
signal t_y0_I6,t_y0_Q6,t_y1_I6,t_y1_Q6:std_logic_vector(31 downto 0);
signal e0_I,e0_Q,e1_I,e1_Q:std_logic_vector(21 downto 0);
signal ee0_I,ee0_Q,ee1_I,ee1_Q:std_logic_vector(7 downto 0);
signal t1_w1_II,t1_w1_QQ,t1_w0_II,t1_w0_QQ,t1_w1_IQ,t1_w1_QI,t1_w0_IQ,t1_w0_QI,tt2_w1_Q,tt2_w1_I,tt2_w0_Q,tt2_w0_I,t2_w1_Q,t2_w1_I,t2_w0_Q,t2_w0_I:word_16_33;
signal t3_w1_I,t3_w0_I,t3_w1_Q,t3_w0_Q:word_8_33;
signal counter,out_counter:integer;
signal I0_out_reg,Q0_out_reg,I1_out_reg,Q1_out_reg:std_logic_vector(7 downto 0);
signal en_out_reg : std_logic; 
type word_18_16 is array(16 downto 0)of std_logic_vector(17 downto 0);
signal w1_I_abs,w1_Q_abs,w0_I_abs,w0_Q_abs:word_18_16;
--signal t1,t2,t3,t4:std_logic;
begin

main_process:process(clk,rst_n,en_in)
variable t,t1,t2,t3,t4,t5,t6:integer;
begin 
if_rst:if (rst_n='1')then
  counter<=0;
  out_counter<=0;
  I0_out_reg<=(others=>'0');
  Q0_out_reg<=(others=>'0');
  I1_out_reg<=(others=>'0');
  Q1_out_reg<=(others=>'0');
  en_out_reg<='0';
  w1_I(L downto L/2+1)<=(others=>(OTHERS=>'0'));
  w1_I(L/2)<="000000010000000000";
  w1_I(L/2-1 downto 0)<=(others=>(OTHERS=>'0'));
  w1_Q<=(others=>(OTHERS=>'0'));
  w0_I(L downto L/2+1)<=(others=>(OTHERS=>'0'));
  w0_I(L/2)<="000000010000000000";
  w0_I(L/2-1 downto 0)<=(others=>(OTHERS=>'0'));
  w0_Q<=(others=>(OTHERS=>'0')); 
  xn_I<=(others=>"00000000");
  xn_Q<=(others=>"00000000");
  m_y0_II<=(others=>"00000000000000000000000000");
  m_y0_IQ<=(others=>"00000000000000000000000000");
  m_y0_QQ<=(others=>"00000000000000000000000000");
  m_y0_QI<=(others=>"00000000000000000000000000");
  m_y1_II<=(others=>"00000000000000000000000000");
  m_y1_IQ<=(others=>"00000000000000000000000000");
  m_y1_QQ<=(others=>"00000000000000000000000000");
  m_y1_QI<=(others=>"00000000000000000000000000");
  a_y0_II<=(others=>"00000000000000000000000000000000");
  a_y0_IQ<=(others=>"00000000000000000000000000000000");
  a_y0_QQ<=(others=>"00000000000000000000000000000000");
  a_y0_QI<=(others=>"00000000000000000000000000000000");
  a_y1_II<=(others=>"00000000000000000000000000000000");
  a_y1_IQ<=(others=>"00000000000000000000000000000000");
  a_y1_QQ<=(others=>"00000000000000000000000000000000");
  a_y1_QI<=(others=>"00000000000000000000000000000000");
  a_y0_I1<=(others=>"00000000000000000000000000000000");
  a_y0_Q1<=(others=>"00000000000000000000000000000000");
  a_y1_I1<=(others=>"00000000000000000000000000000000");
  a_y1_Q1<=(others=>"00000000000000000000000000000000");
  a_y0_I2<=(others=>"00000000000000000000000000000000");
  a_y0_Q2<=(others=>"00000000000000000000000000000000");
  a_y1_I2<=(others=>"00000000000000000000000000000000");
  a_y1_Q2<=(others=>"00000000000000000000000000000000");
  a_y0_I3<=(others=>"00000000000000000000000000000000");
  a_y0_Q3<=(others=>"00000000000000000000000000000000");
  a_y1_I3<=(others=>"00000000000000000000000000000000");
  a_y1_Q3<=(others=>"00000000000000000000000000000000");
--  a_y0_I4<=(others=>"00000000000000000000000000000000");
--  a_y0_Q4<=(others=>"00000000000000000000000000000000");
--  a_y1_I4<=(others=>"00000000000000000000000000000000");
--  a_y1_Q4<=(others=>"00000000000000000000000000000000");
--  a_y0_I5<=(others=>"00000000000000000000000000000000");
--  a_y0_Q5<=(others=>"00000000000000000000000000000000");
--  a_y1_I5<=(others=>"00000000000000000000000000000000");
--  a_y1_Q5<=(others=>"00000000000000000000000000000000");
  a_y0_I6<=(others=>'0');
  a_y0_Q6<=(others=>'0');
  a_y1_I6<=(others=>'0');
  a_y1_Q6<=(others=>'0');
  y0_I<=(others=>'0');
  y0_Q<=(others=>'0');
  y1_I<=(others=>'0');
  y1_Q<=(others=>'0');
  t_y0_I2<=(others=>'0');
  t_y0_Q2<=(others=>'0');
  t_y1_I2<=(others=>'0');
  t_y1_Q2<=(others=>'0');
  t_y0_I3<=(others=>'0');
  t_y0_Q3<=(others=>'0');
  t_y1_I3<=(others=>'0');
  t_y1_Q3<=(others=>'0');
  --t_y0_I4<=(others=>'0');
--  t_y0_Q4<=(others=>'0');
--  t_y1_I4<=(others=>'0');
--  t_y1_Q4<=(others=>'0');
--  t_y0_I5<=(others=>'0');
--  t_y0_Q5<=(others=>'0');
--  t_y1_I5<=(others=>'0');
--  t_y1_Q5<=(others=>'0');
  t_y0_I6<=(others=>'0');
  t_y0_Q6<=(others=>'0');
  t_y1_I6<=(others=>'0');
  t_y1_Q6<=(others=>'0');
  ee0_I<=(others=>'0');
  ee0_Q<=(others=>'0');
  ee1_I<=(others=>'0');
  ee1_Q<=(others=>'0');
  e0_I<=(others=>'0');
  e0_Q<=(others=>'0');
  e1_I<=(others=>'0');
  e1_Q<=(others=>'0');  
  t1_w1_II<=(others=>"0000000000000000");
  t1_w1_QQ<=(others=>"0000000000000000");
  t1_w0_II<=(others=>"0000000000000000");
  t1_w0_QQ<=(others=>"0000000000000000");
  t1_w1_IQ<=(others=>"0000000000000000");
  t1_w1_QI<=(others=>"0000000000000000");
  t1_w0_IQ<=(others=>"0000000000000000");
  t1_w0_QI<=(others=>"0000000000000000");
  t2_w1_I<=(others=>"0000000000000000");
  t2_w1_Q<=(others=>"0000000000000000");
  t2_w0_I<=(others=>"0000000000000000");
  t2_w0_Q<=(others=>"0000000000000000");
  tt2_w1_I<=(others=>"0000000000000000");
  tt2_w1_Q<=(others=>"0000000000000000");
  tt2_w0_I<=(others=>"0000000000000000");
  tt2_w0_Q<=(others=>"0000000000000000");
  t3_w1_I<=(others=>"00000000");
  t3_w1_Q<=(others=>"00000000");
  t3_w0_I<=(others=>"00000000");
  t3_w0_Q<=(others=>"00000000");
   out_counter<=0; 
elsif (clk'event and clk='1')then
  --put the en_in into the line
  --en_line(N1)<=en_in;
--  en_line(N1-1 downto 0)<=en_line(N1 downto 1);
  if_en:if (en_in='1')then
  --1 put the new I\Q signals into xn_I\xn_Q,1-->N-1,0-->N
  xn_I(N-2 downto 0)<=xn_I(N downto 2);
  xn_I(N-1)<=I0_in;
  xn_I(N)<=I1_in;
  xn_Q(N-2 downto 0)<=xn_Q(N downto 2);
  xn_Q(N-1)<=Q0_in;
  xn_Q(N)<=Q1_in;  
  if_counter:if (counter<L/4+1)then
      counter<=counter+1;
  else
  --2 yn=w'*xn
  ---2.1 multiplication
  mul:for t in L downto 0 loop
  m_y0_II(t)<=w0_I(t)*xn_I(N-(L+1-t));
  m_y0_QQ(t)<=w0_Q(t)*xn_Q(N-(L+1-t));
  m_y0_IQ(t)<=w0_I(t)*xn_Q(N-(L+1-t));
  m_y0_QI(t)<=w0_Q(t)*xn_I(N-(L+1-t));
  m_y1_II(t)<=w0_I(t)*xn_I(N-(L-t));
  m_y1_QQ(t)<=w0_Q(t)*xn_Q(N-(L-t));
  m_y1_IQ(t)<=w0_I(t)*xn_Q(N-(L-t));
  m_y1_QI(t)<=w0_Q(t)*xn_I(N-(L-t));
  end loop mul;
  ---2.2 extern the 26-bit result to 32 bits,for the following adding
  extern:for t1 in L downto 0 loop
  a_y0_II(t1)(25 downto 0)<=m_y0_II(t1);
  a_y0_II(t1)(31 downto 26)<=(others=>m_y0_II(t1)(25));
  a_y0_QQ(t1)(25 downto 0)<=m_y0_QQ(t1);
  a_y0_QQ(t1)(31 downto 26)<=(others=>m_y0_QQ(t1)(25));  
  a_y0_IQ(t1)(25 downto 0)<=m_y0_IQ(t1);
  a_y0_IQ(t1)(31 downto 26)<=(others=>m_y0_IQ(t1)(25));  
  a_y0_QI(t1)(25 downto 0)<=m_y0_QI(t1);
  a_y0_QI(t1)(31 downto 26)<=(others=>m_y0_QI(t1)(25));    
  a_y1_II(t1)(25 downto 0)<=m_y1_II(t1);
  a_y1_II(t1)(31 downto 26)<=(others=>m_y1_II(t1)(25));
  a_y1_QQ(t1)(25 downto 0)<=m_y1_QQ(t1);
  a_y1_QQ(t1)(31 downto 26)<=(others=>m_y1_QQ(t1)(25));  
  a_y1_IQ(t1)(25 downto 0)<=m_y1_IQ(t1);
  a_y1_IQ(t1)(31 downto 26)<=(others=>m_y1_IQ(t1)(25));  
  a_y1_QI(t1)(25 downto 0)<=m_y1_QI(t1);
  a_y1_QI(t1)(31 downto 26)<=(others=>m_y1_QI(t1)(25));    
  end loop extern; 
  ---2.3 add(we need 7 clks)
  ----2.3.1
  add1:for t2 in L downto 0 loop
  a_y0_I1(t2)<=a_y0_II(t2)+a_y0_QQ(t2);
  a_y0_Q1(t2)<=a_y0_IQ(t2)-a_y0_QI(t2);
  a_y1_I1(t2)<=a_y1_II(t2)+a_y1_QQ(t2);
  a_y1_Q1(t2)<=a_y1_IQ(t2)-a_y1_QI(t2);
  end loop add1;
  ----2.3.2 9-->4+1
  t_y0_I2<=a_y0_I1(0);
  t_y0_Q2<=a_y0_Q1(0);
  t_y1_I2<=a_y1_I1(0);
  t_y1_Q2<=a_y1_Q1(0);
  add2:for t3 in L/2-1 downto 0 loop
  a_y0_I2(t3)<=a_y0_I1(t3*2+2)+a_y0_I1(t3*2+1);
  a_y0_Q2(t3)<=a_y0_Q1(t3*2+2)+a_y0_Q1(t3*2+1);
  a_y1_I2(t3)<=a_y1_I1(t3*2+2)+a_y1_I1(t3*2+1);
  a_y1_Q2(t3)<=a_y1_Q1(t3*2+2)+a_y1_Q1(t3*2+1);
  end loop add2;
  ----2.3.3 4-->2+1
  t_y0_I3<=t_y0_I2;
  t_y0_Q3<=t_y0_Q2;
  t_y1_I3<=t_y1_I2;
  t_y1_Q3<=t_y1_Q2;
  add3:for t4 in L/4-1 downto 0 loop
  a_y0_I3(t4)<=a_y0_I2(t4*2+1)+a_y0_I2(t4*2);
  a_y0_Q3(t4)<=a_y0_Q2(t4*2+1)+a_y0_Q2(t4*2);
  a_y1_I3(t4)<=a_y1_I2(t4*2+1)+a_y1_I2(t4*2);
  a_y1_Q3(t4)<=a_y1_Q2(t4*2+1)+a_y1_Q2(t4*2);
  end loop add3;
 -- ----2.3.4 8-->4+1
--  t_y0_I4<=t_y0_I3;
--  t_y0_Q4<=t_y0_Q3;
--  t_y1_I4<=t_y1_I3;
--  t_y1_Q4<=t_y1_Q3;
--  add4:for t5 in 3 downto 0 loop
--  a_y0_I4(t5)<=a_y0_I3(t5*2+1)+a_y0_I3(t5*2);
--  a_y0_Q4(t5)<=a_y0_Q3(t5*2+1)+a_y0_Q3(t5*2);
--  a_y1_I4(t5)<=a_y1_I3(t5*2+1)+a_y1_I3(t5*2);
--  a_y1_Q4(t5)<=a_y1_Q3(t5*2+1)+a_y1_Q3(t5*2);
--  end loop add4;
--  ----2.3.5 4-->2+1
--  t_y0_I5<=t_y0_I4;
--  t_y0_Q5<=t_y0_Q4;
--  t_y1_I5<=t_y1_I4;
--  t_y1_Q5<=t_y1_Q4;
--  a_y0_I5(1)<=a_y0_I4(3)+a_y0_I4(2);
--  a_y0_I5(0)<=a_y0_I4(1)+a_y0_I4(0);
--  a_y1_I5(1)<=a_y1_I4(3)+a_y1_I4(2);
--  a_y1_I5(0)<=a_y1_I4(1)+a_y1_I4(0);
--  a_y0_Q5(1)<=a_y0_Q4(3)+a_y0_Q4(2);
--  a_y0_Q5(0)<=a_y0_Q4(1)+a_y0_Q4(0);
--  a_y1_Q5(1)<=a_y1_Q4(3)+a_y1_Q4(2);
--  a_y1_Q5(0)<=a_y1_Q4(1)+a_y1_Q4(0);

  ----2.3.6 2-->1+1
  t_y0_I6<=t_y0_I3;
  t_y0_Q6<=t_y0_Q3;
  t_y1_I6<=t_y1_I3;
  t_y1_Q6<=t_y1_Q3;
  a_y0_I6<=a_y0_I3(1)+a_y0_I3(0);
  a_y1_I6<=a_y1_I3(1)+a_y1_I3(0);
  a_y0_Q6<=a_y0_Q3(1)+a_y0_Q3(0);
  a_y1_Q6<=a_y1_Q3(1)+a_y1_Q3(0);
  ----2.3.7 get y
  y0_I<=a_y0_I6+t_y0_I6;
  y0_Q<=a_y0_Q6+t_y0_Q6;
  y1_I<=a_y1_I6+t_y1_I6;
  y1_Q<=a_y1_Q6+t_y1_Q6;
  
  --3 decide and calculate e?output y  
  --if_count_en:if counter<26 then counter<=counter+1; else
   if jietiaofangshi = "0001" then
	  if (y0_I(31)='1')then
	  e0_I<=-32-y0_I(31 downto 10);
	  else
	  e0_I<=32-y0_I(31 downto 10);
	  end if;
	  if (y0_Q(31)='1')then
	  e0_Q<=0-y0_Q(31 downto 10);
	  else
	  e0_Q<=0-y0_Q(31 downto 10);
	  end if;
	  if (y1_I(31)='1')then
	  e1_I<=-32-y1_I(31 downto 10);
	  else
	  e1_I<=32-y1_I(31 downto 10);
	  end if;
	  if (y1_Q(31)='1')then
	  e1_Q<=0-y1_Q(31 downto 10);
	  else
	  e1_Q<=0-y1_Q(31 downto 10);
	  end if;  
	else
	  if (y0_I(31)='1')then
	  e0_I<=-32-y0_I(31 downto 10);
	  else
	  e0_I<=32-y0_I(31 downto 10);
	  end if;
	  if (y0_Q(31)='1')then
	  e0_Q<=-32-y0_Q(31 downto 10);
	  else
	  e0_Q<=32-y0_Q(31 downto 10);
	  end if;
	  if (y1_I(31)='1')then
	  e1_I<=-32-y1_I(31 downto 10);
	  else
	  e1_I<=32-y1_I(31 downto 10);
	  end if;
	  if (y1_Q(31)='1')then
	  e1_Q<=-32-y1_Q(31 downto 10);
	  else
	  e1_Q<=32-y1_Q(31 downto 10);
	  end if;  
	end if;  
--end if if_count_en;
 if (y0_Q(31 downto 17)="000000000000000")or(y0_Q(31 downto 17)="111111111111111") then
    Q0_out_reg<=y0_Q(17 downto 10);
  elsif y0_Q(31)='0' then
    Q0_out_reg<="01111111";
  else
  Q0_out_reg<="10000000";
 end if;  
   if (y0_I(31 downto 17)="000000000000000")or(y0_I(31 downto 17)="111111111111111") then
    I0_out_reg<=y0_I(17 downto 10);
  elsif y0_I(31)='0' then
    I0_out_reg<="01111111";
  else
  I0_out_reg<="10000000";
 end if;  
 if (y1_Q(31 downto 17)="000000000000000")or(y1_Q(31 downto 17)="111111111111111") then
    Q1_out_reg<=y1_Q(17 downto 10);
  elsif y1_Q(31)='0' then
    Q1_out_reg<="01111111";
  else
  Q1_out_reg<="10000000";
 end if;  
   if (y1_I(31 downto 17)="000000000000000")or(y1_I(31 downto 17)="111111111111111") then
    I1_out_reg<=y1_I(17 downto 10);
  elsif y1_I(31)='0' then
    I1_out_reg<="01111111";
  else
  I1_out_reg<="10000000";
 end if;  
  --4.constrain e into 8 bits
  if (e0_I>127)then
    ee0_I<="01111111";
  elsif(e0_I<-128)then
    ee0_I<="10000000";
  else
    ee0_I<=e0_I(7 downto 0);
  end if ;
  if (e0_Q>127)then
    ee0_Q<="01111111";
  elsif(e0_Q<-128)then
    ee0_Q<="10000000";
  else
    ee0_Q<=e0_Q(7 downto 0);
  end if ;
  if (e1_I>127)then
    ee1_I<="01111111";
  elsif(e1_I<-128)then
    ee1_I<="10000000";
  else
    ee1_I<=e1_I(7 downto 0);
  end if ;
  if (e1_Q>127)then
    ee1_Q<="01111111";
  elsif(e1_Q<-128)then
    ee1_Q<="10000000";
  else
    ee1_Q<=e1_Q(7 downto 0);
  end if ;
  --5.calculate the new w0\w1
  mul_w:for t6 in L downto 0 loop
    ---5.1 multiplication
    t1_w1_II(t6)<=xn_I(t6)*ee0_I; 
    t1_w1_QQ(t6)<=xn_Q(t6)*ee0_Q; 
    t1_w1_IQ(t6)<=xn_I(t6)*ee0_Q; 
    t1_w1_QI(t6)<=xn_Q(t6)*ee0_I; 
    t1_w0_II(t6)<=xn_I(t6+1)*ee1_I; 
    t1_w0_QQ(t6)<=xn_Q(t6+1)*ee1_Q; 
    t1_w0_IQ(t6)<=xn_I(t6+1)*ee1_Q; 
    t1_w0_QI(t6)<=xn_Q(t6+1)*ee1_I; 
--    tt1_w1_I(t6)<=w1_I(t6);
--    tt1_w1_Q(t6)<=w1_Q(t6);
--    tt1_w0_I(t6)<=w0_I(t6);
--    tt1_w0_Q(t6)<=w0_Q(t6);
    
 ---5.2 add to get the real and imag part
    t2_w1_I(t6)<=t1_w1_II(t6)+t1_w1_QQ(t6); 
    t2_w1_Q(t6)<=t1_w1_QI(t6)-t1_w1_IQ(t6); 
    t2_w0_I(t6)<=t1_w0_II(t6)+t1_w0_QQ(t6); 
    t2_w0_Q(t6)<=t1_w0_QI(t6)-t1_w0_IQ(t6); 
    
--    tt2_w1_I(t6)<=tt1_w1_I(t6);
--    tt2_w1_Q(t6)<=tt1_w1_Q(t6);
--    tt2_w0_I(t6)<=tt1_w0_I(t6);
--    tt2_w0_Q(t6)<=tt1_w0_Q(t6);
---5.3 take only the left 7 bits(8*8-->16,left 10,right 11(average power 2^11),right 8(u=2^-8)).if t2_w too small,we change t3_w=0;
   ----5.3.1 add 1 if > 0.5
   if (t2_w1_I(t6)(8)='1')then
     tt2_w1_I(t6)<=t2_w1_I(t6)+P_0_5;
   else 
     tt2_w1_I(t6)<=t2_w1_I(t6);
   end if;
    if (t2_w1_Q(t6)(8)='1')then
     tt2_w1_Q(t6)<=t2_w1_Q(t6)+P_0_5;
   else 
     tt2_w1_Q(t6)<=t2_w1_Q(t6);
   end if;
   if (t2_w0_I(t6)(8)='1')then
     tt2_w0_I(t6)<=t2_w0_I(t6)+P_0_5;
   else 
     tt2_w0_I(t6)<=t2_w0_I(t6);
   end if;
    if (t2_w0_Q(t6)(8)='1')then
     tt2_w0_Q(t6)<=t2_w0_Q(t6)+P_0_5;
   else 
     tt2_w0_Q(t6)<=t2_w0_Q(t6);
   end if;
----5.3.2 take the left 7 bits
--    if ((t2_w1_I(t6)>-512)and(t2_w1_I(t6)<512))then
--      t3_w1_I(t6)<=(others=>'0');
--    else
      t3_w1_I(t6)(7)<=tt2_w1_I(t6)(15);
      t3_w1_I(t6)(6 downto 0)<=tt2_w1_I(t6)(15 downto 9);
--    end if;
--    if ((t2_w1_Q(t6)>-512)and(t2_w1_Q(t6)<512))then
--      t3_w1_Q(t6)<=(others=>'0');
--    else
      t3_w1_Q(t6)(7)<=tt2_w1_Q(t6)(15);
      t3_w1_Q(t6)(6 downto 0)<=tt2_w1_Q(t6)(15 downto 9);
--    end if; 
--    if ((t2_w0_I(t6)>-512)and(t2_w0_I(t6)<512))then
--      t3_w0_I(t6)<=(others=>'0');
--    else
      t3_w0_I(t6)(7)<=tt2_w0_I(t6)(15);
      t3_w0_I(t6)(6 downto 0)<=tt2_w0_I(t6)(15 downto 9);
--    end if;
--    if ((t2_w0_Q(t6)>-512)and(t2_w0_Q(t6)<512))then
--      t3_w0_Q(t6)<=(others=>'0');
--    else
      t3_w0_Q(t6)(7)<=tt2_w0_Q(t6)(15);
      t3_w0_Q(t6)(6 downto 0)<=tt2_w0_Q(t6)(15 downto 9);  
--    end if;
--    tt3_w1_I(t6)<=tt2_w1_I(t6);
--    tt3_w1_Q(t6)<=tt2_w1_Q(t6);
--    tt3_w0_I(t6)<=tt2_w0_I(t6);
--    tt3_w0_Q(t6)<=tt2_w0_Q(t6);
    ---5.4 add the original w 
    w1_I(t6)<=w1_I(t6)+t3_w1_I(t6);
    w1_Q(t6)<=w1_Q(t6)+t3_w1_Q(t6);
    w0_I(t6)<=w0_I(t6)+t3_w0_I(t6);
    w0_Q(t6)<=w0_Q(t6)+t3_w0_Q(t6);
  end loop mul_w;
  if_out_counter:if out_counter<7 then
    out_counter<=out_counter+1;
  else
    out_counter<=out_counter;
    en_out_reg<='1';
  end if if_out_counter;
  end if if_counter;
else
  en_out_reg<='0';
 end if if_en;
 end if if_rst;   
end process main_process;


process(clk,rst_n)
begin
	if rst_n = '1' then
		for i in 0 to 16 loop
			w0_I_abs(i) <= (others => '0');
			w0_Q_abs(i) <= (others => '0');
		end loop;
		I0_out<=(others => '0');
		Q0_out<=(others => '0');
		I1_out<=(others => '0');
		Q1_out<=(others => '0');
		en_out<='0';
	elsif rising_edge(clk) then
		for i in 0 to 8 loop
			w0_I_abs(i) <= abs(w0_I(i));
			w0_Q_abs(i) <= abs(w0_Q(i));
		end loop;
		if w0_I_abs(0) >= w0_I_abs(1) then
			w0_I_abs(9) <= w0_I_abs(0);
		else
			w0_I_abs(9) <= w0_I_abs(1);
		end if;
		
		if w0_I_abs(2) >= w0_I_abs(3) then
			w0_I_abs(10) <= w0_I_abs(2);
		else
			w0_I_abs(10) <= w0_I_abs(3);
		end if;
		
		if w0_I_abs(4) >= w0_I_abs(5) then
			w0_I_abs(11) <= w0_I_abs(4);
		else
			w0_I_abs(11) <= w0_I_abs(5);
		end if;
		
		if w0_I_abs(6) >= w0_I_abs(7) then
			w0_I_abs(12) <= w0_I_abs(6);
		else
			w0_I_abs(12) <= w0_I_abs(7);
		end if;
		
		if w0_I_abs(9) >= w0_I_abs(10) then
			w0_I_abs(13) <= w0_I_abs(9);
		else
			w0_I_abs(13) <= w0_I_abs(10);
		end if;
		
		if w0_I_abs(11) >= w0_I_abs(12) then
			w0_I_abs(14) <= w0_I_abs(11);
		else
			w0_I_abs(14) <= w0_I_abs(12);
		end if;
		
		if w0_I_abs(13) >= w0_I_abs(14) then
			w0_I_abs(15) <= w0_I_abs(13);
		else
			w0_I_abs(15) <= w0_I_abs(14);
		end if;
		
		if w0_I_abs(8) >= w0_I_abs(15) then
			w0_I_abs(16) <= w0_I_abs(8);
		else
			w0_I_abs(16) <= w0_I_abs(15);
		end if;
		
		if w0_Q_abs(0) >= w0_Q_abs(1) then
			w0_Q_abs(9) <= w0_Q_abs(0);
		else
			w0_Q_abs(9) <= w0_Q_abs(1);
		end if;
		
		if w0_Q_abs(2) >= w0_Q_abs(3) then
			w0_Q_abs(10) <= w0_Q_abs(2);
		else
			w0_Q_abs(10) <= w0_Q_abs(3);
		end if;
		
		if w0_Q_abs(4) >= w0_Q_abs(5) then
			w0_Q_abs(11) <= w0_Q_abs(4);
		else
			w0_Q_abs(11) <= w0_Q_abs(5);
		end if;
		
		if w0_Q_abs(6) >= w0_Q_abs(7) then
			w0_Q_abs(12) <= w0_Q_abs(6);
		else
			w0_Q_abs(12) <= w0_Q_abs(7);
		end if;
		
		if w0_Q_abs(9) >= w0_Q_abs(10) then
			w0_Q_abs(13) <= w0_Q_abs(9);
		else
			w0_Q_abs(13) <= w0_Q_abs(10);
		end if;
		
		if w0_Q_abs(11) >= w0_Q_abs(12) then
			w0_Q_abs(14) <= w0_Q_abs(11);
		else
			w0_Q_abs(14) <= w0_Q_abs(12);
		end if;
		
		if w0_Q_abs(13) >= w0_Q_abs(14) then
			w0_Q_abs(15) <= w0_Q_abs(13);
		else
			w0_Q_abs(15) <= w0_Q_abs(14);
		end if;
		
		if w0_Q_abs(8) >= w0_Q_abs(15) then
			w0_Q_abs(16) <= w0_Q_abs(8);
		else
			w0_Q_abs(16) <= w0_Q_abs(15);
		end if;
		
--		if w0_I_abs(16) >= w0_Q_abs(16) then
			I0_out<=I0_out_reg;
			Q0_out<=Q0_out_reg;
			I1_out<=I1_out_reg;
			Q1_out<=Q1_out_reg;
			en_out<=en_out_reg;
--		else
--			I0_out<=Q0_out_reg;
--			Q0_out<=I0_out_reg;
--			I1_out<=Q1_out_reg;
--			Q1_out<=I1_out_reg;
--			en_out<=en_out_reg;
--		end if;
	end if;
end process;


end equ_lms;

