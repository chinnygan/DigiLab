`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2016 17:05:50
// Design Name: 
// Module Name: Processor_Wrapper_tb0
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


module Processor_Wrapper_tb0();

    reg CLK, RESET;
    
    wire IR;

    Processor_Wrapper uut ( 
                            .CLK(CLK),
                            .RESET(RESET),
                            .IR_LED(IR)
                            );
                            
    always forever begin 
        #5 CLK <= ~CLK;
    end
    
    initial begin
        CLK = 0;
        RESET = 1;
    end
    
    always begin
    
        
        #100
        RESET = 0;
    
        
        
    end
                            

endmodule
