    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
    
    entity pipo_parallel is
	port
	(
		reset        :  in std_logic;
		clk          :  in std_logic;
	
		info_in      :  in std_logic_vector(7 downto 0);
		i_sink_val   :  in std_logic;
	
		i_sop        :  in std_logic;
		i_eop        :  in std_logic; 
	
	
		parity_out   :  out std_logic_vector(7 downto 0);
		o_src_val    :  out std_logic;
	
		encode_done  :  out std_logic
	);
	end pipo_parallel;
	
	architecture rtl of pipo_parallel is
	
	constant plength :  std_logic_vector(7 downto 0):= "10000000";
	
	type gshift_ex is array (14 downto 1) of std_logic_vector(510 downto 0);
	type pipo_ex is array (14 downto 1) of std_logic_vector(7 downto 0);
	type q_b_ex is array (14 downto 1) of std_logic_vector(255 downto 0);
	
	signal gshift          :   gshift_ex;
	signal gen             :   gshift_ex;
	signal pipo            :   pipo_ex;
	signal rom_gen_q_b     :   q_b_ex;
	
	signal info            :   std_logic_vector(7135 downto 0);
	signal code_ready      :   std_logic;
	signal pcounter        :   std_logic_vector(7 downto 0);
	signal pcounter_dly1   :   std_logic_vector(7 downto 0);
	signal pcounter_dly2   :   std_logic_vector(7 downto 0);
	signal pcounter_dly3   :   std_logic_vector(7 downto 0);
	signal pcounter_dly4   :   std_logic_vector(7 downto 0);
	signal pcounter_dly5   :   std_logic_vector(7 downto 0);
	signal pcounter_dly6   :   std_logic_vector(7 downto 0);
	signal address_high    :   std_logic_vector(4 downto 0);
	signal address_low     :   std_logic_vector(4 downto 0);
	signal load_val        :   std_logic;
	signal shift_val       :   std_logic;
	signal parity_dly      :   std_logic_vector(7 downto 0);
	signal info_recieve_ena:   std_logic;
	signal temp_xhdl       :   std_logic_vector(7 downto 0);
	
	signal parity_temp     :   std_logic_vector(7 downto 0);
	
	--signal no_use_bit   :   std_logic;
	
	signal no_use_string   :   std_logic_vector(510 downto 0);
	
	component	rom_gen_1	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_2	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_3	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_4	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_5	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_6	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_7	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_8	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_9	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_10	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_11	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_12	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_13	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component	rom_gen_14	
	port(
			address_a	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			clock		   : IN STD_LOGIC ;
			q_a		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0);
			q_b		    : OUT STD_LOGIC_VECTOR (255 DOWNTO 0)
		);
	end	component;
	
	component   shiftreg_511
	port
	(
		reset   :    in std_logic;
		clk     :    in std_logic;
		
		load_data   :   in std_logic_vector(510 downto 0);
		load_val    :   in std_logic;
		shift_val   :   in std_logic;
		
		shiftreg_out:   out std_logic_vector(510 downto 0)
	);
	end  component;
	
	component   inforeg_7136
	port
	(
		reset     :  in std_logic;
		clk       :  in std_logic;
		
		info_in   :  in std_logic_vector(7 downto 0);
		info_val  :  in std_logic;
		info_ena  :  in std_logic;
		 
		inforeg   :  out std_logic_vector(7135 downto 0)
	);
	end  component;
	
	component    pipo_511 
	port
	(
		reset    :  in std_logic;
		clk      :  in std_logic;
		
		info_in  :   in std_logic_vector(510 downto 0);
		gen_in   :   in std_logic_vector(510 downto 0);
		
		pipo_out :   out std_logic_vector(7 downto 0)
	);
	end component;
	
	begin
		info_recieve_ena <= not code_ready;
		
		no_use_string   <= info(492 downto 0) & "000000000000000000";
		
		process ( reset , clk )
		begin
			if ( reset = '1' ) then
				code_ready <= '0';
			elsif rising_edge(clk) then
				if ( i_eop = '1' ) then
					code_ready <= '1';
				elsif ( pcounter = plength ) then
					code_ready <= '0';
				else
				code_ready <= code_ready;
				end if;
			end if;
		end process;
		
		temp_xhdl <= "00000000" when ( pcounter = plength ) else pcounter + "00000001";
		process ( reset , clk )
		begin
			if ( reset = '1' ) then
				pcounter <= (others=>'0');
				pcounter_dly1 <= (others=>'0');
				pcounter_dly2 <= (others=>'0');
				pcounter_dly3 <= (others=>'0');
				pcounter_dly4 <= (others=>'0');
				pcounter_dly5 <= (others=>'0');
				pcounter_dly6 <= (others=>'0');
			elsif rising_edge(clk) then
				pcounter_dly1 <= pcounter;
				pcounter_dly2 <= pcounter_dly1;
				pcounter_dly3 <= pcounter_dly2;
				pcounter_dly4 <= pcounter_dly3;
				pcounter_dly5 <= pcounter_dly4;
				pcounter_dly6 <= pcounter_dly5;
				if ( code_ready = '1' ) then
					pcounter <= temp_xhdl;
				else 
					pcounter <= (others=>'0');
				end if;
			end if;	
		end process;
		
		process ( reset , clk )
		begin
			if ( reset = '1' ) then
				address_low  <= "00000";
				address_high <= "00001";
				
			elsif rising_edge(clk) then
				if( i_sop = '1' ) then
					address_low  <= "00000";
					address_high <= "00001";
			
				elsif (pcounter = 62) then
					address_low  <= "00010";
					address_high <= "00011";
			
				else
					address_low  <= address_low;
					address_high <= address_high;
				end if;
			end if;		
		end process;
		
		process ( reset , clk )
		begin
			if ( reset='1' ) then
				load_val  <= '0';
				shift_val <= '0';
			elsif rising_edge(clk) then
			   
				if (((code_ready = '1') and ((pcounter = "00000000") or (pcounter = "01000000")))) then
					load_val  <= '1';
				else
					load_val  <= '0';
				end if;
				if ((code_ready = '1') and (pcounter /= "00000000")and (pcounter /= "01000000")) then
					shift_val <= '1';
				else
					shift_val <= '0';
				end if;
			end if;
			
		end process;
		
		rom_gen_1_inst : rom_gen_1 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(1)(255 downto 0),
			q_b  =>  rom_gen_q_b(1)  --no_use_bit & gshift(1)(510 downto 256)
		);
		gshift(1)(510 downto 256) <= rom_gen_q_b(1)(254 downto 0);
		
		rom_gen_2_inst : rom_gen_2
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(2)(255 downto 0),
			q_b  =>  rom_gen_q_b(2)--no_use_bit & gshift(2)(510 downto 256)
		);
		gshift(2)(510 downto 256) <= rom_gen_q_b(2)(254 downto 0);
		
		rom_gen_3_inst : rom_gen_3
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(3)(255 downto 0),
			q_b  =>   rom_gen_q_b(3)--no_use_bit & gshift(3)(510 downto 256)
		);
		gshift(3)(510 downto 256) <= rom_gen_q_b(3)(254 downto 0);
		
		rom_gen_4_inst : rom_gen_4
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(4)(255 downto 0),
			q_b  =>   rom_gen_q_b(4)--no_use_bit & gshift(4)(510 downto 256)
		);
		gshift(4)(510 downto 256) <= rom_gen_q_b(4)(254 downto 0);
		
		rom_gen_5_inst : rom_gen_5
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(5)(255 downto 0),
			q_b  =>   rom_gen_q_b(5)--no_use_bit & gshift(5)(510 downto 256)
		);
		gshift(5)(510 downto 256) <= rom_gen_q_b(5)(254 downto 0);
		
		rom_gen_6_inst : rom_gen_6 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(6)(255 downto 0),
			q_b  =>   rom_gen_q_b(6)--no_use_bit & gshift(6)(510 downto 256)
		);
		gshift(6)(510 downto 256) <= rom_gen_q_b(6)(254 downto 0);
		
		rom_gen_7_inst : rom_gen_7 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(7)(255 downto 0),
			q_b  =>   rom_gen_q_b(7)--no_use_bit & gshift(7)(510 downto 256)
		);
		gshift(7)(510 downto 256) <= rom_gen_q_b(7)(254 downto 0);
		
		rom_gen_8_inst : rom_gen_8 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(8)(255 downto 0),
			q_b  =>   rom_gen_q_b(8)--no_use_bit & gshift(8)(510 downto 256)
		);
		gshift(8)(510 downto 256) <= rom_gen_q_b(8)(254 downto 0);
		
		rom_gen_9_inst : rom_gen_9 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(9)(255 downto 0),
			q_b  =>   rom_gen_q_b(9)--no_use_bit & gshift(9)(510 downto 256)
		);
		gshift(9)(510 downto 256) <= rom_gen_q_b(9)(254 downto 0);
		
		rom_gen_10_inst : rom_gen_10 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(10)(255 downto 0),
			q_b  =>   rom_gen_q_b(10)--no_use_bit & gshift(10)(510 downto 256)
		);
	   gshift(10)(510 downto 256) <= rom_gen_q_b(10)(254 downto 0);	
		
		rom_gen_11_inst : rom_gen_11 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(11)(255 downto 0),
			q_b  =>   rom_gen_q_b(11)--no_use_bit & gshift(11)(510 downto 256)
		);
		gshift(11)(510 downto 256) <= rom_gen_q_b(11)(254 downto 0);
		
		rom_gen_12_inst : rom_gen_12 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(12)(255 downto 0),
			q_b  =>   rom_gen_q_b(12)--no_use_bit & gshift(12)(510 downto 256)
		);
		gshift(12)(510 downto 256) <= rom_gen_q_b(12)(254 downto 0);
		
		rom_gen_13_inst : rom_gen_13 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(13)(255 downto 0),
			q_b  =>   rom_gen_q_b(13)--no_use_bit & gshift(13)(510 downto 256)
		);
		gshift(13)(510 downto 256) <= rom_gen_q_b(13)(254 downto 0);
		
		rom_gen_14_inst : rom_gen_14 
		port map
		(
			address_a  =>  address_low,
			address_b  =>  address_high,
			clock  =>  clk,
			q_a  =>  gshift(14)(255 downto 0),
			q_b  =>   rom_gen_q_b(14)--no_use_bit & gshift(14)(510 downto 256)
		);
		gshift(14)(510 downto 256) <= rom_gen_q_b(14)(254 downto 0);
		
		shiftreg_511_1   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(1),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(1)
		);
		
		shiftreg_511_2   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(2),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(2)
		);
		
		shiftreg_511_3   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(3),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(3)
		);
		
		shiftreg_511_4   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(4),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(4)
		);
		
		shiftreg_511_5   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(5),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(5)
		);
		
		shiftreg_511_6   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(6),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(6)
		);
		
		shiftreg_511_7   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(7),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(7)
		);
		
		shiftreg_511_8   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(8),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(8)
		);
		
		shiftreg_511_9   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(9),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(9)
		);
		
		shiftreg_511_10   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(10),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(10)
		);
		
		shiftreg_511_11   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(11),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(11)
		);
		
		shiftreg_511_12   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(12),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(12)
		);
		
		shiftreg_511_13   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(13),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(13)
		);
		
		shiftreg_511_14   : shiftreg_511
		port map
		(
			reset         =>   reset, 
			clk           =>   clk,	
			load_data     =>   gshift(14),	
			load_val      =>   load_val,	
			shift_val     =>   shift_val,	
			shiftreg_out  =>   gen(14)
		);
		
		inforeg_inst      : inforeg_7136 
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info_in,	
			info_val   =>   i_sink_val,
			info_ena   =>   info_recieve_ena,	
			inforeg    =>   info
		);
		
		pipo_511_1    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   no_use_string,	--info(492 downto 0) & "000000000000000000"
			gen_in     =>   gen(1),	
			pipo_out   =>   pipo(1)
		);
		
		pipo_511_2    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(1003 downto 493),	
			gen_in     =>   gen(2),	
			pipo_out   =>   pipo(2)
		);
		
		pipo_511_3    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(1514 downto 1004),	
			gen_in     =>   gen(3),	
			pipo_out   =>   pipo(3)
		);
		
		pipo_511_4    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(2025 downto 1515),	
			gen_in     =>   gen(4),	
			pipo_out   =>   pipo(4)
		);
		
		pipo_511_5    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(2536 downto 2026),	
			gen_in     =>   gen(5),	
			pipo_out   =>   pipo(5)
		);

		pipo_511_6    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(3047 downto 2537),	
			gen_in     =>   gen(6),	
			pipo_out   =>   pipo(6)
		);
		
		pipo_511_7    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(3558 downto 3048),	
			gen_in     =>   gen(7),	
			pipo_out   =>   pipo(7)
		);
		
		pipo_511_8    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(4069 downto 3559),	
			gen_in     =>   gen(8),	
			pipo_out   =>   pipo(8)
		);
		
		pipo_511_9    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(4580 downto 4070),	
			gen_in     =>   gen(9),	
			pipo_out   =>   pipo(9)
		);
		
		pipo_511_10    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(5091 downto 4581),	
			gen_in     =>   gen(10),	
			pipo_out   =>   pipo(10)
		);
		
		pipo_511_11    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(5602 downto 5092),	
			gen_in     =>   gen(11),	
			pipo_out   =>   pipo(11)
		);
		
		pipo_511_12    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(6113 downto 5603),	
			gen_in     =>   gen(12),	
			pipo_out   =>   pipo(12)
		);
		
		pipo_511_13    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(6624 downto 6114),	
			gen_in     =>   gen(13),	
			pipo_out   =>   pipo(13)
		);
		
		pipo_511_14    :    pipo_511
		port map
		(
			reset      =>   reset,
			clk        =>   clk,
			info_in    =>   info(7135 downto 6625),	
			gen_in     =>   gen(14),	
			pipo_out   =>   pipo(14)
		);
		
		parity_temp(7) <= (
						   pipo(14)(7) xor pipo(13)(7) xor pipo(12)(7) xor pipo(11)(7) xor 
						   pipo(10)(7) xor pipo(9)(7) xor  pipo(8)(7) xor  pipo(7)(7) xor 
						   pipo(6)(7) xor  pipo(5)(7) xor  pipo(4)(7) xor  pipo(3)(7) xor 
						   pipo(2)(7) xor  pipo(1)(7)
						   );
		parity_temp(6) <= (
							pipo(14)(6) xor pipo(13)(6) xor pipo(12)(6) xor pipo(11)(6) xor 
							pipo(10)(6) xor pipo(9)(6) xor  pipo(8)(6) xor  pipo(7)(6) xor 
							pipo(6)(6) xor  pipo(5)(6) xor  pipo(4)(6) xor  pipo(3)(6) xor 
							pipo(2)(6) xor  pipo(1)(6)
							);
		parity_temp(5) <= (
							pipo(14)(5) xor pipo(13)(5) xor pipo(12)(5) xor pipo(11)(5) xor 
							pipo(10)(5) xor pipo(9)(5) xor  pipo(8)(5) xor  pipo(7)(5) xor 
							pipo(6)(5) xor  pipo(5)(5) xor  pipo(4)(5) xor  pipo(3)(5) xor 
							pipo(2)(5) xor  pipo(1)(5)
							);                         
		parity_temp(4) <= (
							pipo(14)(4) xor pipo(13)(4) xor pipo(12)(4) xor pipo(11)(4) xor 
							pipo(10)(4) xor pipo(9)(4) xor  pipo(8)(4) xor  pipo(7)(4) xor 
							pipo(6)(4) xor  pipo(5)(4) xor  pipo(4)(4) xor  pipo(3)(4) xor 
							pipo(2)(4) xor  pipo(1)(4)
							);
		parity_temp(3) <= (
							pipo(14)(3) xor pipo(13)(3) xor pipo(12)(3) xor pipo(11)(3) xor 
							pipo(10)(3) xor pipo(9)(3) xor  pipo(8)(3) xor  pipo(7)(3) xor 
							pipo(6)(3) xor  pipo(5)(3) xor  pipo(4)(3) xor  pipo(3)(3) xor 
							pipo(2)(3) xor  pipo(1)(3)
							);
		parity_temp(2) <= (
							pipo(14)(2) xor pipo(13)(2) xor pipo(12)(2) xor pipo(11)(2) xor 
							pipo(10)(2) xor pipo(9)(2) xor  pipo(8)(2) xor  pipo(7)(2) xor 
							pipo(6)(2) xor  pipo(5)(2) xor  pipo(4)(2) xor  pipo(3)(2) xor 
							pipo(2)(2) xor  pipo(1)(2)
							);     
		parity_temp(1) <= (
							pipo(14)(1) xor pipo(13)(1) xor pipo(12)(1) xor pipo(11)(1) xor 
							pipo(10)(1) xor pipo(9)(1) xor  pipo(8)(1) xor  pipo(7)(1) xor 
							pipo(6)(1) xor  pipo(5)(1) xor  pipo(4)(1) xor  pipo(3)(1) xor 
							pipo(2)(1) xor  pipo(1)(1)
							);
		parity_temp(0) <= (
							pipo(14)(0) xor pipo(13)(0) xor pipo(12)(0) xor pipo(11)(0) xor 
							pipo(10)(0) xor pipo(9)(0) xor  pipo(8)(0) xor  pipo(7)(0) xor 
							pipo(6)(0) xor  pipo(5)(0) xor  pipo(4)(0) xor  pipo(3)(0) xor 
							pipo(2)(0) xor  pipo(1)(0)
							);  
		process ( reset , clk )
		begin
			if ( reset = '1' ) then
				parity_dly <= (others=>'0');
			elsif rising_edge(clk) then
				parity_dly <= parity_temp;
			end if;
		end process;

		process ( reset , clk )
		begin
			if ( reset = '1' ) then
			
				parity_out <= (others=>'0');
				encode_done <= '0';
			
			elsif rising_edge(clk) then
				if ( pcounter_dly6 = 63 ) then
					parity_out   <= ( parity_temp(0) & parity_dly(6 downto 0) );
					encode_done  <= '0';
			
				elsif ( pcounter_dly6 = 127 ) then
					parity_out   <= ( "00" & parity_dly(6 downto 1) );
					encode_done  <= '1';
				
				elsif (pcounter_dly6 >= 64) then
					parity_out   <= ( parity_temp(0) & parity_dly(7 downto 1) );
					encode_done  <= '0';
				
				else
					parity_out <= parity_dly;
					encode_done  <= '0';
					
				end if;
			end if;
		end process;
		
		o_src_val <= '1' when pcounter_dly6 /= "00000000" else '0' ;
		  	
	end rtl;
	
	
	
	
	
	