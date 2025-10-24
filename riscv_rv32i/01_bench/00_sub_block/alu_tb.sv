module alu_tb(
	o_alu_data
);
	reg  [31:0] i_op_a;
	reg  [31:0] i_op_b;
	reg  [3:0]  i_alu_op;
	output wire [31:0] o_alu_data;
	alu alu (
		.i_op_a(i_op_a),
		.i_op_b(i_op_b),
		.i_alu_op(i_alu_op),
		.o_alu_data(o_alu_data)
	);
 initial begin
 
		// ADD Tests
		i_alu_op = 4'b0000;

		i_op_a = 0; i_op_b = 0; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 5; i_op_b = 10; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = -5; i_op_b = 3; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 32'h7FFFFFFF; i_op_b = 1; #5;
		$display("ADD (Overflow): %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 1; #5;
		$display("ADD: %h + %h = %h (Result=%h)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 123456; i_op_b = 654321; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = -1000; i_op_b = -2000; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 32'hAAAAAAAA; i_op_b = 32'h55555555; #5;
		$display("ADD: %h + %h = %h (Result=%h)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 1 << 30; i_op_b = 1 << 30; #5;
		$display("ADD: %d + %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		i_op_a = 32'h80000000; i_op_b = 32'h80000000; #5;
		$display("ADD: %h + %h = %h (Result=%h)", i_op_a, i_op_b, i_op_a+i_op_b, o_alu_data);

		// SUB Tests
		i_alu_op = 4'b1000;

		i_op_a = 10; i_op_b = 5; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 5; i_op_b = 10; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = -5; i_op_b = -10; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = 1; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 1; i_op_b = 0; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 1; #5;
		$display("SUB: %h - %h = %h (Result=%h)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 32'h80000000; i_op_b = 1; #5;
		$display("SUB: %h - %h = %h (Result=%h)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 123456789; i_op_b = 98765432; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = 0; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);

		i_op_a = -1000; i_op_b = 1000; #5;
		$display("SUB: %d - %d = %d (Result=%d)", i_op_a, i_op_b, i_op_a - i_op_b, o_alu_data);


		// SLT Tests
		i_alu_op = 4'b0010;

		i_op_a = -5; i_op_b = 5; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 5; i_op_b = -5; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = 0; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 100; i_op_b = 100; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = -100; i_op_b = -50; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'h80000000; i_op_b = 0; #5; // -2147483648 < 0
		$display("SLT: %d < %d ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 1; i_op_b = 2; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'h7FFFFFFF; i_op_b = 32'h80000000; #5; // 2147483647 < -2147483648
		$display("SLT: %d < %d ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = -1; i_op_b = 0; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = -1; #5;
		$display("SLT: %d < %d ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		// SLTU Tests
		i_alu_op = 4'b0011;

		i_op_a = 1; i_op_b = 2; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 2; i_op_b = 1; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = 0; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 0; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 0; i_op_b = 32'hFFFFFFFF; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 123456789; i_op_b = 987654321; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 987654321; i_op_b = 123456789; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'h80000000; i_op_b = 32'h7FFFFFFF; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'h7FFFFFFF; i_op_b = 32'h80000000; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=1)", i_op_a, i_op_b, o_alu_data);

		i_op_a = 32'hAAAAAAAA; i_op_b = 32'h55555555; #5;
		$display("SLTU: %u < %u ? Result=%d (Expected=0)", i_op_a, i_op_b, o_alu_data);


		// XOR Tests
		i_alu_op = 4'b0100;

		i_op_a = 0; i_op_b = 0; #5;
		$display("XOR: %b ^ %b = %b (Result=%b)", i_op_a, i_op_b, i_op_a ^ i_op_b, o_alu_data);

		// OR Tests
		i_alu_op = 4'b0110;

		i_op_a = 0; i_op_b = 0; #5;
		$display("OR: %b | %b = %b (Result=%b)", i_op_a, i_op_b, i_op_a | i_op_b, o_alu_data);

		// AND
		i_alu_op = 4'b0111;
		i_op_a = 8; i_op_b = 3; #5;
		$display("AND: %32b & %32b = %32b (Result=%d)", i_op_a, i_op_b, (i_op_a & i_op_b), o_alu_data);

		// SLL
		i_alu_op = 4'b0001;
		i_op_a = 32'h00000001; i_op_b = 1; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000001; i_op_b = 31; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 4; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h12345678; i_op_b = 8; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h80000000; i_op_b = 1; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h0000FFFF; i_op_b = 16; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'hAAAAAAAA; i_op_b = 3; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000000; i_op_b = 5; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h7FFFFFFF; i_op_b = 1; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000010; i_op_b = 4; #5;
		$display("SLL: %h << %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a << i_op_b[4:0]), o_alu_data);

		// SRL
		i_alu_op = 4'b0101;
		i_op_a = 32'h80000000; i_op_b = 1; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 4; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h12345678; i_op_b = 8; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000001; i_op_b = 1; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h0000FFFF; i_op_b = 16; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'hAAAAAAAA; i_op_b = 3; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h7FFFFFFF; i_op_b = 1; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000010; i_op_b = 4; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'hFFFFFFFF; i_op_b = 31; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		i_op_a = 32'h00000000; i_op_b = 5; #5;
		$display("SRL: %h >> %d = %h (Result=%h)", i_op_a, i_op_b[4:0], (i_op_a >> i_op_b[4:0]), o_alu_data);

		//SRA
		i_alu_op = 4'b1101;
		i_op_a = -32'sd16; i_op_b = 2; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = -32'sd1; i_op_b = 1; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = -32'sd1024; i_op_b = 10; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = 32'sd1024; i_op_b = 5; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = -32'sd2147483648; i_op_b = 31; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = 32'sd0; i_op_b = 3; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = -32'sd5; i_op_b = 1; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = 32'sd15; i_op_b = 3; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = -32'sd8; i_op_b = 2; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		i_op_a = 32'sd2147483647; i_op_b = 31; #5;
		$display("SRA: %d >>> %d = %d (Result=%d)", i_op_a, i_op_b[4:0], ($signed(i_op_a) >>> i_op_b[4:0]), $signed(o_alu_data));

		$finish;
	end
endmodule