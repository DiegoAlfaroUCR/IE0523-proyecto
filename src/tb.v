`include "Transmisor.v"
//Modulo probador
module tester_TX_OS (
    output reg mr_main_reset,
    output reg GTX_CLK,
    output reg [7:0] TXD,
    output reg TX_EN,
    output reg TX_ER,
    output reg TX_OSET_indicate,
    output reg tx_even);

    always begin
        GTX_CLK = 1'b0; 
        #1;
        GTX_CLK = 1'b1; 
        #1;
    end


    always @(posedge GTX_CLK) begin
        tx_even = ~tx_even;
    end

    initial begin
        
        TX_OSET_indicate = 1;// Señal proveniente de la segunda maquina del transmisor
        tx_even = 1;// Señal proveniente de la segunda maquina del transmisor
        //Se inicializan las variables provenientes del GMII
        //TXD = 8'h00;
        TX_EN = 1'b0;
        TX_ER = 1'b0;

        //Se hace reset
        mr_main_reset = 1'b0; 
        #2;
        mr_main_reset = 1'b1;


        #10;
        TX_EN = 1'b1; //Se activa enable
        #2;
        //Data a transmitir
        TXD = 8'h01;
        #2;
        TXD = 8'h02;
        #2;
        TXD = 8'h03;
        #2;
        TXD = 8'h42;
        #2;
        TX_EN =1'b0; //Se desactiva enable
        #20;
        $finish;
    end
endmodule

//Modulo testbench
module testbench_TX_OS;
    wire GTX_CLK, TX_EN, TX_ER;
    wire [7:0] TXD;
    wire [9:0] tx_code_group;
    wire transmitting;
    wire TX_OSET_indicate;
    wire tx_even;

    initial begin
        $dumpfile("Resultados.vcd");
        $dumpvars(-1, testbench_TX_OS);
    end

    tester_TX_OS probador (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TX_OSET_indicate(TX_OSET_indicate),
        .tx_even(tx_even),
        .TXD(TXD[7:0])
    );
    TRANSMIT Trans (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
       // .TX_OSET_indicate(TX_OSET_indicate),
       // .tx_even(tx_even),
        .TXD(TXD[7:0]),
        .transmitting(transmitting)
    );
endmodule