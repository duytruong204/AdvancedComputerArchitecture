module load_pending(
    input wire i_clk,
    input wire i_reset,
    input wire i_is_load,
    output reg r_stall_load
);
    
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            r_stall_load <= 1'b0;
        end 
        else if(r_stall_load) begin
            r_stall_load <= 1'b0;
        end
        else if(i_is_load) begin
            r_stall_load <= 1'b1;
        end
    end

endmodule