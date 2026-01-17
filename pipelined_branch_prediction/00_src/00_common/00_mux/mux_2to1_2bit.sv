//Mux 2 input 2 bit
// mux_2to1_2bit
// 2-bit 2-to-1 multiplexer: selects between i_in0 and i_in1 based on i_sel
module mux_2to1_2bit (
	input  wire [1:0] i_in0,   // Input 0 (2 bit)
	input  wire [1:0] i_in1,   // Input 1 (2 bit)
	input  wire       i_sel,   // Select line
	output wire [1:0] o_out    // Output (2 bit)
);
	genvar i;
	generate
		for(i=0; i < 2; i = i +1) begin: mux_array
           		 mux_2to1_1bit mux (
                		.i_in0(i_in0[i]),
                		.i_in1(i_in1[i]),
                		.i_sel(i_sel),
                		.o_out(o_out[i])
            		);
		end
	endgenerate
endmodule
