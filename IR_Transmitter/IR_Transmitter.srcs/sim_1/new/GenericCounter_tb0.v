`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2016 15:25:59
// Design Name: 
// Module Name: GenericCounter_tb0
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


module GenericCounter_tb0 ();
    // Inputs
    reg CLK;
    reg RESET;
    
    // Outputs
    wire Trigg_out;
    wire [3:0] CountOut;
    
    
       NewCounter
            uut     (       .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE_IN(1'b1),
                            .TRIGG_OUT(Trigg_out),
                            .COUNT(CountOut)
                            );
    
    always forever begin 
        #20 CLK <= ~CLK;
    end
    
    initial begin
        RESET = 1;
        CLK = 0;
    end
    
    always begin
 
        
        #100
        RESET =0;
        
        #500;
        
        
    end
    
    

    
endmodule
