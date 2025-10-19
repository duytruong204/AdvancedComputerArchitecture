// Author: Hai Cao
// Copyright 2024

`define RESETPERIOD 100
`define CLK_PERIOD  2
`define FINISH      10_000


`define DUMP_VCD


module tbench;


// Clock and reset generator
logic i_clk;
logic i_rst_n;


initial tsk_clock_gen(i_clk, `CLK_PERIOD);
initial tsk_reset(i_rst_n, `RESETPERIOD); // Active Low Reset
initial tsk_timeout(`FINISH);



// Wave dumping
initial begin : proc_dump_wave
    $shm_open("wave.shm");
    $shm_probe(dut, "AS");
end


logic [31:0]  o_pc_debug;
logic [31:0]  i_io_sw  ;
logic [31:0]  i_io_btn ;
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
logic         o_insn_vld;

single_cycle   dut (
  .i_clk       (i_clk     ) ,
  .i_rst_n     (i_rst_n   ) ,
  .i_io_sw     (i_io_sw   ) ,
  //.i_io_btn    (i_io_btn  ) ,
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
  .i_rst_n     (i_rst_n   ) ,
  .i_io_sw     (i_io_sw   ) ,
  .i_io_btn    (i_io_btn  ) ,
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
  .i_clk    (i_clk    ),
  .i_rst_n  (i_rst_n  ),
  .i_io_sw  (i_io_sw  ),
  .i_io_btn (i_io_btn )
);




endmodule : tbench
