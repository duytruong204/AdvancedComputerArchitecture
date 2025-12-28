// 16-to-1 Multiplexer (1-bit input each)
// Selects one of 16 input bits based on 4-bit select signal (i_sel)
// Outputs the selected input on o_out
module mux_16to1_1bit (
    input  wire i_in0,  i_in1,  i_in2,  i_in3,    // Inputs 0 to 3
    input  wire i_in4,  i_in5,  i_in6,  i_in7,    // Inputs 4 to 7
    input  wire i_in8,  i_in9,  i_in10, i_in11,   // Inputs 8 to 11
    input  wire i_in12, i_in13, i_in14, i_in15,   // Inputs 12 to 15
    input  wire [3:0]  i_sel,                     // 4-bit select signal to choose input
    output wire        o_out                       // Output of selected input
);

    // Each line checks if i_sel matches input index (binary) and selects that input
    assign o_out = (~i_sel[3] & ~i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in0)  |  // 0000
                   (~i_sel[3] & ~i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in1)  |  // 0001
                   (~i_sel[3] & ~i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in2)  |  // 0010
                   (~i_sel[3] & ~i_sel[2] &  i_sel[1] &  i_sel[0] & i_in3)  |  // 0011
                   (~i_sel[3] &  i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in4)  |  // 0100
                   (~i_sel[3] &  i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in5)  |  // 0101
                   (~i_sel[3] &  i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in6)  |  // 0110
                   (~i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0] & i_in7)  |  // 0111
                   ( i_sel[3] & ~i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in8)  |  // 1000
                   ( i_sel[3] & ~i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in9)  |  // 1001
                   ( i_sel[3] & ~i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in10) |  // 1010
                   ( i_sel[3] & ~i_sel[2] &  i_sel[1] &  i_sel[0] & i_in11) |  // 1011
                   ( i_sel[3] &  i_sel[2] & ~i_sel[1] & ~i_sel[0] & i_in12) |  // 1100
                   ( i_sel[3] &  i_sel[2] & ~i_sel[1] &  i_sel[0] & i_in13) |  // 1101
                   ( i_sel[3] &  i_sel[2] &  i_sel[1] & ~i_sel[0] & i_in14) |  // 1110
                   ( i_sel[3] &  i_sel[2] &  i_sel[1] &  i_sel[0] & i_in15);   // 1111

endmodule
