
`include "test/Sync_Receive/Receive_Synchro.v"
`include "test/Sync_Receive/tester.v"

module Receptor_Synchro_tb;

    wire clk;
    wire mr_main_reset;
    wire power_on;
    wire [9:0] PUDI;

    wire RX_DV;
    wire [7:0] RXD;

    tester_receptor_synchro u1 (
        .Clk(clk),
        .mr_main_reset(mr_main_reset),
        .power_on(power_on),
        .PUDI(PUDI)
    );
    Receptor_Synchro dut (
        .Clk(clk),
        .mr_main_reset(mr_main_reset),
        .power_on(power_on),
        .PUDI(PUDI),
        .RX_DV(RX_DV),
        .RXD(RXD)
    );

    initial begin
        // Configurar el dump file para GTKWave
        $dumpfile("resultados.vcd");  // Nombre del archivo de volcado
        $dumpvars(0, Receptor_Synchro_tb);     // Registrar todas las señales de este módulo
    end


endmodule