`include "tablas.v"

module IdentPUDI (
    input [9:0] PUDI,
    output reg PUDI_COMMA, PUDI_D, PUDI_INVALID);

    always @(*) begin
        // Valores por defecto
        PUDI_COMMA   = 1'b0;
        PUDI_D       = 1'b0;
        PUDI_INVALID = 1'b0;

        case (PUDI)
            10'b0000000000: PUDI_D = 1'b1;
            // SPECIAL_CODE_K28_0_10B : 
            default: PUDI_INVALID = 1'b1;
        endcase
    end

endmodule
