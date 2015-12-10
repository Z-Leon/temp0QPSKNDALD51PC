
module adin
(
   //control interface
   output        adc_fsr              ,
   output        adc_ddrph            ,
   output        adc_des              ,
   output        adc_ndm              ,
   output        adc_rst              ,
   input         adc_sdo              ,
   output        adc_sclk             ,
   output        adc_sdi              ,
   output        adc_scs              ,
   //data clk interface
   input         adc_dclki            ,
   input         adc_dclkq            ,
   input  [11:0] adc_di               ,
   input  [11:0] adc_dq               ,
   //adc usr interface
   output [11:0] adc_d0               ,
   output [11:0] adc_d1               ,   
   output [11:0] adc_d2               ,   
   output [11:0] adc_d3               ,   
   output [11:0] adc_d4               ,   
   output [11:0] adc_d5               ,   
   output [11:0] adc_d6               ,   
   output [11:0] adc_d7               ,      
   output        data_rx_outclock      
   
);

 //
 wire          data_pll_areset    ;
 wire [23:0]   data_rx_fifo_reset ;
 wire [23:0]   data_rx_reset      ;
 wire [23:0]   data_rx_dpa_locked ;
 wire [95:0]   data_rx_out        ;
// wire          data_i_rx_outclock   ;
 
 
 // adc control signal assign
 // binary offset output 
  assign   adc_fsr   = 1'b1 ;   // 1: analog input range is 800 mv vpp, 0: 600mv vpp
  assign   adc_ddrph = 1'b0 ;   // 1: data and clk in 90 phase , 0: data and clk in 0 phase
  assign   adc_des   = 1'b1 ;   // 1: adc sample in double edge mode , 0: not in double edge mode
  assign   adc_ndm   = 1'b1 ;   // 1: adc data output not in de-mux mode,0: in de-mux mode 
  assign   adc_rst   = 1'b0 ;   // 1: rst active ,0 : rst not active
  
  assign   adc_sclk  = 1'b0 ; 
  assign   adc_sdi   = 1'b0 ;
  assign   adc_scs   = 1'b0 ;  
  
 // adc_interface rst control 
 // first not reset
 assign data_pll_areset    = 1'b0 ;
 //assign data_rx_fifo_reset = 24'b0 ;  
 //assign data_rx_reset      = 24'b0 ;

  
     
 // data_i altlvds_rx module
 
 adc_interface adc_di_inst (
	.pll_areset    ( data_pll_areset    ),         
	//.rx_fifo_reset ( data_rx_fifo_reset ),      
	.rx_in         ( {adc_di,adc_dq}      ),              
	.rx_inclock    ( adc_dclki            ),         
	//.rx_reset      ( data_rx_reset      ),           
	//.rx_dpa_locked ( data_rx_dpa_locked ),      
	.rx_out        ( data_rx_out          ),             
	.rx_outclock   ( data_rx_outclock     )
	);  
	
// adc_interface adc_di_inst (
//	.rx_in       ({adc_di,adc_dq}) ,
//	.rx_inclock  (adc_dclki) ,
//	.rx_out      (data_rx_out),
//	.rx_outclock (data_rx_outclock)
//	);
	
  //Q3   
  assign adc_d6  = {data_rx_out[44],data_rx_out[40],data_rx_out[36],data_rx_out[32],data_rx_out[28],data_rx_out[24],data_rx_out[20],data_rx_out[16],data_rx_out[12],data_rx_out[8] ,data_rx_out[4],data_rx_out[0]} ;
  //Q2
  assign adc_d4  = {data_rx_out[45],data_rx_out[41],data_rx_out[37],data_rx_out[33],data_rx_out[29],data_rx_out[25],data_rx_out[21],data_rx_out[17],data_rx_out[13],data_rx_out[9] ,data_rx_out[5],data_rx_out[1]} ;
  //Q1
  assign adc_d2  = {data_rx_out[46],data_rx_out[42],data_rx_out[38],data_rx_out[34],data_rx_out[30],data_rx_out[26],data_rx_out[22],data_rx_out[18],data_rx_out[14],data_rx_out[10],data_rx_out[6],data_rx_out[2]} ;
  //Q0
  assign adc_d0  = {data_rx_out[47],data_rx_out[43],data_rx_out[39],data_rx_out[35],data_rx_out[31],data_rx_out[27],data_rx_out[23],data_rx_out[19],data_rx_out[15],data_rx_out[11],data_rx_out[7],data_rx_out[3]} ;
  //I3
  assign adc_d7  = {data_rx_out[92],data_rx_out[88],data_rx_out[84],data_rx_out[80],data_rx_out[76],data_rx_out[72],data_rx_out[68],data_rx_out[64],data_rx_out[60],data_rx_out[56],data_rx_out[52],data_rx_out[48]} ;
  //I2
  assign adc_d5  = {data_rx_out[93],data_rx_out[89],data_rx_out[85],data_rx_out[81],data_rx_out[77],data_rx_out[73],data_rx_out[69],data_rx_out[65],data_rx_out[61],data_rx_out[57],data_rx_out[53],data_rx_out[49]} ;
  //I1
  assign adc_d3  = {data_rx_out[94],data_rx_out[90],data_rx_out[86],data_rx_out[82],data_rx_out[78],data_rx_out[74],data_rx_out[70],data_rx_out[66],data_rx_out[62],data_rx_out[58],data_rx_out[54],data_rx_out[50]} ;
  //I0
  assign adc_d1  = {data_rx_out[95],data_rx_out[91],data_rx_out[87],data_rx_out[83],data_rx_out[79],data_rx_out[75],data_rx_out[71],data_rx_out[67],data_rx_out[63],data_rx_out[59],data_rx_out[55],data_rx_out[51]} ;
  
  //test data com
  // q0 i0 q1 i1 q2 i2 q3 i3
	
endmodule