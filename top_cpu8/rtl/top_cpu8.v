module top_cpu8 (
    input  wire       clk,
    input  wire        reset,
    output wire [7:0]  acc_out,   
    output wire [7:0]  pc_debug,   
    output wire        halted_out 
);

    localparam S_FETCH = 1'b0;
    localparam S_EXEC  = 1'b1;
    reg state;
    reg halted;

    wire [7:0] pc_out;
    wire [7:0] pc_jump_target;
    wire       pc_load_final, pc_enable_final;

    wire [3:0] mem_addr;
    wire [7:0] mem_data_out;
    wire       mem_read_final, mem_write_final;

    wire [3:0] ir_opcode, ir_operand;
    wire       ir_load_final;

    wire reg_write_ctrl, mem_read_ctrl, mem_write_ctrl, pc_load_ctrl, halt_ctrl;
    wire [7:0] acc_q;
    wire       zero_flag;

    wire [7:0] alu_result;
    wire       alu_carry;

    pc8 PC (
        .clk(clk),
        .reset(reset),
        .pc_enable(pc_enable_final),
        .pc_load(pc_load_final),
        .pc_in(pc_jump_target),
        .pc_out(pc_out)
    );

    assign pc_jump_target  = {4'b0000, ir_operand};
    assign pc_enable_final = (state == S_FETCH) && !halted;
    assign pc_load_final   = (state == S_EXEC)  && pc_load_ctrl;


    ir8 IR (
        .clk(clk),
        .reset(reset),
        .ir_load(ir_load_final),
        .instr_in(mem_data_out),
        .opcode(ir_opcode),
        .operand(ir_operand)
    );

    assign ir_load_final = (state == S_FETCH) && !halted;


    mem8 MEM (
        .clk(clk),
        .addr(mem_addr),
        .data_in(acc_q),
        .mem_read(mem_read_final),
        .mem_write(mem_write_final),
        .data_out(mem_data_out)
    );

    assign mem_addr        = (state == S_FETCH) ? pc_out[3:0] : ir_operand;
    assign mem_read_final  = (state == S_FETCH) ? 1'b1 : mem_read_ctrl;
    assign mem_write_final = (state == S_EXEC)  && mem_write_ctrl;


    reg8 ACC (
        .clk(clk),
        .rst(reset),
        .en((state == S_EXEC) && reg_write_ctrl),
        .d(alu_result),
        .q(acc_q)
    );

    assign zero_flag = ~|acc_q;


    alu8 ALU (
        .A(acc_q),
        .B(mem_data_out),
        .opcode(ir_opcode[2:0]),
        .result(alu_result),
        .carry(alu_carry)
    );


    control_unit CU (
        .opcode(ir_opcode),
        .zero_flag(zero_flag),
        .reg_write(reg_write_ctrl),
        .mem_read(mem_read_ctrl),
        .mem_write(mem_write_ctrl),
        .pc_load(pc_load_ctrl),
        .halt(halt_ctrl)
    );


    always @(posedge clk) begin
    $display("----------------------------------------");
    if (state)
        $display("State      = EXEC");
    else
        $display("State      = FETCH");

    $display("PC         = %d", pc_out);
    $display("Opcode     = %b", ir_opcode);
    $display("Operand    = %d", ir_operand);
    $display("MemoryData = %d", mem_data_out);
    $display("ACC        = %d", acc_q);
    $display("ALU Result = %d", alu_result);
    $display("reg_write  = %b", reg_write_ctrl);
    $display("mem_read   = %b", mem_read_ctrl);
    $display("mem_write  = %b", mem_write_ctrl);

    if (reset) begin
        state  <= S_FETCH;
        halted <= 1'b0;
    end else begin
        state <= ~state;
        if ((state == S_EXEC) && halt_ctrl)
            halted <= 1'b1;
    end
end


    assign acc_out    = acc_q;
    assign pc_debug   = pc_out;
    assign halted_out = halted;

endmodule
