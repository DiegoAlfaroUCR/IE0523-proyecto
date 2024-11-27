`include "src/Receive.v"
`include "src/Synchronization.v"
module Receptor_Synchro (
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
    Synchronization synchro (
        .Clk(Clk),
        .mr_main_reset(mr_main_reset),
        .power_on(power_on),
        .PUDI(PUDI),
        .code_sync_status(sync_status),
        .SUDI(SUDI)
    );
    Receive receptor (
        .clk(Clk),
        .reset(mr_main_reset),
        .sync_status(sync_status),
        .SUDI(SUDI),
        .RX_DV(RX_DV),
        .RXD(RXD)
    );



    
endmodule