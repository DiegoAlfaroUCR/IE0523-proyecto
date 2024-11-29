`ifndef TABLAS_CODE_GROUPS  // Solo entra si TABLAS_CODE_GROUPS no está definido, evitar inclusión múltiple del archivo
    `define TABLAS_CODE_GROUPS  // Define TABLAS_CODE_GROUPS

    // --- Códigos Especiales en 8 y 10 bits (Current RD+) ---
    `define SPECIAL_CODE_K28_0_8B 8'h1C
    `define SPECIAL_CODE_K28_0_10B 10'b11_0000_1011

    `define SPECIAL_CODE_K28_1_8B 8'h3C
    `define SPECIAL_CODE_K28_1_10B 10'b11_0000_0110

    `define SPECIAL_CODE_K28_2_8B 8'h5C
    `define SPECIAL_CODE_K28_2_10B 10'b11_0000_1010

    `define SPECIAL_CODE_K28_3_8B 8'h7C
    `define SPECIAL_CODE_K28_3_10B 10'b11_0000_1100

    `define SPECIAL_CODE_K28_4_8B 8'h9C
    `define SPECIAL_CODE_K28_4_10B 10'b11_0000_1101

    `define SPECIAL_CODE_K28_5_8B 8'hBC  // /COMMA/
    `define SPECIAL_CODE_K28_5_10B 10'b11_0000_0101

    `define SPECIAL_CODE_K28_6_8B 8'hDC
    `define SPECIAL_CODE_K28_6_10B 10'b11_0000_1001

    `define SPECIAL_CODE_K28_7_8B 8'hFC
    `define SPECIAL_CODE_K28_7_10B 10'b11_0000_0111

    `define SPECIAL_CODE_K23_7_8B 8'hF7  // /R/
    `define SPECIAL_CODE_K23_7_10B 10'b00_0101_0111

    `define SPECIAL_CODE_K27_7_8B 8'hFB  // /S/
    `define SPECIAL_CODE_K27_7_10B 10'b00_1001_0111

    `define SPECIAL_CODE_K29_7_8B 8'hFD  // /T/
    `define SPECIAL_CODE_K29_7_10B 10'b01_0001_0111

    `define SPECIAL_CODE_K30_7_8B 8'hFE  // /V/
    `define SPECIAL_CODE_K30_7_10B 10'b10_0001_0111


   // --- Valid data code-groups: Códigos de Datos en 8 y 10 bits (Current RD-) ---, el primer /I/ tiene disparidad negativa,
    `define DATA_CODE_D00_0_8B 8'h00
    `define DATA_CODE_D00_0_10B 10'b10_0111_0100  

    `define DATA_CODE_D01_0_8B 8'h01
    `define DATA_CODE_D01_0_10B 10'b01_1101_0100 

    `define DATA_CODE_D02_0_8B 8'h02
    `define DATA_CODE_D02_0_10B 10'b10_1101_0100  

    `define DATA_CODE_D02_2_8B 8'h42
    `define DATA_CODE_D02_2_10B 10'b10_1101_0101 


    `define DATA_CODE_D03_0_8B 8'h03
    `define DATA_CODE_D03_0_10B 10'b11_0001_1011  

    `define DATA_CODE_D16_2_8B 8'h50
    `define DATA_CODE_D16_2_10B 10'b01_1011_0101 

    `define DATA_CODE_D26_4_8B 8'h9A
    `define DATA_CODE_D26_4_10B 10'b01_0110_1101  

    `define DATA_CODE_D06_5_8B 8'hA6
    `define DATA_CODE_D06_5_10B 10'b01_1001_1010  

    `define DATA_CODE_D21_5_8B 8'hB5
    `define DATA_CODE_D21_5_10B 10'b10_1010_1010  

    `define DATA_CODE_D05_6_8B 8'hC5
    `define DATA_CODE_D05_6_10B 10'b10_1001_0110  
`endif // Fin de la guarda de inclusión