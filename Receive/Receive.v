`include "tablas.v"

module Receive (
    input clk,
    input reset,
    input sync_status,
    input [10:0] SUDI,
    output reg RX_DV,
    output reg RX_ER,
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

    localparam check_end_code = {`SPECIAL_CODE_K29_7_10B ,`SPECIAL_CODE_K23_7_10B ,`SPECIAL_CODE_K28_5_10B};

    wire [9:0] SUDI_RX_Code;
    wire RX_even;

    assign SUDI_RX_Code = SUDI[10:1];
    assign RX_even = SUDI[0];

    // Registro de desplazamiento para las últimas tres señales
    reg [9:0] last_three_codes[2:0];
    reg [7:0] current_state, next_state;
    reg receiving = 1'b1; // inicia en TRUE

always @(posedge clk ) begin
    if (reset)begin
        current_state <= LINK_FAILED;
        last_three_codes[0] <= 10'b0;
        last_three_codes[1] <= 10'b0;
        last_three_codes[2] <= 10'b0;
    end
    else begin
        current_state <= next_state;
        if (current_state == RECEIVE) begin
            // Desplazar y capturar la nueva señal en el registro de desplazamiento
            last_three_codes[2] <= last_three_codes[1];
            last_three_codes[1] <= last_three_codes[0];
            last_three_codes[0] <= SUDI_RX_Code;
        end
    end
end

always @(*) begin

    RX_DV = 1'b0;
    RXD = 8'b0;
    next_state = current_state;
    case (current_state)
        LINK_FAILED: begin 
            if (receiving) begin  
                receiving = 1'b1;
                RX_ER = 1'b1;
            end
            else begin
                RX_DV = 1'b0;
                RX_ER = 1'b0;
            end
            next_state = WAIT_K;
        end
        WAIT_K: begin 
            receiving = 1'b0;
            if (SUDI_RX_Code == `SPECIAL_CODE_K28_5_10B && RX_even)
                next_state = RX_K;
            else
                next_state = WAIT_K;
        end
        RX_K: begin 
            if (SUDI_RX_Code != `DATA_CODE_D02_2_10B && SUDI_RX_Code == `DATA_CODE_D21_5_10B)
                next_state = IDLE_D;
            else begin 
                next_state = RX_K;
            end
        end
        IDLE_D: begin
            if (SUDI_RX_Code == `SPECIAL_CODE_K28_5_10B)
                next_state = RX_K;
            else 
                next_state = START_PACKET;
        end
        START_PACKET: begin
            RX_DV = 1'b1;
            RXD = 8'b01010101;
            next_state = RECEIVE;
        end
        RECEIVE: begin  // FAlTA implementar la decoficicacion
            if (check_end == check_end_code)
                next_state = TRI_RR;
        end

        TRI_RR: begin
            next_state = RX_K;
        end
        default:
            next_state = LINK_FAILED;
    endcase
end




endmodule