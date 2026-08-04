module control_unit(
    input  [3:0] opcode,    
    input        zero_flag, 
    output reg   reg_write, 
    output reg   mem_read,   
    output reg   mem_write, 
    output reg   pc_load,   
    output reg   halt       
);
always @(*)
begin

    reg_write = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    pc_load   = 1'b0;
    halt      = 1'b0;

    case(opcode)

        4'b0000, // ADD
        4'b0001, // SUB
        4'b0010, // AND
        4'b0011, // OR
        4'b0100, // XOR
        4'b0101, // NOT A
        4'b0110, // SHIFT LEFT
        4'b0111: // SHIFT RIGHT
        begin
            reg_write = 1'b1;
            mem_read  = 1'b1;   
        end

        4'b1000: begin        // LOAD
            reg_write = 1'b1;
            mem_read  = 1'b1;
        end

        4'b1001: begin        // STORE
            mem_write = 1'b1;
        end

        4'b1010: begin        // JUMP (unconditional)
            pc_load = 1'b1;
        end

        4'b1011: begin        // JZ (jump if accumulator == 0)
            pc_load = zero_flag;
        end

        4'b1100: begin        // HALT
            halt = 1'b1;
        end

        default: begin

        end

    endcase
end

endmodule
