module Tester_receptor (
    output reg clk,
    output reg reset,
    output reg [10:0] SUDI,
    output reg sync_status
);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Reloj de 10 ns de período (100 MHz)
    end

   // Procedimiento de prueba
    initial begin

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
        SUDI = {`DATA_CODE_D21_5_10B, 1'b1};  // Código de transición a IDLE_D

        // Prueba de IDLE_D y transición a START_PACKET
        #10;
        SUDI = {`SPECIAL_CODE_K27_7_10B, 1'b1};  

        // Prueba de estado START_PACKET y transición a RECEIVE
        #30;
        SUDI = {`DATA_CODE_D00_0_10B, 1'b1};  // Código de datos
        #20;
        SUDI = {`DATA_CODE_D01_0_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D02_0_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D02_2_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D03_0_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D16_2_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D26_4_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D06_5_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D21_5_10B, 1'b1};  // Otro código de datos
        #20;
        SUDI = {`DATA_CODE_D05_6_10B, 1'b1};  // Otro código de datos

        // Prueba de estado RECEIVE y verificación de patrón de fin
        #30;
        SUDI = {`SPECIAL_CODE_K29_7_10B, 1'b1};
        #20;
        SUDI = {`SPECIAL_CODE_K23_7_10B, 1'b1};
        #20;
        SUDI = {`SPECIAL_CODE_K28_5_10B, 1'b1};  // Patrón de fin para transición a TRI_RR

        // Esperar unos ciclos y revisar las señales de salida
        #100;
        
        // Termina la simulación
        $finish;
    end


    
endmodule