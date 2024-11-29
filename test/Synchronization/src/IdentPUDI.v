/**
 * Archivo: IdentPUDI.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo IdentPUDI
 *
 * Versión: 1
 * Fecha: //2024
 *
 * Copyright (c) 2024 Diego Alfaro Segura
 * MIT License
 */

`include "src/tablas.v"

module IdentPUDI (
    input [9:0] PUDI,
    output reg PUDI_COMMA, PUDI_D, PUDI_INVALID);

    always @(*) begin
        // Valores por defecto
        PUDI_COMMA   = 1'b0;
        PUDI_D       = 1'b0;
        PUDI_INVALID = 1'b0;

        // Se buscan los caracteres en ambas RD.
        case (PUDI)
            /* Caracteres especiales */
            // K28.0
            `SPECIAL_CODE_K28_0_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K28_0_10B: PUDI_INVALID = 1'b0;

            // K28.1 (COMMA)
            `SPECIAL_CODE_K28_1_10B:  PUDI_COMMA = 1'b1;
            ~`SPECIAL_CODE_K28_1_10B: PUDI_COMMA = 1'b1;

            // K28.2
            `SPECIAL_CODE_K28_2_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K28_2_10B: PUDI_INVALID = 1'b0;

            // K28.3
            `SPECIAL_CODE_K28_3_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K28_3_10B: PUDI_INVALID = 1'b0;

            // K28.4
            `SPECIAL_CODE_K28_4_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K28_4_10B: PUDI_INVALID = 1'b0;

            // K28.5 (COMMA)
            `SPECIAL_CODE_K28_5_10B:  PUDI_COMMA = 1'b1;
            ~`SPECIAL_CODE_K28_5_10B: PUDI_COMMA = 1'b1;

            // K28.6
            `SPECIAL_CODE_K28_6_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K28_6_10B: PUDI_INVALID = 1'b0;

            // K28.7
            `SPECIAL_CODE_K28_7_10B:  PUDI_COMMA = 1'b1;
            ~`SPECIAL_CODE_K28_7_10B: PUDI_COMMA = 1'b1;

            // K23.7
            `SPECIAL_CODE_K23_7_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K23_7_10B: PUDI_INVALID = 1'b0;

            // K27.7
            `SPECIAL_CODE_K27_7_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K27_7_10B: PUDI_INVALID = 1'b0;

            // K29.7
            `SPECIAL_CODE_K29_7_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K29_7_10B: PUDI_INVALID = 1'b0;

            // K30.7
            `SPECIAL_CODE_K30_7_10B:  PUDI_INVALID = 1'b0;
            ~`SPECIAL_CODE_K30_7_10B: PUDI_INVALID = 1'b0;

            /* Caracteres de data */
            // D0.0
            `DATA_CODE_D00_0_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D00_0_10B: PUDI_D = 1'b1;

            // D1.0
            `DATA_CODE_D01_0_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D01_0_10B: PUDI_D = 1'b1;

            // D2.0
            `DATA_CODE_D02_0_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D02_0_10B: PUDI_D = 1'b1;

            // D3.0
            `DATA_CODE_D03_0_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D03_0_10B: PUDI_D = 1'b1;

            // D2.2
            `DATA_CODE_D02_2_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D02_2_10B: PUDI_D = 1'b1;

            // D16.2
            `DATA_CODE_D16_2_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D16_2_10B: PUDI_D = 1'b1;

            // D26.4
            `DATA_CODE_D26_4_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D26_4_10B: PUDI_D = 1'b1;

            // D6.5
            `DATA_CODE_D06_5_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D06_5_10B: PUDI_D = 1'b1;

            // D21.5
            `DATA_CODE_D21_5_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D21_5_10B: PUDI_D = 1'b1;

            // D5.6
            `DATA_CODE_D05_6_10B:  PUDI_D = 1'b1;
            ~`DATA_CODE_D05_6_10B: PUDI_D = 1'b1;

            default: PUDI_INVALID = 1'b1;
        endcase
    end

endmodule
