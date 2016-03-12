`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// s1231893
// Create Date: 16.02.2016 10:16:33
// Design Name: IR Transmitter
// Module Name: IRTransmitterSM_tb0
// Project Name: Digital Systems Lab 4
// Target Devices: Baysys 3
// Tool Versions: 
// Description: Tests for IR_TransmitterSM
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IRTransmitterSM_tb0();
    // Inputs
reg CLK;
reg RESET;
reg PACKET_ENABLE;
reg [3:0] COMM;

// Outputs
wire Next_IR;


   IRTransmitterSM
        uut     (       .RESET(RESET),
                        .CLK(CLK),
                        .COMMAND(COMM),
                        .SEND_PACKET(PACKET_ENABLE),
                        .IR_LED(Next_IR)
                        );

always forever begin 
    #5 CLK <= ~CLK;
end

initial begin
    RESET = 1;
    CLK = 0;
    PACKET_ENABLE = 0;
    COMM = 4'b0000;
end

always begin

    
    #100
    RESET =0;
    
    #50
    COMM = 4'b0010;
    
    #50
    PACKET_ENABLE = 1;
    
    #500;
    
    
end
endmodule
