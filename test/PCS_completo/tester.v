/**
 * Archivo: tester.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo de prueba para PCS completo.
 *
 * Versión: 1
 * Fecha: 30/11/2024
 *
 * Copyright (c) 2024
 * MIT License
 */

`timescale 1ns/1ns

// +++++++ Módulo tester +++++++

module tester(
    output reg Clk,                      // Señal de reloj
    output reg mr_main_reset,            // Señal de reset
    output reg power_on,                 // Señal de encencido
    output reg [7:0] TXD,                // Datos a transmitir
    output reg TX_EN,                    // Señal de enable para transmisor
    output reg TX_ER,                    // Señal de error para transmisor
    output reg PUDI_indicate             // Señal de indicación de codegroup llegado por PMA
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
            TX_EN = 1'b1; //Se activa enable
            #30
            TXD = 8'h01;
            #10;
            TXD = 8'h03;
            #10;
            TXD = 8'h9A;
            #10;
            TXD = 8'hB5;
            #10;
            TXD = 8'h42;
            #10;
            TXD = 8'h9A;
            #10;
            TXD = 8'hB5;
            #10;
            TXD = 8'h01;
            #10;
            TXD = 8'hC5;
            TX_EN =1'b0; //Se desactiva enable
            TXD = 8'h00;
            #50

        // ++++++++++++++++++++ Prueba #2: Secuencia completa ++++++++++++++++++++
            TX_EN = 1'b1; //Se activa enable
            #30
            TXD = 8'h01; // Byte 1
            #10;
            TXD = 8'h03; // Byte 2
            #10;
            TXD = 8'h9A; // Byte 3
            #10;
            TXD = 8'hB5; // Byte 4
            #10;
            TXD = 8'h42; // Byte 5
            #10;
            TXD = 8'h02; // Byte 6
            #10;
            TXD = 8'h42; // Byte 7
            #10;
            TXD = 8'h9A; // Byte 8
            #10;
            TXD = 8'hB5; // Byte 9
            #10;
            TXD = 8'h01; // Byte 10
            #10;
            TXD = 8'hC5; // Byte 11
            #10;
            TXD = 8'h03; // Byte 12
            #10;
            TXD = 8'h9A; // Byte 13
            #10;
            TXD = 8'hB5; // Byte 14
            #10;
            TXD = 8'h42; // Byte 15
            #10;
            TXD = 8'h02; // Byte 16
            #10;
            TXD = 8'h42; // Byte 17
            #10;
            TXD = 8'h9A; // Byte 18
            #10;
            TXD = 8'hB5; // Byte 19
            #10;
            TXD = 8'h01; // Byte 20
            #10;
            TXD = 8'hC5; // Byte 21
            #10;
            TXD = 8'h03; // Byte 22
            #10;
            TXD = 8'h9A; // Byte 23
            #10;
            TXD = 8'hB5; // Byte 24
            #10;
            TXD = 8'h42; // Byte 25
            #10;
            TXD = 8'h02; // Byte 26
            #10;
            TXD = 8'h42; // Byte 27
            #10;
            TXD = 8'h9A; // Byte 28
            #10;
            TXD = 8'hB5; // Byte 29
            #10;
            TXD = 8'h01; // Byte 30
            #10;
            TXD = 8'hC5; // Byte 31
            #10;
            TXD = 8'h03; // Byte 32
            #10;
            TXD = 8'h9A; // Byte 33
            #10;
            TXD = 8'hB5; // Byte 34
            #10;
            TXD = 8'h42; // Byte 35
            #10;
            TXD = 8'h02; // Byte 36
            #10;
            TXD = 8'h42; // Byte 37
            #10;
            TXD = 8'h9A; // Byte 38
            #10;
            TXD = 8'hB5; // Byte 39
            #10;
            TXD = 8'h01; // Byte 40
            #10;
            TXD = 8'hC5; // Byte 41
            #10;
            TXD = 8'h03; // Byte 42
            #10;
            TXD = 8'h9A; // Byte 43
            #10;
            TXD = 8'hB5; // Byte 44
            #10;
            TXD = 8'h42; // Byte 45
            #10;
            TXD = 8'h02; // Byte 46
            #10;
            TXD = 8'h42; // Byte 47
            #10;
            TXD = 8'h9A; // Byte 48
            #10;
            TXD = 8'hB5; // Byte 49
            #10;
            TXD = 8'h01; // Byte 50
            #10;
            TXD = 8'hC5; // Byte 51
            #10;
            TXD = 8'h03; // Byte 52
            #10;
            TXD = 8'h9A; // Byte 53
            #10;
            TXD = 8'hB5; // Byte 54
            #10;
            TXD = 8'h42; // Byte 55
            #10;
            TXD = 8'h02; // Byte 56
            #10;
            TXD = 8'h42; // Byte 57
            #10;
            TXD = 8'h9A; // Byte 58
            #10;
            TXD = 8'hB5; // Byte 59
            #10;
            TXD = 8'h01; // Byte 60
            #10;
            TXD = 8'hC5; // Byte 61
            #10;
            TXD = 8'h03; // Byte 62
            #10;
            TXD = 8'h9A; // Byte 63
            #10;
            TXD = 8'hB5; // Byte 64
            #10;
        // TXD = 8'hC5;
            TX_EN =1'b0; //Se desactiva enable
    //       TXD = 8'h00;
        #100;

        #5 $finish;
    end

    // Se genera la señal de reloj
    always begin
        #5 Clk = !Clk;
end

endmodule
