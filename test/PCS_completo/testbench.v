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

`include "src/PCS.v"
`include "test/PCS_completo/tester.v"

module testbench;
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire RX_DV;  // From pcs of PCS
  wire [7:0] RXD;  // From pcs of PCS
  wire Clk;  // To/From gmii of tester, ..
  wire mr_main_reset;  // To/From gmii of tester, ..
  wire power_on;  // To/From gmii of tester, ..
  wire [7:0] TXD;  // To/From gmii of tester, ..
  wire TX_EN;  // To/From gmii of tester, ..
  wire TX_ER;  // To/From gmii of tester, ..
  wire PUDI_indicate;  // To/From gmii of tester, ..
  // End of automatics


  tester gmii (  /*AUTOINST*/
      // Outputs
      .Clk(Clk),
      .mr_main_reset(mr_main_reset),
      .power_on(power_on),
      .TXD(TXD[7:0]),
      .TX_EN(TX_EN),
      .TX_ER(TX_ER),
      .PUDI_indicate(PUDI_indicate)
  );

  PCS pcs (  /*AUTOINST*/
      // Inputs
      .Clk(Clk),
      .mr_main_reset(mr_main_reset),
      .power_on(power_on),
      .TXD(TXD[7:0]),
      .TX_EN(TX_EN),
      .TX_ER(TX_ER),
      .PUDI_indicate(PUDI_indicate),
      // Outputs
      .RX_DV(RX_DV),
      .RXD(RXD[7:0])
  );

  initial begin
    $dumpfile("resultados.vcd");
    $dumpvars(0, testbench);
  end

endmodule
