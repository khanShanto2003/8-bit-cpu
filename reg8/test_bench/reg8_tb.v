`timescale 1ns/1ps

module reg8_tb;

reg clk;
reg rst;
reg en;
reg [7:0] d;
wire [7:0] q;

reg8 uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d),
    .q(q)
);

always #5 clk = ~clk;

initial
begin

    $dumpfile("reg8.vcd");
    $dumpvars(0, reg8_tb);


    $monitor("Time=%0t clk=%b rst=%b en=%b d=%b q=%b",
              $time, clk, rst, en, d, q);

    clk = 0;
    rst = 1;
    en = 0;
    d = 8'b00000000;

    #10 rst = 0;

    en = 1;
    d = 8'b10101010;
    #10;

    d = 8'b11001100;
    #10;

    en = 0;
    d = 8'b11111111;
    #10;

    en = 1;
    #10;

    rst = 1;
    #10;

    $finish;
end

endmodule
