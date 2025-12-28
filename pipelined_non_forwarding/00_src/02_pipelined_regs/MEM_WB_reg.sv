module MEM_WB_reg(
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

    input wire [31:0] i_alu_data,   // Incoming ALU data
    output reg [31:0] o_alu_data,   // Latched ALU
    
    input wire [31:0] i_ld_data,   // Incoming load data
    output reg [31:0] o_ld_data,   // Latched load data
    // Control signals
    input wire [1:0] i_wb_sel,      // Incoming write-back select
    output reg [1:0] o_wb_sel,      // Latched write-back select

    input wire       i_rd_wren,     // Incoming rd write enable
    output reg       o_rd_wren,     // Latched rd write enable
    
    input wire       i_insn_vld,     // Incoming instruction valid
    output reg       o_insn_vld,     // Latched instruction valid

    input wire       i_pc_sel,     // Incoming pc select
    output reg       o_pc_sel      // Latched pc select
);

    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin          
            o_pc       <= 32'b0;
            o_inst     <= 32'h00;
            o_rd_addr  <= 5'b0;
            o_alu_data <= 32'b0;
            o_wb_sel   <= 2'b0;
            o_rd_wren  <= 1'b0;
            o_insn_vld <= 1'b0;
            o_pc_sel   <= 1'b0;
            o_ld_data <= 32'b0;
        end
        else if (i_flush) begin
            o_pc       <= 32'b0;
            o_inst     <= 32'h13; // NOP instruction
            o_rd_addr  <= 5'b0;
            o_alu_data <= 32'b0;
            o_wb_sel   <= 2'b0;
            o_rd_wren  <= 1'b0;
            o_insn_vld <= 1'b0;
            o_pc_sel   <= 1'b0;
            o_ld_data <= 32'b0;
        end
        else if (!i_stall) begin
            o_pc       <= i_pc;
            o_inst     <= i_inst;
            o_rd_addr  <= i_rd_addr;
            o_alu_data <= i_alu_data;
            o_wb_sel   <= i_wb_sel;
            o_rd_wren  <= i_rd_wren;
            o_insn_vld <= i_insn_vld;
            o_pc_sel   <= i_pc_sel;
            o_ld_data  <= i_ld_data;
        end
    end
endmodule