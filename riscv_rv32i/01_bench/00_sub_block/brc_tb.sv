module brc_tb(
	o_br_less,
	o_br_equal
);
	reg 			[31:0] i_rs1_data;
	reg 			[31:0] i_rs2_data;
	reg 			i_br_un;
	output wire	o_br_less;
	output wire	o_br_equal;
	
	brc u_1 (
		.i_rs1_data(i_rs1_data),
		.i_rs2_data(i_rs2_data),
		.i_br_un(i_br_un),
		.o_br_less(o_br_less),
		.o_br_equal(o_br_equal)
	);
	
	initial begin
		// Unsigned comparisons
		i_br_un = 0;

		// Test case 1
		i_rs1_data = 0;       i_rs2_data = 0;       #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 2
		i_rs1_data = 1;       i_rs2_data = 0;       #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 3
		i_rs1_data = 0;       i_rs2_data = 1;       #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 4
		i_rs1_data = 4294967295; i_rs2_data = 0;     #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 5
		i_rs1_data = 0;       i_rs2_data = 4294967295; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 6
		i_rs1_data = 123456789; i_rs2_data = 987654321; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 7
		i_rs1_data = 987654321; i_rs2_data = 123456789; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 8
		i_rs1_data = 2147483647; i_rs2_data = 2147483647; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 9
		i_rs1_data = 2147483647; i_rs2_data = 2147483648; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);

		// Test case 10
		i_rs1_data = 4294967295; i_rs2_data = 4294967295; #5;
		$display("Unsigned: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					i_rs1_data, i_rs2_data,
					o_br_less, (i_rs1_data < i_rs2_data) ? 1'b1 : 1'b0,
					o_br_equal, (i_rs1_data == i_rs2_data) ? 1'b1 : 1'b0);
		// Signed comparisons
		i_br_un = 1;

		// Test case 1
		i_rs1_data = 0;       i_rs2_data = 0;       #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 2
		i_rs1_data = -1;      i_rs2_data = 0;       #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 3
		i_rs1_data = 0;       i_rs2_data = -1;      #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 4
		i_rs1_data = -2147483648; i_rs2_data = 0;     #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 5
		i_rs1_data = 0;       i_rs2_data = -2147483648; #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 6
		i_rs1_data = 123456789; i_rs2_data = -123456789; #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 7
		i_rs1_data = -123456789; i_rs2_data = 123456789; #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 8
		i_rs1_data = -2147483648; i_rs2_data = -1;    #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 9
		i_rs1_data = -1;      i_rs2_data = -2147483648; #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);

		// Test case 10
		i_rs1_data = -1000;   i_rs2_data = -1000;    #5;
		$display("Signed: %0d < %0d ? less=actual:%b expected:%b, equal=actual:%b expected:%b",
					$signed(i_rs1_data), $signed(i_rs2_data),
					o_br_less, ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1'b1 : 1'b0,
					o_br_equal, ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1'b1 : 1'b0);


	end
	 
endmodule