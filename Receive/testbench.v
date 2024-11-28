
module Receive_tb;

    // Señales del módulo
    wire clk;
    wire reset;
    wire sync_status;
    wire [10:0] SUDI;
    wire RX_DV;
    wire [7:0] RXD;


    Tester_receptor tester (
        .clk(clk),
        .reset(reset),
        .sync_status(sync_status),
        .SUDI(SUDI)
    );

    // Instancia del módulo Receive
    Receive uut (
        .clk(clk),
        .reset(reset),
        .sync_status(sync_status),
        .SUDI(SUDI),
        .RX_DV(RX_DV),
        .RXD(RXD)
    );

    // Procedimiento de prueba
    initial begin
        // Configurar el dump file para GTKWave
        $dumpfile("Receive_tb.vcd");  // Nombre del archivo de volcado
        $dumpvars(0, Receive_tb);     // Registrar todas las señales de este módulo
    end

    // Monitoreo para ver las señales en la consola
    initial begin
        $monitor("Time=%0d, clk=%b, reset=%b, sync_status=%b, SUDI=%b, RX_DV=%b, RXD=%b",
                 $time, clk, reset, sync_status, SUDI, RX_DV, RXD);
    end

endmodule
