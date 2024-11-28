/**
 * Archivo: testbench.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Banco de pruebas.
 *
 * Versión: 1
 * Fecha:  //2024
 *
 * Copyright (c) 2024 Diego Alfaro Segura
 * MIT License
 */

`include "src/Synchronization.v"
`include "src/Transmisor.v"
`include "src/Receive.v"
`include "tester.v"

module testbench;
  // Wires
  wire [7:0] TXD;
  wire TX_EN;
  wire TX_ER;
  wire Clk;
  wire mr_main_reset;
  wire power_on;
  wire code_sync_status;
  wire [10:0] SUDI;
  wire [9:0] PUDR_PUDI;
  wire TX_OSET_indicate;
  wire RX_DV;
  wire [7:0] RXD;

  tester Test1 (
      // Inputs
      .code_sync_status(code_sync_status),
      .SUDI(SUDI[10:0]),
      .transmitting(transmitting),
      .PUDR_PUDI(PUDR_PUDI[9:0]),

      // Outputs
      .Clk(Clk),
      .mr_main_reset(mr_main_reset),
      .power_on(power_on),
      .TXD(TXD[7:0]),
      .TX_EN(TX_EN),
      .TX_ER(TX_ER),
      .PUDI_indicate(PUDI_indicate) //
  );

    // Synchronization
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
  Receive R1 (  /*AUTOINST*/
      // Inputs
      .clk(Clk),
      .reset(mr_main_reset),
      .sync_status(code_sync_status),
      .SUDI(SUDI[10:0]),
      // Outputs
      .RX_DV(RX_DV),
      .RXD(RXD[7:0])
  );

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(0, testbench);
  end

endmodule
