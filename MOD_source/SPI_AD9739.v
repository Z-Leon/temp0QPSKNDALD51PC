// for DAC chip AD9739 , SPI Initialization
// 4-wire
// see datasheet of AD9739   Table 31
// JL 2014-01

module SPI_AD9739

(
	// Input Ports
	input clk ,   //2M
	input reset,
	input sdi,

	// Output Ports
	output reg sclk,  // fsclk=1/2*fclk
	output reg cs,
	output reg sdo    // 1/2 * fclk

);

	// Module Item(s)

// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

	// Declare state register
	reg		[4:0]state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15, S16 = 16, S17 = 17,S18 = 18, S19 = 19, S20 = 20, S21 = 21, S22 = 22;
	
	always @ (posedge clk or posedge reset) begin
		if (reset)
			sclk <= 1'b0;
		else
			sclk <= !sclk;
	end
		
	// sclk 			0   1   0   1   0   1   ...   0   1   0   1   0   1   0   1 
	// cnt			0   1   2   3   4   5   ...   30  31  32  33  34  35  36  37  38  39  40   0
	// cs				1   1   0   0   0   0   ...   0   0   0   0   1   1   1   1
	// sdata			x   x   0   0   N1  N1  ...   D1  D1  D0  D0  x   x
	
	reg [6:0] cnt;
	reg [15:0] sdo_reg, sdo_init;
	reg [7:0] cnt_wait;
	
	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				sdo_init <= 16'h0000;
			S1:
				// write   0x00(addr)  0x00(value)
				sdo_init <= 16'h0000;
			S2:
				// write   0x00(addr)  0x20(value)
				sdo_init <= 16'h0020;
			S3:
				// write   0x00(addr)  0x00(value)
				sdo_init <= 16'h0000;
			S4:
				// write   0x22(addr)  0x0f(value)
				sdo_init <= 16'h220f;
			S5:
				// write   0x23(addr)  0x0f(value)
				sdo_init <= 16'h230f;
			S6:
				// write   0x24(addr)  0x30(value)
				sdo_init <= 16'h2430;
			S7:
				// write   0x25(addr)  0x80(value)
				sdo_init <= 16'h2580;
			S8:
				// write   0x27(addr)  0x44(value)
				sdo_init <= 16'h2742;   //1.6G to 2.5G   MU Phase:6  Slope:-
				//sdo_init <= 16'h2744;   
			S9:
				// write   0x28(addr)  0x6c(value)
				sdo_init <= 16'h286c;
			S10:
				// write   0x29(addr)  0xcb(value)
				sdo_init <= 16'h29cb;
			S11:
				// write   0x26(addr)  0x02(value)
				sdo_init <= 16'h2602;   // Slope : -
			S12:
				// write   0x26(addr)  0x03(value)
				sdo_init <= 16'h2603;  // Slope : -
			
			S13,S14,S15,S20:
				sdo_init <= 16'h0000;
			
			S16:
				// write   0x13(addr)  0x72(value)
				sdo_init <= 16'h1372;  // Slope : -
			S17:
				// write   0x10(addr)  0x00(value)
				sdo_init <= 16'h1000;  // Slope : -
			S18:
				// write   0x10(addr)  0x02(value)
				sdo_init <= 16'h1002;  // Slope : -
			S19:
				// write   0x10(addr)  0x03(value)
				sdo_init <= 16'h1003;  // Slope : -
				
			default:
				sdo_init <= 16'h0000;
		endcase
	end
	
	// Determine the next state
	always @ (posedge clk or posedge reset) begin
		if (reset)
		begin
			state <= S0;
			cnt <= 0;
			cnt_wait <= 0;
			sdo_reg <= 0;
			sdo <= 0;
			cs <= 1'b1;
		end
		else
		begin
			case (state)
				S0:
				begin
					state <= S1;
					cnt <= 0;
					cnt_wait <= 0;
					sdo_reg <= 0;
					sdo <= 0;
					cs <= 1'b1;
				end
					
				S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12:
				begin
					// write   (addr)  (value)
					if ( cnt==7'd0 && sclk==1'b1)
					begin
						cnt <= 7'd0;
						state <= state;
					end
					else if ( cnt != 7'd40 )
					begin
						state <= state;
						cnt <= cnt + 7'd1;
					end
					else
					begin
						state <= state + 5'd1;
						cnt <= 0;
					end
					
					if ( cnt == 7'd0 )
						sdo_reg <= sdo_init;
					else if ( sclk == 1'b1 )
						sdo_reg <= ( sdo_reg<<1 );
					else
						sdo_reg <= sdo_reg;

					
					if ( sclk == 1'b1 )
						sdo <= sdo_reg[15];
						
					if ( ( cnt>=7'd1 ) && ( cnt<=7'd32 ) )
						cs <= 1'b0;
					else
						cs <= 1'b1;
				end
				
				S13:
				begin
					// Wait for 160K*1/fdata cycles
					// 160K * 1/1.6G = 100us
					// 100us = 200 * 1/2M
					cs <= 1'b1;
					if (cnt_wait != 200) 
					begin
						cnt_wait <= cnt_wait + 8'd1;
						state <= state;
					end
					else
					begin
						cnt_wait <= 0;
						state <= S14;
					end
				end
				
				S14:
				begin
					// read  0x2a(addr)  (value)
					if ( cnt==7'd0 && sclk==1'b1)
					begin
						cnt <= 7'd0;
						state <= state;
					end
					else if ( cnt != 7'd40 )
					begin
						state <= state;
						cnt <= cnt + 7'd1;
					end
					else
					begin
						state <= state + 5'd1;
						cnt <= 0;
					end
					
					if ( cnt == 7'd0 )
						sdo_reg <= 16'haa00;
					else if ( sclk == 1'b1 )
						sdo_reg <= ( sdo_reg<<1 );
					else
						sdo_reg <= sdo_reg;

					
					if ( sclk == 1'b1 )
						sdo <= sdo_reg[15];
						
					if ( ( cnt>=7'd1 ) && ( cnt<=7'd32 ) )
						cs <= 1'b0;
					else
						cs <= 1'b1;
				end
				
				
				S15:
				begin
					cs <= 1'b1;
					state <= S16;
				end
				

				S16,S17,S18,S19:
				begin
					// write  (addr)  (value)
					if ( cnt==7'd0 && sclk==1'b1)
					begin
						cnt <= 7'd0;
						state <= state;
					end
					else if ( cnt != 7'd40 )
					begin
						state <= state;
						cnt <= cnt + 7'd1;
					end
					else
					begin
						state <= state+1;
						cnt <= 0;
					end
					
					if ( cnt == 7'd0 )
						sdo_reg <= sdo_init;
					else if ( sclk == 1'b1 )
						sdo_reg <= ( sdo_reg<<1 );
					else
						sdo_reg <= sdo_reg;

					
					if ( sclk == 1'b1 )
						sdo <= sdo_reg[15];
						
					if ( ( cnt>=7'd1 ) && ( cnt<=7'd32 ) )
						cs <= 1'b0;
					else
						cs <= 1'b1;
				end
				
				S20:
				begin
					// Wait for 135K*1/fdata cycles
					// 135K * 1/1.6G = 84.375us
					// 84.375us = 168.75 * 1/2M
					cs <= 1'b1;
					if (cnt_wait != 169) 
					begin
						cnt_wait <= cnt_wait + 8'd1;
						state <= state;
					end
					else
					begin
						cnt_wait <= 0;
						state <= S21;
					end
				end
				
				S21:
				begin
					// read  0x21(addr)  (value)
					if ( cnt==7'd0 && sclk==1'b1)
					begin
						cnt <= 7'd0;
						state <= state;
					end
					else if ( cnt != 7'd40 )
					begin
						state <= state;
						cnt <= cnt + 7'd1;
					end
					else
					begin
						state <= state + 5'd1;
						cnt <= 0;
					end
					
					if ( cnt == 7'd0 )
						sdo_reg <= 16'ha100;
					else if ( sclk == 1'b1 )
						sdo_reg <= ( sdo_reg<<1 );
					else
						sdo_reg <= sdo_reg;

					
					if ( sclk == 1'b1 )
						sdo <= sdo_reg[15];
						
					if ( ( cnt>=7'd1 ) && ( cnt<=7'd32 ) )
						cs <= 1'b0;
					else
						cs <= 1'b1;
				end
	
				S22:
				begin
					cs <= 1'b1;
					state <= state;
				end
					
	
				
				default : state <= S0;
				
			endcase
		end
	end


	
	
endmodule
