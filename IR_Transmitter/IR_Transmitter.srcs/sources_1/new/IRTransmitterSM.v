`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// s1231893
// Create Date: 01.02.2016 19:38:17
// Design Name: IR Transmitter
// Module Name: IRTransmitterSM
// Design Name: IR Transmitter
// Module Name: IRTransmitterMaster
// Project Name: Digital Systems Lab 4
// Target Devices: Baysys 3
// Description: Sends out a packet of data at the specified frequency whenever an SEND_PACKET is sent
// 
// Dependencies: NewCounter
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IRTransmitterSM(
    //Standard Signals
    input RESET,
    input CLK,
    // Bus Interface Signals
    input [3:0] COMMAND,
    input SEND_PACKET,
    // IF LED signal
    output IR_LED
    );
    
    //Default Parameters set for Red Car
    parameter StartBurstSize = 192;
    parameter CarSelectBurstSize = 24;
    parameter GapSize = 24;
    parameter AssertBurstSize = 48;
    parameter DeAssertBurstSize = 24;
    parameter Frequency = 36000;
    
/*
Generate the pulse signal here from the main clock running at 50MHz to generate the right frequency for
the car in question e.g. 40KHz for BLUE coded cars
*/

// Create Generic counter with double desired frequency to toggle another register on and off
// That register will be the desired frequency

    wire pulseTrig;
    reg pulseGen;

    NewCounter #(.COUNT_MAX(50000000 / Frequency), .COUNT_WIDTH(11))
            PulseGen (      .CLK(CLK),
                                    .RESET(RESET),
                                    .ENABLE_IN(1'b1),
                                    .TRIGG_OUT(pulseTrig)
                                    );
                                    
    always@(posedge CLK)
        if (RESET) begin
            pulseGen <= 1'b0;
        end
        else if (pulseTrig) begin
            pulseGen <= !pulseGen;
        end
        
    

/*
Simple state machine to generate the states of the packet i.e. Start, Gaps, Right Assert or De-Assert, Left
Assert or De-Assert, Backward Assert or De-Assert, and Forward Assert or De-Assert
*/

    //  Start, Gap, CarSelect values are constant, no need to be assigned like this
        
    reg [7:0] CurrRight, NextRight;
    reg [7:0] CurrLeft, NextLeft;
    reg [7:0] CurrBwd, NextBwd;
    reg [7:0] CurrFwd, NextFwd;

    always@(posedge CLK) begin 
        
        CurrRight   <=  NextRight;
        CurrLeft    <=  NextLeft;
        CurrBwd     <=  NextBwd;
        CurrFwd     <=  NextFwd;
    end
    
    always@(COMMAND) begin
        if(RESET) begin
            NextRight   <=  DeAssertBurstSize;
            NextLeft    <=  DeAssertBurstSize;
            NextBwd     <=  DeAssertBurstSize;
            NextFwd     <=  DeAssertBurstSize;
        end
        else begin
            //Here is where the Command order is defined
            NextRight   <=    COMMAND[0] ? AssertBurstSize : DeAssertBurstSize;
            NextLeft    <=    COMMAND[1] ? AssertBurstSize : DeAssertBurstSize;
            NextBwd     <=    COMMAND[2] ? AssertBurstSize : DeAssertBurstSize;
            NextFwd     <=    COMMAND[3] ? AssertBurstSize : DeAssertBurstSize;
        end
    end



// Finally, tie the pulse generator with the packet state to generate IR_LED

    reg [3:0] PacketState;
    reg [7:0] Count;
    reg IR_Out, Next_IR;
    
    
    // Packet State Machine
    // Cycles through each packet state and counts up at each frequency pulse until the desired count is reached
    // The signal will be high in a non-gap state and low in gap and end states
    // Will stay in end state until reset or another Send_packet signal is sent
    always@(posedge pulseGen or posedge SEND_PACKET or posedge RESET) begin 
    
        IR_Out <= Next_IR;
        

        if(SEND_PACKET || RESET) begin // SEND_PACKET will set up the packet state machine
            PacketState     <=  4'b0000;
            Count           <=  8'd0;
        end
        else begin
        
        case(PacketState)
            // Start
            4'b0000 :   begin
                            if(Count < StartBurstSize - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b0001;
                            end
                        end
            // Gap1
            4'b0001 :   begin
                            if(Count < GapSize - 1) begin
                                Next_IR      <= 0;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  1;
                                Count       <=  0;
                                PacketState <=  4'b0010;
                            end
                        end
            // CarSelect
            4'b0010 :   begin
                            if(Count < CarSelectBurstSize - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b0011;
                            end
                        end                        
             // Gap2
            4'b0011 :   begin
                            if(Count < GapSize - 1) begin
                                Next_IR      <= 0;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  1;
                                Count       <=  0;
                                PacketState <=  4'b0100;
                            end
                        end
            // Right
            4'b0100 :   begin
                            if(Count < CurrRight - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b0101;
                            end
                        end                        
            // Gap3
            4'b0101 :   begin
                            if(Count < GapSize - 1) begin
                                Next_IR      <= 0;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  1;
                                Count       <=  0;
                                PacketState <=  4'b0110;
                            end
                        end
            // Left
            4'b0110 :   begin
                            if(Count < CurrLeft - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b0111;
                            end
                        end                                                
            // Gap4
            4'b0111 :   begin
                            if(Count < GapSize - 1) begin
                               Next_IR      <= 0;
                               Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  1;
                                Count       <=  0;
                                PacketState <=  4'b1000;
                            end
                        end
            // Back
            4'b1000 :   begin
                            if(Count < CurrBwd - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b1001;
                            end
                        end
             // Gap5
            4'b1001 :   begin
                            if(Count < GapSize - 1) begin
                                Next_IR      <= 0;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  1;
                                Count       <=  0;
                                PacketState <=  4'b1010;
                            end
                        end
            // Forward
            4'b1010 :   begin
                            if(Count < CurrFwd - 1) begin
                                Next_IR      <= 1;
                                Count       <= Count + 1;
                            end
                            else begin
                                Next_IR      <=  0;
                                Count       <=  0;
                                PacketState <=  4'b1011;
                            end
                        end
                        
           // End state
           4'b1011 :   begin
                               Next_IR      <=  0;
                       end
        endcase
        
        end
    end

    // Finally and generated pulse with the correct frequency
    assign IR_LED = IR_Out && pulseGen;

endmodule
