`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Scott Postlethwaite
// s1231893
// Create Date: 04.02.2016 13:21:07
// Design Name: IR Transmitter
// Module Name: IRTransmitterMaster
// Project Name: Digital Systems Lab 4
// Target Devices: Baysys 3
// Description: Wrapper for IR_Transmitter SM will send a pulse to selected car every 100ms and displays selected car on 7 seg display
// 
// Dependencies: Seg7Decoder, NewCounter, IR_TransmitterSM
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IRTransmitterMaster(
    input CLK,
    input RESET,
    input BTN0,
    input BTN1,
    input BTN2,
    input BTN3,
    input MODE,  // MODE == 1: ALL DRIVE, MODE == 0: Car Select
    input CS1,   // Car selection 1
    input CS0,   // Car selection 0
    output IR_LED,
    output [7:0] HEX_OUT,
    output [3:0] SEG_SELECT_OUT
    );
    
    
    
    // A 10 Hz Generic Counter for generating packet trigger
    wire packetTrigger;
    wire BlueIR, RedIR, YellowIR, GreenIR;
    
    NewCounter #(.COUNT_MAX(10000000), .COUNT_WIDTH(24))
            PacketTriggerGen (      .CLK(CLK),
                                    .RESET(RESET),
                                    .ENABLE_IN(1'b1),
                                    .TRIGG_OUT(packetTrigger)
                                    );
                                 
                  
    
    
    // ALL DRIVE mode will drive all 4 kinds of cars at once               
                                 
     // A 40 Hz Generic Counter for generating packet trigger for "all drive" mode
    reg [1:0] AllState;
    reg AllBlue, AllRed, AllYellow, AllGreen;
    wire allPacketTrigger;
    
    NewCounter #(.COUNT_MAX(2500000), .COUNT_WIDTH(22))
            AllPacketTriggerGen (   .CLK(CLK),
                                    .RESET(RESET),
                                    .ENABLE_IN(1'b1),
                                    .TRIGG_OUT(allPacketTrigger)
                                    );
    
    
    
    // The all drive mode will cycle between all four state machines, giving each a 
    // 10Hz Frequency output using this state machine
    always@(posedge allPacketTrigger or posedge RESET) begin
        if(RESET) begin
                AllState <= 2'b00;
                AllBlue      <= 1'b0;
                AllRed       <= 1'b0;
                AllYellow    <= 1'b0;
                AllGreen     <= 1'b0;
        end
            else begin
            case(AllState)
                2'b00: begin
                           AllBlue      <= 1'b1;
                           AllRed       <= 1'b0;
                           AllYellow    <= 1'b0;
                           AllGreen     <= 1'b0;
                           
                           AllState     <= 2'b01;
                       end
                       
                2'b01: begin
                           AllBlue      <= 1'b0;
                           AllRed       <= 1'b1;
                           AllYellow    <= 1'b0;
                           AllGreen     <= 1'b0;
                           
                           AllState     <= 2'b10;
                       end
                       
                2'b10: begin
                           AllBlue      <= 1'b0;
                           AllRed       <= 1'b0;
                           AllYellow    <= 1'b1;
                           AllGreen     <= 1'b0;
                           
                           AllState     <= 2'b11;
                       end
                       
                2'b11: begin
                           AllBlue      <= 1'b0;
                           AllRed       <= 1'b0;
                           AllYellow    <= 1'b0;
                           AllGreen     <= 1'b1;
                           
                           AllState     <= 2'b00;
                       end
            endcase
        end          
    end          
    
    
                     
                                 
                                                                     
    // 4 states to accomodate for all car types
    reg BlueTrigger, RedTrigger, YellowTrigger, GreenTrigger;
    
    
    // SEND_PACKET trigger behaviour is only sent to selected state machine
    always@(posedge CLK) begin
        BlueTrigger     <= MODE ? AllBlue      : packetTrigger && ~CS1 && ~CS0;
        RedTrigger      <= MODE ? AllRed       : packetTrigger && ~CS1 &&  CS0;
        YellowTrigger   <= MODE ? AllYellow    : packetTrigger &&  CS1 && ~CS0;
        GreenTrigger    <= MODE ? AllGreen     : packetTrigger &&  CS1 &&  CS0;
    end
    
    //Instantiate state machine for 4 different cars
    IRTransmitterSM #(.StartBurstSize(191), .CarSelectBurstSize(47), .GapSize(25), .AssertBurstSize(47), .DeAssertBurstSize(22), .Frequency(36000))
                       BlueCar (    .RESET(RESET),
                                    .CLK(CLK),
                                    .COMMAND({BTN0, BTN1, BTN2, BTN3}),
                                    .SEND_PACKET(BlueTrigger),
                                    .IR_LED(BlueIR)
                                    );    
                                    
    IRTransmitterSM #(.StartBurstSize(192), .CarSelectBurstSize(24), .GapSize(24), .AssertBurstSize(48), .DeAssertBurstSize(24), .Frequency(36000))
                       RedCar (     .RESET(RESET),
                                    .CLK(CLK),
                                    .COMMAND({BTN0, BTN1, BTN2, BTN3}),
                                    .SEND_PACKET(RedTrigger),
                                    .IR_LED(RedIR)
                                    );
                                    
    IRTransmitterSM #(.StartBurstSize(88), .CarSelectBurstSize(22), .GapSize(40), .AssertBurstSize(44), .DeAssertBurstSize(22), .Frequency(40000))
                       YellowCar (  .RESET(RESET),
                                    .CLK(CLK),
                                    .COMMAND({BTN0, BTN1, BTN2, BTN3}),
                                    .SEND_PACKET(YellowTrigger),
                                    .IR_LED(YellowIR)
                                    );    
                                    
    IRTransmitterSM #(.StartBurstSize(88), .CarSelectBurstSize(44), .GapSize(40), .AssertBurstSize(44), .DeAssertBurstSize(22), .Frequency(37500))
                       GreenCar (   .RESET(RESET),
                                    .CLK(CLK),
                                    .COMMAND({BTN0, BTN1, BTN2, BTN3}),
                                    .SEND_PACKET(GreenTrigger),
                                    .IR_LED(GreenIR)
                                    );
    
    
    // Output selected based on car selection and mode  
    reg MuxOut;
                                  
    always@(BlueIR or RedIR or YellowIR or GreenIR) begin
        if(MODE) begin
            MuxOut <= BlueIR || RedIR || YellowIR || GreenIR;
        end
        else begin
            case({CS1, CS0})
                // BLue Out
                2'b00:  MuxOut <= BlueIR;
                // Red Out
                2'b01:  MuxOut <= RedIR;
                // Yellow Out
                2'b10:  MuxOut <= YellowIR;
                // Green Out
                2'b11:  MuxOut <= GreenIR;
             endcase
        end
    end
                                    
    assign IR_LED = MuxOut;     
    
    
    
    
    
    
    
    // 7 Segment display
    
    //16 bit Counter
     //Will send out a pulse on the trigger wire at a 1Khz Frequency
     wire bit16trig;
     
     NewCounter #(.COUNT_WIDTH(16),
                            .COUNT_MAX(999999)
                            )
                            Bit16 (
                            .CLK(CLK),
                            .RESET(1'b0),
                            .ENABLE_IN(1'b1),
                            .TRIGG_OUT(bit16trig)
                            );
    
    //2 bit counter
    //Controls which digit on the display is being written to
    wire [1:0] bit2count;
    
    NewCounter #(.COUNT_WIDTH(2),
                          .COUNT_MAX(3)
                          )
                          Bit2 (
                          .CLK(CLK),
                          .RESET(1'b0),
                          .ENABLE_IN(bit16trig),
                          .COUNT(bit2count)
                          );
    
    reg [3:0] SegIn;
    
    always@(posedge CLK) begin
        SegIn <= MODE ? 4'h5   : {2'b0, CS1, CS0};
    end                          
                              
    Seg7Decoder S7 (
                     .SEG_SELECT_IN(bit2count),
                     .BIN_IN(SegIn),
                     .DOT_IN(1'b1),
                     .SEG_SELECT_OUT(SEG_SELECT_OUT),
                     .HEX_OUT(HEX_OUT)
                     );                     
    
    
endmodule
