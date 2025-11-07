`define RESET_PERIOD 100
`define CLK_PERIOD   2
`define FINISH       40_000



//`include "D:/Application/altera/13.0sp1/Project/Single_Cycle_RISC_V/riscv_rv32i/00_src/include.sv"
module tbench;

// Clock and reset generator
logic i_clk;
logic i_reset;
int fd,fc;
//initial tsk_clock_gen(i_clk, `CLK_PERIOD);
  initial begin
//	 fd = $fopen("G:/CA/mile2/simulation_log.txt", "w");
//	 fc = $fopen("G:/CA/mile2/cycle.txt", "w");
    i_clk = 1'b1;
    forever #(2) i_clk = !i_clk;
  end
//initial tsk_reset(i_reset, `RESET_PERIOD); // Active Low Reset
  initial begin
    i_reset = 1'b0;
    #(100) i_reset = 1'b1;
  end
//initial tsk_timeout(`FINISH);
  initial begin
    #40_000 $display("\nTimeout...\n\n");
//	 $fclose(fd);
//	 $fclose(fc);
            $finish;
  end


logic [31:0]  i_io_sw  ;
logic [31:0]  o_io_ledr;
logic [31:0]  o_io_ledg;
logic [31:0]  o_io_lcd ;
logic [ 6:0]  o_io_hex0;
logic [ 6:0]  o_io_hex1;
logic [ 6:0]  o_io_hex2;
logic [ 6:0]  o_io_hex3;
logic [ 6:0]  o_io_hex4;
logic [ 6:0]  o_io_hex5;
logic [ 6:0]  o_io_hex6;
logic [ 6:0]  o_io_hex7;
logic [31:0]  o_pc_debug;
logic         o_insn_vld;

single_cycle dut (
    .i_clk       (i_clk     ) ,
    .i_reset     (i_reset   ) ,
    .i_io_sw     (i_io_sw   ) ,
    .o_io_ledr   (o_io_ledr ) ,
    .o_io_ledg   (o_io_ledg ) ,
    .o_io_lcd    (o_io_lcd  ) ,
    .o_io_hex0   (o_io_hex0 ) ,
    .o_io_hex1   (o_io_hex1 ) ,
    .o_io_hex2   (o_io_hex2 ) ,
    .o_io_hex3   (o_io_hex3 ) ,
    .o_io_hex4   (o_io_hex4 ) ,
    .o_io_hex5   (o_io_hex5 ) ,
    .o_io_hex6   (o_io_hex6 ) ,
    .o_io_hex7   (o_io_hex7 ) ,
    .o_pc_debug  (o_pc_debug) ,
    .o_insn_vld  (o_insn_vld)
);




scoreboard scoreboard (
    .i_clk       (i_clk     ) ,
    .i_reset     (i_reset   ) ,
    .i_io_sw     (i_io_sw   ) ,
    .o_io_ledr   (o_io_ledr ) ,
    .o_io_ledg   (o_io_ledg ) ,
    .o_io_lcd    (o_io_lcd  ) ,
    .o_io_hex0   (o_io_hex0 ) ,
    .o_io_hex1   (o_io_hex1 ) ,
    .o_io_hex2   (o_io_hex2 ) ,
    .o_io_hex3   (o_io_hex3 ) ,
    .o_io_hex4   (o_io_hex4 ) ,
    .o_io_hex5   (o_io_hex5 ) ,
    .o_io_hex6   (o_io_hex6 ) ,
    .o_io_hex7   (o_io_hex7 ) ,
    .o_pc_debug  (o_pc_debug) ,
    .o_insn_vld  (o_insn_vld)
);


driver driver(
  .i_clk    (i_clk  ),
  .i_reset  (i_reset),
  .o_sw_data(i_io_sw)
);




endmodule : tbench
