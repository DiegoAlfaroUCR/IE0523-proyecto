`include "Transmisor.v"
//Modulo probador
module tester_TX_OS (
    output reg mr_main_reset,
    output reg GTX_CLK,
    output reg [7:0] TXD,
    output reg TX_EN,
    output reg TX_ER);


    always begin
        GTX_CLK = 1'b0; 
        #1;
        GTX_CLK = 1'b1; 
        #1;
    end


    initial begin
        
        //Se inicializan las variables provenientes del GMII
        //TXD = 8'h00;
        TX_EN = 1'b0;
        TX_ER = 1'b0;
        TXD = 8'h00;

        //Se hace reset
        mr_main_reset = 1'b1; 
        #2;
        mr_main_reset = 1'b0;


        #10;
        TX_EN = 1'b1; //Se activa enable
        #3;
        //Data a transmitir
        TXD = 8'h01;
        #2;
        TXD = 8'h03;
        #2;
        TXD = 8'h9A;
        #2;
        TXD = 8'hB5;
        #2;
        TXD = 8'h42;
        #2;
        TXD = 8'h02;
        #2;
        TXD = 8'h42;
        #2;
        TXD = 8'h9A;
        #2;
        TXD = 8'hB5;
        #2;
        TXD = 8'h01;
        #2;
        TXD = 8'hC5;
        TX_EN =1'b0; //Se desactiva enable
        TXD = 8'h00;
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

    initial begin
        $dumpfile("Resultados.vcd");
        $dumpvars(-1, testbench_TX_OS);
    end

    tester_TX_OS probador (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TXD(TXD[7:0])
    );
    ENCODE encodiando (
        .clk(GTX_CLK),
        .reset(mr_main_reset)
    );//

    TRANSMIT Trans (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TXD(TXD[7:0]),
        .transmitting(transmitting)
    );
endmodule