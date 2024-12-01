/**
 * Archivo: testbench.v
 * Autor: Diego Alfaro Segura (diego.alfarosegura@ucr.ac.cr)
 *
 * Banco de pruebas para unión entre transmisor y sincronizador.
 *
 * Versión: 1
 * Fecha:  30/11/2024
 *
 * Copyright (c) 2024 Diego Alfaro Segura
 * MIT License
 */

`include "src/Synchronization.v"
`include "src/Transmisor.v"
`include "test/Sync_Trans/tester.v"

module testbench;
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [7:0] TXD;  // From Test1 of tester
  wire TX_EN;  // From Test1 of tester
  wire TX_ER;  // From Test1 of tester
  wire Clk;  // To/From Test1 of tester, ..
  wire mr_main_reset;  // To/From Test1 of tester, ..
  wire power_on;  // To/From Test1 of tester, ..
  wire code_sync_status;  // To/From Test1 of tester, ..
  wire [10:0] SUDI;  // To/From Test1 of tester, ..
  wire [9:0] PUDR_PUDI;
  wire TX_OSET_indicate;
  // End of automatics

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
      .PUDI_indicate(PUDI_indicate)
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

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(0, testbench);
  end

endmodule
