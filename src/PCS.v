/**
 * Archivo: PCS.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Módulo PCS: Wrapper para unir módulos de PCS.
 *
 * Versión: 1
 * Fecha: 30/11/2024
 *
 * Copyright (c) 2024 Diego Alfaro Segura
 * MIT License
 */

`include "src/Transmisor.v"
`include "src/Synchronization.v"
`include "src/Receive.v"

module PCS (
    // Inputs generales
    input Clk,
    input mr_main_reset,
    input power_on,

    // Inputs de transmisor
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,

    // Inputs de sincronizador/receptor
    input PUDI_indicate,

    // Outputs de receptor
    output RX_DV,
    output [7:0] RXD
);

    // Wires de comunicación interna
    wire code_sync_status;
    wire [10:0] SUDI;
    wire [9:0] PUDR_PUDI;

    // Sincronizador
    Synchronization S1 (
        // Inputs
        .Clk(Clk),
        .mr_main_reset(mr_main_reset),
        .power_on(power_on),
        .PUDI(PUDR_PUDI[9:0]),
        .PUDI_indicate(PUDI_indicate),

        // Outputs
        .code_sync_status(code_sync_status),
        .SUDI(SUDI[10:0])
    );

    // Transmisor
    TRANSMIT T1 (
        // Inputs
        .GTX_CLK(Clk),
        .mr_main_reset(mr_main_reset),
        .TXD(TXD[7:0]),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),

        // Outputs
        .transmitting(transmitting),
        .PUDR(PUDR_PUDI[9:0])
    );

    // Receptor
    Receive R1 (
        // Inputs
        .clk(Clk),
        .reset(mr_main_reset),
        .sync_status(code_sync_status),
        .SUDI(SUDI[10:0]),
        // Outputs
        .RX_DV(RX_DV),
        .RXD(RXD[7:0])
    );

endmodule
