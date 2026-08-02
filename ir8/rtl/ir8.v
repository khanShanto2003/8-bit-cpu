
module ir8 (
    input  wire       clk,
    input  wire        reset,     
    input  wire        ir_load,   
    input  wire [7:0]  instr_in, 
    output reg  [3:0]  opcode,    
    output reg  [3:0]  operand    
);

    always @(posedge clk) begin
        if (reset) begin
            opcode  <= 4'd0;
            operand <= 4'd0;
        end
        else if (ir_load) begin
            opcode  <= instr_in[7:4];
            operand <= instr_in[3:0];
        end
        
    end

endmodule
