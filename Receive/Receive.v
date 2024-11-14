`include "tablas.v"  // Incluir las definiciones de los códigos especiales

module Receive (
    input clk,            // Señal de reloj
    input reset,          // Señal de reset
    input sync_status,    // Estado de sincronización
    input [10:0] SUDI,    // Señal de entrada SUDI de 11 bits
    output reg RX_DV,     // Señal de datos válidos (indicador de datos recibidos)
    output reg RX_ER,     // Señal de error en recepción
    output reg [7:0] RXD  // Datos recibidos
);

    // Función para decodificar códigos especiales de 10 bits a 8 bits
    function [7:0] DECODE;
        input [9:0] SUDI_RX_CODE;  // Código SUDI de 10 bits
        case(SUDI_RX_CODE)    
            `SPECIAL_CODE_K28_0_10B:  DECODE = `SPECIAL_CODE_K28_0_8B;   
            `SPECIAL_CODE_K28_1_10B:  DECODE = `SPECIAL_CODE_K28_1_8B;  
            `SPECIAL_CODE_K28_2_10B:  DECODE = `SPECIAL_CODE_K28_2_8B;  
            `SPECIAL_CODE_K28_3_10B:  DECODE = `SPECIAL_CODE_K28_3_8B;  
            `SPECIAL_CODE_K28_4_10B:  DECODE = `SPECIAL_CODE_K28_4_8B;    
            `SPECIAL_CODE_K28_5_10B:  DECODE = `SPECIAL_CODE_K28_5_8B;   
            `SPECIAL_CODE_K28_6_10B:  DECODE = `SPECIAL_CODE_K28_6_8B;  
            `SPECIAL_CODE_K28_7_10B:  DECODE = `SPECIAL_CODE_K28_7_8B;      
            `SPECIAL_CODE_K23_7_10B:  DECODE = `SPECIAL_CODE_K23_7_8B;   
            `SPECIAL_CODE_K27_7_10B:  DECODE = `SPECIAL_CODE_K27_7_8B;  
            `SPECIAL_CODE_K29_7_10B:  DECODE = `SPECIAL_CODE_K29_7_8B;  
            `SPECIAL_CODE_K30_7_10B:  DECODE = `SPECIAL_CODE_K30_7_8B; 
            `DATA_CODE_D00_0_10B:  DECODE = `DATA_CODE_D00_0_8B;  
            `DATA_CODE_D01_0_10B:  DECODE = `DATA_CODE_D01_0_8B;
            `DATA_CODE_D02_0_10B:  DECODE = `DATA_CODE_D02_0_8B;
            `DATA_CODE_D02_2_10B:  DECODE = `DATA_CODE_D02_2_8B;
            `DATA_CODE_D03_0_10B:  DECODE = `DATA_CODE_D03_0_8B;
            `DATA_CODE_D16_2_10B:  DECODE = `DATA_CODE_D16_2_8B;
            `DATA_CODE_D26_4_10B:  DECODE = `DATA_CODE_D26_4_8B;
            `DATA_CODE_D06_5_10B:  DECODE = `DATA_CODE_D06_5_8B;
            `DATA_CODE_D21_5_10B:  DECODE = `DATA_CODE_D21_5_8B;
            `DATA_CODE_D05_6_10B:  DECODE = `DATA_CODE_D05_6_8B;
        endcase
    endfunction

    // Definición de estados del sistema (estado de la máquina de estados)
    localparam LINK_FAILED  = 8'b00000001;
    localparam WAIT_K       = 8'b00000010;
    localparam RX_K         = 8'b00000100;
    localparam IDLE_D       = 8'b00001000;
    localparam START_PACKET = 8'b00010000;
    localparam RECEIVE      = 8'b00100000;
    localparam RX_DATA      = 8'b01000000;
    localparam TRI_RR       = 8'b10000000;

    // Definir el patrón de 30 bits que se utilizará para verificar los tres últimos códigos SUDI
    localparam check_end_code = {`SPECIAL_CODE_K29_7_10B ,`SPECIAL_CODE_K23_7_10B ,`SPECIAL_CODE_K28_5_10B};

    wire [9:0] SUDI_RX_Code;   // Registro para almacenar la señal SUDI de 10 bits
    wire RX_even;               // Señal de paridad (disparidad)
    reg [29:0] check_end;       // Registro para almacenar la concatenación de los tres últimos valores de SUDI_RX_Code
    assign SUDI_RX_Code = SUDI[10:1];  // Asignar los primeros 10 bits de SUDI a SUDI_RX_Code
    assign RX_even = SUDI[0];  // Asignar el bit de paridad de SUDI

    // Registro de desplazamiento para las últimas tres señales de 10 bits
    reg [9:0] last_three_codes[2:0];
    reg [7:0] current_state, next_state;  // Estados actuales y siguientes de la máquina de estados
    reg receiving = 1'b1;  // Variable para indicar si se está recibiendo (inicialmente en TRUE)

    // Lógica secuencial que se ejecuta con el flanco positivo del reloj
    always @(posedge clk) begin
        if (reset) begin
            // Restablece los estados y las últimas tres señales
            current_state <= LINK_FAILED;
            last_three_codes[0] <= 10'b0;
            last_three_codes[1] <= 10'b0;
            last_three_codes[2] <= 10'b0;
        end else begin
            current_state <= next_state;  // Actualiza el estado actual con el siguiente estado
            if (current_state == RECEIVE) begin
                // Desplazar y capturar la nueva señal en el registro de desplazamiento
                last_three_codes[2] <= last_three_codes[1];
                last_three_codes[1] <= last_three_codes[0];
                last_three_codes[0] <= SUDI_RX_Code;
            end
        end
    end

    // Lógica combinacional para determinar el siguiente estado y las señales de salida
    always @(*) begin
        RX_DV = 1'b0;  // Inicializa RX_DV (dato válido) en 0
        RXD = 8'b0;    // Inicializa los datos RXD en 0
        next_state = current_state;  // Establece el siguiente estado igual al estado actual por defecto

        case (current_state)
            LINK_FAILED: begin
                if (receiving) begin  
                    receiving = 1'b1;  // Si se está recibiendo, se activa el indicador de error
                    RX_ER = 1'b1;      // Indica error en la recepción
                end else begin
                    RX_DV = 1'b0;      // No hay datos válidos
                    RX_ER = 1'b0;      // No hay error
                end
                next_state = WAIT_K;  // Transición al estado de espera
            end

            WAIT_K: begin
                receiving = 1'b0;  // Desactiva la recepción
                if (SUDI_RX_Code == `SPECIAL_CODE_K28_5_10B && RX_even)  // Si el código es el esperado y la paridad es correcta
                    next_state = RX_K;  // Transición al estado RX_K
                else
                    next_state = WAIT_K;  // Permanece en el estado WAIT_K
            end

            RX_K: begin
                if (SUDI_RX_Code != `DATA_CODE_D02_2_10B && SUDI_RX_Code == `DATA_CODE_D21_5_10B)  // Condición de transición
                    next_state = IDLE_D;  // Transición al estado IDLE_D
                else 
                    next_state = RX_K;  // Permanece en el estado RX_K
            end

            IDLE_D: begin
                if (SUDI_RX_Code == `SPECIAL_CODE_K28_5_10B)
                    next_state = RX_K;  // Si recibe un código especial, transita a RX_K
                else 
                    next_state = START_PACKET;  // De lo contrario, inicia el paquete
            end

            START_PACKET: begin
                RX_DV = 1'b1;   // Marca los datos como válidos
                RXD = 8'b01010101;  // Datos de ejemplo para el inicio del paquete
                next_state = RECEIVE;  // Transición al estado RECEIVE
            end

            RECEIVE: begin  // Faltaría implementar la decodificación aquí
                check_end = {last_three_codes[2], last_three_codes[1], last_three_codes[0]};  // Concatenar las últimas tres señales
                if (check_end == check_end_code)  // Verifica si coinciden con el patrón final
                    next_state = TRI_RR;  // Si coincide, transita al estado TRI_RR
                else
                    next_state = RX_DATA;
            end
            RX_DATA: begin 
                RXD = DECODE(SUDI_RX_Code);
                next_state = RECEIVE;

            end
            TRI_RR: begin
                next_state = RX_K;  // Regresa al estado RX_K
            end

            default:
                next_state = LINK_FAILED;  // Si el estado no es reconocido, transita al estado LINK_FAILED
        endcase
    end
endmodule