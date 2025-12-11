module hazard_detector (
    input  wire        i_clk,
    input  wire        i_reset,
    // ID stage
    input  wire [4:0]  i_ID_rs1_addr,
    input  wire [4:0]  i_ID_rs2_addr,
    // EX stage
    input  wire [4:0]  i_EX_rs1_addr,
    input  wire [4:0]  i_EX_rs2_addr,
    input  wire        i_EX_rd_wren,
    input  wire [4:0]  i_EX_rd_addr,
    input  wire        i_EX_pc_sel,
    // MEM stage
    input  wire [4:0]  i_MEM_rd_addr,
    input  wire        i_MEM_rd_wren,
    input  wire [31:0] i_MEM_inst,
    // WB stage
    input  wire        i_WB_rd_wren,
    input  wire [4:0]  i_WB_rd_addr,
    // Outputs
    output reg         o_pc_stall,
    output reg         o_IF_ID_stall,
    output reg         o_IF_ID_flush,
    output reg         o_ID_EX_stall,
    output reg         o_ID_EX_flush,
    output reg         o_EX_MEM_stall,
    output reg         o_EX_MEM_flush,
    output reg         o_MEM_WB_stall,
    output reg         o_MEM_WB_flush
);
    wire [6:0] w_MEM_opcode = i_MEM_inst[6:0];

	wire w_MEM_load  = (~w_MEM_opcode[6] & ~w_MEM_opcode[5] & ~w_MEM_opcode[4] & ~w_MEM_opcode[3] & ~w_MEM_opcode[2] &  w_MEM_opcode[1] &  w_MEM_opcode[0]); // 0000011

    reg r_stall_load, r_stall_load_next;
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            r_stall_load <= 1'b0;
        end 
        else begin
            r_stall_load <= r_stall_load_next;
        end
    end

    always @(*) begin
        //Memory hazard detection
        if(r_stall_load) begin
            r_stall_load_next = 0;
        end else 
        if(w_MEM_load) begin
            r_stall_load_next = 1;
        end else begin
            r_stall_load_next = r_stall_load;
        end
    end

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
        if(w_MEM_load & !r_stall_load) begin
            o_pc_stall     = 1;
            o_IF_ID_stall  = 1;
            o_ID_EX_stall  = 1;
            o_EX_MEM_stall = 1;
            o_MEM_WB_stall = 1;
        end else
        //Load-use hazard detection
        if ((i_EX_rd_wren && //ALU -> ALU
                (i_EX_rd_addr != 5'd0) &&
                ((i_EX_rd_addr == i_ID_rs1_addr) || (i_EX_rd_addr == i_ID_rs2_addr))
            )
            ||
            (i_MEM_rd_wren && 
                (i_MEM_rd_addr != 5'd0) &&
                ((i_MEM_rd_addr == i_ID_rs1_addr) || (i_MEM_rd_addr == i_ID_rs2_addr))
            )
            ||
            (i_WB_rd_wren &&
                (i_WB_rd_addr != 5'd0) &&
                ((i_WB_rd_addr == i_ID_rs1_addr) || (i_WB_rd_addr == i_ID_rs2_addr))
            )
        ) begin
            o_pc_stall     = 1;
            o_IF_ID_stall  = 1;
            o_ID_EX_flush  = 1;
        end else
        //Branch hazard detection
        if (i_EX_pc_sel) begin
            o_IF_ID_flush  = 1;
            o_ID_EX_flush  = 1;
        end
    end

endmodule
