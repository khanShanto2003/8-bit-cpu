module pc8 (
    input  wire       clk,
    input  wire       reset,     
    input  wire       pc_enable, 
    input  wire       pc_load,   
    input  wire [7:0] pc_in,     
    output reg  [7:0] pc_out     
);

    always @(posedge clk) begin
        if (reset)
            pc_out <= 8'd0;
        else if (pc_load)
            pc_out <= pc_in;      
        else if (pc_enable)
            pc_out <= pc_out + 8'd1;
        
    end

endmodule
