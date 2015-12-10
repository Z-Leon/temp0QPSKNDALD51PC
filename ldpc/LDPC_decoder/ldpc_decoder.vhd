library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity	ldpc_decoder	 is         
port(
	 clk        :in std_logic;
	 reset      :in std_logic;
	 
	 ldpc_in    :in std_logic_vector(31 downto 0);
	 i_val      :in std_logic;
	 i_sop      :in std_logic;
	 i_eop      :in std_logic;
	 
	 ldpc_out   :out std_logic_vector(7 downto 0); 
	 o_val      :out std_logic;
	 o_sop      :out std_logic;
	 o_eop      :out std_logic;
	 decode_succeed:out std_logic
	 );	 
end	ldpc_decoder;

architecture rtl of ldpc_decoder is
   constant WAIT0 :std_logic_vector(3 downto 0):="0000";
   constant INIT :std_logic_vector(3 downto 0):="0001";
   constant CN_update :std_logic_vector(3 downto 0):="0010";
   constant VN_update :std_logic_vector(3 downto 0):="0100";
   constant INPUT :std_logic_vector(3 downto 0):="0001";
   constant OUTPUT :std_logic_vector(3 downto 0):="0010";
   constant MAX_ITER_TIMES :std_logic_vector(7 downto 0):="00001010";
   
   signal state,state_dly :std_logic_vector(3 downto 0);
   signal o_state:std_logic_vector(3 downto 0);
   signal o_counter    :std_logic_vector(11 downto 0);
   signal byte_counter :std_logic_vector(7 downto 0);
   signal iter_counter :std_logic_vector(7 downto 0);
   signal wren1,wren2,wren_buffer,mux_control,wren_ch,o_wren :std_logic;
   signal eop_dly1,eop_dly2,eop_dly3,eop_dly4,eop_dly5,eop_dly6,DNU_eop,DNU_eop_dly:std_logic;
   signal v_address_reset,c_address_reset,v_shift_post_reset,v_shift_pre_reset:std_logic;
   signal ch_address_reset,decision_shift_reset,decision_address_reset,DNU_reset,buffer_address_reset:std_logic;
   signal o_ldpc_reset,o_address_reset :std_logic;
   signal buffer_flag  :std_logic;
   
   signal c_message_in,c_message_out :std_logic_vector(2047 downto 0);
   signal c_message_in_align,c_message_out_align :std_logic_vector(2047 downto 0);
   signal v_message_in,v_message_out :std_logic_vector(2047 downto 0);
   signal v_message_in_align,v_message_out_align:std_logic_vector(2047 downto 0);
   signal v_message_in_shift,v_message_out_shift :std_logic_vector(2047 downto 0);
   signal decision_out,decision_out_align,decision_out_shift:std_logic_vector(511 downto 0);
   signal decision_make_in,decision_make_in_align :std_logic_vector(511 downto 0);
   signal ch_message_out :std_logic_vector(511 downto 0);
   signal decision :std_logic;
   
   
   signal c_address_a,c_address_b,v_address_a,v_address_b :std_logic_vector(223 downto 0);
   signal c_address_a_dly,c_address_b_dly,v_address_a_dly,v_address_b_dly :std_logic_vector(223 downto 0);
   
   signal address_a10,address_b10 :std_logic_vector(223 downto 0);
   signal address_a1,address_b1,address_a2,address_b2:std_logic_vector(223 downto 0);
   signal ldpc_out_raddress :std_logic_vector(5 downto 0);
   signal ldpc_out_waddress,ldpc_out_waddress_dly2:std_logic_vector(95 downto 0);
   signal ldpc_buffer_in,ldpc_buffer_out:std_logic_vector(127 downto 0);
   
   signal wraddress_buffer :std_logic_vector(111 downto 0);
   
   signal decode_succeed0  :std_logic;--将buffer分解为一个寄存器和输出信号
   
   signal resetorDNU_reset :std_logic;
   signal resetorv_shift_pre_reset :std_logic;
   signal resetorv_shift_post_reset :std_logic;
   signal resetordecision_shift_reset :std_logic;
   signal reset_c_address_reset_buffer_address_reset :std_logic;
   signal resetorv_address_reset :std_logic;
   signal resetoro_address_reset :std_logic;
   signal resetoro_ldpc_reset :std_logic;
   
component  CNU_block is
  port(
	 clk   : in std_logic;
	 reset : in std_logic;
	 data_in  :in std_logic_vector(2047 downto 0); 
	 data_out :out std_logic_vector(2047 downto 0)
	 );	 
end	component;

component VNU_block	 is         
 port(
	 clk        :in std_logic;
	 reset      :in std_logic;
	 
	 channel_in :in std_logic_vector(511 downto 0);
	 data_in    :in std_logic_vector(2047 downto 0);
	 
    decision_out :out std_logic_vector(511 downto 0); 
	 data_out  :out std_logic_vector(2047 downto 0)
	   );	
end	component;

component DNU_block	 is         
port(
	 clk   : in std_logic;
	 reset : in std_logic;
	 data_in  :in std_logic_vector(511 downto 0); 
	 DNU_eop : in std_logic;
	 
	 decision :out std_logic
	 );	 
end	component;

component c_message_walign	 is         
port(
	 c_message : in std_logic_vector(2047 downto 0);
	 c_message_align : out std_logic_vector(2047 downto 0)
	  );
end	component;

component v_message_walign	 is         
port(
   mux_control      : in  std_logic;
	ch_message      : in  std_logic_vector(511 downto 0);
	v_message       : in  std_logic_vector(2047 downto 0);
	v_message_align : out  std_logic_vector(2047 downto 0)
   );
end	component;

component decision_walign	 is         
port( 
   decision        : in  std_logic_vector(511 downto 0);
   decision_align  : out std_logic_vector(511 downto 0)
	);	 
end	component;

component c_message_ralign	 is         
port(
	 c_message : in std_logic_vector(2047 downto 0);
	 c_message_align : out std_logic_vector(2047 downto 0)
	  );
end	component;

component v_message_ralign	 is         
port( 
   v_message        : in  std_logic_vector(2047 downto 0);
   v_message_align  : out std_logic_vector(2047 downto 0)
	);	
end	component;

component decision_ralign	 is         
port(
   
   decision        : in  std_logic_vector(511 downto 0);
   decision_align  : out std_logic_vector(511 downto 0)
	);	 
end	component;

component v_message_shift_pre	 is         
port(
   clk     : in  std_logic;
   reset   : in  std_logic;
   
   data_in : in  std_logic_vector(2047 downto 0);
   data_out: out  std_logic_vector(2047 downto 0)
   );
end	component;
    
component v_message_shift_post	 is         
port(
   clk     : in  std_logic;
   reset   : in  std_logic;
   
   data_in : in  std_logic_vector(2047 downto 0);
   data_out: out  std_logic_vector(2047 downto 0)
   );	
end	component;

component decision_shift	 is         
port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   data_in   : in  std_logic_vector(511 downto 0);
   data_out  : out std_logic_vector(511 downto 0)
	);	 
end	component;

component ldpc_buffer_align	 is         
port(
   clk         : in std_logic;
   reset       : in std_logic;
   mux_control : in std_logic;
   ch_message  : in std_logic_vector(511 downto 0);
   data_in     : in std_logic_vector(511 downto 0);
   data_out    : out std_logic_vector(127 downto 0)
	);
end	component;

component c_address_gen	 is         
port(
	 clk         : in std_logic;
	 reset       : in std_logic;
	 
	 c_address_a : out std_logic_vector(223 downto 0);
	 c_address_b : out std_logic_vector(223 downto 0);
	 
    c_address_a_dly : out std_logic_vector(223 downto 0); 
	 c_address_b_dly : out std_logic_vector(223 downto 0)
	   );	 
end	component;

component v_address_gen	 is         
 port( 
    clk    : in std_logic;
    reset  : in std_logic;
    v_address_a    : out std_logic_vector(223 downto 0);
    v_address_b    : out std_logic_vector(223 downto 0);
    v_address_a_dly: out std_logic_vector(223 downto 0);
    v_address_b_dly: out std_logic_vector(223 downto 0)
    );	 	 
end	component;





component ch_message_block	 is         
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
end	component;


component message_block	 is         
port(
   
   address_a: in std_logic_vector(223 downto 0);
   address_b: in std_logic_vector(223 downto 0);
   clock    : in std_logic;
   
   data_a   : in std_logic_vector(1023 downto 0);
   data_b   : in std_logic_vector(1023 downto 0);
   wren_a   : in std_logic;
   wren_b   : in std_logic;
   q_a      : out std_logic_vector(1023 downto 0);
   q_b      : out std_logic_vector(1023 downto 0)
	);	 
end	component;

component decision_block	 is         
port(
   
   address_a: in std_logic_vector(223 downto 0);
   address_b: in std_logic_vector(223 downto 0);
   clock    : in std_logic;
   data_a   : in std_logic_vector(255 downto 0);
   data_b   : in std_logic_vector(255 downto 0);
   wren_a   : in std_logic;
   wren_b   : in std_logic;
   q_a      : out std_logic_vector(255 downto 0);
   q_b      : out std_logic_vector(255 downto 0)
	);	 	 
end	component;

component ldpc_out_address_gen	 is         
port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   
   waddress      : out  std_logic_vector(95 downto 0);
   waddress_dly2 : out  std_logic_vector(95 downto 0);
   raddress      : out  std_logic_vector(5 downto 0)
   );	 
end	component;

component ldpc_buffer_block	 is         
port(
   clock     : in  std_logic;
   reset     : in  std_logic;
   data      : in  std_logic_vector(127 downto 0);
   rdaddress : in  std_logic_vector(95 downto 0);
   wraddress : in  std_logic_vector(111 downto 0);
   wren      : in  std_logic;
   q         : out  std_logic_vector(127 downto 0)
   );
end	component;

component ldpc_out_block	 is         
port(
   clock     : in  std_logic;
   reset     : in  std_logic;
   
   data      : in  std_logic_vector(127 downto 0);
   rdaddress : in  std_logic_vector(5 downto 0);
   wraddress : in  std_logic_vector(95 downto 0);
   wren      : in  std_logic;
   q         : out std_logic_vector(7 downto 0)
   );	  
end	component;

begin
   process(clk,reset)
      begin
         if(reset='1') then
              eop_dly1 <= '0';
		        eop_dly2 <= '0';
		        eop_dly3 <= '0';
		        eop_dly4 <= '0';
		        eop_dly5 <= '0';
		        eop_dly6 <= '0'; 
		       elsif (clk'event and clk='1') then
		        eop_dly1 <= i_eop;
		        eop_dly2 <= eop_dly1;
		        eop_dly3 <= eop_dly2;
		        eop_dly4 <= eop_dly3;
		        eop_dly5 <= eop_dly4;
		        eop_dly6 <= eop_dly5;
		        end if;
		end process;
		
		process(clk,reset) --state
		  begin
		     if (reset='1') then
		       state <= WAIT0;
		       state_dly <= WAIT0;
		       byte_counter  <= x"00";
		       iter_counter <= x"00"; 
		     elsif (clk'event and clk='1') then
		       state_dly <= state;
		       byte_counter <= byte_counter + 1;
		       case state is
		          when WAIT0 =>
		               byte_counter <=x"00";
		               iter_counter <= x"00";
			           if(eop_dly6='1') then
			            state <= INIT;			
		              end if;
		              
		          when INIT =>
		              if(byte_counter = "01000011") then--byte_counter = 8'd67
			            state <= CN_UPDATE;
				         byte_counter <="00000000";
				        end if;
				        
				    when CN_UPDATE =>
		              if(decode_succeed0='1' or iter_counter = MAX_ITER_TIMES) then
			            state <= WAIT0;
				         byte_counter <="00000000";
				        elsif (byte_counter="01001010") then--(byte_counter = 8'd74)
				         state <= VN_UPDATE;
				         byte_counter <="00000000";
				        end if;
				        
				    when VN_UPDATE =>
		              if (byte_counter="01001100") then--(byte_counter = 8'd76)
				         state <= CN_UPDATE;
				         byte_counter <= "00000000";
				         iter_counter <= iter_counter + 1;
				        end if;
				        
				    when others=>
				         state<=WAIT0;
				  end case;
			    end if;
		 end process;
		 
		 
		 process(clk,reset)  --o_state
		  begin
		   if (reset='1') then
		      o_state <= WAIT0;
		      o_counter <= x"000";
		      buffer_flag <= '0';
		     elsif (clk'event and clk='1')then
		      o_counter <= o_counter + 1;
			   case (o_state) is
			     when WAIT0 =>
			        buffer_flag <= '0';
			        o_counter <= x"000";
			       if(decode_succeed0='1' or iter_counter = MAX_ITER_TIMES) then 
				     o_state <= INPUT;
				    end if;
				  when INPUT =>
			        buffer_flag <= '0';
			       	if (o_counter=66) then 
				     o_state <= OUTPUT;
				     o_counter <= x"000";
				     end if;
				  when OUTPUT =>
				     if (decode_succeed0='1' or iter_counter = MAX_ITER_TIMES) then
				        buffer_flag <= '1';
				     end if;
				     
			        if(o_counter = 1029) then --o_counter = 12'd1029
			              o_counter<=x"000";--原来遗漏的
			              if (buffer_flag='1') then
			                 o_state <=INPUT;
			              else
			                 o_state <=WAIT0;
			              end if;
			        end if;
			      when others =>
			          buffer_flag <= buffer_flag;
			          o_state <=o_state;
			          o_counter<=o_counter;
			    -- when others =>
			    --    o_state <= WAIT0;
		       --    o_counter <= x"000";
		       --    buffer_flag <= '0';
			     end case;
			 end if;
			end process;
		
		   process(clk,reset)
		     begin
		     	 if (reset='1') then
		     	   wren1  <= '0';
		         wren2  <= '0';
		         wren_buffer <= '0';
		         wren_ch <= '0';
		         mux_control <= '0';
		         DNU_eop <= '0';	
		         DNU_eop_dly <= '0';	
		       elsif (clk'event and clk='1') then
		         if ((state = VN_UPDATE and byte_counter >= 12) or (state = INIT and byte_counter >= x"03"))then  
			          wren1 <= '1';
		           else
			          wren1 <= '0';
			      end if;
			      
			      
			      if (state = CN_UPDATE and byte_counter >=11) then
			          wren2 <= '1';
		            else
			          wren2 <= '0';
			      end if;
			      
			      if ((state_dly = VN_UPDATE and byte_counter >=13) or (state = INIT and byte_counter >= 4)) then
			        wren_buffer <= '1';
		           else
			        wren_buffer <= '0';
			      end if;
			     
		         if (i_sop='1') then
			        wren_ch <= '1';
		           elsif (eop_dly6='1') then
			        wren_ch <= '0';
		           else
			        wren_ch <= wren_ch;
			      end if;
			
		         if(state = INIT) then
			         mux_control <= '1';
		         else
			         mux_control <= '0';
			      end if;
			      
			      DNU_eop_dly <= DNU_eop;	
			     
		         if (state = CN_UPDATE and byte_counter =68) then--byte_counter = 8'd68
			         DNU_eop <= '1';
		         else
			         DNU_eop <= '0';
			      end if;
			   end if;
		    end process;    
			   
			process (clk,reset)
			  begin
			  if (reset='1') then
			      c_address_reset <= '0';
		         v_address_reset <= '0';
		         v_shift_pre_reset <= '0';
		         v_shift_post_reset <= '0';
		         ch_address_reset <= '0';
		         decision_shift_reset <= '0';
		         DNU_reset <= '0';
		         buffer_address_reset <= '0'; 
		      elsif (clk'event and clk='1') then
		         if(state = CN_UPDATE and byte_counter = x"00") then
			         c_address_reset <= '1';
		         else
			         c_address_reset <= '0';
			      end if;
			      
		         if((state = INIT and byte_counter = x"02") or (state = VN_UPDATE and byte_counter = x"00")) then
			        v_address_reset <= '1';
		         else
			        v_address_reset <= '0';
			      end if;
			      
		         if(state=VN_UPDATE and byte_counter = x"02") then
			         ch_address_reset <= '1';
		         else
			         ch_address_reset <= '0';
			      end if;
			       
		         if(state = VN_UPDATE and byte_counter = x"02") then
			         v_shift_pre_reset <= '1';
		         else
			         v_shift_pre_reset <= '0';
			      end if;
			      
		         if((state = INIT and byte_counter =x"01") or (state = VN_UPDATE and byte_counter = x"0A" )) then
			         v_shift_post_reset <= '1';
		         else
			         v_shift_post_reset <= '0';
			      end if;
			      
		         if(state = VN_UPDATE and byte_counter = x"0A" ) then
		           decision_shift_reset <= '1';
		         else
			        decision_shift_reset <= '0';
			      end if;
			      
		         if(state = CN_UPDATE and byte_counter =x"02") then
			         DNU_reset <= '1';
		         else
			         DNU_reset <= '0';
			      end if;
			      
	            if((state = VN_UPDATE and byte_counter = x"02") or (state = INIT and byte_counter =x"03")) then
			         buffer_address_reset <= '1';
		         else
			         buffer_address_reset <= '0'; 
			      end if;
			   end if;
			 end process;
			    
			    
			process(clk,reset) 
			  begin 
			    if (reset='1') then
			         decode_succeed0 <= '0';
			      elsif (clk'event and clk='1') then
			          if(DNU_eop_dly='1' and decision='1') then
			            decode_succeed0 <= '1';
		             else 
			            decode_succeed0 <= '0';  
	                end if;
	           end if;
	       end process;
	       decode_succeed<=decode_succeed0;
	      
	       process(clk,reset) 
			  begin 
			    if (reset='1') then
			         o_val <= '0';
			         o_wren<= '0';
			         o_sop <= '0';
			         o_eop <= '0';
			      elsif (clk'event and clk='1') then
			          if(o_state = OUTPUT and o_counter >=10 and o_counter <=901)then
			            o_val <= '1';
		             else 
			            o_val <= '0';
			          end if;
			           
		             if(o_state = INPUT and o_counter >=3)then
			            o_wren <= '1';
		             else 
			            o_wren <= '0'; 
			          end if;
			          
		             if(o_state = OUTPUT and o_counter =10)then
			             o_sop <= '1';
		             else 
			             o_sop <= '0';
			          end if;
			          
		             if(o_state = OUTPUT and o_counter =901)then
			             o_eop <= '1';
		             else 
			             o_eop <= '0'; 
	                end if;
	              end if;
	          end process;
	          
	          
	        process(clk,reset) 
			    begin 
			      if (reset='1') then
			        o_address_reset <= '0';
		           o_ldpc_reset <= '0';
			      elsif (clk'event and clk='1') then
			        if((o_state = INPUT and o_counter = 0) or (o_state = OUTPUT and o_counter = 0)) then
			           o_address_reset <= '1';
		           else 
			           o_address_reset <= '0';
			        end if;
		            
		           if(o_state =OUTPUT and o_counter =2) then
			           o_ldpc_reset <= '1';
		           else 
			           o_ldpc_reset <= '0';
	              end if;
	            end if;
	        end process;
	      
	       
CNU_block_inst :CNU_block  
  port map(
	clk=>clk,
	reset=>reset,
	data_in=>c_message_in_align,
	--i_val=>c_val_in,
	data_out=>c_message_out
	--o_val=>c_val_out
      );

VNU_block_inst :VNU_block 
  port map(
	clk=>clk,
	reset=>reset,
	channel_in=>ch_message_out,
	data_in=>v_message_in_align,
	--i_val=>v_val_in,
	decision_out=>decision_out,
	data_out=>v_message_out
	--o_val=>v_val_out
      );

DNU_block_inst :DNU_block 
  port map(
	clk=>clk,
	reset=>resetorDNU_reset,
	data_in=>decision_make_in_align,
	DNU_eop=>DNU_eop,
	decision=>decision
      );
resetorDNU_reset<=reset or DNU_reset;

c_message_walign_inst:c_message_walign 
  port map(
	c_message=>c_message_out,
	c_message_align=>c_message_out_align
      );

v_message_walign_inst: v_message_walign 
  port map(
	mux_control=>mux_control,
	ch_message=>ch_message_out,
	v_message=>v_message_out,
	v_message_align=>v_message_out_align
      );

decision_walign_inst  :decision_walign 
  port map(
	decision=>decision_out,
	decision_align=>decision_out_align
      );

c_message_ralign_inst :c_message_ralign 
  port map(
	c_message=>c_message_in,
	c_message_align=>c_message_in_align
      );

v_message_ralign_inst :v_message_ralign
  port map(
	v_message=>v_message_in_shift,
	v_message_align=>v_message_in_align
      );

decision_ralign_inst :decision_ralign 
  port map(
	decision=>decision_make_in,
	decision_align=>decision_make_in_align
      );

v_message_shift_pre_inst :v_message_shift_pre 
  port map(
	clk=>clk,
	reset=>resetorv_shift_pre_reset,
	data_in=>v_message_in,
	data_out=>v_message_in_shift
      );
resetorv_shift_pre_reset<=reset or v_shift_pre_reset;

v_message_shift_post_inst :v_message_shift_post 
  port map(
	clk=>clk,
	reset=>resetorv_shift_post_reset,
	data_in=>v_message_out_align,
	data_out=>v_message_out_shift
      );
resetorv_shift_post_reset<=reset or v_shift_post_reset;

decision_shift_inst :decision_shift 
  port map(
	clk=>clk,
	reset=>resetordecision_shift_reset,
	data_in=>decision_out_align,
	data_out=>decision_out_shift
      );
resetordecision_shift_reset<=reset or decision_shift_reset;

ldpc_buffer_align_inst :ldpc_buffer_align 
  port map(
	clk=>clk,
	reset=>reset,
	mux_control=>mux_control,
	ch_message=>ch_message_out,
	data_in=>decision_out,
	data_out=>ldpc_buffer_in
      );

c_address_gen_inst :c_address_gen 
  port map(
	clk=>clk,
	reset=>reset_c_address_reset_buffer_address_reset,
	c_address_a=>c_address_a,
	c_address_b=>c_address_b,
	c_address_a_dly=>c_address_a_dly,
	c_address_b_dly=>c_address_b_dly
      );
reset_c_address_reset_buffer_address_reset<=reset or c_address_reset or buffer_address_reset;

v_address_gen_inst :v_address_gen 
  port map(
	clk=>clk,
	reset=>resetorv_address_reset,
	v_address_a=>v_address_a,
	v_address_b=>v_address_b, 
	v_address_a_dly=>v_address_a_dly,
	v_address_b_dly=>v_address_b_dly
      );
resetorv_address_reset<= reset or v_address_reset;


address_a10 <=v_address_a when (state_dly = INIT) else v_address_a_dly;
address_b10 <=v_address_b when (state_dly = INIT) else v_address_b_dly;
address_a1 <=address_a10 when (wren1='1') else c_address_a;
address_b1 <=address_b10 when (wren1='1') else c_address_b;
--assign address_a1 = wren1 ? ((state_dly == INIT) ? v_address_a : v_address_a_dly) : c_address_a;
--assign address_b1 = wren1 ? ((state_dly == INIT) ? v_address_b : v_address_b_dly) : c_address_b;
--assign address_a2 = wren2 ? c_address_a_dly : v_address_a;
--assign address_b2 = wren2 ? c_address_b_dly : v_address_b;
 
address_a2 <=c_address_a_dly when (wren2='1') else v_address_a;
address_b2 <=c_address_b_dly when (wren2='1') else v_address_b;

ch_message_block_inst :ch_message_block 
  port map(
   clock=>clk,
   reset=>reset,
   ch_address_reset=>ch_address_reset,
   data=>ldpc_in,
   i_val=>i_val,
   i_sop=>i_sop,
   i_eop=>eop_dly6,
   wren=>wren_ch,
   q=>ch_message_out
      );

message_block_inst1 :message_block 
  port map(
	address_a=>address_a1,
	address_b=>address_b1,
	clock=>clk,
	data_a=>v_message_out_shift(1023 downto 0),
	data_b=>v_message_out_shift(2047 downto 1024),
	wren_a=>wren1,
	wren_b=>wren1,
	q_a=>c_message_in(1023 downto 0),
	q_b=>c_message_in(2047 downto 1024)
      );

message_block_inst2 :message_block 
  port map(
	address_a=>address_a2,
	address_b=>address_b2,
	clock=>clk,
	data_a=>c_message_out_align(1023 downto 0),
	data_b=>c_message_out_align(2047 downto 1024),
	wren_a=>wren2,
	wren_b=>wren2,
	q_a=>v_message_in(1023 downto 0),
	q_b=>v_message_in(2047 downto 1024)
      );

decision_block_inst :decision_block 
  port map(
	address_a=>address_a1,
	address_b=>address_b1,
	clock=>clk,
	data_a=>decision_out_shift(255 downto 0),
	data_b=>decision_out_shift(511 downto 256),
	wren_a=>wren1,
	wren_b=>wren1,
	q_a=>decision_make_in(255 downto 0),
	q_b=>decision_make_in(511 downto 256)
      );



ldpc_out_address_gen_inst:ldpc_out_address_gen 
  port map(
	clk=>clk,
	reset=>resetoro_address_reset,
	waddress=>ldpc_out_waddress,
	waddress_dly2=>ldpc_out_waddress_dly2,
	raddress=>ldpc_out_raddress
      );
resetoro_address_reset<=reset or o_address_reset;


ldpc_buffer_block_inst:ldpc_buffer_block 
  port map(
   clock=>clk,
   reset=>reset,
   data=>ldpc_buffer_in,
   rdaddress=>ldpc_out_waddress,
   wraddress=>wraddress_buffer,
   wren=>wren_buffer,
   q=>ldpc_buffer_out
      );
wraddress_buffer<=c_address_a(111 downto 0) when (state_dly = INIT) else c_address_a_dly(111 downto 0);

ldpc_out_block_inst:ldpc_out_block 
  port map(
   clock=>clk,
   reset=>resetoro_ldpc_reset,
   data=>ldpc_buffer_out,
   rdaddress=>ldpc_out_raddress,
   wraddress=>ldpc_out_waddress_dly2,
   wren=>o_wren,
   q=>ldpc_out
      );
resetoro_ldpc_reset<=reset or o_ldpc_reset;

end rtl;  
