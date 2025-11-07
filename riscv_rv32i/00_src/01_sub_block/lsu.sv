module lsu(
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire	[31:0] 	i_lsu_addr,
	input  wire [31:0] 	i_st_data,
	input  wire			i_lsu_wren,
	input  wire	[2:0]	i_type_access,
	output wire	[31:0] 	o_ld_data,
	output wire	[31:0] 	o_io_ledr, o_io_ledg,
	output wire	[6:0]  	o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
	output wire	[6:0]  	o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
	output wire	[31:0]	o_io_lcd,
	input  wire	[31:0]	i_io_sw
);
	wire 		w_sw_enable,	w_lcd_enable,	w_hexh_enable,	w_hexl_enable,	w_ledg_enable, w_ledr_enable, w_mem_enable;
	wire [31:0] 				w_lcd_out, 		w_hexh_out, 	w_hexl_out, 	w_ledg_out, 	w_ledr_out;
	wire [31:0] w_sw_data, 		w_lcd_data, 	w_hexh_data, 	w_hexl_data, 	w_ledg_data, 	w_ledr_data, 	w_mem_data;
	wire [11:0] w_peripheral_addr;
	wire [10:0] w_memory_addr;
	wire [31:0] w_output_data;
	wire [3:0]	w_bmask;
	
	memory_encoder memory_encoder (
		.i_lsu_addr(i_lsu_addr),
		.o_sw_enable(w_sw_enable),
		.o_lcd_enable(w_lcd_enable),
		.o_hexh_enable(w_hexh_enable),
		.o_hexl_enable(w_hexl_enable),
		.o_ledg_enable(w_ledg_enable),
		.o_ledr_enable(w_ledr_enable),
		.o_mem_enable(w_mem_enable),
		.o_peripheral_addr(w_peripheral_addr),
		.o_memory_addr(w_memory_addr)
	);

	internal_memory internal_memory (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_lsu_wren(i_lsu_wren),
		.i_bmask(w_bmask),
		.i_memory_addr(w_memory_addr),
		.i_write_data(i_st_data),
		.i_mem_enable(w_mem_enable),
		.o_mem_data(w_mem_data)
	);
	
	ouput_peripheral_memory ouput_peripheral_memory (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_lsu_wren(i_lsu_wren),
		.i_bmask(w_bmask),
		.i_peripheral_addr(w_peripheral_addr),
		.i_write_data(i_st_data),
		.i_lcd_enable(w_lcd_enable),
		.i_hexh_enable(w_hexh_enable),
		.i_hexl_enable(w_hexl_enable),
		.i_ledg_enable(w_ledg_enable),
		.i_ledr_enable(w_ledr_enable),
		.o_lcd_data(w_lcd_data),
		.o_hexh_data(w_hexh_data),
		.o_hexl_data(w_hexl_data),
		.o_ledg_data(w_ledg_data),
		.o_ledr_data(w_ledr_data),
		.o_lcd_out(w_lcd_out),
		.o_hexh_out(w_hexh_out),
		.o_hexl_out(w_hexl_out),
		.o_ledg_out(w_ledg_out),
		.o_ledr_out(w_ledr_out)
	);

	assign o_io_ledr = w_ledr_out;
	assign o_io_ledg = w_ledg_out;
	assign o_io_lcd  = w_lcd_out;
	assign o_io_hex0 = w_hexl_out[  6:0];
	assign o_io_hex1 = w_hexl_out[ 14:8];
	assign o_io_hex2 = w_hexl_out[22:16];
	assign o_io_hex3 = w_hexl_out[30:24];
	assign o_io_hex4 = w_hexh_out[  6:0];
	assign o_io_hex5 = w_hexh_out[ 14:8];
	assign o_io_hex6 = w_hexh_out[22:16];
	assign o_io_hex7 = w_hexh_out[30:24];
	
	// input_peripheral_memory input_peripheral_memory (
	// 	.i_clk(i_clk),
	// 	.i_reset(i_reset),
	// 	.i_lsu_wren(i_lsu_wren),
	// 	.i_bmask(w_bmask),
	// 	.i_peripheral_addr(w_peripheral_addr),
	// 	.i_io_sw(i_io_sw),
	// 	.i_sw_enable(w_sw_enable),
	// 	.o_sw_data(w_sw_data)
	// );
	
	mux_by_enable_32bit mux_by_enable_32bit(
		.i_sw_enable(w_sw_enable),
		.i_lcd_enable(w_lcd_enable),
		.i_hexh_enable(w_hexh_enable),
		.i_hexl_enable(w_hexl_enable),
		.i_ledg_enable(w_ledg_enable),
		.i_ledr_enable(w_ledr_enable),
		.i_mem_enable(w_mem_enable),
		.i_sw_data(i_io_sw),
		.i_lcd_data(w_lcd_data),
		.i_hexh_data(w_hexh_data),
		.i_hexl_data(w_hexl_data),
		.i_ledg_data(w_ledg_data),
		.i_ledr_data(w_ledr_data),
		.i_mem_data(w_mem_data),
		.o_output_data(w_output_data)
	);
	
	store_control store(
		.i_type_access(i_type_access),
		.o_bmask(w_bmask)
	);

	load_control load(
		.i_output_data(w_output_data),
		.i_type_access(i_type_access), // LB, LH, LBU, LHU, SW
		.o_ld_data(o_ld_data)
	);
	
endmodule

module memory_encoder(
	input  wire [31:0] 	i_lsu_addr,
	output wire 		o_sw_enable,
	output wire 		o_lcd_enable,
	output wire 		o_hexh_enable,
	output wire 		o_hexl_enable,
	output wire 		o_ledg_enable,
	output wire 		o_ledr_enable,
	output wire 		o_mem_enable,
	output wire [11:0] 	o_peripheral_addr,
	output wire [10:0]  o_memory_addr
);
	assign o_peripheral_addr = i_lsu_addr[11:0];
	assign o_memory_addr     = i_lsu_addr[10:0];
	equal_20bit  u1(20'h1001_0,i_lsu_addr[31:12], o_sw_enable);
	equal_20bit  u2(20'h1000_4,i_lsu_addr[31:12], o_lcd_enable);
	equal_20bit  u3(20'h1000_3,i_lsu_addr[31:12], o_hexh_enable);
	equal_20bit  u4(20'h1000_2,i_lsu_addr[31:12], o_hexl_enable);
	equal_20bit  u5(20'h1000_1,i_lsu_addr[31:12], o_ledg_enable);	
	equal_20bit  u6(20'h1000_0,i_lsu_addr[31:12], o_ledr_enable);		
	equal_20bit  u7(20'h0000_0,i_lsu_addr[31:12], o_mem_enable);	
endmodule

module internal_memory (
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire 		i_lsu_wren,
	input  wire [3:0] 	i_bmask,
	input  wire [10:0]  i_memory_addr,
	input  wire [31:0] 	i_write_data,
	input  wire 		i_mem_enable,
	output wire [31:0] 	o_mem_data
);
	//RV32I provides a 32-bit address space that is byte-addressed.
	memory_ram #(.DEPTH(2048)) internal_memory (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_memory_addr),
		.i_bmask(i_bmask),
		.i_wren(i_mem_enable & i_lsu_wren), 
		.i_wdata(i_write_data),
		.o_rdata(o_mem_data)
	);

endmodule

module ouput_peripheral_memory(
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire 		i_lsu_wren,
	input  wire [3:0] 	i_bmask,
	input  wire [11:0] 	i_peripheral_addr,
	input  wire [31:0] 	i_write_data,
	input  wire 		i_lcd_enable,
	input  wire 		i_hexh_enable,
	input  wire 		i_hexl_enable,
	input  wire 		i_ledg_enable,
	input  wire 		i_ledr_enable,
	output wire [31:0] 	o_lcd_data,
	output wire [31:0] 	o_hexh_data,
	output wire [31:0] 	o_hexl_data,
	output wire [31:0] 	o_ledg_data,
	output wire [31:0] 	o_ledr_data,
	output wire [31:0] 	o_lcd_out,
	output wire [31:0] 	o_hexh_out,
	output wire [31:0] 	o_hexl_out,
	output wire [31:0] 	o_ledg_out,
	output wire [31:0] 	o_ledr_out
);

	//RV32I provides a 32-bit address space that is byte-addressed.
	// Other peripheral device with write by i_wdata
	wire w_lcd_write_enable = i_lcd_enable & i_lsu_wren;
	memory_ram #(.DEPTH(4096)) lcd_control_register (
		.i_clk(i_clk), 
		.i_reset(i_reset), 
		.i_addr(i_peripheral_addr), 
		.i_bmask(i_bmask),
		.i_wren(w_lcd_write_enable),
		.i_wdata(i_write_data),
		.o_rdata(o_lcd_data)
	);
	d_latch_32bit lcd_control_latch (
		.i_reset(i_reset),
		.i_en(w_lcd_write_enable),
		.i_d(o_lcd_data),
		.o_q(o_lcd_out)
	);

	wire w_hexh_write_enable = i_hexh_enable & i_lsu_wren;
	memory_ram #(.DEPTH(4096)) seven_segment_leds_7to4 (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_peripheral_addr),
		.i_bmask(i_bmask),
		.i_wren(w_hexh_write_enable),
		.i_wdata(i_write_data),
		.o_rdata(o_hexh_data)
	);
	d_latch_32bit seven_segment_leds_7to4_latch (
		.i_reset(i_reset),
		.i_en(w_hexh_write_enable),
		.i_d(o_hexh_data),
		.o_q(o_hexh_out)
	);

	wire w_hexl_write_enable = i_hexl_enable & i_lsu_wren;
	memory_ram #(.DEPTH(4096)) seven_segment_leds_3to0 (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_peripheral_addr),
		.i_bmask(i_bmask),
		.i_wren(w_hexl_write_enable),
		.i_wdata(i_write_data),
		.o_rdata(o_hexl_data)
	);
	d_latch_32bit seven_segment_leds_3to0_latch (
		.i_reset(i_reset),
		.i_en(w_hexl_write_enable),
		.i_d(o_hexl_data),
		.o_q(o_hexl_out)
	);

	wire w_ledg_write_enable = i_ledg_enable & i_lsu_wren;
	memory_ram #(.DEPTH(4096)) green_leds (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_peripheral_addr),
		.i_bmask(i_bmask),
		.i_wren(w_ledg_write_enable),
		.i_wdata(i_write_data),
		.o_rdata(o_ledg_data)
	);
	d_latch_32bit green_leds_latch (
		.i_reset(i_reset),
		.i_en(w_ledg_write_enable),
		.i_d(o_ledg_data),
		.o_q(o_ledg_out)
	);

	wire w_ledr_write_enable = i_ledr_enable & i_lsu_wren;
	memory_ram #(.DEPTH(4096)) red_leds (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_peripheral_addr),
		.i_bmask(i_bmask),
		.i_wren(w_ledr_write_enable),
		.i_wdata(i_write_data),
		.o_rdata(o_ledr_data)
	);
	d_latch_32bit red_leds_latch (
		.i_reset(i_reset),
		.i_en(w_ledr_write_enable),
		.i_d(o_ledr_data),
		.o_q(o_ledr_out)
	);

endmodule

module input_peripheral_memory(
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire 		i_lsu_wren,
	input  wire [3:0] 	i_bmask,
	input  wire [11:0] 	i_peripheral_addr,
	input  wire [31:0] 	i_io_sw,
	input  wire 		i_sw_enable,
	output wire [31:0] 	o_sw_data
);
	//RV32I provides a 32-bit address space that is byte-addressed.
	// Switch will write by SW device (i_io_sw)
	memory #(.DEPTH(4096)) Switches (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_addr(i_peripheral_addr),
		.i_bmask(i_bmask),
		.i_wren(i_sw_enable & i_lsu_wren),
		.i_wdata(i_io_sw),
		.o_rdata(o_sw_data)
	);

endmodule

module d_latch_32bit(
	input  wire 		i_reset,
	input  wire 		i_en,
	input  wire [31:0] 	i_d,
	output reg  [31:0] 	o_q
);
	always @(*) begin
		if(!i_reset) begin
			o_q <= 32'b0;
		end else if(i_en) begin
			o_q <= i_d;
		end
	end
endmodule

module mux_by_enable_32bit(
	input  wire 		i_sw_enable,
	input  wire 		i_lcd_enable,
	input  wire 		i_hexh_enable,
	input  wire 		i_hexl_enable,
	input  wire 		i_ledg_enable,
	input  wire 		i_ledr_enable,
	input  wire 		i_mem_enable,
	input  wire [31:0] 	i_sw_data,
	input  wire [31:0] 	i_lcd_data,
	input  wire [31:0] 	i_hexh_data,
	input  wire [31:0] 	i_hexl_data,
	input  wire [31:0] 	i_ledg_data,
	input  wire [31:0] 	i_ledr_data,
	input  wire [31:0] 	i_mem_data,
	output wire [31:0] 	o_output_data
);

	wire [31:0] w_mux1_out, w_mux2_out, w_mux3_out, w_mux4_out, w_mux5_out, w_mux6_out;
	mux_2to1_32bit mux1 (.i_in0(32'b0)		 , .i_in1(i_sw_data), 	.i_sel(i_sw_enable), 	.o_out(w_mux1_out));
	mux_2to1_32bit mux2 (.i_in0(w_mux1_out) , .i_in1(i_lcd_data), 	.i_sel(i_lcd_enable), 	.o_out(w_mux2_out));
	mux_2to1_32bit mux3 (.i_in0(w_mux2_out) , .i_in1(i_hexh_data), 	.i_sel(i_hexh_enable), 	.o_out(w_mux3_out));
	mux_2to1_32bit mux4 (.i_in0(w_mux3_out) , .i_in1(i_hexl_data), 	.i_sel(i_hexl_enable), 	.o_out(w_mux4_out));
	mux_2to1_32bit mux5 (.i_in0(w_mux4_out) , .i_in1(i_ledg_data), 	.i_sel(i_ledg_enable), 	.o_out(w_mux5_out));
	mux_2to1_32bit mux6 (.i_in0(w_mux5_out) , .i_in1(i_ledr_data), 	.i_sel(i_ledr_enable), 	.o_out(w_mux6_out));
	mux_2to1_32bit mux7 (.i_in0(w_mux6_out) , .i_in1(i_mem_data), 	.i_sel(i_mem_enable), 	.o_out(o_output_data));
	
endmodule

//implement load (LB, LH, LBU, LHU)
module load_control(
	input  wire [31:0] i_output_data,
	input  wire [2:0]  i_type_access, // LB, LH, LBU, LHU,
	output wire [31:0] o_ld_data
);
	wire [31:0] w_LB_out, w_LH_out, w_LW_out, w_LBU_out, w_LHU_out, w_default;
	assign w_LB_out  = {{24{i_output_data[7]}} , i_output_data[7:0]};
	assign w_LH_out  = {{16{i_output_data[15]}}, i_output_data[15:0]};
	assign w_LW_out  = {               	  		 i_output_data[31:0]};
	assign w_LBU_out = {24'b0				   , i_output_data[7:0]};
	assign w_LHU_out = {16'b0				   , i_output_data[15:0]};
	assign w_default = w_LW_out;
	mux_8to1_32bit  u1(
		.i_in0(w_LB_out), 	//000
		.i_in1(w_LH_out), 	//001
		.i_in2(w_LW_out), 	//010
		.i_in3(w_default),  //011
		.i_in4(w_LBU_out), 	//100
		.i_in5(w_LHU_out), 	//101
		.i_in6(w_default),	//110
		.i_in7(w_default),	//111
		.i_sel(i_type_access),
		.o_out(o_ld_data)
	);
endmodule

module store_control(
	input  wire [2:0]  	i_type_access, // SB SH SW
	output wire [3:0] 	o_bmask
);	
	wire [3:0] w_SB_out, w_SH_out, w_SW_out, w_default_out;
	assign w_SB_out = 4'b0001;
	assign w_SH_out = 4'b0011;
	assign w_SW_out = 4'b1111;
	assign w_default_out = w_SW_out;
	mux_4to1_4bit mux_4to1_4bit(
		.i_in0(w_SB_out), 			//00
		.i_in1(w_SH_out), 			//01
		.i_in2(w_SW_out), 			//10
		.i_in3(w_default_out), 		//11
		.i_sel(i_type_access[1:0]), 
		.o_out(o_bmask)
	);

endmodule