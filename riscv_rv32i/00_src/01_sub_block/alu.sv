module alu (
	input  wire [31:0] i_op_a, 		//32 input First operand for ALU operations.
	input  wire [31:0] i_op_b, 		//32 input Second operand for ALU operations.
	input  wire [3:0]  i_alu_op, 	//4 input The operation to be performed.
	output wire [31:0] o_alu_data 	//32 output Result of the ALU operation.
);
	wire  [31:0]	w_add_result, w_sub_result;
	wire			w_slt_result_1bit, w_sltu_result_1bit;
	wire  [31:0] 	w_slt_result, w_sltu_result;
	wire  [31:0] 	w_xor_result, w_or_result, w_and_result;
	wire  [31:0] 	w_sll_result, w_srl_result, w_sra_result;
	
	full_adder_32bit add(
		.i_a(i_op_a),
		.i_b(i_op_b),
		.i_carry(1'b0),
		.o_sum(w_add_result),
		.o_carry()
	);
	
	full_adder_32bit sub(
		.i_a(i_op_a),
		.i_b(~i_op_b),
		.i_carry(1'b1),
		.o_sum(w_sub_result),
		.o_carry()
	);
	
	slt_32bit slt_32bit(
		.i_a(i_op_a),
		.i_b(i_op_b),
		.o_out(w_slt_result_1bit)
	);
	assign w_slt_result = {31'b0, w_slt_result_1bit};
	
	sltu_32bit 	sltu_32bit(
		.i_a(i_op_a),
		.i_b(i_op_b),
		.o_out(w_sltu_result_1bit)
	);
	assign w_sltu_result = {31'b0, w_sltu_result_1bit};
	
	xor_32bit xor_32bit (
		.i_a(i_op_a), 
		.i_b(i_op_b), 
		.o_out(w_xor_result)
	);
	
	or_32bit or_32bit (
		.i_a(i_op_a), 
		.i_b(i_op_b), 
		.o_out(w_or_result)
	);
	
	and_32bit and_32bit (
		.i_a(i_op_a), 
		.i_b(i_op_b), 
		.o_out(w_and_result)
	);
	
	sll_32bit sll_32bit (
		.i_a(i_op_a), 
		.i_b(i_op_b[4:0]), 
		.o_out(w_sll_result)
	);
	
	srl_32bit srl_32bit (
		.i_a(i_op_a),
		.i_b(i_op_b[4:0]),
		.o_out(w_srl_result)
	);
	
	sra_32bit sra_32bit(
		.i_a(i_op_a),
		.i_b(i_op_b[4:0]),
		.o_out(w_sra_result)
	);

	mux_16to1_32bit mux_16to1( //func7 	- func3 	: meanings
		.i_in0(w_add_result), 	//0 		- 000		: ADD
		.i_in1(w_sll_result), 	//0 		- 001		: SLL
		.i_in2(w_slt_result), 	//0 		- 010		: SLT
		.i_in3(w_sltu_result),	//0 		- 011		: SLTU
		.i_in4(w_xor_result), 	//0 		- 100		: XOR
		.i_in5(w_srl_result),  	//0 		- 101		: SRL
		.i_in6(w_or_result), 	//0 		- 110		: OR
		.i_in7(w_and_result), 	//0 		- 111		: AND
		.i_in8(w_sub_result), 	//1 		- 000		: SUB
		.i_in9(32'b0), 			//1 		- 001		: unused
		.i_in10(32'b0),			//1 		- 010		: unused
		.i_in11(32'b0),			//1 		- 011		: unused
		.i_in12(32'b0),			//1 		- 100		: unused
		.i_in13(w_sra_result),	//1 		- 101		: SRA
		.i_in14(32'b0), 		//1 		- 110		: unused
		.i_in15(i_op_b),  		//1 		- 111		: B (return i_op_b)
		.i_sel(i_alu_op), 
		.o_out(o_alu_data)
	);
endmodule