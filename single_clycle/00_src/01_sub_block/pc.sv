module pc (
    input  wire        i_clk,
    input  wire        i_reset,
    input  wire [31:0] i_pc,
    input  wire [31:0] i_inst,
    output reg  [31:0] o_pc
);

    reg r_stall;
    wire [31:0] w_pc_next;
    wire w_stall_next;

    wire [4:0] w_opcode = i_inst[6:2];

    // Example load detection: only 00000 (LB) for simplicity
    wire w_load = ~w_opcode[4] & ~w_opcode[3] & ~w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 00000;

    // FF for next PC and stall signal
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            o_pc    <= 32'b0;
            r_stall <= 1'b0;
        end else begin
            o_pc    <= w_pc_next;
            r_stall <= w_stall_next;
        end
    end

    // Mux to select next PC and stall signal
    // If load instruction is detected, hold PC and assert stall
    wire w_lsu_load_stall = !w_load | ( w_load & r_stall);
    mux_2to1_32bit pc_mux (
        .i_in0(o_pc),
        .i_in1(i_pc),
        .i_sel(w_lsu_load_stall),
        .o_out(w_pc_next)
    );

    mux_2to1_1bit stall_mux (
        .i_in0(1'b1),
        .i_in1(1'b0),
        .i_sel(w_lsu_load_stall),
        .o_out(w_stall_next)
    );

endmodule

// Old version:
// Memory need wait one more cycle to load data from memory to regfile.
// So this module is not used anymore.

// module pc (
// 	input  wire        i_clk,      // Clock input
// 	input  wire        i_reset,    // Active-low synchronous reset
// 	input  wire [31:0] i_pc,       // Input PC value (next PC)
// 	output reg  [31:0] o_pc        // Output PC value (current PC)
// );

// 	// PC update logic
// 	always @(posedge i_clk or negedge i_reset) begin
// 		if (!i_reset)
// 			o_pc <= 32'b0;         // Reset PC to 0
// 		else
// 			o_pc <= i_pc;          // Update PC with new value
// 	end

// endmodule
