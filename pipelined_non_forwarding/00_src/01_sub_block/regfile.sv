module regfile(
	input  wire 		i_clk,
	input  wire			i_reset, 
	input  wire	[4:0]	i_rs1_addr,
	input  wire [4:0]	i_rs2_addr,
	output wire [31:0]	o_rs1_data,
	output wire	[31:0]	o_rs2_data,
	input  wire	[4:0]	i_rd_addr,
	input  wire [31:0]	i_rd_data,
	input  wire			i_rd_wren
);
	wire 		[31:0] 	w_registers [31:0];
	wire		[31:0]  w_write_addr_onehot;
	
	binary_to_onehot_32bit bin2hot (
		.i_in(i_rd_addr), 
		.o_out(w_write_addr_onehot)
	);
	
	d_flip_flop_32x32bit d_flip_flop_32x32bit (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_write_enable(i_rd_wren),
		.i_write_data(i_rd_data),
		.i_write_addr_onehot(w_write_addr_onehot),
		.o_registers(w_registers)
	);

	mux_32to1_register32bit mux_rs1(.i_registers(w_registers), .i_sel(i_rs1_addr), .o_out(o_rs1_data));
	mux_32to1_register32bit mux_rs2(.i_registers(w_registers), .i_sel(i_rs2_addr), .o_out(o_rs2_data));

endmodule

module d_flip_flop_32x32bit (
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire 		i_write_enable,
	input  wire [31:0] 	i_write_data,
	input  wire [31:0] 	i_write_addr_onehot, // onehot encoded
	output wire [31:0]  o_registers [0:31]
);
	
	wire [31:0] w_next_data [0:31];
	
	// Register x0 is always zero
	assign o_registers[0] = 32'b0;

	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1) begin: gen_register_bank
			d_flip_flop #(.DATA_WIDTH(32)) d_flip_flop_32bit (
				.i_clk(i_clk), 
				.i_reset(i_reset),
				.i_en(i_write_enable & i_write_addr_onehot[i]),
				.i_d(i_write_data), 
				.o_q(o_registers[i])
			);
		end
	endgenerate
endmodule

module binary_to_onehot_32bit(
	input  wire	[4:0]  i_in,
	output wire [31:0] o_out
);
	sll_32bit sll_32bit (
		.i_a(32'b1), 
		.i_b(i_in), 
		.o_out(o_out)
	);
endmodule

// mux_32to1_register32bit
// Selects one 32-bit register from 32 inputs using a 5-bit selector (i_sel).
// Hierarchical design using mux_2to1_32bit_unit modules.

module mux_32to1_register32bit (
    input  wire [31:0] i_registers [0:31],  // 32 registers, each 32 bits wide
    input  wire [4:0]  i_sel,              // 5-bit select signal
    output wire [31:0] o_out               // Selected 32-bit output
);

    // Intermediate stages of selection
    wire [31:0] stage0 [0:15];
    wire [31:0] stage1 [0:7];
    wire [31:0] stage2 [0:3];
    wire [31:0] stage3 [0:1];

    genvar i;

    // Stage 0: 32-to-16
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage0
            mux_2to1_32bit u_mux0 (
                .i_in0(i_registers[2 * i]),
                .i_in1(i_registers[2 * i + 1]),
                .i_sel(i_sel[0]),
                .o_out(stage0[i])
            );
        end
    endgenerate

    // Stage 1: 16-to-8
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1
            mux_2to1_32bit u_mux1 (
                .i_in0(stage0[2 * i]),
                .i_in1(stage0[2 * i + 1]),
                .i_sel(i_sel[1]),
                .o_out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: 8-to-4
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage2
            mux_2to1_32bit u_mux2 (
                .i_in0(stage1[2 * i]),
                .i_in1(stage1[2 * i + 1]),
                .i_sel(i_sel[2]),
                .o_out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: 4-to-2
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_stage3
            mux_2to1_32bit u_mux3 (
                .i_in0(stage2[2 * i]),
                .i_in1(stage2[2 * i + 1]),
                .i_sel(i_sel[3]),
                .o_out(stage3[i])
            );
        end
    endgenerate

    // Final Stage: 2-to-1
    mux_2to1_32bit u_mux4 (
        .i_in0(stage3[0]),
        .i_in1(stage3[1]),
        .i_sel(i_sel[4]),
        .o_out(o_out)
    );

endmodule
