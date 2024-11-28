`include "encode.v"

module ENCODE_tb;

// Señales para el DUT (Device Under Test)
reg [7:0] code_group_8b_recibido;
reg reset;
reg clk;
wire [9:0] code_group_10b;
wire running_disparity;

// Instanciar el DUT
ENCODE UTt (
    .code_group_8b_recibido(code_group_8b_recibido),
    .reset(reset),
    .clk(clk),
    .code_group_10b(code_group_10b),
    .running_disparity(running_disparity)
);

// Generación del reloj
initial clk = 0;
always #1 clk = ~clk; // Período de 10ns

// Procedimiento de prueba
initial begin
    // Inicializar señales
    reset = 0;
    code_group_8b_recibido = 8'b00000000; // Valor inicial de la entrada

    // Esperar al flanco positivo del reloj para reiniciar
    #2;
    reset = 1; // Desactivar reset

    // Prueba 1: D0.0
    #2 code_group_8b_recibido = 8'b00000000; // Ejemplo D0.0
    #2; // Esperar 10ns para observar los resultados
    $display("Test 1: code_group_8b_recibido = %b | code_group_10b = %b | RD = %b", 
             code_group_8b_recibido, code_group_10b, running_disparity);

    // Prueba 2: D1.0
    #2 code_group_8b_recibido = 8'b00000001; // Ejemplo D1.0
    #2;
    $display("Test 2: code_group_8b_recibido = %b | code_group_10b = %b | RD = %b", 
             code_group_8b_recibido, code_group_10b, running_disparity);

    // Prueba 3: D2.0
    #2 code_group_8b_recibido = 8'b00000010; // Ejemplo D2.0
    #2;
    $display("Test 3: code_group_8b_recibido = %b | code_group_10b = %b | RD = %b", 
             code_group_8b_recibido, code_group_10b, running_disparity);

    // Prueba 4: D3.0
    #2 code_group_8b_recibido = 8'b00000011; // Ejemplo D3.0
    #2;
    $display("Test 4: code_group_8b_recibido = %b | code_group_10b = %b | RD = %b", 
             code_group_8b_recibido, code_group_10b, running_disparity);
    #2 code_group_8b_recibido = 8'b00000000; // Ejemplo D0.0
    #10; // Esperar 10ns para observar los resultados

    // Finalizar la simulación después de las pruebas
    #2;
    $finish;
end

// Monitoreo y generación de archivo VCD
initial begin
    $dumpfile("encode_tb.vcd"); // Archivo para GTKWave
    $dumpvars(0, ENCODE_tb);    // Registra todas las señales del módulo y submódulos
end

endmodule
