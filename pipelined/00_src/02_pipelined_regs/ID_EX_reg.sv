//======================================================================
//  ID/EX Pipeline Register
//----------------------------------------------------------------------
//  Holds all signals passed from ID → EX stage
//  Includes: 
//    • PC, PC+4, instruction
//    • Register read data (rs1, rs2)
//    • Immediate value
//    • ALU control signals
//    • Branch control signals
//    • Memory access signals
//    • Write-back control signals
//    • PC selection control
//
//  Supports:
//    • STALL (hold values)
//    • FLUSH (clear to zero)
//    • Active-low reset
//======================================================================
module ID_EX_reg(
    input wire        i_clk,        // Clock
    input wire        i_reset,      // Active-low reset
    input wire        i_stall,      // Stall signal (0 = update, 1 = hold)
    input wire        i_flush,      // Flush signal (0 = normal, 1 = clear)

    input wire [31:0] i_pc,         // Incoming PC value
    output reg [31:0] o_pc,         // Latched PC output
    
    input wire [31:0] i_inst,       // Incoming instruction
    output reg [31:0] o_inst,       // Latched instruction output

    input wire [4:0]  i_rs1_addr,   // Incoming rs1 address
    output reg [4:0]  o_rs1_addr,   // Latched

    input wire [4:0]  i_rs2_addr,   // Incoming rs2 address
    output reg [4:0]  o_rs2_addr,   // Latched

    input wire [4:0]  i_rd_addr,    // Incoming rd address
    output reg [4:0]  o_rd_addr,    // Latched rd address

    input wire [31:0] i_rs1_data,   // Incoming rs1 data
    output reg [31:0] o_rs1_data,   // Latched rs1 data

    input wire [31:0] i_rs2_data,   // Incoming rs2 data
    output reg [31:0] o_rs2_data,   // Latched rs2 data

    input wire [31:0] i_imm,        // Incoming immediate value
    output reg [31:0] o_imm,        // Latched immediate value
    // Control signals
    input wire       i_op_a_sel,    // Incoming operand A select
    output reg       o_op_a_sel,    // Latched operand A select

    input wire       i_op_b_sel,    // Incoming operand B select
    output reg       o_op_b_sel,    // Latched operand B select

    input wire [3:0] i_alu_op,      // Incoming ALU operation
    output reg [3:0] o_alu_op,      // Latched ALU operation

    input wire       i_br_un,       // Incoming branch unsigned
    output reg       o_br_un,       // Latched branch unsigned

    input wire       i_mem_rw,      // Incoming memory read/write
    output reg       o_mem_rw,      // Latched memory read/write

    input wire [2:0] i_type_access, // Incoming type of memory access
    output reg [2:0] o_type_access, // Latched type of memory access

    input wire [1:0] i_wb_sel,      // Incoming write-back select
    output reg [1:0] o_wb_sel,      // Latched write-back select

    input wire       i_rd_wren,     // Incoming rd write enable
    output reg       o_rd_wren,     // Latched rd write enable

    input wire       i_insn_vld,     // Incoming instruction valid
    output reg       o_insn_vld      // Latched instruction valid
);

    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            o_pc          <= 32'b0;
            o_inst        <= 32'h13; // NOP instruction
            o_rs1_addr    <= 5'b0;
            o_rs2_addr    <= 5'b0;
            o_rd_addr     <= 5'b0;
            o_rs1_data    <= 32'b0;
            o_rs2_data    <= 32'b0;
            o_imm         <= 32'b0;
            o_op_a_sel    <= 1'b0;
            o_op_b_sel    <= 1'b0;
            o_alu_op      <= 4'b0;
            o_br_un       <= 1'b0;
            o_mem_rw      <= 1'b0;
            o_type_access <= 3'b0;
            o_wb_sel      <= 2'b0;
            o_rd_wren     <= 1'b0;
            o_insn_vld    <= 1'b0;
        end else if (i_flush) begin
            o_pc          <= 32'b0;
            o_inst        <= 32'h13; // NOP instruction
            o_rs1_addr    <= 5'b0;
            o_rs2_addr    <= 5'b0;
            o_rd_addr     <= 5'b0;
            o_rs1_data    <= 32'b0;
            o_rs2_data    <= 32'b0;
            o_imm         <= 32'b0;
            o_op_a_sel    <= 1'b0;
            o_op_b_sel    <= 1'b0;
            o_alu_op      <= 4'b0;
            o_br_un       <= 1'b0;
            o_mem_rw      <= 1'b0;
            o_type_access <= 3'b0;
            o_wb_sel      <= 2'b0;
            o_rd_wren     <= 1'b0;
            o_insn_vld    <= 1'b0;
        end else if (!i_stall) begin
            o_pc          <= i_pc;
            o_inst        <= i_inst;
            o_rs1_addr    <= i_rs1_addr;
            o_rs2_addr    <= i_rs2_addr;
            o_rd_addr     <= i_rd_addr;
            o_rs1_data    <= i_rs1_data;
            o_rs2_data    <= i_rs2_data;
            o_imm         <= i_imm;
            o_op_a_sel    <= i_op_a_sel;
            o_op_b_sel    <= i_op_b_sel;
            o_alu_op      <= i_alu_op;
            o_br_un       <= i_br_un;
            o_mem_rw      <= i_mem_rw;
            o_type_access <= i_type_access;
            o_wb_sel      <= i_wb_sel;
            o_rd_wren     <= i_rd_wren;
            o_insn_vld    <= i_insn_vld;
        end
    end

endmodule