`include "test/Transmit/tester_transmisor.v"
`include "src/Transmisor.v"

module testbench_TX_OS;
    wire GTX_CLK, TX_EN, TX_ER;
    wire [7:0] TXD;
    wire [9:0] tx_code_group;
    wire transmitting;
    wire mr_main_reset;

    // Generar archivo de simulación
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1, testbench_TX_OS);
    end

    // Instancia del módulo de prueba (tester)
    tester_TX_OS probador (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TXD(TXD)
    );

    // Instancia del módulo ENCODE
    ENCODE encodiando (
        .clk(GTX_CLK),
        .reset(mr_main_reset)
    );

    // Instancia del módulo TRANSMIT
    TRANSMIT Trans (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TXD(TXD),
        .transmitting(transmitting)
    );
endmodule
