// pc8_tb.v
`timescale 1ns/1ps

module pc8_tb;

    reg        clk;
    reg        reset;
    reg        pc_enable;
    reg        pc_load;
    reg  [7:0] pc_in;
    wire [7:0] pc_out;

    pc8 uut (
        .clk       (clk),
        .reset     (reset),
        .pc_enable (pc_enable),
        .pc_load   (pc_load),
        .pc_in     (pc_in),
        .pc_out    (pc_out)
    );

    
    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc8_tb.vcd");
        $dumpvars(0, pc8_tb);

        clk       = 0;
        reset     = 1;
        pc_enable = 0;
        pc_load   = 0;
        pc_in     = 8'd0;

        #10 reset = 0;

        pc_enable = 1;
        #10; // pc_out should become 1
        #10; // 2
        #10; // 3
        #10; // 4
        #10; // 5
        pc_enable = 0;

        #10;
        #10;

        pc_load = 1;
        pc_in   = 8'h2A;
        #10;
        pc_load = 0;

        pc_enable = 1;
        #10; // 0x2B
        #10; // 0x2C
        pc_enable = 0;

        reset = 1;
        #10;
        reset = 0;

        #20 $finish;
    end

    initial begin
        $monitor("t=%0t reset=%b enable=%b load=%b pc_in=%h pc_out=%h",
                  $time, reset, pc_enable, pc_load, pc_in, pc_out);
    end

endmodule
