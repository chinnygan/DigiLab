`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// s1231893
// Create Date: 04.02.2016 15:24:12
// Design Name: IR Transmitter
// Module Name: IRTransmitterMaster
// Project Name: Digital Systems Lab 4
// Target Devices: Baysys 3
// Dependencies: IRTransmitterMaster/*
// 
// Testbench for entire system
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module IRTransmitterMaster_tb0(

    );
    
    // Inputs
    reg CLK;
    reg RESET;
    reg B0, B1, B2, B3;
    reg CS1, CS0, MODE;
    
    // Outputs
    wire IR_LED;
    
    // Unit under test
    IRTransmitterMaster uut (   .CLK(CLK),
                                .RESET(RESET),
                                .BTN0(B0),
                                .BTN1(B1),
                                .BTN2(B2),
                                .BTN3(B3),
                                .MODE(MODE),
                                .CS1(CS1),
                                .CS0(CS0),
                                .IR_LED(IR_LED)
                                );
                                
always forever begin 
    #5 CLK <= ~CLK;
end

initial begin
    RESET = 1;
    CLK = 0;
    B0 = 0;
    B1 = 0;
    B2 = 0;
    B3 = 0;
    
    CS1 = 0;
    CS0 = 0;
    MODE = 0;
end

always begin

    
    #100
    RESET =0;

    
    #500;
    B2 = 1;
    B3 = 1;
    
    
end
    
endmodule