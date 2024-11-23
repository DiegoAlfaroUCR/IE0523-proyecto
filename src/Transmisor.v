`include "tablas.v"

// Definir salidas de uso
`define TRUE  1'b1
`define FALSE 1'b0
    
//Generar los ordered sets en one-hot
`define OS_T   9'b000000001  // Estado 1
`define OS_R   9'b000000010  // Estado 2
`define OS_I   9'b000001000  // Estado 3
`define OS_D   9'b000010000  // Estado 4
`define OS_S   9'b000100000  // Estado 5
`define OS_V   9'b001000000  // Estado 6
`define OS_LI  9'b010000000  // Estado 7

/*-------------------------------------------------------------------------------

--------------------- MODULOS PARA PCS transmit ordered set  ---------------------
------------------------------------------------------------------------------------*/

// Módulo VOID para decidir si se sustituye el código de grupo con /V/;
module VOID (
    input [8:0] x_in,            // Código de grupo de entrada
    input TX_EN,              // Señal de habilitación de transmisión
    input TX_ER,              // Señal de error de transmisión, no lo usamos 
    input [7:0] TXD,          // Código de datos TXD
    output reg [8:0] VOID_OUT // Código de grupo de salida (original o sustituido por /V/)
);

    // El valor del código de grupo /V/ (K30.7)
    // `OS_V es el valor de /V/ en 8 bits 

    always @(*) begin
        // Condición 1: Si [TX_EN=FALSE * TX_ER=TRUE * TXD != 00001111], devolver /V/
        if (TX_EN == 1'b0 && TX_ER == 1'b1 && TXD != 8'b00001111) begin
            VOID_OUT = `OS_V;
        end
        // Condición 2: Si [TX_EN=TRUE * TX_ER=TRUE], devolver /V/
        else if (TX_EN == 1'b1 && TX_ER == 1'b1) begin
            VOID_OUT = `OS_V;
        end
        // En caso contrario, devolver el valor original de x
        else begin
            VOID_OUT = x_in;
        end
    end
endmodule

//Maquina de estados PCS transmit ordered set
module TRANSMIT_OS (
    //Inputs
    input mr_main_reset,           // Señal de reset principal
    input GTX_CLK,                 // Señal de reloj
    input [7:0] TXD,               // Datos de transmisión
    input TX_EN,                   // Habilitación de transmisión
    input TX_ER,                   // Error de transmisión
    input TX_OSET_indicate,        // Indicador de conjunto de órdenes de transmisión
    input tx_even,                 // Señal de paridad para los datos de transmisión


    //outputs
    output reg [6:0] tx_o_set,      // Conjunto de órdenes de transmisión generado
    output reg transmitting,       // Indicador de transmisión en progreso
    output reg [9:0] PUDR // Grupo de código de transmisión
    );

    // variables internas de TX ordered set
    // wire xmit_change_out;
    wire [8:0] tx_set_void;  // no va a cambiar porque no hay "errores"
    reg [4:0] estado_actual;
    reg [4:0] estado_siguiente;
    localparam XMIT_DATA           = 5'b00001;     
    localparam START_OF_PACKET     = 5'b00010; 
    localparam TX_PACKET           = 5'b00100;            
    localparam END_OF_PACKET_NOEXT = 5'b01000;  
    localparam EPD2_NOEXT          = 5'b10000;      


    //VOID(X)
    VOID void (
        .x_in(`OS_D),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TXD(TXD[7:0]),
        .VOID_OUT(tx_set_void)
    );

    always @(posedge GTX_CLK) begin
        if (!mr_main_reset) begin
            estado_actual <= XMIT_DATA;
            transmitting <= `FALSE;
        end else
            estado_actual <= estado_siguiente;
    end

    always @(*) begin
        // FF
        estado_siguiente = estado_actual;
        

        // Máquina de estados
        case(estado_actual)
            // XMIT_DATA
            XMIT_DATA: begin
                transmitting = `FALSE;
                tx_o_set = `OS_I; // /I/
                //transmitting = `TRUE;
                if (!TX_EN && TX_OSET_indicate) 
                    estado_siguiente = XMIT_DATA;

                if (TX_EN && !TX_ER && TX_OSET_indicate)
                    estado_siguiente = START_OF_PACKET;

            end

            // START_OF_PACKET
            START_OF_PACKET: begin
                tx_o_set = `OS_S; // /S/
                transmitting = `TRUE;
                if (TX_OSET_indicate) begin
                 estado_siguiente = TX_PACKET; // condicion de salto de estado
                end
            end

            // TX_PACKET
            TX_PACKET: begin

                if (TX_EN) begin
                    tx_o_set = tx_set_void; // VOID(/D/)   
                end

                if (!TX_EN && !TX_ER) begin
                    estado_siguiente = END_OF_PACKET_NOEXT; // condicion de salto de estado
                end
            end

            // END_OF_PACKET_NOEXT
            END_OF_PACKET_NOEXT: begin
                tx_o_set = `OS_T; // /T/
                
                if (!tx_even) begin
                transmitting = `FALSE;
                end
                if (TX_OSET_indicate) begin
                    estado_siguiente = EPD2_NOEXT; // condicion de salto de estado
                end
            end

            // Bloque de EPD2_NOEXT
            EPD2_NOEXT: begin
                transmitting = `FALSE;
                tx_o_set = `OS_R; // Toma el valor de /R/ (carrier extend)

                if (!tx_even && TX_OSET_indicate) begin
                    estado_siguiente = XMIT_DATA; // salto a la etiqueta "A"
                end else
                    estado_siguiente = XMIT_DATA; // Revisar bien
            end
            // default
            default:
                estado_siguiente = XMIT_DATA; 
        endcase
    end
endmodule


/*-------------------------------------------------------------------------------

--------------------- MODULOS PARA PCS transmit code-group  ---------------------
------------------------------------------------------------------------------------*/


// Este módulo codifica un código de grupo de 8 bits en un código de grupo de 10 bits.
// esta función fijo luego la acomodo bien en encode.v cuando ya haya revisado lo de la disparidad.
module ENCODE (
    input [7:0] code_group_8b_recibido,  // Entrada de 8 bits
    output reg [9:0] code_group_10b      // Salida de 10 bits
);

// variables internas:

    always @(code_group_8b_recibido) begin
        // Códigos de datos válidos
        if (code_group_8b_recibido == `DATA_CODE_D00_0_8B)
            code_group_10b = `DATA_CODE_D00_0_10B; // D0.0
        else if (code_group_8b_recibido == `DATA_CODE_D01_0_8B)
            code_group_10b = `DATA_CODE_D01_0_10B; // D1.0
        else if (code_group_8b_recibido == `DATA_CODE_D02_0_8B)
            code_group_10b = `DATA_CODE_D02_0_10B; // D2.0
        else if (code_group_8b_recibido == `DATA_CODE_D03_0_8B)
            code_group_10b = `DATA_CODE_D03_0_10B; // D3.0
        else if (code_group_8b_recibido == `DATA_CODE_D02_2_8B)
            code_group_10b = `DATA_CODE_D02_2_10B; // D2.2
        else if (code_group_8b_recibido == `DATA_CODE_D16_2_8B)
            code_group_10b = `DATA_CODE_D16_2_10B; // D16.2
        else if (code_group_8b_recibido == `DATA_CODE_D26_4_8B)
            code_group_10b = `DATA_CODE_D26_4_10B; // D26.4
        else if (code_group_8b_recibido == `DATA_CODE_D06_5_8B)
            code_group_10b = `DATA_CODE_D06_5_10B; // D6.5
        else if (code_group_8b_recibido == `DATA_CODE_D21_5_8B)
            code_group_10b = `DATA_CODE_D21_5_10B; // D21.5
        else if (code_group_8b_recibido == `DATA_CODE_D05_6_8B)
            code_group_10b = `DATA_CODE_D05_6_10B; // D05.6

        // Códigos especiales
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_0_8B)
            code_group_10b = `SPECIAL_CODE_K28_0_10B; // K28.0
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_1_8B)
            code_group_10b = `SPECIAL_CODE_K28_1_10B; // K28.1
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_2_8B)
            code_group_10b = `SPECIAL_CODE_K28_2_10B; // K28.2
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_3_8B)
            code_group_10b = `SPECIAL_CODE_K28_3_10B; // K28.3
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_4_8B)
            code_group_10b = `SPECIAL_CODE_K28_4_10B; // K28.4
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_5_8B)
            code_group_10b = `SPECIAL_CODE_K28_5_10B; // K28.5
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_6_8B)
            code_group_10b = `SPECIAL_CODE_K28_6_10B; // K28.6
        else if (code_group_8b_recibido == `SPECIAL_CODE_K28_7_8B)
            code_group_10b = `SPECIAL_CODE_K28_7_10B; // K28.7
        else if (code_group_8b_recibido == `SPECIAL_CODE_K23_7_8B)
            code_group_10b = `SPECIAL_CODE_K23_7_10B; // K23.7 /R/
        else if (code_group_8b_recibido == `SPECIAL_CODE_K27_7_8B)
            code_group_10b = `SPECIAL_CODE_K27_7_10B; // K27.7 /S/
        else if (code_group_8b_recibido == `SPECIAL_CODE_K30_7_8B)
            code_group_10b = `SPECIAL_CODE_K30_7_10B; // K30.7 /V/
    end
endmodule

//Maquina de estados PCS transmit code-group 
module TRANSMIT_CG (
    input mr_main_reset,           // Señal de reinicio principal
    input GTX_CLK,                 // Reloj de transmisión
    input [6:0] tx_o_set,           // Conjunto de salida de transmisión
    input [7:0] TXD,               // Datos de transmisión
    output reg tx_even,            // Bit de paridad de transmisión
    output reg TX_OSET_indicate,   // Indicador de conjunto de salida de transmisión
    output reg [9:0] PUDR // Código de grupo de transmisión
    );
// variables internas de TX code group
    wire [9:0] TXD_encoded;   // Datos de transmisión codificados
    reg [1:0] state, nxt_state;          // Estado actual y Próximo estado de la máquina de estados    
// función ENCODE(X)
ENCODE encoding (
    .code_group_8b_recibido(TXD),
    .code_group_10b(TXD_encoded)
    );
    /* Estados son 4, pero el SPECIAL_GO, y DATA_GO; al usar la lógica de cambio
    de estado de GENERATE_CODE_GROUPS no era completamente necesario. 
    */

    localparam GENERATE_CODE_GROUPS = 2'b01;
    localparam IDLE_I2B = 2'b10;

    always @(posedge GTX_CLK) begin
        if (!mr_main_reset) begin
            state <= GENERATE_CODE_GROUPS;
            TX_OSET_indicate <= `FALSE;
        end
        else
            state <= nxt_state;
        end
    always @(*) begin
        // Valores iniciales y comportamiento de los FF
        nxt_state = state;
        TX_OSET_indicate = `FALSE;
        case(state)
            // GENERATE_CODE_GROUPS,  se decide qué tipo de code-group es el valor a enviar
            GENERATE_CODE_GROUPS: begin
                if (tx_o_set == `OS_I) begin
                    tx_even = `TRUE;
                    PUDR = `SPECIAL_CODE_K28_5_10B; // /K28.5/
                    nxt_state = IDLE_I2B;
                end                    
                
                else begin
                    // Se pasa al estado SPECIAL_GO, pero no se crea un estado
                    // adicional, no es necesario
                    TX_OSET_indicate = `TRUE;
                    tx_even = !tx_even;
                        
                    if(tx_o_set == `OS_R)
                        PUDR = `SPECIAL_CODE_K23_7_10B; // /R/
                    
                    if(tx_o_set == `OS_S)
                        PUDR = `SPECIAL_CODE_K27_7_10B; // /S/

                    if(tx_o_set == `OS_T)
                        PUDR = `SPECIAL_CODE_K29_7_10B; // /T/

                    if(tx_o_set == `OS_V)
                        PUDR = `SPECIAL_CODE_K30_7_10B; // /V/
                    // este es como el estado de DATA_GO
                    if(tx_o_set == `OS_D)
                        PUDR = TXD_encoded;                 
                end
            end

            // IDLE_I2B, pasar la segunda parte de IDLE en par
            IDLE_I2B: begin
                tx_even = `FALSE;
                TX_OSET_indicate = `TRUE;
                PUDR = `DATA_CODE_D16_2_10B; // /D16.2/
                nxt_state = GENERATE_CODE_GROUPS;
            end

            default : nxt_state = GENERATE_CODE_GROUPS;
        endcase
    end
endmodule



/*-----------------------------------------------------------------------------
------Modulo para instanciar transmit ordered set y transmit code-group--------
-----------------------------------------------------------------------------*/

module TRANSMIT (
    input mr_main_reset,
    input GTX_CLK,
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,
   // input [2:0] xmit,
    output transmitting,
    output [9:0] PUDR);


    // variables internas de TX
    wire TX_OSET_indicate;
    wire [6:0] tx_o_set;
    wire tx_even;

    TRANSMIT_OS ordered_set (
        // entradas de TX ordered set
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .TXD(TXD[7:0]),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .tx_even(tx_even),
        .TX_OSET_indicate(TX_OSET_indicate),
        // salidas de TX ordered set
        .tx_o_set(tx_o_set),
        .transmitting(transmitting)
    );

    TRANSMIT_CG code_group (
        // entradas de TX code group
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .tx_o_set(tx_o_set),
        .TXD(TXD[7:0]),
        // salidas de TX code group
        .tx_even(tx_even),
        .TX_OSET_indicate(TX_OSET_indicate),
        .PUDR(PUDR[9:0])
    );
endmodule