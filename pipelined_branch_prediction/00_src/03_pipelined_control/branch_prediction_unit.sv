module branch_prediction_unit(
    input  wire         i_clk,
    input  wire         i_reset,

    // ================= IF stage =================
    input  wire [31:0]  i_IF_pc,
    input  wire [31:0]  i_IF_pc_4,
    output wire         o_IF_hit,        // predicted taken
    output reg  [31:0]  o_IF_pc_target,  // NEXT PC (predict or redirect)

    // ================= EX stage =================
    input  wire         i_EX_hit,        // instruction in EX is branch
    input  wire         i_EX_pc_sel,     // actual taken
    input  wire [31:0]  i_EX_pc,
    input  wire [31:0]  i_EX_alu_data,   // actual target

    // ================= Control ==================
    output reg          o_branch_flush
);

    // -------------------------------------------------
    // Parameters
    // -------------------------------------------------
    localparam ENTRIES     = 1024;  // Number of BHT/BTB entries
    localparam INDEX_BITS = $clog2(ENTRIES);
    localparam TAG_BITS   = 32 - INDEX_BITS - 2;

    // -------------------------------------------------
    // Branch History Table (2-bit counters)
    // -------------------------------------------------
    reg [1:0] bht [0:ENTRIES-1];

    // -------------------------------------------------
    // Branch Target Buffer
    // -------------------------------------------------
    reg                btb_valid  [0:ENTRIES-1];
    reg [TAG_BITS-1:0] btb_tag    [0:ENTRIES-1];
    reg [31:0]         btb_target [0:ENTRIES-1];

    // -------------------------------------------------
    // Index & Tag
    // -------------------------------------------------
    wire [INDEX_BITS-1:0] if_index = i_IF_pc[INDEX_BITS+1:2];
    wire [INDEX_BITS-1:0] ex_index = i_EX_pc[INDEX_BITS+1:2];

    wire [TAG_BITS-1:0] if_tag = i_IF_pc[31:INDEX_BITS+2];
    wire [TAG_BITS-1:0] ex_tag = i_EX_pc[31:INDEX_BITS+2];

    // =================================================
    // IF STAGE : Prediction
    // =================================================
    wire btb_hit_if =
        btb_valid[if_index] &&
        (btb_tag[if_index] == if_tag) && bht[if_index][1];

    wire pred_taken_if =
        bht[if_index][1] && btb_hit_if;

    assign o_IF_hit = pred_taken_if;

    wire [31:0] predicted_pc =
        pred_taken_if ? btb_target[if_index] : i_IF_pc_4;

    // =================================================
    // EX STAGE : Prediction info (for comparison)
    // =================================================
    wire btb_hit_ex =
        btb_valid[ex_index] &&
        (btb_tag[ex_index] == ex_tag) && bht[ex_index][1];

    wire pred_taken_ex =
        bht[ex_index][1] && btb_hit_ex;

    // =================================================
    // Misprediction detection
    // =================================================
    always @(*) begin
        o_branch_flush = 1'b0;
        if (pred_taken_ex) begin
            // Direction mismatch
            if (pred_taken_ex != i_EX_pc_sel)
                o_branch_flush = 1'b1;

            // Target mismatch
            else if ((i_EX_pc_sel == pred_taken_ex ) &&
                     (btb_target[ex_index] != i_EX_alu_data))
                o_branch_flush = 1'b1;

        end else begin
            if (i_EX_pc_sel)  // predicted taken but not a branch
                o_branch_flush = 1'b1;
        end
    end

    // =================================================
    // FINAL NEXT-PC MUX (EX has priority)
    // =================================================
    always @(*) begin
        if (o_IF_hit) begin
            // Predicted PC from IF
            o_IF_pc_target = predicted_pc;
        end else
            o_IF_pc_target = i_IF_pc_4;

        if (o_branch_flush) begin
            // Correct PC from EX
            if (i_EX_pc_sel)
                o_IF_pc_target = i_EX_alu_data;  // taken
            else
                o_IF_pc_target = i_EX_pc + 4;    // not taken
        end
    end

    // =================================================
    // Update BHT + BTB
    // =================================================
    integer i;
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            for (i = 0; i < ENTRIES; i = i + 1) begin
                bht[i]       <= 2'b01;  // weakly not taken
                btb_valid[i] <= 1'b0;
            end
        end else if (o_branch_flush) begin

            // ---- BHT update
            case (bht[ex_index])
                2'b00: bht[ex_index] <= i_EX_pc_sel ? 2'b01 : 2'b00;
                2'b01: bht[ex_index] <= i_EX_pc_sel ? 2'b10 : 2'b00;
                2'b10: bht[ex_index] <= i_EX_pc_sel ? 2'b11 : 2'b01;
                2'b11: bht[ex_index] <= i_EX_pc_sel ? 2'b11 : 2'b10;
            endcase

            // ---- BTB update
            if (i_EX_pc_sel) begin
                btb_valid [ex_index] <= 1'b1;
                btb_tag   [ex_index] <= ex_tag;
                btb_target[ex_index] <= i_EX_alu_data;
            end
        end
    end

endmodule
