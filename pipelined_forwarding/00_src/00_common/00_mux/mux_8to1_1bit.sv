// 1-bit 8-to-1 multiplexer
// Selects one of eight 1-bit inputs based on a 3-bit select signal (i_sel).
// Output is the selected 1-bit input.

module mux_8to1_1bit (
    input  wire i_in0,  // Input 0
    input  wire i_in1,  // Input 1
    input  wire i_in2,  // Input 2
    input  wire i_in3,  // Input 3
    input  wire i_in4,  // Input 4
    input  wire i_in5,  // Input 5
    input  wire i_in6,  // Input 6
    input  wire i_in7,  // Input 7
    input  wire [2:0] i_sel,  // 3-bit select signal
    output wire o_out         // Output
);

    assign o_out = (~i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in0) | // 000
                   (~i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in1) | // 001
                   (~i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in2) | // 010
                   (~i_sel[2] &  i_sel[1] &  i_sel[0] & i_in3) | // 011
                   ( i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in4) | // 100
                   ( i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in5) | // 101
                   ( i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in6) | // 110
                   ( i_sel[2] &  i_sel[1] &  i_sel[0] & i_in7);  // 111

endmodule
