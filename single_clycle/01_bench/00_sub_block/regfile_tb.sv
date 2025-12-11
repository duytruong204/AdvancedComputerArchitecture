`include "D:/Application/altera/13.0sp1/Project/Single_Cycle_RISC_V/riscv_rv32i/00_src/include.sv"

module regfile_tb (
	o_rs1_data,
	o_rs2_data
);

	output o_rs1_data;
	output o_rs2_data;
	reg         i_clk;
	reg         i_reset;
	reg  [4:0]  i_rs1_addr;
	reg  [4:0]  i_rs2_addr;
	wire [31:0] o_rs1_data;
	wire [31:0] o_rs2_data;
	reg  [4:0]  i_rd_addr;
	reg  [31:0] i_rd_data;
	reg         i_rd_wren;

	regfile u_1 (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_rs1_addr(i_rs1_addr),
		.i_rs2_addr(i_rs2_addr),
		.o_rs1_data(o_rs1_data),
		.o_rs2_data(o_rs2_data),
		.i_rd_addr(i_rd_addr),
		.i_rd_data(i_rd_data),
		.i_rd_wren(i_rd_wren)
  );

	always #5 i_clk = ~i_clk;

initial begin
    // Initialize
	i_clk      = 0;
	i_reset    = 0;
	i_rs1_addr = 0;
	i_rs2_addr = 0;
	i_rd_addr  = 0;
	i_rd_data  = 0;
	i_rd_wren  = 0;

    // Apply reset
	#20;
	i_reset = 1;
	i_rs1_addr = 0; i_rs2_addr = 0;
	#10;
	$display("Test1: reg0 = %h (Expected=00000000)", o_rs1_data);

	// 2. Write to reg5, read reg5 and reg0
	@(posedge i_clk);
	i_rd_addr = 5; i_rd_data = 32'hDEADBEEF; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 5; i_rs2_addr = 0;
	#10;
	$display("Test2: reg5=%h, reg0=%h (Expected=DEADBEEF, 00000000)", o_rs1_data, o_rs2_data);

	// 3. Write to reg10, read reg10 and reg5
	@(posedge i_clk);
	i_rd_addr = 10; i_rd_data = 32'h12345678; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 10; i_rs2_addr = 5;
	#10;
	$display("Test3: reg10=%h, reg5=%h (Expected=12345678, DEADBEEF)", o_rs1_data, o_rs2_data);

	// 4. Write 0 to reg0 (should NOT write), read reg0
	@(posedge i_clk);
	i_rd_addr = 0; i_rd_data = 32'hFFFFFFFF; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 0; i_rs2_addr = 1;
	#10;
	$display("Test4: reg0=%h (Expected=00000000)", o_rs1_data);

	// 5. Write max unsigned value to reg1, read reg1
	@(posedge i_clk);
	i_rd_addr = 1; i_rd_data = 32'hFFFFFFFF; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 1; i_rs2_addr = 0;
	#10;
	$display("Test5: reg1=%h, reg0=%h (Expected=FFFFFFFF, 00000000)", o_rs1_data, o_rs2_data);

	// 6. Overwrite reg5 with new value, read reg5
	@(posedge i_clk);
	i_rd_addr = 5; i_rd_data = 32'h0A0A0A0A; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 5; i_rs2_addr = 10;
	#10;
	$display("Test6: reg5=%h, reg10=%h (Expected=0A0A0A0A, 12345678)", o_rs1_data, o_rs2_data);

	// 7. Write to reg31, read reg31 and reg1
	@(posedge i_clk);
	i_rd_addr = 31; i_rd_data = 32'hCAFEBABE; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 31; i_rs2_addr = 1;
	#10;
	$display("Test7: reg31=%h, reg1=%h (Expected=CAFEBABE, FFFFFFFF)", o_rs1_data, o_rs2_data);

	// 8. Read registers with no write enable active (should get last values)
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 5; i_rs2_addr = 31;
	#10;
	$display("Test8: reg5=%h, reg31=%h (Expected=0A0A0A0A, CAFEBABE)", o_rs1_data, o_rs2_data);

	// 9. Write zero to reg10, read reg10
	@(posedge i_clk);
	i_rd_addr = 10; i_rd_data = 32'h00000000; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 10; i_rs2_addr = 0;
	#10;
	$display("Test9: reg10=%h, reg0=%h (Expected=00000000, 00000000)", o_rs1_data, o_rs2_data);

	// 10. Write a random value to reg15, read reg15
	@(posedge i_clk);
	i_rd_addr = 15; i_rd_data = 32'h55AA55AA; i_rd_wren = 1;
	@(posedge i_clk);
	i_rd_wren = 0;
	@(posedge i_clk);
	i_rs1_addr = 15; i_rs2_addr = 5;
	#10;
	$display("Test10: reg15=%h, reg5=%h (Expected=55AA55AA, 0A0A0A0A)", o_rs1_data, o_rs2_data);


    // Done
    #20;
    $finish;
  end


endmodule
