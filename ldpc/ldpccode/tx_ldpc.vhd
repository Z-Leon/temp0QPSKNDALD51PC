    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    
    entity tx_ldpc is  -- define entity
	port
	(   clk          :  in std_logic;
	    reset        :  in std_logic;
	    i_data		 :  in std_logic_vector(7 downto 0);
	    d_src_is_GE  :  in std_logic;
	
	    o_val        : out std_logic;
	    o_data       : out std_logic_vector(8 downto 1);
		o_sop        : out std_logic;
		o_eop        : out std_logic;

		pre_fifo_rden	: out std_logic		       
		
	 );
	end tx_ldpc;
	
	architecture rtl of tx_ldpc is
    
    signal t_sop,t_eop,t_val :  std_logic;
    signal t_data            :  std_logic_vector(7 downto 0);
    signal debugcounter      :  std_logic_vector(15 downto 0);
    
    signal temp_o_val  :   std_logic;
    signal temp_o_sop  :   std_logic;
    signal temp_o_eop  :   std_logic;
    signal t2_sop,t2_eop,t2_val :  std_logic;
    signal t2_data  , t1_data          :  std_logic_vector(7 downto 0);
    signal t3_sop,t3_eop,t3_val :  std_logic;
    signal t3_data             :  std_logic_vector(7 downto 0);
    signal pn23 : std_logic_vector(23 downto 0);
    
    component siggen  is 
		port
		(               
			i_clk   :   in std_logic;
			i_reset :   in std_logic;
	
			o_sop   :  out std_logic;
			o_eop   :  out std_logic;
			o_val   :  out std_logic;
		   o_data  :  out std_logic_vector(8 downto 1)
		);
		end component;
		
	component ldpc_enc is 
		port
		(               
			reset        :   in std_logic;
			clk          :   in std_logic;
	
			ldpc_in      :   in std_logic_vector(7 downto 0);
			i_sink_val   :   in std_logic;
			i_sink_sop   :   in std_logic;
		    i_sink_eop   :   in std_logic;
	
			ldpc_out     :   out std_logic_vector(7 downto 0);
			o_src_val    :   out std_logic;
			o_src_sop    :   out std_logic;
			o_src_eop    :   out std_logic
		);
		end component;
    
    begin
		o_val <= temp_o_val;
		o_sop <= temp_o_sop;
		o_eop <= temp_o_eop;
		
		process ( clk , reset )
		begin
			if ( reset = '1' ) then
				debugcounter <= (others=>'0');
			elsif rising_edge(clk) then
				if ( temp_o_eop = '1' ) then
					debugcounter <= (others=>'0');
				elsif ( temp_o_sop = '1' ) then
					debugcounter <= x"0001";
				elsif ( temp_o_val = '1' ) then
					debugcounter <= debugcounter + x"0001";
				end if;
			end if;
		end process;
		
		siggen_inst : siggen 
		port map
        (
			i_clk  =>  clk,
			i_reset=>  reset,
	
			o_sop  =>  t_sop,
			o_eop  =>  t_eop,
			o_val  =>  t_val,
			o_data =>  t_data
		);

        pre_fifo_rden <= t_val;

        sig_dly : process( clk, reset )
        begin
          if( reset = '1' ) then
            t1_data <= (others => '0');
            t2_val <= '0';
            t2_sop <= '0';
            t2_eop <= '0';
          elsif( rising_edge(clk) ) then
          	t1_data <= t_data;
          	t2_val <= t_val;
          	t2_sop <= t_sop;
          	t2_eop <= t_eop;
          	
          end if ;
        end process ; -- sig_dly

        sig_dly2 : process( clk, reset )
        begin
          if( reset = '1' ) then
            t2_data <= (others => '0');
            t3_val <= '0';
            t3_sop <= '0';
            t3_eop <= '0';
          elsif( rising_edge(clk) ) then
          	t2_data <= t1_data;
          	t3_val <= t2_val;
          	t3_sop <= t2_sop;
          	t3_eop <= t2_eop;
          	
          end if ;
        end process ; 
		  
		  --t1_data <= x"47";

    --    --process(t1_data, i_data, pn23(23 downto 16), d_src_is_GE)
		  --process(t1_data, i_data, d_src_is_GE)
    --    begin
    --    	if d_src_is_GE = '1' then
    --    		t2_data <= i_data;-- xor pn23(23 downto 16);
				----t2_data <= pn23(23 downto 16);
    --    	else
    --    		t2_data <= t1_data;-- xor pn23(23 downto 16);
    --    	end if;
    --    end process;

            --process(t1_data, i_data, pn23(23 downto 16), d_src_is_GE)
		  process(t2_data, i_data, d_src_is_GE)
        begin
        	if d_src_is_GE = '1' then
        		t3_data <= i_data;
        	else
        		t3_data <= t2_data;
        	end if;
        end process;

   --     ------------  scrambler ---------------
   --     --
   --     -- i_data XOR pn23
   --     --
   --     pn23_p8_pr : process( clk, reset )
   --     begin
   --       if( reset = '1' ) then
   --         pn23 <= (others => '0');
   --       elsif( rising_edge(clk) ) then
   --       	if t_sop='1' or t_eop='1' then
   --       		pn23(1) <= '1';
   --       		pn23(23 downto 2) <= (others => '0');
   --       	elsif t_val='1' then
   --       		pn23(23 downto 9) <= pn23(15 downto 1);
			--	pn23(8 downto 1)  <= pn23(23 downto 16) xor pn23(18 downto 11);
			--else
			--	pn23 <= pn23;
			--end if;
   --       end if ;
   --     end process ; -- pn23_p8_pr
   --     ---------------------------------------------------


		ldpc_enc_inst : ldpc_enc 
		port map
		(
			reset       =>  reset,
			clk         =>  clk,
	
			ldpc_in     =>  t3_data,
			i_sink_val  =>  t3_val,
			i_sink_sop  =>  t3_sop,
			i_sink_eop  =>  t3_eop,

			ldpc_out   =>  o_data,
			o_src_val  =>  temp_o_val,
			o_src_sop  =>  temp_o_sop,
			o_src_eop  =>  temp_o_eop
		);
	end rtl;  			
				
