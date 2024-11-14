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
`include "tester.v"

module testbench;
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire Clk;  // To/From T1 of tester, ..
  wire mr_main_reset;  // To/From T1 of tester, ..
  wire power_on;  // To/From T1 of tester, ..
  wire [9:0] PUDI;  // To/From T1 of tester, ..
  wire code_sync_status;  // To/From T1 of tester, ..
  wire [10:0] SUDI;  // To/From T1 of tester, ..
  // End of automatics

  tester T1 (  /*AUTOINST*/
      // Inputs
      .code_sync_status(code_sync_status),
      .SUDI(SUDI[10:0]),
      // Outputs
      .Clk(Clk),
      .mr_main_reset(mr_main_reset),
      .power_on(power_on),
      .PUDI(PUDI[9:0])
  );

    // Synchronization
  Synchronization S1 (  /*AUTOINST*/
      // Inputs
      .Clk(Clk),
      .mr_main_reset(mr_main_reset),
      .power_on(power_on),
      .PUDI(PUDI[9:0]),
      // Outputs
      .code_sync_status(code_sync_status),
      .SUDI(SUDI[10:0])
  );

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(0, testbench);
  end

endmodule
