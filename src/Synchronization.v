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

`include "IdentPUDI.v"

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
    output reg [11:0] SUDI);        // Señal SUDI de salida, contiene el code group y rx_even

    // output reg rx_even, removido para incluirlo en SUDI
    //input PUDI REVISAR SI DEBERÍA SER rx_code_group o si es PUDI en sí

/* ++++++++++++++++++++++++ Asignación de registros internos ++++++++++++++++++++++++ */
    // Vectores de estado presente y de próximo estado
    reg [10:0] State, next_State;

    // rx_even
    reg rx_even, next_rx_even;

    // code_sync_status
    reg next_code_sync_status;

    // Manejo de PUDI
    reg PUDI_INVALID, PUDI_COMMA, PUDI_D;

    // Manejo de códigos buenos
    reg [1:0] good_cgs, next_good_cgs; // Contadores

    wire cggood;
    assign cggood = !(PUDI_INVALID | PUDI_COMMA & rx_even);

/* ++++++++++++++++++++++++++++ Determinación de PUDI ++++++++++++++++++++++++++++++ */
    always @(*) begin
        case (PUDI)     // COMMA
            10'b0000000000: PUDI_COMMA = `TRUE;
            default: PUDI_COMMA = `FALSE;
        endcase

        case (PUDI)     // /D/
            10'b0000000000: PUDI_D = `TRUE;
            default: PUDI_D = `FALSE;
        endcase

        case (PUDI)     // /INVALID/
            10'b0000000000: PUDI_INVALID = `TRUE;
            default: PUDI_INVALID = `FALSE;
        endcase
    end

    // To do: Probar un solo case con todos los códigos disponibles.
    // case (PUDI)
    //     :
    //     default: PUDI_INVALID = `TRUE;
    // endcase

/* +++++++++++++++++++++++++++++ Asignación de estados ++++++++++++++++++++++++++++++ */
    localparam [10:0]
        LOSS_OF_SYNC     = 11'b00000000001,
        COMMA_DETECT_1   = 11'b00000000010,
        ACQUIRE_SYNC_1   = 11'b00000000100,
        COMMA_DETECT_2   = 11'b00000001000,
        ACQUIRE_SYNC_2   = 11'b00000010000,
        COMMA_DETECT_3   = 11'b00000100000,
        SYNC_ACQUIRED_1  = 11'b00001000000,
        SYNC_ACQUIRED_2  = 11'b00010000000,
        SYNC_ACQUIRED_2A = 11'b00100000000,
        SYNC_ACQUIRED_3  = 11'b01000000000,
        SYNC_ACQUIRED_3A = 11'b10000000000;

/* +++++++++++++++++++++++++++++ Definición de Flip Flops +++++++++++++++++++++++++++ */
    always @(posedge Clk) begin
        if (power_on || mr_main_reset)  begin
            State            <= LOSS_OF_SYNC;
            good_cgs         <= 2'b0;
            rx_even          <= `FALSE;     // Se define para que no sea X, pero es irrelevante.
            code_sync_status <= `FAIL;
        end
        else begin
            State            <= next_State;
            good_cgs         <= next_good_cgs;
            rx_even          <= next_rx_even;
            code_sync_status <= next_code_sync_status;
        end
        SUDI <= {PUDI, rx_even};            // Se declara la salida SUDI
    end

/* +++++++++++++++++++++++++++++ Cambio de estados ++++++++++++++++++++++++++++++++++ */
    always @(*) begin

    // Valores por defecto para mantener el comportamiento de FF.
    next_State            = State;
    next_good_cgs         = good_cgs;
    next_rx_even          = rx_even;
    next_code_sync_status = code_sync_status;

    // Lógica combinacional según el estado presente.
    case (State)
        LOSS_OF_SYNC: begin
            next_code_sync_status = `FAIL;
            next_rx_even = ~rx_even;
            if(PUDI_COMMA) next_State = COMMA_DETECT_1;
        end

        COMMA_DETECT_1: begin
            next_rx_even = `TRUE;
            if(PUDI_D) next_State = ACQUIRE_SYNC_1;
            else next_State = LOSS_OF_SYNC;
        end

        ACQUIRE_SYNC_1: begin
            next_rx_even = ~rx_even;
            if(PUDI_COMMA & ~rx_even) next_State = COMMA_DETECT_2;
            else if (~cggood) next_State = LOSS_OF_SYNC;
            // Siguiente if no es necesario pues no se actualiza el State
            // else if (~PUDI_COMMA & ~PUDI_INVALID) next_State = ACQUIRE_SYNC_1;
        end

        COMMA_DETECT_2: begin
            next_rx_even = `TRUE;
            if(PUDI_D) next_State = ACQUIRE_SYNC_2;
            else next_State = LOSS_OF_SYNC;
        end

        ACQUIRE_SYNC_2: begin
            next_rx_even = ~rx_even;
            if(PUDI_COMMA & ~rx_even) next_State = COMMA_DETECT_3;
            else if (~cggood) next_State = LOSS_OF_SYNC;
            // else if (~PUDI_COMMA & ~PUDI_INVALID) next_State = ACQUIRE_SYNC_2;
        end

        COMMA_DETECT_3: begin
            next_rx_even = `TRUE;
            if(PUDI_D) next_State = SYNC_ACQUIRED_1;
            else next_State = LOSS_OF_SYNC;
        end

        SYNC_ACQUIRED_1: begin
            next_code_sync_status = `TRUE;
            next_rx_even = ~rx_even;
            if(~cggood) next_State = SYNC_ACQUIRED_2;
        end

        SYNC_ACQUIRED_2: begin
            next_rx_even = ~rx_even;
            next_good_cgs = 2'b0;
            if(cggood) next_State = SYNC_ACQUIRED_2A;
            else next_State = SYNC_ACQUIRED_3;
        end

        SYNC_ACQUIRED_2A: begin
            next_rx_even = ~rx_even;
            next_good_cgs = good_cgs + 1;
            // REVISAR SI DEBO REVISAR QUE SEA 2 O 3
            if(cggood & good_cgs == 2'd3) next_State = SYNC_ACQUIRED_1;
            else if (cggood & good_cgs != 2'd3) next_State = SYNC_ACQUIRED_2A;
            else if (~cggood) next_State = SYNC_ACQUIRED_3;
        end

        SYNC_ACQUIRED_3: begin
            next_rx_even = ~rx_even;
            next_good_cgs = 2'b0;
            if(cggood) next_State = SYNC_ACQUIRED_3A;
            else next_State = LOSS_OF_SYNC;
        end

        SYNC_ACQUIRED_3A: begin
            next_rx_even = ~rx_even;
            next_good_cgs = good_cgs + 1;
            // REVISAR SI DEBO REVISAR QUE SEA 2 O 3
            if(cggood & good_cgs == 2'd3) next_State = SYNC_ACQUIRED_2;
            else if (cggood & good_cgs != 2'd3) next_State = SYNC_ACQUIRED_3A;
            else if (~cggood) next_State = LOSS_OF_SYNC;
        end

        default: next_State = LOSS_OF_SYNC;
    endcase
    end

endmodule
