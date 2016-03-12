`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// s1231893
// Create Date:    11:25:23 10/15/2014 
// Design Name: IR Transmitter
// Module Name:    Seg7Decoder 
// Project Name: Digital Systems Lab
// Target Devices: Basysy 3
// Description: Decodes a number into a 7 segment display signal
//
// Dependencies: None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Seg7Decoder(
	input [1:0] SEG_SELECT_IN,
	input [3:0] BIN_IN,
	input DOT_IN,
	output reg [3:0] SEG_SELECT_OUT,
	output reg [7:0] HEX_OUT
    );
	 
	 
	 //Segment select case statement
	 always@(SEG_SELECT_IN) begin
		case(SEG_SELECT_IN)
			2'b00		: SEG_SELECT_OUT <= 4'b1110;
			2'b01		: SEG_SELECT_OUT <= 4'b1101;
			2'b10		: SEG_SELECT_OUT <= 4'b1011;
			2'b11		: SEG_SELECT_OUT <= 4'b0111;
			default	: SEG_SELECT_OUT <= 4'b1111;
		endcase
	 end
	
	
	//4 bit input to decoded 7 bit signal for display on LED
	always@(BIN_IN or DOT_IN) begin
		case (BIN_IN)
			4'h0		:	HEX_OUT[6:0] <= 7'b0000011;  // b
			4'h1		:	HEX_OUT[6:0] <= 7'b0101111;  // r
			4'h2		:	HEX_OUT[6:0] <= 7'b0010001;  // y
			4'h3		:	HEX_OUT[6:0] <= 7'b0010000;  // g
			
			4'h5		:	HEX_OUT[6:0] <= 7'b0001000;  // All mode 'A'
			
//			4'h4		:	HEX_OUT[6:0] <= 7'b0011001;
//			4'h5		:	HEX_OUT[6:0] <= 7'b0010010;
//			4'h6		:	HEX_OUT[6:0] <= 7'b0000010;
//			4'h7		:	HEX_OUT[6:0] <= 7'b1111000;
			
//			4'h8		:	HEX_OUT[6:0] <= 7'b0000000;
//			4'h9		:	HEX_OUT[6:0] <= 7'b0010000;
//			4'hA		:	HEX_OUT[6:0] <= 7'b0001000;
//			4'hB		:	HEX_OUT[6:0] <= 7'b0000011;
			
//			4'hC		:	HEX_OUT[6:0] <= 7'b1000110;
//			4'hD		:	HEX_OUT[6:0] <= 7'b0100001;
//			4'hE		:	HEX_OUT[6:0] <= 7'b0000110;
//			4'hF		:	HEX_OUT[6:0] <= 7'b0001110;
			
			default	:	HEX_OUT[6:0] <= 7'b1111111;
		endcase
		
		HEX_OUT[7] <= ~DOT_IN;
	 end
	 
	 
	/*Old 7Seg display decoder, for debugging purposes
	wire A, B, C, D;
	 
	 assign A = BIN_IN[1];
	 assign B = BIN_IN[0];
	 assign C = BIN_IN[3];
	 assign D = BIN_IN[2];
	 
	 
	 //7 Seg display assignments
	 assign HEX_OUT[0] = ((~A&B&~C&~D) | (~A&~B&~C&D) | (~A&B&C&D) | (A&B&C&~D));
	 assign HEX_OUT[1] = ((A&B&C) | (A&~B&D) | (~B&C&D) | (~A&B&~C&D));
	 assign HEX_OUT[2] = ((A&C&D) | (~B&C&D) | (A&~B&~C&~D));
	 assign HEX_OUT[3] = ((A&B&D) | (A&~B&C&~D) | (~A&B&~D) | (~A&~B&~C&D));
	 assign HEX_OUT[4] = ((B&~C) | (~A&~C&D) | (~A&B&~D));	 
	 assign HEX_OUT[5] = ((B&~C&~D) | (A&~C&~D) | (A&B&~C) | (~A&B&C&D));
	 assign HEX_OUT[6] = ((~A&~C&~D) | (~A&~B&C&D) | (A&B&~C&D));
	 assign HEX_OUT[7] = ~DOT_IN;
	*/


endmodule
