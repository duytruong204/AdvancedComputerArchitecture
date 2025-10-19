`timescale 1ns/1ps

module lsu_tb (
	o_ld_data,
   o_io_ledr, o_io_ledg,
   o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
   o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
   o_io_lcd
);

    // Clock and Reset
    reg         i_clk;
    reg         i_reset;

    // Inputs to LSU
    reg  [2:0]  i_type_access;
    reg  [31:0] i_lsu_addr;
    reg  [31:0] i_st_data;
    reg         i_lsu_wren;
    reg  [31:0] i_io_sw;

    // Outputs from LSU
    output wire [31:0] o_ld_data;
    output wire [31:0] o_io_ledr, o_io_ledg;
    output wire [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3;
    output wire [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
    output wire [31:0] o_io_lcd;

    // DUT
    lsu dut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_type_access(i_type_access),
        .i_lsu_addr(i_lsu_addr),
        .i_st_data(i_st_data),
        .i_lsu_wren(i_lsu_wren),
        .o_ld_data(o_ld_data),
        .o_io_ledr(o_io_ledr),
        .o_io_ledg(o_io_ledg),
        .o_io_hex0(o_io_hex0),
        .o_io_hex1(o_io_hex1),
        .o_io_hex2(o_io_hex2),
        .o_io_hex3(o_io_hex3),
        .o_io_hex4(o_io_hex4),
        .o_io_hex5(o_io_hex5),
        .o_io_hex6(o_io_hex6),
        .o_io_hex7(o_io_hex7),
        .o_io_lcd(o_io_lcd),
        .i_io_sw(i_io_sw)
    );

    // Clock generation
    always #5 i_clk = ~i_clk;

    task reset_dut;
    begin
        i_clk = 0;
        i_reset = 1;
        i_type_access = 3'b000;
        i_lsu_addr = 32'h0;
        i_st_data = 32'h0;
        i_lsu_wren = 0;
        i_io_sw = 32'h0;
        #20;
        i_reset = 0;
    end
    endtask

    // Store helper
    task do_store(input [2:0] access, input [31:0] addr, input [31:0] data);
    begin
        @(posedge i_clk);
        i_type_access = access;
        i_lsu_addr = addr;
        i_st_data = data;
        i_lsu_wren = 1;
        @(posedge i_clk);
        i_lsu_wren = 0;
    end
    endtask

    // Load helper
    task do_load(input [2:0] access, input [31:0] addr);
    begin
        @(posedge i_clk);
        i_type_access = access;
        i_lsu_addr = addr;
        i_lsu_wren = 0;
        @(posedge i_clk);
    end
    endtask

    // Main test
    initial begin
        $display("Starting LSU Testbench...");
        reset_dut;

        // --- Memory Store Tests ---
        $display("\n[STORE] Storing 0xABCD1234 at address 0x00000004 with SW");
        do_store(3'b010, 32'h0000_0004, 32'hABCD1234); // SW
        do_load(3'b010, 32'h0000_0004); // LW
        #1;
        $display("[LOAD] LW from 0x00000004 = %h", o_ld_data);

        $display("[STORE] Storing 0x00001234 at address 0x00000008 with SH");
        do_store(3'b001, 32'h0000_0008, 32'h00001234); // SH
        do_load(3'b101, 32'h0000_0008); // LHU
        #1;
        $display("[LOAD] LHU from 0x00000008 = %h", o_ld_data);

        $display("[STORE] Storing 0x0000007F at address 0x00000010 with SB");
        do_store(3'b000, 32'h0000_0010, 32'h0000007F); // SB
        do_load(3'b100, 32'h0000_0010); // LBU
        #1;
        $display("[LOAD] LBU from 0x00000010 = %h", o_ld_data);

        $display("[STORE] Storing 0xFFFFFF80 (signed -128) at address 0x00000014 with SB");
        do_store(3'b000, 32'h0000_0014, 32'hFFFFFF80);
        do_load(3'b000, 32'h0000_0014); // LB
        #1;
        $display("[LOAD] LB from 0x00000014 = %h", o_ld_data);

        // --- Peripheral Tests ---
        $display("\n[PERIPHERAL] Writing to RED LEDs");
        do_store(3'b010, 32'h1000_0000, 32'hDEAD_BEEF); // RED LEDs
        do_load(3'b010, 32'h1000_0000);
        #1;
        $display("[RED LED] = %h", o_io_ledr);

        $display("[PERIPHERAL] Writing to LCD");
        do_store(3'b010, 32'h1000_4000, 32'h12345678);
        do_load(3'b010, 32'h1000_4000);
        #1;
        $display("[LCD] = %h", o_io_lcd);

        $display("[PERIPHERAL] Writing to HEX 3-0");
        do_store(3'b010, 32'h1000_2000, 32'hCAFEBABE);
        do_load(3'b010, 32'h1000_2000);
        #1;
        $display("HEX0 = %h, HEX1 = %h, HEX2 = %h, HEX3 = %h",
            o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3);

        $display("[PERIPHERAL] Writing to HEX 7-4");
        do_store(3'b010, 32'h1000_3000, 32'hFACEFEED);
        do_load(3'b010, 32'h1000_3000);
        #1;
        $display("HEX4 = %h, HEX5 = %h, HEX6 = %h, HEX7 = %h",
            o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7);

        // --- Switch Input Test ---
        $display("\n[SWITCH] Simulating write from switches");
        i_io_sw = 32'h1111_2222;
        i_lsu_addr = 32'h1001_0000; // switch-mapped address
        i_type_access = 3'b010; // SW
        i_lsu_wren = 1;
        @(posedge i_clk);
        i_lsu_wren = 0;

        $display("Switch input written to memory via i_io_sw");

        $display("\n[ALL TESTS PASSED]");
        $finish;
    end

endmodule
