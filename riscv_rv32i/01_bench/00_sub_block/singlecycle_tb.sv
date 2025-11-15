`timescale 1ns/1ps
`include "D:/Application/altera/13.0sp1/Project/Single_Cycle_RISC_V/riscv_rv32i/00_src/include.sv"
`define RESET_PERIOD 100
`define CLK_PERIOD   2
`define FINISH       40000

module singlecycle_tb;
	reg  [31:0]  i_io_sw  ;
	wire [31:0]  o_io_ledr;
	wire [31:0]  o_io_ledg;
	wire [31:0]  o_io_lcd ;
	wire [ 6:0]  o_io_hex0;
	wire [ 6:0]  o_io_hex1;
	wire [ 6:0]  o_io_hex2;
	wire [ 6:0]  o_io_hex3;
	wire [ 6:0]  o_io_hex4;
	wire [ 6:0]  o_io_hex5;
	wire [ 6:0]  o_io_hex6;
	wire [ 6:0]  o_io_hex7;
	wire [31:0] o_pc_debug;
	wire 		o_insn_vld;
	reg	i_clk;
	reg i_reset;

	// Hex display decoder
	function string display_hex(input [6:0] hex);
		begin
			case (~hex)
				7'b0111111: display_hex = "0";
				7'b0000110: display_hex = "1";
				7'b1011011: display_hex = "2";
				7'b1001111: display_hex = "3";
				7'b1100110: display_hex = "4";
				7'b1101101: display_hex = "5";
				7'b1111101: display_hex = "6";
				7'b0000111: display_hex = "7";
				7'b1111111: display_hex = "8";
				7'b1101111: display_hex = "9";
				7'b1110111: display_hex = "A";
				7'b1111100: display_hex = "b";
				7'b0111001: display_hex = "C";
				7'b1011110: display_hex = "d";
				7'b1111001: display_hex = "E";
				7'b1110001: display_hex = "F";
				default:    display_hex = "?";
			endcase
		end
	endfunction

	single_cycle single_cycle (
		.i_clk       (i_clk     ) ,
		.i_reset     (i_reset   ) ,
		.i_io_sw     (i_io_sw   ) ,
		.o_io_ledr   (o_io_ledr ) ,
		.o_io_ledg   (o_io_ledg ) ,
		.o_io_lcd    (o_io_lcd  ) ,
		.o_io_hex0   (o_io_hex0 ) ,
		.o_io_hex1   (o_io_hex1 ) ,
		.o_io_hex2   (o_io_hex2 ) ,
		.o_io_hex3   (o_io_hex3 ) ,
		.o_io_hex4   (o_io_hex4 ) ,
		.o_io_hex5   (o_io_hex5 ) ,
		.o_io_hex6   (o_io_hex6 ) ,
		.o_io_hex7   (o_io_hex7 ) ,
		.o_pc_debug  (o_pc_debug) ,
		.o_insn_vld  (o_insn_vld)
	);
	initial begin
		i_io_sw = 32'b0;
		i_clk = 0;
		i_reset = 1;
	end
	// Clock generation
	always #`CLK_PERIOD i_clk = ~i_clk;

	// Reset logic
	initial begin
		i_clk = 0;
		i_reset = 0;
		#`RESET_PERIOD;
		i_reset = 1;
		#`FINISH;
		$display("=== Simulation Finished ===");
		$finish;
	end
	integer i, j;
	// always @ (o_io_lcd) begin
	// 	$display("%8h", o_io_lcd);
	// end
	// Show pc and instruction
	always @ (o_pc_debug) begin
		// Show pc and instruction
		$display("==============================");
		$display("PC = %8h, Instruction = %8h", 
			single_cycle.pc.o_pc, single_cycle.inst_mem.o_inst
		);
		// Show all registers
		for (i = 0; i < 8; i = i + 1) begin
			$display("R%0d = %8h | R%0d = %8h | R%0d = %8h | R%0d = %8h", 
			i*4+0, single_cycle.regfile.d_flip_flop_32x32bit.o_registers[i*4+0],
			i*4+1, single_cycle.regfile.d_flip_flop_32x32bit.o_registers[i*4+1],
			i*4+2, single_cycle.regfile.d_flip_flop_32x32bit.o_registers[i*4+2],
			i*4+3, single_cycle.regfile.d_flip_flop_32x32bit.o_registers[i*4+3]
			);
		end
		// Show first 32 memory locations
		for (i = 0; i < 9; i = i + 1) begin
			$display("M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h", 
				i*4+0, 	single_cycle.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+0], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+0], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+0], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+0],
				i*4+1, 	single_cycle.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+1], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+1], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+1], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+1],
				i*4+2, 	single_cycle.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+2], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+2], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+2], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+2],
				i*4+3, 	single_cycle.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+3], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+3], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+3], 
						single_cycle.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+3]
			);
		end

		// Show IOs
		$display("LEDG = %8h, LEDR = %8h, LCD = %8h", 
			o_io_ledg, o_io_ledr, o_io_lcd
		);
		// Show hex displays
		$display("HEX7 = %2h, HEX6 = %2h, HEX5 = %2h, HEX4 = %2h, HEX3 = %2h, HEX2 = %2h, HEX1 = %2h, HEX0 = %2h", 
			o_io_hex7, o_io_hex6, o_io_hex5, o_io_hex4,
			o_io_hex3, o_io_hex2, o_io_hex1, o_io_hex0
		);
		// hex digits displayed
		$display("Hex Digits: %s%s%s%s%s%s%s%s",
			display_hex(o_io_hex7),
			display_hex(o_io_hex6),
			display_hex(o_io_hex5),
			display_hex(o_io_hex4),
			display_hex(o_io_hex3),
			display_hex(o_io_hex2),
			display_hex(o_io_hex1),
			display_hex(o_io_hex0)
		);
		// Finish simulation if instruction not valid
		if(o_insn_vld == 0) begin
			$display("Instruction not valid yet.");
			$finish;
		end
		$display("==============================");
	end

endmodule

