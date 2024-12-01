/**
 * Archivo: tester.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo de prueba para unión entre transmisor y sincronizador.
 *
 * Versión: 1
 * Fecha: 30/11/2024
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
    input code_sync_status,              // Estatus de sincronización
    input [10:0] SUDI,                   // Señal SUDI de salida, contiene el code group y rx_even
    input transmitting,                  // Indicación de transmisión del transmit
    input [9:0] PUDR_PUDI,               // Comunicación en loopback  entre transmisor y sync

    output reg Clk,                      // Señal de reloj
    output reg mr_main_reset,            // Señal de reset
    output reg power_on,                 // Señal de encencido
    output reg [7:0] TXD,                // Datos a transmitir
    output reg TX_EN,                    // Señal de enable para transmisor
    output reg TX_ER,                    // Señal de error para transmisor

    output reg PUDI_indicate //
    );

    initial begin
        // Valores iniciales de señales
            Clk = 0;
            mr_main_reset = 0;
            power_on = 0;
            TX_EN = 1'b0;
            TX_ER = 1'b0;
            TXD = 8'h00;
            PUDI_indicate = 0;

            // Reset momentáneo
            #5 mr_main_reset = 1;
            PUDI_indicate = 1;
            #20 mr_main_reset = 0;

            // ++++++++++++++++++++ Prueba #1: Secuencia corta ++++++++++++++++++++
            #80
            TX_EN = 1'b1; // Se activa enable
            #30
            TXD = 8'hAC; // D12.5 (Nuevo)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TX_EN = 1'b0; // Se desactiva enable
            TXD = 8'h00;
            #50

            // ++++++++++++++++++++ Prueba #2: Secuencia combinada ++++++++++++++++++++
            TX_EN = 1'b1; // Se activa enable
            #30
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hAC; // D12.5 (Nuevo)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'h94; // D20.4 (Nuevo)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TX_EN = 1'b0; // Se desactiva enable
            TXD = 8'h00;
            #50
            // ++++++++++++++++++++ Prueba #3: Secuencia extendida ++++++++++++++++++++
            TX_EN = 1'b1; // Se activa enable
            #30
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hC5; // D05.6 (Anterior)
            #10;
            TXD = 8'hAC; // D12.5 (Nuevo)
            #10;
            TXD = 8'h94; // D20.4 (Nuevo)
            #10;
            TXD = 8'h93; // D19.4 (Nuevo)
            #10;
            // TXD = 8'h95; // D21.4 (Nuevo)
            // #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hC5; // D05.6 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TXD = 8'hA6; // D06.5 (Anterior)
            #10;
            TXD = 8'hB5; // D21.5 (Anterior)
            #10;
            TX_EN = 1'b0; // Se desactiva enable
            TXD = 8'h00;
            #50



        #5 $finish;
    end

    // Se genera la señal de reloj
    always begin
        #5 Clk = !Clk;
end

endmodule
