/**
 * Archivo: Synchronization.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo Synchronization
 *
 * Versión: 1
 * Fecha: //2024
 *
 * Copyright (c) 2024 Diego Alfaro Segura
 * MIT License
 */

`include "src/IdentPUDI.v"

/* ++++++++++++++++++++ Definiciones constantes ++++++++++++++++++++ */
    `define TRUE    1'b1
    `define FALSE   1'b0
    `define OK      1'b1
    `define FAIL    1'b0

/* ++++++++++++++++++++ Módulo Synchronization +++++++++++++++++++++ */
module Synchronization(
    input Clk,                      // Señal de reloj
    input mr_main_reset,            // Señal de reset
    input power_on,                 // Señal de encencido
    input [9:0] PUDI,               // Code group recibido del PMA
    output reg code_sync_status,    // Estatus de sincronización
    output reg [10:0] SUDI);        // Señal SUDI de salida, contiene el code group y rx_even

/* ++++++++++++++++++++++++ Asignación de registros internos ++++++++++++++++++++++++ */
    // Vectores de estado presente y de próximo estado
    reg [10:0] State, next_State;

    // rx_even
    reg rx_even, prev_rx_even;

    // code_sync_status
    reg next_code_sync_status;

    // Manejo de códigos buenos
    reg [1:0] good_cgs, prev_good_cgs; // Contadores

    wire cggood;
    assign cggood = !(PUDI_INVALID | PUDI_COMMA & rx_even);

/* ++++++++++++++++++++++++++++ Determinación de PUDI ++++++++++++++++++++++++++++++ */
    wire PUDI_COMMA, PUDI_D, PUDI_INVALID;
    IdentPUDI ID1 (.PUDI(PUDI),
                   .PUDI_COMMA(PUDI_COMMA),
                   .PUDI_D(PUDI_D),
                   .PUDI_INVALID(PUDI_INVALID));

/* +++++++++++++++++++++++++++++ Asignación de estados ++++++++++++++++++++++++++++++ */
    localparam [10:0]
        LOSS_OF_SYNC     = 11'b00000000001,     // En decimal: 1
        COMMA_DETECT_1   = 11'b00000000010,     // En decimal: 2
        ACQUIRE_SYNC_1   = 11'b00000000100,     // En decimal: 4
        COMMA_DETECT_2   = 11'b00000001000,     // En decimal: 8
        ACQUIRE_SYNC_2   = 11'b00000010000,     // En decimal: 16
        COMMA_DETECT_3   = 11'b00000100000,     // En decimal: 32
        SYNC_ACQUIRED_1  = 11'b00001000000,     // En decimal: 64
        SYNC_ACQUIRED_2  = 11'b00010000000,     // En decimal: 128
        SYNC_ACQUIRED_2A = 11'b00100000000,     // En decimal: 256
        SYNC_ACQUIRED_3  = 11'b01000000000,     // En decimal: 512
        SYNC_ACQUIRED_3A = 11'b10000000000;     // En decimal: 1024

/* +++++++++++++++++++++++++++++ Definición de Flip Flops +++++++++++++++++++++++++++ */
    always @(posedge Clk) begin
        if (mr_main_reset || power_on)  begin
            State            <= LOSS_OF_SYNC;
            good_cgs         <= 2'b0;
            rx_even          <= `FALSE;     // Se define para que no sea X, pero es irrelevante.
            code_sync_status <= `FAIL;
        end
        else begin
            State            <= next_State;
            prev_good_cgs    <= good_cgs;
            prev_rx_even     <= rx_even;

        end
        SUDI <= {PUDI, rx_even};    // Asignar valor de SUDI
    end

/* +++++++++++++++++++++++++++++ Cambio de estados ++++++++++++++++++++++++++++++++++ */
    always @(*) begin

    // Valores por defecto para mantener el comportamiento de FF.
    next_State            = State;
    good_cgs              = prev_good_cgs;
    rx_even               = prev_rx_even;

    // Lógica combinacional según el estado presente.
    case (State)
        LOSS_OF_SYNC: begin
            code_sync_status = `FAIL;
            rx_even = ~prev_rx_even;
            if(PUDI_COMMA) next_State = COMMA_DETECT_1;
        end

        COMMA_DETECT_1: begin
            rx_even = `TRUE;
            if(PUDI_D) next_State = ACQUIRE_SYNC_1;
            else next_State = LOSS_OF_SYNC;
        end

        ACQUIRE_SYNC_1: begin
            rx_even = ~prev_rx_even;
            if(PUDI_COMMA & ~rx_even) next_State = COMMA_DETECT_2;
            else if (~cggood) next_State = LOSS_OF_SYNC;
        end

        COMMA_DETECT_2: begin
            rx_even = `TRUE;
            if(PUDI_D) next_State = ACQUIRE_SYNC_2;
            else next_State = LOSS_OF_SYNC;
        end

        ACQUIRE_SYNC_2: begin
            rx_even = ~prev_rx_even;
            if(PUDI_COMMA & ~rx_even) next_State = COMMA_DETECT_3;
            else if (~cggood) next_State = LOSS_OF_SYNC;
        end

        COMMA_DETECT_3: begin
            rx_even = `TRUE;
            if(PUDI_D) next_State = SYNC_ACQUIRED_1;
            else next_State = LOSS_OF_SYNC;
        end

        SYNC_ACQUIRED_1: begin
            code_sync_status = `TRUE;
            rx_even = ~prev_rx_even;
            if(~cggood) next_State = SYNC_ACQUIRED_2;
        end

        SYNC_ACQUIRED_2: begin
            rx_even = ~prev_rx_even;
            good_cgs = 2'b0;
            if(cggood) next_State = SYNC_ACQUIRED_2A;
            else next_State = SYNC_ACQUIRED_3;
        end

        SYNC_ACQUIRED_2A: begin
            rx_even = ~prev_rx_even;
            good_cgs = prev_good_cgs + 1;
            if(cggood & good_cgs == 2'd3) next_State = SYNC_ACQUIRED_1;
            else if (~cggood) next_State = SYNC_ACQUIRED_3;
        end

        SYNC_ACQUIRED_3: begin
            rx_even = ~prev_rx_even;
            good_cgs = 2'b0;
            if(cggood) next_State = SYNC_ACQUIRED_3A;
            else next_State = LOSS_OF_SYNC;
        end

        SYNC_ACQUIRED_3A: begin
            rx_even = ~prev_rx_even;
            good_cgs = prev_good_cgs + 1;
            if(cggood & good_cgs == 2'd3) next_State = SYNC_ACQUIRED_2;
            else if (~cggood) next_State = LOSS_OF_SYNC;
        end

        default: next_State = LOSS_OF_SYNC;
    endcase
    end

endmodule
