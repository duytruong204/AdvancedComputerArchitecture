//Mux 2 input 32 bit
// mux_2to1_32bit
// 32-bit 2-to-1 multiplexer: selects between i_in0 and i_in1 based on i_sel
module mux_2to1_32bit (
	input  wire [31:0] i_in0,   // Input 0 (32 bit)
	input  wire [31:0] i_in1,   // Input 1 (32 bit)
	input  wire        i_sel,   // Select line
	output wire [31:0] o_out    // Output (32 bit)
);
	genvar i;
	generate
		for(i=0; i < 32; i = i +1) begin: mux_array
           		 mux_2to1_1bit mux (
                		.i_in0(i_in0[i]),
                		.i_in1(i_in1[i]),
                		.i_sel(i_sel),
                		.o_out(o_out[i])
            		);
		end
	endgenerate
endmodule
