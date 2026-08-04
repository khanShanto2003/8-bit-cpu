`timescale 1ns/1ps

module control_unit_tb;

    reg  [3:0] opcode;
    reg        zero_flag;
    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       pc_load;
    wire       halt;

    integer errors = 0;

    // DUT instantiation
    control_unit uut (
        .opcode    (opcode),
        .zero_flag (zero_flag),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .pc_load   (pc_load),
        .halt      (halt)
    );

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
    end

    task check;
        input [127:0] name;
        input exp_reg_write, exp_mem_read, exp_mem_write, exp_pc_load, exp_halt;
        begin
            #1; 
            if (reg_write !== exp_reg_write || mem_read !== exp_mem_read ||
                mem_write !== exp_mem_write || pc_load !== exp_pc_load ||
                halt !== exp_halt) begin
                $display("FAIL [%0s] opcode=%b zero=%b -> got rw=%b mr=%b mw=%b pcl=%b halt=%b | expected rw=%b mr=%b mw=%b pcl=%b halt=%b",
                    name, opcode, zero_flag, reg_write, mem_read, mem_write, pc_load, halt,
                    exp_reg_write, exp_mem_read, exp_mem_write, exp_pc_load, exp_halt);
                errors = errors + 1;
            end
            else begin
                $display("PASS [%0s] opcode=%b zero=%b -> rw=%b mr=%b mw=%b pcl=%b halt=%b",
                    name, opcode, zero_flag, reg_write, mem_read, mem_write, pc_load, halt);
            end
        end
    endtask

    initial begin
        zero_flag = 1'b0;

        opcode = 4'b0000; check("ADD", 1,1,0,0,0);
        opcode = 4'b0001; check("SUB", 1,1,0,0,0);
        opcode = 4'b0010; check("AND", 1,1,0,0,0);
        opcode = 4'b0011; check("OR",  1,1,0,0,0);
        opcode = 4'b0100; check("XOR", 1,1,0,0,0);
        opcode = 4'b0101; check("NOT", 1,1,0,0,0);
        opcode = 4'b0110; check("SHL", 1,1,0,0,0);
        opcode = 4'b0111; check("SHR", 1,1,0,0,0);

        opcode = 4'b1000; check("LOAD",  1,1,0,0,0);
        opcode = 4'b1001; check("STORE", 0,0,1,0,0);
        opcode = 4'b1010; check("JUMP",  0,0,0,1,0);

        opcode = 4'b1011; zero_flag = 1'b0; check("JZ_not_taken", 0,0,0,0,0);
        opcode = 4'b1011; zero_flag = 1'b1; check("JZ_taken",     0,0,0,1,0);
        zero_flag = 1'b0; 

        opcode = 4'b1100; check("HALT", 0,0,0,0,1);

        opcode = 4'b1101; check("RESERVED_1101", 0,0,0,0,0);
        opcode = 4'b1110; check("RESERVED_1110", 0,0,0,0,0);
        opcode = 4'b1111; check("RESERVED_1111", 0,0,0,0,0);

        #5;
        if (errors == 0)
            $display("\n*** ALL TESTS PASSED ***\n");
        else
            $display("\n*** %0d TEST(S) FAILED ***\n", errors);

        $finish;
    end

endmodule
