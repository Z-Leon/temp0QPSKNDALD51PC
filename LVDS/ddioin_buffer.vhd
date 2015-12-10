---------------------------------
-- Author	: JiangLong
-- Date   	: 20151210
-- Project	: pj051
-- Function	: ddio input and buffer
-- Description	: 
--
-- Ports	: 
--
-- Problems	: 
-- History	: 
----------------------------------
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity ddioin_buffer is
  port (
  	aReset	: in std_logic;
  	ddio_clk	: in std_logic;  --100MHz
  	ddio_din	: in std_logic_vector(4 downto 0);  
  	rdclk		: in std_logic;  --100MHz

  	d_out 		: out std_logic_vector(4 downto 0) 
	
  ) ;
end entity ; 

architecture arch of ddioin_buffer is

component ddio_fromF2 IS
	PORT
	(
		datain		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		inclock		: IN STD_LOGIC ;
		dataout_h		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		dataout_l		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END component;

component ff_ddio_in IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
END component;

signal rdreq : std_logic;
signal rdusedw : std_logic_vector(3 downto 0) ;
signal data_in_l : std_logic_vector(4 downto 0) ;

begin

ddio_fromF2_inst: ddio_fromF2 
	PORT map
	(
		--aclr		=> aReset,
		datain		=> ddio_din,
		inclock		=> ddio_clk,
		dataout_h		=> open,
		dataout_l		=> data_in_l
	);

ff_ddio_in_inst : ff_ddio_in
PORT map
	(
		aclr		=> aReset ,
		data		=> data_in_l ,
		rdclk		=> rdclk ,
		rdreq		=> rdreq ,
		wrclk		=> ddio_clk ,
		wrreq		=> '1' ,
		q			=> d_out ,
		rdempty		=> open ,
		rdusedw		=> rdusedw ,
		wrfull		=> open 
	);

-- identifier
process( rdclk, aReset )
begin
  if( aReset = '1' ) then
    rdreq <= '0' ;
  elsif( rising_edge(rdclk) ) then
  	if unsigned(rdusedw) >= to_unsigned(4, rdusedw'length) then
  		rdreq <=  '1';
  	else
  		rdreq <= '0' ;
  	end if;
  end if ;
end process ; 


end architecture ;