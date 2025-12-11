module d_flip_flop #(
	parameter DATA_WIDTH = 32
)(
	input  wire						i_clk,
	input  wire						i_reset,
	input  wire						i_en,
	input  wire [DATA_WIDTH-1:0] 	i_d,
	output reg  [DATA_WIDTH-1:0] 		o_q
);
	always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            o_q <= 32'b0;       // Asynchronous reset clears output
        end else if (i_en) begin
            o_q <= i_d;         // Load new data on clock edge if enabled
        end
    end
endmodule