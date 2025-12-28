module forwarding_unit (
    // ID stage
    input  wire [4:0]  i_ID_rs1_addr,
    input  wire [4:0]  i_ID_rs2_addr,
    // EX stage
    input  wire [4:0]  i_EX_rs1_addr,
    input  wire [4:0]  i_EX_rs2_addr,
    // MEM Stage
    input  wire [31:0] i_MEM_inst,
    input  wire [4:0]  i_MEM_rs2_addr,
    input  wire        i_MEM_rd_wren,
    input  wire [4:0]  i_MEM_rd_addr,     
    // WB Stage
    input  wire [31:0] i_WB_inst,
    input  wire        i_WB_rd_wren,
    input  wire [4:0]  i_WB_rd_addr,
    // Forwarding control outputs
    output reg  [1:0]  o_forward_sel_A,
    output reg  [1:0]  o_forward_sel_B,
    output reg         o_forward_sel_rs1,
    output reg         o_forward_sel_rs2,
    output reg         o_forward_sel_st
);
    // 00 -> Use register file
    // 10 -> Forward from EX/MEM
    // 01 -> Forward from MEM/WB
    wire [6:0] w_MEM_opcode = i_MEM_inst[6:0];
    wire [6:0] w_WB_opcode  = i_WB_inst[6:0];
    wire w_MEM_load  = (~w_MEM_opcode[6] & ~w_MEM_opcode[5] & ~w_MEM_opcode[4] & ~w_MEM_opcode[3] & ~w_MEM_opcode[2] &  w_MEM_opcode[1] &  w_MEM_opcode[0]); // 0100011
    wire w_MEM_store = (~w_MEM_opcode[6] &  w_MEM_opcode[5] & ~w_MEM_opcode[4] & ~w_MEM_opcode[3] & ~w_MEM_opcode[2] &  w_MEM_opcode[1] &  w_MEM_opcode[0]); // 0100011
    wire w_WB_load   = (~w_WB_opcode[6]  & ~w_WB_opcode[5]  & ~w_WB_opcode[4]  & ~w_WB_opcode[3]  & ~w_WB_opcode[2]  &  w_WB_opcode[1]  &  w_WB_opcode[0]);  // 0000011
    always @(*) begin
        o_forward_sel_A = 2'b00;
        o_forward_sel_B = 2'b00;
        o_forward_sel_rs1 = 1'b0;
        o_forward_sel_rs2 = 1'b0;
        o_forward_sel_st = 1'b0;

        // ---------- EX/MEM forwarding (highest priority) ----------
        if (i_MEM_rd_wren && (i_MEM_rd_addr != 5'd0) &&
            (i_MEM_rd_addr == i_EX_rs1_addr))
            o_forward_sel_A = 2'b10;
        // ---------- MEM/WB forwarding ----------
        else if (i_WB_rd_wren && (i_WB_rd_addr != 5'd0) &&
            (i_WB_rd_addr == i_EX_rs1_addr))
            o_forward_sel_A = 2'b01;

        // ---------- EX/MEM forwarding (highest priority) ----------
        if (i_MEM_rd_wren && (i_MEM_rd_addr != 5'd0) &&
            (i_MEM_rd_addr == i_EX_rs2_addr))
            o_forward_sel_B = 2'b10;
        // ---------- MEM/WB forwarding ----------
        else if (i_WB_rd_wren && (i_WB_rd_addr != 5'd0) &&
            (i_WB_rd_addr == i_EX_rs2_addr))
            o_forward_sel_B = 2'b01;

        // ---------- ID/WB forwarding ----------
        if (i_WB_rd_wren && (i_WB_rd_addr != 5'd0) &&
            (i_WB_rd_addr == i_ID_rs1_addr))
            o_forward_sel_rs1 = 1'b1;
        // ---------- ID/WB forwarding ----------
        if (i_WB_rd_wren && (i_WB_rd_addr != 5'd0) &&
            (i_WB_rd_addr == i_ID_rs2_addr))
            o_forward_sel_rs2 = 1'b1;

        // ---------- LOAD/STORE forwarding ----------
        if (w_MEM_store && w_WB_load &&
            (i_MEM_rs2_addr == i_WB_rd_addr))
            o_forward_sel_st = 1'b1;
    end

endmodule