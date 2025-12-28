module WB_Extra_reg (
    input wire        i_clk,        // Clock
    input wire        i_reset,      // Active-low reset
    input wire        i_stall,      // Stall signal (0 = update, 1 = hold)
    input wire        i_flush,      // Flush signal (0 = normal, 1 = clear)

    input wire [31:0] i_pc,       // Incoming PC+4 value
    output reg [31:0] o_pc,       // Latched PC+4 output
    
    input wire [31:0] i_inst,       // Incoming instruction
    output reg [31:0] o_inst,       // Latched instruction output

    input wire [4:0]  i_rd_addr,    // Incoming rd address
    output reg [4:0]  o_rd_addr,    // Latched rd address

    input wire       i_rd_wren,     // Incoming rd write enable
    output reg       o_rd_wren,     // Latched rd write enable

    input wire       i_rd_data,     // Incoming rd data
    output reg       o_rd_data      // Latched rd data
);
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin          
            o_pc     <= 32'b0;
            o_inst   <= 32'h00;
            o_rd_wren<= 32'h00;
            o_rd_addr<= 32'h00;
            o_rd_data<= 32'h00;
        end 
        else if(i_flush) begin
            o_pc     <= 32'b0;
            o_inst   <= 32'h13; // NOP instruction
            o_rd_wren<= 32'h00;
            o_rd_addr<= 32'h00;
            o_rd_data<= 32'h00;
        end
        else if(!i_stall) begin
            o_pc     <= i_pc;
            o_inst   <= i_inst;
            o_rd_wren<= i_rd_wren;
            o_rd_addr<= i_rd_addr;
            o_rd_data<= i_rd_data;
        end
    end

endmodule