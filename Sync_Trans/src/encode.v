`include "src/tablas.v"
module countones #(parameter WIDTH = 6) (
    input [WIDTH-1:0] data_in, // Entrada de datos
    output reg [3:0] count     // Cantidad de bits en 1 (hasta 15 bits máximo)
);
    integer i;

    always @(*) begin
        count = 0; // Inicializar el contador
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (data_in[i] == 1'b1)
                count = count + 1;
        end
    end
endmodule
module ENCODE (
    input [7:0] code_group_8b_recibido,  // Entrada de 8 bits
    output reg [9:0] code_group_10b,     // Salida de 10 bits
    input reset,                         // Reinicia el cálculo de RD
    input clk,                           // Reloj
    output reg running_disparity         // RD actual: 1 = positivo, 0 = negativo
);

// Variables internas
reg [5:0] subblock_6b;   // Primer sub-bloque de 6 bits (abcdei)
reg [3:0] subblock_4b;   // Segundo sub-bloque de 4 bits (fghj)
wire [3:0] count_ones_6b; // Número de 1s en sub-bloque de 6 bits
wire [3:0] count_ones_4b; // Número de 1s en sub-bloque de 4 bits
wire [3:0] count_zeros_6b, count_zeros_4b; // Contador de ceros en cada bloque
reg [9:0] adjusted_code_group_10b; // Código ajustado según RD
reg subblock_rd_6b; // RD después del sub-bloque de 6 bits
reg subblock_rd_4b; // RD después del sub-bloque de 4 bits

// Estados de la FSM

localparam RESET = 4'b0001;             // Estado de Reset
localparam CODE_GROUP_RD = 4'b0010;     // Estado donde se aplica la disparidad al grupo
localparam  NEXT_RD = 4'b0100;           // Estado para calcular la disparidad de los sub-bloques
localparam ESPERAR_CODE_GROUP = 4'b1000; // Estado de espera de un nuevo group


reg [3:0]  current_state, next_state; // Estado actual y siguiente

// Instancias del módulo countones
countones #(6) count_6b (
    .data_in(subblock_6b),
    .count(count_ones_6b)
);

countones #(4) count_4b (
    .data_in(subblock_4b),
    .count(count_ones_4b)
);

// Contador de ceros
assign count_zeros_6b = 6 - count_ones_6b;
assign count_zeros_4b = 4 - count_ones_4b;

// Mapear entrada a códigos de 10 bits en RD+
always @(*) begin
    case (code_group_8b_recibido)
        `DATA_CODE_D00_0_8B: adjusted_code_group_10b = `DATA_CODE_D00_0_10B; // D0.0
        `DATA_CODE_D01_0_8B: adjusted_code_group_10b = `DATA_CODE_D01_0_10B; // D1.0
        `DATA_CODE_D02_0_8B: adjusted_code_group_10b = `DATA_CODE_D02_0_10B; // D2.0
        `DATA_CODE_D03_0_8B: adjusted_code_group_10b = `DATA_CODE_D03_0_10B; // D3.0
        `DATA_CODE_D02_2_8B: adjusted_code_group_10b = `DATA_CODE_D02_2_10B; // D2.2
        `DATA_CODE_D16_2_8B: adjusted_code_group_10b = `DATA_CODE_D16_2_10B; // D16.2
        `DATA_CODE_D26_4_8B: adjusted_code_group_10b = `DATA_CODE_D26_4_10B; // D26.4
        `DATA_CODE_D06_5_8B: adjusted_code_group_10b = `DATA_CODE_D06_5_10B; // D6.5
        `DATA_CODE_D21_5_8B: adjusted_code_group_10b = `DATA_CODE_D21_5_10B; // D21.5
        `DATA_CODE_D05_6_8B: adjusted_code_group_10b = `DATA_CODE_D05_6_10B; // D5.6
    endcase
end

// Máquina de Estados (FSM)
always @(posedge clk /*or negedge clk*/ or posedge reset) begin
    if (reset) begin
        current_state <= RESET; // Comienza en el estado de reset
        running_disparity <= 1'b0; // Disparidad inicial en negativo
    end else begin
        current_state <= next_state; // Transición al siguiente estado
    end
end

// Lógica de transición de estados y salida
always @(*) begin
    next_state = current_state; // Valor por defecto (sin cambios de estado)
    case (current_state)
        RESET: begin  //1
            running_disparity <= 1'b0; // RD=0 (negativo)
            next_state = CODE_GROUP_RD; // Avanza al siguiente estado
        end

        CODE_GROUP_RD: begin //2
            // Aplicar disparidad al código de 10 bits
            if (running_disparity == 1'b1)
                code_group_10b = adjusted_code_group_10b; // RD+: se pasa como está
            else
                code_group_10b = ~adjusted_code_group_10b; // RD-: se invierte
            

                    // Separar sub-bloques
            subblock_6b = code_group_10b[9:4]; // Bits abcdei
            subblock_4b = code_group_10b[3:0]; // Bits fghj
            next_state = NEXT_RD; // Pasar al siguiente estado para calcular RD
        end

        NEXT_RD: begin //4
            // Calcular disparidad para el sub-bloque de 6 bits
            case (subblock_6b)
                6'b000111: subblock_rd_6b = 1'b1; // RD+ para 000111
                6'b111000: subblock_rd_6b = 1'b0; // RD- para 111000
                default: begin
                    if (count_ones_6b > count_zeros_6b)
                        subblock_rd_6b = 1'b1; // Más 1s -> RD+
                    else if (count_ones_6b < count_zeros_6b)
                        subblock_rd_6b = 1'b0; // Más 0s -> RD-
                    else
                        subblock_rd_6b = running_disparity; // Igual, mantener RD
                end
            endcase

            // Calcular disparidad para el sub-bloque de 4 bits
            case (subblock_4b) 
                4'b0011: subblock_rd_4b = 1'b1; // RD+ para 0011
                4'b1100: subblock_rd_4b = 1'b0; // RD- para 1100
                default: begin
                    if (count_ones_4b > count_zeros_4b)
                        subblock_rd_4b = 1'b1; // Más 1s -> RD+
                    else if (count_ones_4b < count_zeros_4b)
                        subblock_rd_4b = 1'b0; // Más 0s -> RD-
                    else
                        subblock_rd_4b = subblock_rd_6b; // Igual, mantener RD
                end
            endcase

            // Actualizar RD global
            running_disparity <= subblock_rd_4b;

            next_state = CODE_GROUP_RD; // Esperar nuevo grupo de código
        end

        ESPERAR_CODE_GROUP: begin //8
            next_state = CODE_GROUP_RD; // Espera el siguiente grupo de datos
        end

        default: begin
            next_state = RESET; // Estado por defecto
        end
    endcase
end

endmodule
