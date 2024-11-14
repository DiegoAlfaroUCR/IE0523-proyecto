`timescale 1ns/1ps

module Receive_tb;

    // Señales del módulo
    reg clk;
    reg reset;
    reg sync_status;
    reg [10:0] SUDI;
    wire RX_DV;
    wire RX_ER;
    wire [7:0] RXD;

    // Instancia del módulo Receive
    Receive uut (
        .clk(clk),
        .reset(reset),
        .sync_status(sync_status),
        .SUDI(SUDI),
        .RX_DV(RX_DV),
        .RX_ER(RX_ER),
        .RXD(RXD)
    );

    // Generador de señal de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Reloj de 10 ns de período (100 MHz)
    end

    // Procedimiento de prueba
    initial begin
        // Configurar el dump file para GTKWave
        $dumpfile("Receive_tb.vcd");  // Nombre del archivo de volcado
        $dumpvars(0, Receive_tb);     // Registrar todas las señales de este módulo

        // Inicialización
        reset = 1;
        sync_status = 0;
        SUDI = 11'b0;
        
        // Liberar el reset y permitir que el módulo empiece a funcionar
        #10;
        reset = 0;

        // Prueba de transición inicial a WAIT_K
        #20;
        sync_status = 1;
        SUDI = {`SPECIAL_CODE_K28_5_10B, 1'b1};  // Código especial de inicio

        // Esperar unos ciclos para ver la transición a RX_K
        #20;
        SUDI = {`DATA_CODE_D21_5_10B, 1'b0};  // Código de transición a IDLE_D

        // Prueba de IDLE_D y transición a START_PACKET
        #20;
        SUDI = {`SPECIAL_CODE_K28_5_10B, 1'b0};  // Otro código especial

        // Prueba de estado START_PACKET y transición a RECEIVE
        #20;
        SUDI = {`DATA_CODE_D00_0_10B, 1'b0};  // Código de datos
        #10;
        SUDI = {`DATA_CODE_D01_0_10B, 1'b0};  // Otro código de datos

        // Prueba de estado RECEIVE y verificación de patrón de fin
        #30;
        SUDI = {`SPECIAL_CODE_K29_7_10B, 1'b1};
        #10;
        SUDI = {`SPECIAL_CODE_K23_7_10B, 1'b1};
        #10;
        SUDI = {`SPECIAL_CODE_K28_5_10B, 1'b1};  // Patrón de fin para transición a TRI_RR

        // Esperar unos ciclos y revisar las señales de salida
        #30;
        
        // Termina la simulación
        $finish;
    end

    // Monitoreo para ver las señales en la consola
    initial begin
        $monitor("Time=%0d, clk=%b, reset=%b, sync_status=%b, SUDI=%b, RX_DV=%b, RX_ER=%b, RXD=%b",
                 $time, clk, reset, sync_status, SUDI, RX_DV, RX_ER, RXD);
    end

endmodule
