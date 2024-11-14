`include "code_grups.v"

module Receive (
    input clk,
    input reset,
    input sync_status,
    input [9:0] SUDI,
    output reg RX_DV,
    output reg [7:0] RXD
);

    localparam LINK_FAILED  = 8'b00000001;
    localparam WAIT_K       = 8'b00000010;
    localparam RX_K         = 8'b00000100;
    localparam IDLE_D       = 8'b00001000;
    localparam START_PACKET = 8'b00010000;
    localparam RECEIVE      = 8'b00100000;
    localparam RX_DATA      = 8'b01000000;
    localparam TRI_RR       = 8'b10000000;

    reg [7:0] current_state, next_state;
    reg receiving;

function [9:0] D;
   input [9:0] SUDI; 
   case(SUDI)
    b10_D0_0:  D = b10_D0_0;    
    b10_D1_0:  D = b10_D1_0;   
    b10_D2_0:  D = b10_D2_0;  
    b10_D3_0:  D = b10_D3_0;  
    b10_D4_0:  D = b10_D4_0;  
    b10_D5_0:  D = b10_D5_0;    
    b10_D6_0:  D = b10_D6_0;   
    b10_D7_0:  D = b10_D7_0;  
    b10_D8_0:  D = b10_D8_0;      
    b10_D9_0:  D = b10_D9_0;  
    b10_K28_0: D = b10_K28_0; 
    b10_K28_1: D = b10_K28_1; 
    b10_K28_2: D = b10_K28_2; 
    b10_K28_3: D = b10_K28_3; 
    b10_K28_4: D = b10_K28_4; 
    b10_K28_5: D = b10_K28_5; 
    b10_K28_6: D = b10_K28_6;      
    b10_K28_7: D = b10_K28_7;
    b10_K23_7: D = b10_K23_7;
    b10_K27_7: D = b10_K27_7;
    b10_K29_7: D = b10_K29_7; 
    b10_K30_7: D = b10_K30_7;
   endcase
endfunction


always @(posedge clk ) begin
    if (reset)
        current_state <= LINK_FAILED;
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    case (current_state)
        LINK_FAILED: begin 
            if (sync_status) 
                next_state = WAIT_K;
        end
        WAIT_K: begin 
            if (SUDI == K28_5)
                next_state = RX_K;
            else
                next_state = WAIT_K;
        end
        RX_K: begin 
            if (SUDI == D(SUDI))
                next_state = IDLE_D;
            else begin 
                next_state = RX_K;
            end
        end
        IDLE_D: begin
            if (SUDI == b10_K28_5)
                next_state = RX_K;
            else if (SUDI) begin
                next_state = START_OF_PACKET;
            end
            else 
                next_state = IDLE_D;
        end
        START_PACKET: begin
            RX_DV = 1'b1;
            RXD = 8'b01010101;
            next_state = RECEIVE;
        end
        RECEIVE: begin 



        end

        TRI_RR: begin
            RX_DV = 1'b0;
            RXD = 8'b00001111;
            next_state = RX_K;
        end


        default:
            next_state = LINK_FAILED;
    endcase
end




endmodule