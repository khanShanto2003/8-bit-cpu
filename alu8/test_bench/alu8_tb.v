`timescale 1ns/1ps

module alu8_tb;

reg [7:0] A;
reg [7:0] B;
reg [2:0] opcode;

wire [7:0] result;
wire carry;
    

alu8 DUT(
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .carry(carry)
);


initial begin

    // VCD file for GTKWave
    $dumpfile("alu.vcd");
    $dumpvars(0,alu8_tb);


    $monitor("Time=%0t A=%b B=%b OP=%b RESULT=%b CARRY=%b",
              $time,A,B,opcode,result,carry);


    A = 8'd10;
    B = 8'd5;


    opcode = 3'b000; #10; // ADD
    opcode = 3'b001; #10; // SUB
    opcode = 3'b010; #10; // AND
    opcode = 3'b011; #10; // OR
    opcode = 3'b100; #10; // XOR
    opcode = 3'b101; #10; // NOT
    opcode = 3'b110; #10; // SHIFT LEFT
    opcode = 3'b111; #10; // SHIFT RIGHT


    $finish;

end

endmodule
