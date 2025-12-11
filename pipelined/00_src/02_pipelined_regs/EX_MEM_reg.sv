//======================================================================
//  EX/MEM Pipeline Register
//----------------------------------------------------------------------
//  Holds all signals passed from Execute → Memory stage.
//  Includes:
//    • PC+4
//    • Instruction
//    • ALU result
//    • rs2 data (used for store instructions)
//    • Memory access control signals
//    • Write-back control signals
//    • PC selection controls
//
//  Supports:
//    • STALL (holds outputs)
//    • FLUSH (outputs cleared)
//    • Active-low reset
//======================================================================
module EX_MEM_reg(
    input wire        i_clk,        // Clock
    input wire        i_reset,      // Active-low reset
    input wire        i_stall,      // Stall signal (0 = update, 1 = hold)
    input wire        i_flush,      // Flush signal (0 = normal, 1 = clear)

    input wire [31:0] i_pc,       // Incoming PC value
    output reg [31:0] o_pc,       // Latched PC output
    
    input wire [31:0] i_inst,       // Incoming instruction
    output reg [31:0] o_inst,       // Latched instruction output

    input wire [31:0] i_alu_data,   // Incoming ALU data
    output reg [31:0] o_alu_data,   // Latched ALU

    input wire [4:0]  i_rs1_addr,   // Incoming rs1 address
    output reg [4:0]  o_rs1_addr,   // Latched

    input wire [4:0]  i_rs2_addr,   // Incoming rs2 address
    output reg [4:0]  o_rs2_addr,   // Latched

    input wire [4:0]  i_rd_addr,    // Incoming rd address
    output reg [4:0]  o_rd_addr,    // Latched rd address

    input wire [31:0] i_rs2_data,   // Incoming rs2 data
    output reg [31:0] o_rs2_data,   // Latched rs2
    // Control signals
    input wire       i_mem_rw,      // Incoming memory read/write
    output reg       o_mem_rw,      // Latched memory read/write

    input wire [2:0] i_type_access, // Incoming type of memory access
    output reg [2:0] o_type_access, // Latched type of memory access

    input wire [1:0] i_wb_sel,      // Incoming write-back select
    output reg [1:0] o_wb_sel,      // Latched write-back select

    input wire       i_rd_wren,     // Incoming rd write enable
    output reg       o_rd_wren,     // Latched rd write enable

    input wire       i_insn_vld,     // Incoming instruction valid
    output reg       o_insn_vld,     // Latched instruction valid

    input wire       i_pc_sel,      // Incoming PC select
    output reg       o_pc_sel       // Latched PC select
);
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin          
            o_pc          <= 32'b0;
            o_inst        <= 32'h13; // NOP instruction
            o_alu_data    <= 32'b0;
            o_rs1_addr    <= 5'b0;
            o_rs2_addr    <= 5'b0;
            o_rd_addr     <= 5'b0;
            o_rs2_data    <= 32'b0;
            o_mem_rw      <= 1'b0;
            o_type_access <= 3'b0;
            o_wb_sel      <= 2'b0;
            o_rd_wren     <= 1'b0;
            o_insn_vld    <= 1'b0;
            o_pc_sel      <= 1'b0;
        end else if (i_flush) begin
            o_pc          <= 32'b0;
            o_inst        <= 32'h13; // NOP instruction
            o_alu_data    <= 32'b0;
            o_rs1_addr    <= 5'b0;
            o_rs2_addr    <= 5'b0;
            o_rd_addr     <= 5'b0;
            o_rs2_data    <= 32'b0;
            o_mem_rw      <= 1'b0;
            o_type_access <= 3'b0;
            o_wb_sel      <= 2'b0;
            o_rd_wren     <= 1'b0;
            o_insn_vld    <= 1'b0;
            o_pc_sel      <= 1'b0;
        end else if (!i_stall) begin
            o_pc          <= i_pc;
            o_inst        <= i_inst;
            o_alu_data    <= i_alu_data;
            o_rs1_addr    <= i_rs1_addr;
            o_rs2_addr    <= i_rs2_addr;
            o_rd_addr     <= i_rd_addr;
            o_rs2_data    <= i_rs2_data;
            o_mem_rw      <= i_mem_rw;
            o_type_access <= i_type_access;
            o_wb_sel      <= i_wb_sel;
            o_rd_wren     <= i_rd_wren;
            o_insn_vld    <= i_insn_vld;
            o_pc_sel      <= i_pc_sel;
        end
    end

endmodule