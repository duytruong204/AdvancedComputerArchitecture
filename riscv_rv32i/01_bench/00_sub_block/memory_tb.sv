`timescale 1ns / 1ps

module memory_tb(o_rdata);

	parameter N = 32;  // Number of memory locations, must match the DUT parameter

	// Inputs
	reg                  i_clk;
	reg                  i_reset;
	reg  [$clog2(N)-1:0] i_addr;
	reg  [31:0]          i_wdata;
	reg  [3:0]           i_bmask;
	reg                  i_wren;

	// Outputs
	output wire [31:0]          o_rdata;

	// Instantiate DUT
	memory #(.N(N)) dut (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_addr),
		.i_wdata(i_wdata),
		.i_bmask(i_bmask),
		.i_wren(i_wren),
		.o_rdata(o_rdata)
	);

	// Clock generation
	initial i_clk = 0;
	always #5 i_clk = ~i_clk; // 100MHz clock

	// Reference memory to check correctness
	reg [31:0] reference_mem [0:N-1];

	integer i;

	initial begin
		// Initialize reference memory to zero
		for (i = 0; i < N; i = i + 1) begin
			reference_mem[i] = 32'b0;
		end

		// Initialize inputs
		i_reset = 1;
		i_addr = 0;
		i_wdata = 0;
		i_bmask = 4'b0000;
		i_wren = 0;

		#20;
		i_reset = 0;

		// Wait a few cycles after reset
		@(posedge i_clk);
		@(posedge i_clk);

		// Write full words with full mask
		$display("=== Writing full 32-bit words ===");
		for (i = 0; i < N; i = i + 1) begin
			i_addr = i;
			i_wdata = i * 100;    // arbitrary data
			i_bmask = 4'b1111;   // write all bytes
			i_wren = 1;
			@(posedge i_clk);
			reference_mem[i] = i_wdata;
			$display("WRITE: Addr=%0d Data=0x%08X Mask=%b", i, i_wdata, i_bmask);
		end

		i_wren = 0;
		@(posedge i_clk);

		// Read back full words and check
		$display("=== Reading full 32-bit words ===");
		for (i = 0; i < N; i = i + 1) begin
			i_addr = i;
			@(posedge i_clk);
			#1;  // small delay for combinational read data

			$display("READ: Addr=%0d Data=0x%08X Expected=0x%08X %s", i, o_rdata, reference_mem[i],
				(o_rdata === reference_mem[i]) ? "PASS" : "FAIL");
		end

		// Partial byte writes with masks
		$display("=== Partial byte writes with masks ===");
		// Let's write to address 5, modifying only lower two bytes
		i_addr = 5;
		i_wdata = 32'hAABBCCDD;
		i_bmask = 4'b0011; // only lower two bytes
		i_wren = 1;
		@(posedge i_clk);
		i_wren = 0;

		// Update reference memory accordingly (only lower 16 bits updated)
		reference_mem[5][15:0] = i_wdata[15:0];

		// Read back address 5
		@(posedge i_clk);
		#1;
		$display("READ: Addr=5 Data=0x%08X Expected=0x%08X %s", o_rdata, reference_mem[5],
			(o_rdata === reference_mem[5]) ? "PASS" : "FAIL");

		// Partial byte write to address 10, only top byte
		i_addr = 10;
		i_wdata = 32'h11223344;
		i_bmask = 4'b1000; // only top byte
		i_wren = 1;
		@(posedge i_clk);
		i_wren = 0;

		// Update reference memory accordingly
		reference_mem[10][31:24] = i_wdata[31:24];

		// Read back address 10
		@(posedge i_clk);
		#1;
		$display("READ: Addr=10 Data=0x%08X Expected=0x%08X %s", o_rdata, reference_mem[10],
			(o_rdata === reference_mem[10]) ? "PASS" : "FAIL");

		// Test reset clears memory
		$display("=== Testing Reset clears memory ===");
		i_reset = 1;
		@(posedge i_clk);
		i_reset = 0;
		@(posedge i_clk);

		// Read all addresses after reset, should be zero
		for (i = 0; i < N; i = i + 1) begin
			i_addr = i;
			@(posedge i_clk);
			#1;
			$display("READ after reset Addr=%0d Data=0x%08X Expected=0x00000000 %s",
				i, o_rdata, (o_rdata === 32'b0) ? "PASS" : "FAIL");
		end

		$display("Testbench completed.");
		$finish;
	end

endmodule
