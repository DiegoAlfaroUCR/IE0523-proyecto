`ifndef TABLAS_CODE_GROUPS  // Solo entra si TABLAS_CODE_GROUPS no está definido, evitar inclusión múltiple del archivo
    `define TABLAS_CODE_GROUPS  // Define TABLAS_CODE_GROUPS

    // --- Códigos Especiales en 8 y 10 bits (Current RD+) ---
    // K28.0
    `define SPECIAL_CODE_K28_0_8B 8'h1C  // Decimal: 28, Negado: 227
    `define SPECIAL_CODE_K28_0_10B 10'b110000_1011  // Decimal: 779, Negado: 244

    // K28.1
    `define SPECIAL_CODE_K28_1_8B 8'h3C  // Decimal: 60, Negado: 195
    `define SPECIAL_CODE_K28_1_10B 10'b110000_0110  // Decimal: 774, Negado: 249

    // K28.2
    `define SPECIAL_CODE_K28_2_8B 8'h5C  // Decimal: 92, Negado: 163
    `define SPECIAL_CODE_K28_2_10B 10'b110000_1010  // Decimal: 778, Negado: 245

    // K28.3
    `define SPECIAL_CODE_K28_3_8B 8'h7C  // Decimal: 124, Negado: 131
    `define SPECIAL_CODE_K28_3_10B 10'b110000_1100  // Decimal: 780, Negado: 243

    // K28.4
    `define SPECIAL_CODE_K28_4_8B 8'h9C  // Decimal: 156, Negado: 99
    `define SPECIAL_CODE_K28_4_10B 10'b110000_1101  // Decimal: 781, Negado: 242

    // K28.5 /I/ (Idle or Comma)
    `define SPECIAL_CODE_K28_5_8B 8'hBC  // Decimal: 188, Negado: 67
    `define SPECIAL_CODE_K28_5_10B 10'b110000_0101  // Decimal: 773, Negado: 250

    // K28.6
    `define SPECIAL_CODE_K28_6_8B 8'hDC  // Decimal: 220, Negado: 35
    `define SPECIAL_CODE_K28_6_10B 10'b110000_1001  // Decimal: 777, Negado: 246

    // K28.7
    `define SPECIAL_CODE_K28_7_8B 8'hFC  // Decimal: 252, Negado: 3
    `define SPECIAL_CODE_K28_7_10B 10'b110000_0111  // Decimal: 775, Negado: 248

    // K23.7 /R/ (Reserved)
    `define SPECIAL_CODE_K23_7_8B 8'hF7  // Decimal: 247, Negado: 8
    `define SPECIAL_CODE_K23_7_10B 10'b000101_0111  // Decimal: 87, Negado: 936

    // K27.7 /S/ (Start-of-frame delimiter)
    `define SPECIAL_CODE_K27_7_8B 8'hFB  // Decimal: 251, Negado: 4
    `define SPECIAL_CODE_K27_7_10B 10'b001001_0111  // Decimal: 151, Negado: 872

    // K29.7 /T/ (End-of-frame delimiter)
    `define SPECIAL_CODE_K29_7_8B 8'hFD  // Decimal: 253, Negado: 2
    `define SPECIAL_CODE_K29_7_10B 10'b010001_0111  // Decimal: 279, Negado: 744

    // K30.7 /V/ (Error or Violation)
    `define SPECIAL_CODE_K30_7_8B 8'hFE  // Decimal: 254, Negado: 1
    `define SPECIAL_CODE_K30_7_10B 10'b100001_0111  // Decimal: 535, Negado: 488


// --- Valid data code-groups: Códigos de Datos en 8 y 10 bits (Current RD+) ---
    // D00.0
    `define DATA_CODE_D00_0_8B 8'h00  // Decimal: 0, Negado: 255
    `define DATA_CODE_D00_0_10B 10'b011000_1011  // Decimal: 395, Negado: 628

    // D01.0
    `define DATA_CODE_D01_0_8B 8'h01  // Decimal: 1, Negado: 254
    `define DATA_CODE_D01_0_10B 10'b100010_1011  // Decimal: 555, Negado: 468

    // D02.0
    `define DATA_CODE_D02_0_8B 8'h02  // Decimal: 2, Negado: 253
    `define DATA_CODE_D02_0_10B 10'b010010_1011  // Decimal: 299, Negado: 724

    // D03.0
    `define DATA_CODE_D03_0_8B 8'h03  // Decimal: 3, Negado: 252
    `define DATA_CODE_D03_0_10B 10'b110001_0100  // Decimal: 788, Negado: 235

    // D02.2
    `define DATA_CODE_D02_2_8B 8'h42  // Decimal: 66, Negado: 189
    `define DATA_CODE_D02_2_10B 10'b010010_0101  // Decimal: 293, Negado: 730

    // D16.2
    `define DATA_CODE_D16_2_8B 8'h50  // Decimal: 80, Negado: 175
    `define DATA_CODE_D16_2_10B 10'b100100_0101  // Decimal: 581, Negado: 442

    // D26.4
    `define DATA_CODE_D26_4_8B 8'h9A  // Decimal: 154, Negado: 101
    `define DATA_CODE_D26_4_10B 10'b010110_0010  // Decimal: 354, Negado: 669

    // D06.5
    `define DATA_CODE_D06_5_8B 8'hA6  // Decimal: 166, Negado: 89
    `define DATA_CODE_D06_5_10B 10'b011001_1010  // Decimal: 410, Negado: 613

    // D21.5
    `define DATA_CODE_D21_5_8B 8'hB5  // Decimal: 181, Negado: 74
    `define DATA_CODE_D21_5_10B 10'b101010_1010  // Decimal: 682, Negado: 341

    // D05.6
    `define DATA_CODE_D05_6_8B 8'hC5  // Decimal: 197, Negado: 58
    `define DATA_CODE_D05_6_10B 10'b101001_0110  // Decimal: 678, Negado: 345

`endif // Fin de la guarda de inclusión
