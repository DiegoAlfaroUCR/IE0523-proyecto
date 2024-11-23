`include "Receive.v"
`include "Synchronization.v"
module moduleName (
    input Clk,                      // Señal de reloj
    input mr_main_reset,            // Señal de reset
    input power_on,                 // Señal de encencido
    input [9:0] PUDI,               // Code group recibido del PMA
    output RX_DV,               // Señal de datos válidos (indicador de datos recibidos)
    output [7:0] RXD            // Datos recibidos
);

    wire sync_status;
    wire [10:0] SUDI;
    // Intanciar el Synchronizator
    Synchronization syncrho (
        .clk(clk),
        .mr_main_reset(mr_main_reset),
        .power_on(power_on),
        .PUDI(PUDI),
        .code_sync_status(sync_status),
        .SUDI(SUDI)
    );
    Receive receptor (
        clk(clk),
        reset(mr_main_reset),
        sync_status(sync_status),
        SUDI(SUDI),
        RX_DV(RX_DV),
        RXD(RXD)
    );



    
endmodule