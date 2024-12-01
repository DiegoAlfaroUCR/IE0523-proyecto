`include "src/tablas.v"  // Incluir las definiciones de los códigos especiales
`timescale 1ns/1ns

`define COMMA ~10'b110000_0101
`define D1    10'b011000_1011
`define D2    10'b100010_1011
`define D3    10'b010010_1011
`define D4    10'b100100_0101
`define MALO  10'b000000_0000
`define S     10'b001001_0111

module tester_receptor_synchro (
    output reg Clk,                      // Señal de reloj
    output reg mr_main_reset,            // Señal de reset
    output reg power_on,                 // Señal de encencido
    output reg [9:0] PUDI               // Code group recibido del PMA
);
    
    initial begin
        // Valores iniciales de señales
            Clk = 0;
            mr_main_reset = 0;
            power_on = 0;
           
           

            // Reset momentáneo al inicio para iniciar en estado
            #5 mr_main_reset = 1;
            #10 mr_main_reset = 0;

        // ++++++++++++++++++++ Prueba #1: Sincronización correcta ++++++++++++++++++++
            #10 PUDI = `COMMA;
            #10 PUDI = `D1;
            #10 PUDI = `COMMA;
            #10 PUDI = `D2;
            #10 PUDI = `COMMA;
            #10 PUDI = `D3;
            #10 PUDI = `D1;
            #10 PUDI = `D2;
            #20 PUDI = `COMMA;
            #10 PUDI = `D1;
            #10 PUDI = `S;
            #10 PUDI = `DATA_CODE_D00_0_10B;
            #10 PUDI = `DATA_CODE_D01_0_10B;
            #10 PUDI = `DATA_CODE_D02_0_10B;
            #10 PUDI = `DATA_CODE_D02_2_10B;
            #10 PUDI = `DATA_CODE_D03_0_10B;
            #10 PUDI = `DATA_CODE_D16_2_10B;
            #10 PUDI = `DATA_CODE_D26_4_10B;
            #10 PUDI = `DATA_CODE_D06_5_10B;
            #10 PUDI = `DATA_CODE_D21_5_10B;
            #10 PUDI = `DATA_CODE_D05_6_10B;
            #10 PUDI = `SPECIAL_CODE_K29_7_10B;
            #10 PUDI = `SPECIAL_CODE_K23_7_10B;
            #10 PUDI = ~`SPECIAL_CODE_K28_5_10B;
            #60 PUDI = `MALO;
        #5 $finish;
    end

    // Se genera la señal de reloj
    always begin
        #5 Clk = !Clk;
end





endmodule