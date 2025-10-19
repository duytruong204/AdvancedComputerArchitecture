module memory #(
	parameter 		N = 32 	//Number of byte memories
)(
	i_clk, 
	i_reset, //1 input Global active reset.
	i_addr, 	//? input Address for both read and write operations.
	i_bmask,	//4 input Byte mask, 1 for enable, otherwise 0.
	i_wdata, //32 input Write data.
	i_wren, 	//1 input Write enable, 1 if writing, 0 if reading.
	o_rdata 	//32 output Read data.
);
	input wire 							i_clk, i_reset;
	input wire 	[$clog2(N)-1:0]	i_addr;
	input wire 	[3:0] 				i_bmask;
	input wire 	[31:0] 				i_wdata;
	input wire 							i_wren;
	output wire	[31:0]				o_rdata;
	
	reg 			[7:0] 				mem [0:N-1];
	integer i;

	always @(posedge i_clk or negedge i_reset) begin
		if (!i_reset) begin
			for (i = 0; i < N; i = i + 1) begin
				mem[i] <= 8'b0;
			end
		end else begin
			if (i_wren) begin
				if(i_bmask[3]) mem[i_addr + 3] <= i_wdata	[31:24];
				if(i_bmask[2]) mem[i_addr + 2] <= i_wdata	[23:16];
				if(i_bmask[1]) mem[i_addr + 1] <= i_wdata	[15:8];
				if(i_bmask[0]) mem[i_addr + 0] <= i_wdata	[7:0];
			end
		end
	end
	assign o_rdata[31:24] = mem[i_addr + 3];
	assign o_rdata[23:16] = mem[i_addr + 2];
	assign o_rdata[15:8 ] = mem[i_addr + 1];
	assign o_rdata[7:0  ] = mem[i_addr + 0];
	
endmodule
