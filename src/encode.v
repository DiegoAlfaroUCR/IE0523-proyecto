`include "tablas.v"
// Generar el ENCODE donde se pasan de 8B/10B y se calcula la disparidad.
module ENCODE1 (
    input [7:0] code_group_8b_recibido,
    input wire running_disparity,
    input wire [3:0] contador,nxt_contador;
    output reg [9:0] code_group_10b,
    output reg new_running_disparity
);


// Este módulo codifica un código de grupo de 8 bits en un código de grupo de 10 bits.
module ENCODE2 (
    input [7:0] code_group_8b_recibido,  // Entrada de 8 bits
    output reg [9:0] code_group_10b      // Salida de 10 bits
);

    always @(code_group_8b_recibido) begin
        // Códigos de datos válidos
        if (code_group_8b_recibido == `DATA_CODE_D00_0_8B)
            code_group_10b = `DATA_CODE_D00_0_10B; // D0.0
        else if (code_group_8b_recibido == `DATA_CODE_D01_0_8B)
            code_group_10b = `DATA_CODE_D01_0_10B; // D1.0
        else if (code_group_8b_recibido == `DATA_CODE_D02_0_8B)
            code_group_10b = `DATA_CODE_D02_0_10B; // D2.0
        else if (code_group_8b_recibido == `DATA_CODE_D03_0_8B)
            code_group_10b = `DATA_CODE_D03_0_10B; // D3.0
        else if (code_group_8b_recibido == `DATA_CODE_D02_2_8B)
            code_group_10b = `DATA_CODE_D02_2_10B; // D2.2
        else if (code_group_8b_recibido == `DATA_CODE_D16_2_8B)
            code_group_10b = `DATA_CODE_D16_2_10B; // D16.2
        else if (code_group_8b_recibido == `DATA_CODE_D26_4_8B)
            code_group_10b = `DATA_CODE_D26_4_10B; // D26.4
        else if (code_group_8b_recibido == `DATA_CODE_D06_5_8B)
            code_group_10b = `DATA_CODE_D06_5_10B; // D6.5
        else if (code_group_8b_recibido == `DATA_CODE_D21_5_8B)
            code_group_10b = `DATA_CODE_D21_5_10B; // D21.5
        else if (code_group_8b_recibido == `DATA_CODE_D05_6_8B)
            code_group_10b = `DATA_CODE_D05_6_10B; // D05.6

        // Códigos especiales
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_0_8B)
            code_group_10b = `SPECIAL_CODE_K28_0_10B; // K28.0
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_1_8B)
            code_group_10b = `SPECIAL_CODE_K28_1_10B; // K28.1
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_2_8B)
            code_group_10b = `SPECIAL_CODE_K28_2_10B; // K28.2
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_3_8B)
            code_group_10b = `SPECIAL_CODE_K28_3_10B; // K28.3
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_4_8B)
            code_group_10b = `SPECIAL_CODE_K28_4_10B; // K28.4
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_5_8B)
            code_group_10b = `SPECIAL_CODE_K28_5_10B; // K28.5
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_6_8B)
            code_group_10b = `SPECIAL_CODE_K28_6_10B; // K28.6
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_7_8B)
            code_group_10b = `SPECIAL_CODE_K28_7_10B; // K28.7
        else if (code_group_8b_recibido == `SPECIAL_CODE_K23_7_8B)
            code_group_10b = `SPECIAL_CODE_K23_7_10B; // K23.7 /R/
        else if (code_group_8b_recibido == `SPECIAL_CODE_K27_7_8B)
            code_group_10b = `SPECIAL_CODE_K27_7_10B; // K27.7 /S/
        else if (code_group_8b_recibido == `SPECIAL_CODE_K30_7_8B)
            code_group_10b = `SPECIAL_CODE_K30_7_10B; // K30.7 /V/
    end
endmodule