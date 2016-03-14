`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2016 16:23:19
// Design Name: 
// Module Name: Processor_Wrapper
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


module Processor_Wrapper(
    //Standard Signals
    input CLK,
    input RESET,
    output IR_LED
    );
    
    wire [7:0] ROM_DATA, ROM_ADDRESS, BUS_DATA, BUS_ADDR;
    wire [1:0] BUS_INTERRUPTS_RAISE, BUS_INTERRUPTS_ACK;
    
    assign BUS_INTERRUPTS_RAISE[1] = 1'b0;
    
    Processor Proc (            .CLK(CLK),
                                .RESET(RESET),
                                // RAM
                                .BUS_DATA(BUS_DATA),
                                .BUS_ADDR(BUS_ADDR),
                                .BUS_WE(BUS_WE),
                                // ROM
                                .ROM_ADDRESS(ROM_ADDRESS),
                                .ROM_DATA(ROM_DATA),
                                // INTERRUPT signals
                                .BUS_INTERRUPTS_RAISE(BUS_INTERRUPTS_RAISE),
                                .BUS_INTERRUPTS_ACK(BUS_INTERRUPTS_ACK)
                                );
            
    ROM Rom (                   .CLK(CLK),
                                //BUS signals
                                .DATA(ROM_DATA),
                                .ADDR(ROM_ADDRESS)
                                );
                                
    RAM Ram (                    //standard signals
                                .CLK(CLK),
                                  //BUS signals
                                .BUS_DATA(BUS_DATA),
                                .BUS_ADDR(BUS_ADDR),
                                .BUS_WE(BUS_WE)
                                );
                                
    Timer Time (                //standard signals
                                .CLK(CLK),
                                .RESET(RESET),
                                //BUS signals
                                .BUS_DATA(BUS_DATA),
                                .BUS_ADDR(BUS_ADDR),
                                .BUS_WE(BUS_WE),
                                .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[0]),
                                .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[0])
                                
                                );
                        
    IR_Processor_Interface IR (
                                .CLK(CLK),
                                .RESET(RESET),
                                .BUS_DATA(BUS_DATA),
                                .BUS_ADDR(BUS_ADDR),
                                .BUS_WE(BUS_WE),
                                .IR_LED(IR_LED)
                                );
                         
    
    
endmodule
