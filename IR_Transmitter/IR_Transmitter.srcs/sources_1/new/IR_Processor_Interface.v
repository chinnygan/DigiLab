`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2016 00:42:11
// Design Name: 
// Module Name: IR_Processor_Interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IR_Processor_Interface(
    input CLK,
    input RESET,
    input [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    output IR_LED
    );
    
    // Base address of IR data in RAM, we only have to worry about 1!
    parameter [7:0] IRBaseAddr = 8'h90;
    parameter [7:0] InitialIR = 8'h00;
    
    reg [7:0] COMMAND;
    
    always@(posedge CLK) 
    begin
        if(RESET)
            COMMAND <= InitialIR;
        else if((BUS_ADDR == IRBaseAddr) & BUS_WE)
            COMMAND <= BUS_DATA;
    end
    
    
    IRTransmitterMaster IR (
                                .CLK(CLK),
                                .RESET(RESET),
                                .BTN0(COMMAND[0]),
                                .BTN1(COMMAND[1]),
                                .BTN2(COMMAND[2]),
                                .BTN3(COMMAND[3]),
                                .MODE(1'b1),  // MODE == 1: ALL DRIVE, MODE == 0: Car Select
                                .CS1(COMMAND[6]),   // Car selection 1
                                .CS0(COMMAND[5]),   // Car selection 0
                                .IR_LED(IR_LED)
                                );
    
    
endmodule
