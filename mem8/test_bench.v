`timescale 1ns/1ps

module mem8_tb;

    reg         clk;
    reg  [3:0]  addr;
    reg  [7:0]  data_in;
    reg         mem_read;
    reg         mem_write;
    wire [7:0]  data_out;

    mem8 uut (
        .clk       (clk),
        .addr      (addr),
        .data_in   (data_in),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .data_out  (data_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mem8_tb.vcd");
        $dumpvars(0, mem8_tb);
    end

    initial begin
        $monitor("time=%0t | addr=%d mem_read=%b mem_write=%b data_in=%d -> data_out=%d",
                  $time, addr, mem_read, mem_write, data_in, data_out);
    end

    initial begin
        clk = 0;
        mem_read  = 0;
        mem_write = 0;
        data_in   = 0;
        addr      = 0;

        mem_read = 1;
        addr = 4'd0; #10;  // expect LOAD 5  = 10000101
        addr = 4'd1; #10;  // expect ADD 6   = 00000110
        addr = 4'd2; #10;  // expect STORE 7 = 10010111
        addr = 4'd3; #10;  // expect HALT    = 11000000
        addr = 4'd5; #10;  // expect 10 (operand A)
        addr = 4'd6; #10;  // expect 20 (operand B)
        addr = 4'd7; #10;  // expect 0  (result, not written yet)

        mem_read = 0;
        #10;

        mem_write = 1;
        addr    = 4'd7;
        data_in = 8'd30;
        @(posedge clk);
        #1;
        mem_write = 0;

        mem_read = 1;
        addr = 4'd7;
        #10;
        mem_read = 0;

        mem_write = 1;
        addr    = 4'd9;
        data_in = 8'd99;
        @(posedge clk);
        #1;
        mem_write = 0;

        mem_read = 1;
        addr = 4'd9;
        #10;
        mem_read = 0;

        #10;
        $display("\n*** mem8 testbench finished ***\n");
        $finish;
    end

endmodule

