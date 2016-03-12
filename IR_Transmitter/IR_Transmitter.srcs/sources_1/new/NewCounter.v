`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// 
// Create Date:    10:37:28 10/22/2014 
// Design Name: 
// Module Name:    NewCounter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Counts up by one every clock cycle until the value of COUNT_MAX is reached.
//		Then sends out trigger pulse on TRIGG_OUT and resets the counter to 0.
//		COUNT_WIDTH is the number of bits used to store COUNT_MAX.
//
// Dependencies: None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NewCounter(
		CLK,
		RESET,
		ENABLE_IN,
		TRIGG_OUT,
		COUNT
    );
	 
	 parameter COUNT_WIDTH = 4;
	 parameter COUNT_MAX = 9;
	 
	 
	 input CLK;
	 input RESET;
	 input ENABLE_IN;
	 output TRIGG_OUT;
	 output [COUNT_WIDTH-1:0] COUNT;
	 
	 //Declare the register that holds the Trigger_out signal between clock signals
	 reg [COUNT_WIDTH-1:0] Counter;
	 reg TriggerOut;
	 
	 //Synchronous Counter Logic
	 always@(posedge CLK) begin
		if (RESET)
			Counter <= 0;
		else begin
			if (ENABLE_IN) begin
				if (Counter == COUNT_MAX)
					Counter <= 0;
				else
					Counter <= Counter + 1;
				end
			end
		end
		
	 //TriggerOut Logic
	 always@(posedge CLK) begin
		if (RESET)
			TriggerOut <= 0;
		else begin
			if (ENABLE_IN && (Counter == COUNT_MAX))
				TriggerOut <= 1;
			else
				TriggerOut <= 0;
		end
	 end
	 
	 assign COUNT = Counter;
	 assign TRIGG_OUT = TriggerOut;


endmodule
