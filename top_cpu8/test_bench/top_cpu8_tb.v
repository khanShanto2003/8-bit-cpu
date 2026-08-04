`timescale 1ns/1ps
module top_cpu8_tb;
    reg clk, reset;

    top_cpu8 uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("top_cpu8_tb.vcd");
        $dumpvars(0, top_cpu8_tb);

        clk   = 0;
        reset = 1;
        #12 reset = 0;

        #200;

        $display("ACC (accumulator) = %d", uut.acc_q);
        $display("mem[7] (result)   = %d", uut.MEM.mem[7]);

        $finish;
    end
endmodule
