/**
 * Archivo: tester.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo de prueba.
 *
 * Versión: 1
 * Fecha: //2024
 *
 * Copyright (c) 2024
 * MIT License
 */

`timescale 1ns/1ns

`define COMMA 10'b110000_0101
`define D1    10'b011000_1011
`define D2    10'b100010_1011
`define D3    10'b010010_1011
`define D4    10'b100100_0101
`define MALO  10'b000000_0000

// +++++++ Módulo tester +++++++

module tester(
    output reg Clk,                      // Señal de reloj
    output reg mr_main_reset,            // Señal de reset
    output reg power_on,                 // Señal de encencido
    output reg [9:0] PUDI,               // Code group recibido del PMA
    input code_sync_status,              // Estatus de sincronización
    input [10:0] SUDI);                  // Señal SUDI de salida, contiene el code group y rx_even

    initial begin
        // Valores iniciales de señales
            Clk = 0;
            mr_main_reset = 0;
            power_on = 0;
            PUDI = 10'b000000_0000;

            // Reset momentáneo al inicio para iniciar en estado
            // #5 mr_main_reset = 1'b1;

        // ++++++++++++++++++++ Prueba #1, Lectura ++++++++++++++++++++

            #20
        #5 $finish;
    end

    // Se genera la señal de reloj
    always begin
        #5 Clk = !Clk;
end

endmodule
