module pc (
    input  wire        i_clk,
    input  wire        i_reset,
    input  wire [31:0] i_pc,
    input  wire [31:0] i_inst,
    output reg  [31:0] o_pc
);

    reg r_stall;

    wire [4:0] w_opcode = i_inst[6:2];

    // Example load detection: only 00000 (LB) for simplicity
    wire w_load = (w_opcode == 5'b00000);

    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            o_pc    <= 32'b0;
            r_stall <= 1'b0;
        end else begin
            if (!w_load | ( w_load & r_stall)) begin
                o_pc <= i_pc;
                r_stall <= 1'b0;
            end else begin
                r_stall <= 1'b1;
                // PC holds its value automatically
            end
        end
    end

endmodule

// module pc (
// 	input  wire        i_clk,      // Clock input
// 	input  wire        i_reset,    // Active-low synchronous reset
// 	input  wire [31:0] i_pc,       // Input PC value (next PC)
// 	output reg  [31:0] o_pc        // Output PC value (current PC)
// );

// 	// PC update logic
// 	always @(posedge i_clk or negedge i_reset) begin
// 		if (!i_reset)
// 			o_pc <= 32'b0;         // Reset PC to 0
// 		else
// 			o_pc <= i_pc;          // Update PC with new value
// 	end

// endmodule
