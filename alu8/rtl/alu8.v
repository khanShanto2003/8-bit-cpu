module alu8(
    input  [7:0] A,
    input  [7:0] B,
    input  [2:0] opcode,
    output reg [7:0] result,
    output reg carry
);

always @(*)
begin
    carry = 1'b0;

    case(opcode)

        3'b000: begin        // ADD
            {carry,result} = A + B;
        end

        3'b001: begin        // SUB
            result = A - B;
        end

        3'b010: begin        // AND
            result = A & B;
        end

        3'b011: begin        // OR
            result = A | B;
        end

        3'b100: begin        // XOR
            result = A ^ B;
        end

        3'b101: begin        // NOT A
            result = ~A;
        end

        3'b110: begin        // SHIFT LEFT
            result = A << 1;
        end

        3'b111: begin        // SHIFT RIGHT
            result = A >> 1;
        end

        default: begin
            result = 8'b0;
        end

    endcase
end

endmodule
