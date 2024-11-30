//Modulo probador
module tester_TX_OS (
    output reg mr_main_reset,
    output reg GTX_CLK,
    output reg [7:0] TXD,
    output reg TX_EN,
    output reg TX_ER);


    always begin
        GTX_CLK = 1'b0; 
        #5;
        GTX_CLK = 1'b1; 
        #5;
    end


    initial begin
        
        //Se inicializan las variables provenientes del GMII
        //TXD = 8'h00;
        TX_EN = 1'b0;
        TX_ER = 1'b0;
        TXD = 8'h00;

        //Se hace reset
        mr_main_reset = 1'b1; 
        #10;
        mr_main_reset = 1'b0;


        #60;
        TX_EN = 1'b1; //Se activa enable
        #25;
        //Data a transmitir
        TXD = 8'h01; // Byte 1
        #10;
        TXD = 8'h03; // Byte 2
        #10;
        TXD = 8'h9A; // Byte 3
        #10;
        TXD = 8'hB5; // Byte 4
        #10;
        TXD = 8'h42; // Byte 5
        #10;
        TXD = 8'h02; // Byte 6
        #10;
        TXD = 8'h42; // Byte 7
        #10;
        TXD = 8'h9A; // Byte 8
        #10;
        TXD = 8'hB5; // Byte 9
        #10;
        TXD = 8'h00; // Byte 10
        #10;
        TX_EN = 1'b0; //Se desactiva enable

        #120;





        TX_EN = 1'b1; //Se activa enable
        #25;
        //Data a transmitir
        TXD = 8'h01; // Byte 1
        #10;
        TXD = 8'h03; // Byte 2
        #10;
        TXD = 8'h9A; // Byte 3
        #10;
        TXD = 8'hB5; // Byte 4
        #10;
        TXD = 8'h42; // Byte 5
        #10;
        TXD = 8'h02; // Byte 6
        #10;
        TXD = 8'h42; // Byte 7
        #10;
        TXD = 8'h9A; // Byte 8
        #10;
        TXD = 8'hB5; // Byte 9
        #10;
        TXD = 8'h01; // Byte 10
        #10;
        TXD = 8'h01; // Byte 10
        #10;
        TXD = 8'hC5; // Byte 11
        #10;
        TXD = 8'h03; // Byte 12
        #10;
        TXD = 8'h9A; // Byte 13
        #10;
        TXD = 8'hB5; // Byte 14
        #10;
        TXD = 8'h42; // Byte 15
        #10;
        TXD = 8'h02; // Byte 16
        #10;
        TXD = 8'h42; // Byte 17
        #10;
        TXD = 8'h9A; // Byte 18
        #10;
        TXD = 8'hB5; // Byte 19
        #10;
        TXD = 8'h01; // Byte 20
        #10;
        TXD = 8'hC5; // Byte 21
        #10;
        TXD = 8'h03; // Byte 22
        #10;
        TXD = 8'h9A; // Byte 23
        #10;
        TXD = 8'hB5; // Byte 24
        #10;
        TXD = 8'h42; // Byte 25
        #10;
        TXD = 8'h02; // Byte 26
        #10;
        TXD = 8'h42; // Byte 27
        #10;
        TXD = 8'h9A; // Byte 28
        #10;
        TXD = 8'hB5; // Byte 29
        #10;
        TXD = 8'h01; // Byte 30
        #10;
        TXD = 8'hC5; // Byte 31
        #10;
        TXD = 8'h03; // Byte 32
        #10;
        TXD = 8'h9A; // Byte 33
        #10;
        TXD = 8'hB5; // Byte 34
        #10;
        TXD = 8'h42; // Byte 35
        #10;
        TXD = 8'h02; // Byte 36
        #10;
        TXD = 8'h42; // Byte 37
        #10;
        TXD = 8'h9A; // Byte 38
        #10;
        TXD = 8'hB5; // Byte 39
        #10;
        TXD = 8'h01; // Byte 40
        #10;
        TXD = 8'hC5; // Byte 41
        #10;
        TXD = 8'h03; // Byte 42
        #10;
        TXD = 8'h9A; // Byte 43
        #10;
        TXD = 8'hB5; // Byte 44
        #10;
        TXD = 8'h42; // Byte 45
        #10;
        TXD = 8'h02; // Byte 46
        #10;
        TXD = 8'h42; // Byte 47
        #10;
        TXD = 8'h9A; // Byte 48
        #10;
        TXD = 8'hB5; // Byte 49
        #10;
        TXD = 8'h01; // Byte 50
        #10;
        TXD = 8'hC5; // Byte 51
        #10;
        TXD = 8'h03; // Byte 52
        #10;
        TXD = 8'h9A; // Byte 53
        #10;
        TXD = 8'hB5; // Byte 54
        #10;
        TXD = 8'h42; // Byte 55
        #10;
        TXD = 8'h02; // Byte 56
        #10;
        TXD = 8'h42; // Byte 57
        #10;
        TXD = 8'h9A; // Byte 58
        #10;
        TXD = 8'hB5; // Byte 59
        #10;
        TXD = 8'h01; // Byte 60
        #10;
        TXD = 8'hC5; // Byte 61
        #10;
        TXD = 8'h03; // Byte 62
        #10;
        TXD = 8'h9A; // Byte 63
        #10;
        TXD = 8'hB5; // Byte 64
        #10;
        TX_EN =1'b0; //Se desactiva enable

        #100;
        $finish;
    end
endmodule