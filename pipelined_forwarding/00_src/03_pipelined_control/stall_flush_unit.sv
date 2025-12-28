module stall_flush_unit (
    input  wire        i_clk,
    input  wire        i_reset,
    // ID stage
    input  wire [4:0]  i_ID_rs1_addr,
    input  wire [4:0]  i_ID_rs2_addr,
    // EX stage
    input  wire        i_EX_pc_sel,
    input  wire        i_EX_rd_wren,
    input  wire [4:0]  i_EX_rd_addr,
    input  wire [31:0] i_EX_inst,
    // MEM stage
    input  wire [4:0]  i_MEM_rd_addr,
    input  wire        i_MEM_rd_wren,
    input  wire [31:0] i_MEM_inst,
    // WB stage
    input  wire        i_WB_rd_wren,
    input  wire [4:0]  i_WB_rd_addr,
    // Outputs
    output reg        o_pc_stall,
    output reg        o_IF_ID_stall,
    output reg        o_IF_ID_flush,
    output reg        o_ID_EX_stall,
    output reg        o_ID_EX_flush,
    output reg        o_EX_MEM_stall,
    output reg        o_EX_MEM_flush,
    output reg        o_MEM_WB_stall,
    output reg        o_MEM_WB_flush
);
    wire [6:0] w_EX_opcode = i_EX_inst[6:0];
    wire [6:0] w_MEM_opcode = i_MEM_inst[6:0];
    wire w_EX_load  = (~w_EX_opcode[6]  & ~w_EX_opcode[5]  & ~w_EX_opcode[4]  & ~w_EX_opcode[3]  & ~w_EX_opcode[2]  &  w_EX_opcode[1]  &  w_EX_opcode[0]);  // 0000011
    wire w_MEM_load = (~w_MEM_opcode[6] & ~w_MEM_opcode[5] & ~w_MEM_opcode[4] & ~w_MEM_opcode[3] & ~w_MEM_opcode[2] &  w_MEM_opcode[1] &  w_MEM_opcode[0]); // 0000011

    wire w_stall_load;

    load_pending load_pending(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_is_load(w_MEM_load),
        .r_stall_load(w_stall_load)
    );

    initial begin
        o_pc_stall     = 1'b0;
        o_IF_ID_stall  = 1'b0;
        o_IF_ID_flush  = 1'b0;
        o_ID_EX_stall  = 1'b0;
        o_ID_EX_flush  = 1'b0;
        o_EX_MEM_stall = 1'b0;
        o_EX_MEM_flush = 1'b0;
        o_MEM_WB_stall = 1'b0;
        o_MEM_WB_flush = 1'b0;
    end

    always @(*) begin
        o_pc_stall     = 1'b0;
        o_IF_ID_stall  = 1'b0;
        o_IF_ID_flush  = 1'b0;
        o_ID_EX_stall  = 1'b0;
        o_ID_EX_flush  = 1'b0;
        o_EX_MEM_stall = 1'b0;
        o_EX_MEM_flush = 1'b0;
        o_MEM_WB_stall = 1'b0;
        o_MEM_WB_flush = 1'b0;
        // Load stall
        if(w_MEM_load & !w_stall_load) begin
            o_pc_stall     = 1;
            o_IF_ID_stall  = 1;
            o_ID_EX_stall  = 1;
            o_EX_MEM_stall = 1;
            o_MEM_WB_flush = 1;
        end else
        //Branch hazard detection
        if (i_EX_pc_sel) begin
            o_IF_ID_flush  = 1;
            o_ID_EX_flush  = 1;
        end else
        //Load-Use Hazard
        if((i_EX_rd_wren && w_EX_load && //ALU -> ALU
                (i_EX_rd_addr != 5'd0) &&
                ((i_EX_rd_addr == i_ID_rs1_addr) || (i_EX_rd_addr == i_ID_rs2_addr))
            ))
        begin
            o_pc_stall     = 1;
            o_IF_ID_stall  = 1;
            o_ID_EX_flush  = 1;
        end
    end

endmodule
