`ifndef TABLAS_CODE_GROUPS  // Solo entra si TABLAS_CODE_GROUPS no está definido, evitar inclusión múltiple del archivo
    `define TABLAS_CODE_GROUPS  // Define TABLAS_CODE_GROUPS

    // --- Códigos Especiales en 8 y 10 bits (Current RD+) ---
    `define SPECIAL_CODE_K28_0_8B 8'h1C
    `define SPECIAL_CODE_K28_0_10B 10'b110000_1011

    `define SPECIAL_CODE_K28_1_8B 8'h3C
    `define SPECIAL_CODE_K28_1_10B 10'b110000_0110

    `define SPECIAL_CODE_K28_2_8B 8'h5C
    `define SPECIAL_CODE_K28_2_10B 10'b110000_1010

    `define SPECIAL_CODE_K28_3_8B 8'h7C
    `define SPECIAL_CODE_K28_3_10B 10'b110000_1100

    `define SPECIAL_CODE_K28_4_8B 8'h9C
    `define SPECIAL_CODE_K28_4_10B 10'b110000_1101

    `define SPECIAL_CODE_K28_5_8B 8'hBC  // /COMMA/
    `define SPECIAL_CODE_K28_5_10B 10'b110000_0101

    `define SPECIAL_CODE_K28_6_8B 8'hDC
    `define SPECIAL_CODE_K28_6_10B 10'b110000_1001

    `define SPECIAL_CODE_K28_7_8B 8'hFC
    `define SPECIAL_CODE_K28_7_10B 10'b110000_0111

    `define SPECIAL_CODE_K23_7_8B 8'hF7  // /R/
    `define SPECIAL_CODE_K23_7_10B 10'b000101_0111

    `define SPECIAL_CODE_K27_7_8B 8'hFB  // /S/
    `define SPECIAL_CODE_K27_7_10B 10'b001001_0111

    `define SPECIAL_CODE_K29_7_8B 8'hFD  // /T/
    `define SPECIAL_CODE_K29_7_10B 10'b010001_0111

    `define SPECIAL_CODE_K30_7_8B 8'hFE  // /V/
    `define SPECIAL_CODE_K30_7_10B 10'b100001_0111


   // --- Valid data code-groups: Códigos de Datos en 8 y 10 bits (Current RD+) ---
    `define DATA_CODE_D00_0_8B 8'h00
    `define DATA_CODE_D00_0_10B 10'b011000_1011  

    `define DATA_CODE_D01_0_8B 8'h01
    `define DATA_CODE_D01_0_10B 10'b100010_1011 

    `define DATA_CODE_D02_0_8B 8'h02
    `define DATA_CODE_D02_0_10B 10'b010010_1011

    `define DATA_CODE_D03_0_8B 8'h03
    `define DATA_CODE_D03_0_10B 10'b110001_0100  

    `define DATA_CODE_D02_2_8B 8'h42
    `define DATA_CODE_D02_2_10B 10'b010010_0101

    `define DATA_CODE_D16_2_8B 8'h50
    `define DATA_CODE_D16_2_10B 10'b100100_0101 

    `define DATA_CODE_D26_4_8B 8'h9A
    `define DATA_CODE_D26_4_10B 10'b010110_0010  

    `define DATA_CODE_D06_5_8B 8'hA6
    `define DATA_CODE_D06_5_10B 10'b011001_1010 

    `define DATA_CODE_D21_5_8B 8'hB5
    `define DATA_CODE_D21_5_10B 10'b10_1010_1010  

    `define DATA_CODE_D05_6_8B 8'hC5
    `define DATA_CODE_D05_6_10B 10'b101001_0110  

`endif // Fin de la guarda de inclusión