// ir8_tb.v
`timescale 1ns/1ps

module ir8_tb;

    reg        clk;
    reg        reset;
    reg        ir_load;
    reg  [7:0] instr_in;
    wire [3:0] opcode;
    wire [3:0] operand;

    ir8 uut (
        .clk      (clk),
        .reset    (reset),
        .ir_load  (ir_load),
        .instr_in (instr_in),
        .opcode   (opcode),
        .operand  (operand)
    );

  
    always #5 clk = ~clk;

    initial begin
        $dumpfile("ir8_tb.vcd");
        $dumpvars(0, ir8_tb);

        clk      = 0;
        reset    = 1;
        ir_load  = 0;
        instr_in = 8'd0;

        
        #10 reset = 0;

        
instr_in = 8'b0001_1110;
        ir_load  = 1;
        #10;
        ir_load  = 0;

       
        instr_in = 8'b1111_1111; 
        #10;
        #10;

        
        instr_in = 8'b0010_1111;
        ir_load  = 1;
        #10;
        ir_load  = 0;

        instr_in = 8'b1110_0000;
        ir_load  = 1;
        #10;
        ir_load  = 0;

        
        instr_in = 8'b1111_0000;
        ir_load  = 1;
        #10;
        ir_load  = 0;

        reset = 1;
        #10;
        reset = 0;

        #20 $finish;
    end

    initial begin
        $monitor("t=%0t reset=%b load=%b instr_in=%b opcode=%h operand=%h",
                  $time, reset, ir_load, instr_in, opcode, operand);
    end

endmodule
