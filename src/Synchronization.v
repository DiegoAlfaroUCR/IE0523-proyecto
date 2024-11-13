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


// ++++++++++++++++++++ Módulo Synchronization ++++++++++++++++++++
module Synchronization(input Clk, Reset,                // Señales comunes de chip
                       input [9:0] rx_code_group,       // Code group recibido del PMA, REVISAR SI DEBERÍA SER rx_code_group o si es PUDI en sí
                       input PUDI,                      // Indicación PUDI.. expandir
                       output reg code_synch_status,    // Estatus de sincronización
                       output reg rx_even,              // Indicador de paridad del codegroup
                       output reg [9:0] PUDI);          // Señal PUDI de salida

/* ++++++++++++++++++++++++ Asignación de registros internos ++++++++++++++++++++++++ */
    // Vectores de estado presente y de próximo estado
    reg [6:0] EstPres, ProxEstado;

    // Manejo de códigos buenos
    reg [1:0] good_cgs, next_good_cgs;

    wire cggood;
    assign cggood = (!(INVALID | COMMA & rx_even) & PUDI);

    wire INVALID;
    assign INVALID = 1'b1;  // To do: Verificar que el código es parte de los válidos.

    wire COMMA;
    assign COMMA = 1'b1;    // To do: Verificar que el código es una comma, ver pag 63.

/* +++++++++++++++++++++++++++++ Asignación de estados +++++++++++++++++++++++++++++ */
   // Se asignan los estados según el diagrama ASM de la máquina.
   // Se usa un FF para cada estado para evitar race conditions durante operacion del IC.
    localparam [8:0]
        LOSS_OF_SYNC     = 9'b000000001,
        COMMA_DETECT_1   = 9'b000000010,
        ACQUIRE_SYNC_1   = 9'b000000100,
        COMMA_DETECT_2   = 9'b000001000,
        ACQUIRE_SYNC_2   = 9'b000010000,
        COMMA_DETECT_3   = 9'b000100000,
        SYNC_ACQUIRED_1  = 9'b001000000,
        SYNC_ACQUIRED_2  = 9'b010000000,
        SYNC_ACQUIRED_2A = 9'b100000000;


/* +++++++++++++++++++++++++++++ Definición de Flip Flops +++++++++++++++++++++++++++++ */
    // Se define el flanco creciente de reloj como el flanco activo de reloj y reset sincrónico.
    always @(posedge Clk, negedge Reset)
        if (~Reset)  begin
            EstPres    <= Estado_Idle;
        end
        else begin
            EstPres    <= ProxEstado;
        end

/* +++++++++++++++++++++++++++++ Lógica combinacional +++++++++++++++++++++++++++++ */
    always @(*) begin

    // Valores por defecto para mantener el comportamiento de FF.
    ProxEstado = EstPres;

    // Lógica combinacional según el estado presente.
    case (EstPres)
        default: ProxEstado = Estado_Idle;
    endcase
    end

endmodule
