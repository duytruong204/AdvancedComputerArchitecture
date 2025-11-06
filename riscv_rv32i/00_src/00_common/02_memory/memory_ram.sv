// Byte-addressable memory module (32-bit word interface)
// Supports byte-enable write (via i_bmask), synchronous write, asynchronous read
module memory_ram #(
	parameter DEPTH = 4096 // Number of memory bytes
)(
	input  wire                     i_clk,        // Clock
	input  wire                     i_reset,      // Active-low synchronous reset
	input  wire [$clog2(DEPTH)-1:0] i_addr,       // Byte address (for both read/write)
	input  wire [3:0]               i_bmask,      // Byte mask (1 = enable write)
	input  wire [31:0]              i_wdata,      // Write data
	input  wire                     i_wren,       // Write enable
	output wire [31:0]              o_rdata       // Read data (combinational)
);
	
	localparam ADDR_WIDTH = $clog2(DEPTH);
	//wire w_is_addr_byte_0 = ~i_addr[1] & ~i_addr[0]; //00
	//wire w_is_addr_byte_1 = ~i_addr[1] &  i_addr[0]; //01
	//wire w_is_addr_byte_2 =  i_addr[1] & ~i_addr[0]; //10
	//wire w_is_addr_byte_3 =  i_addr[1] &  i_addr[0]; //11
	
	wire [31:0] w_wdata_shifted;
	wire [3:0] w_bmask_shifted;
	wire [7:0] w_byte_rdata_0, w_byte_rdata_1, w_byte_rdata_2, w_byte_rdata_3;

	wire [ADDR_WIDTH-3:0] base_word_addr = i_addr[ADDR_WIDTH-1:2];

	wire [ADDR_WIDTH-3:0] w_byte_addr_0 = base_word_addr + (i_addr[1:0] > 2'd0);
	wire [ADDR_WIDTH-3:0] w_byte_addr_1 = base_word_addr + (i_addr[1:0] > 2'd1);
	wire [ADDR_WIDTH-3:0] w_byte_addr_2 = base_word_addr + (i_addr[1:0] > 2'd2);
	wire [ADDR_WIDTH-3:0] w_byte_addr_3 = base_word_addr;
	
	mux_4to1_32bit mux_data_in (
		.i_in0(i_wdata),
		.i_in1({i_wdata[23:0], i_wdata[31:24]}),
		.i_in2({i_wdata[15:0], i_wdata[31:16]}),
		.i_in3({i_wdata[7:0], i_wdata[31:8]}),
		.i_sel(i_addr[1:0]),
		.o_out(w_wdata_shifted)
	);
	
	mux_4to1_4bit mux_byte_mask_in (
		.i_in0(i_bmask),
		.i_in1({i_bmask[2:0], i_bmask[3]}),
		.i_in2({i_bmask[1:0], i_bmask[3:2]}),
		.i_in3({i_bmask[0], i_bmask[3:1]}),
		.i_sel(i_addr[1:0]),
		.o_out(w_bmask_shifted)
	);
	
	 // Byte 0 (lowest)
    single_port_ram #(.DATA_WIDTH(8), .DEPTH(DEPTH/4)) ram_col_0 (
        .i_clk  (i_clk),
        .i_wren (i_wren & w_bmask_shifted[0]),
        .i_addr (w_byte_addr_0),
        .i_wdata(w_wdata_shifted[7:0]),
        .o_rdata(w_byte_rdata_0)
    );

    // Byte 1
    single_port_ram #(.DATA_WIDTH(8), .DEPTH(DEPTH/4)) ram_col_1 (
        .i_clk  (i_clk),
        .i_wren (i_wren & w_bmask_shifted[1]),
        .i_addr (w_byte_addr_1),
        .i_wdata(w_wdata_shifted[15:8]),
        .o_rdata(w_byte_rdata_1)
    );

    // Byte 2
    single_port_ram #(.DATA_WIDTH(8), .DEPTH(DEPTH/4)) ram_col_2 (
        .i_clk  (i_clk),
        .i_wren (i_wren & w_bmask_shifted[2]),
        .i_addr (w_byte_addr_2),
        .i_wdata(w_wdata_shifted[23:16]),
        .o_rdata(w_byte_rdata_2)
    );

    // Byte 3 (highest)
    single_port_ram #(.DATA_WIDTH(8), .DEPTH(DEPTH/4)) ram_col_3 (
        .i_clk  (i_clk),
        .i_wren (i_wren & w_bmask_shifted[3]),
        .i_addr (w_byte_addr_3),
        .i_wdata(w_wdata_shifted[31:24]),
        .o_rdata(w_byte_rdata_3)
    );
	 
	mux_4to1_32bit mux_data_out (
		.i_in0({w_byte_rdata_3, w_byte_rdata_2, w_byte_rdata_1, w_byte_rdata_0}), // aligned
		.i_in1({w_byte_rdata_0, w_byte_rdata_3, w_byte_rdata_2, w_byte_rdata_1}), // rotate left 8 bits
		.i_in2({w_byte_rdata_1, w_byte_rdata_0, w_byte_rdata_3, w_byte_rdata_2}), // rotate left 16 bits
		.i_in3({w_byte_rdata_2, w_byte_rdata_1, w_byte_rdata_0, w_byte_rdata_3}), // rotate left 24 bits
		.i_sel(i_addr[1:0]),
		.o_out(o_rdata)
	);

endmodule
