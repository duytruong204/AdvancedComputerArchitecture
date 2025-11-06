`timescale 1ns / 1ps
`include "D:/Application/altera/13.0sp1/Project/Single_Cycle_RISC_V/riscv_rv32i/00_src/include.sv"

module memory_tb;

    parameter DEPTH = 32;  // number of bytes

    // Inputs
    reg i_clk;
    reg [$clog2(DEPTH)-1:0] i_addr;
    reg [31:0] i_wdata;
    reg [3:0] i_bmask;
    reg i_wren;

    // Outputs
    wire [31:0] o_rdata;

    // DUT
    memory #(.DEPTH(DEPTH)) dut (
        .i_clk(i_clk),
        .i_addr(i_addr),
        .i_wdata(i_wdata),
        .i_bmask(i_bmask),
        .i_wren(i_wren),
        .o_rdata(o_rdata)
    );

    // Clock
    initial i_clk = 0;
    always #5 i_clk = ~i_clk;

    // Reference memory as bytes
    reg [7:0] mem [0:DEPTH-1]; // lowest byte

    integer i; // must be declared at the top of block

    // ---------------- Helper functions ----------------
    // Write reference memory (handles byte mask)
    task write_ref;
        input [$clog2(DEPTH)-1:0] addr;
        input [31:0] data;
        input [3:0] mask;
        integer w;
        begin
            w = addr;
            if (mask[0]) mem[w] = data[7:0];
            if (mask[1]) mem[w+1] = data[15:8];
            if (mask[2]) mem[w+2] = data[23:16];
            if (mask[3]) mem[w+3] = data[31:24];
        end
    endtask

    // Read reference memory (returns 32-bit word)
    function [31:0] read_ref;
        input [$clog2(DEPTH)-1:0] addr;
        integer w;
        begin
            w = addr;
				read_ref = {mem[w+3], mem[w+2], mem[w+1], mem[w]};
        end
    endfunction

    // ---------------- Main Testbench ----------------
    initial begin
        // --------------- Declare arrays first ---------------
        reg [31:0] partial_data [0:7];
        reg [3:0]  partial_mask [0:7];
        reg [$clog2(DEPTH)-1:0] partial_addr [0:7];
        integer k;

        // Initialize reference memory
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = 0;
        end

        // -------- Full word writes --------
        $display("\n=== Full Word Writes ===");
        for (i = 0; i < DEPTH; i = i + 4) begin
            i_addr = i;
            i_wdata = i * 100;
            i_bmask = 4'b1111;
            i_wren = 1;
            @(posedge i_clk);
            i_wren = 0;

            write_ref(i_addr, i_wdata, i_bmask);
            $display("WRITE Addr=%0d Data=0x%08X", i, i_wdata);
        end

        // Read & verify
        $display("\n=== Verify Full Words ===");
        for (i = 0; i < DEPTH; i = i + 4) begin
            i_addr = i;
            @(posedge i_clk);
            #1;
            if (o_rdata !== read_ref(i_addr))
                $display("ERROR Addr=%0d Read=0x%08X Expected=0x%08X", i, o_rdata, read_ref(i_addr));
            else
                $display("READ Addr=%0d Data=0x%08X [OK]", i, o_rdata);
        end

        // -------- Partial writes --------
        $display("\n=== Partial Writes ===");

        // Define partial write test cases
        partial_data[0] = 32'hAAAABBBB; partial_mask[0] = 4'b0001; partial_addr[0] = 1; // byte 0 only
        partial_data[1] = 32'hCCCCDDDD; partial_mask[1] = 4'b0010; partial_addr[1] = 2; // byte 1 only
        partial_data[2] = 32'h11112222; partial_mask[2] = 4'b0100; partial_addr[2] = 3; // byte 2 only
        partial_data[3] = 32'h33334444; partial_mask[3] = 4'b1000; partial_addr[3] = 4; // byte 3 only
        partial_data[4] = 32'h55556666; partial_mask[4] = 4'b0011; partial_addr[4] = 5; // lower 2 bytes
        partial_data[5] = 32'h77778888; partial_mask[5] = 4'b1100; partial_addr[5] = 6; // upper 2 bytes
        partial_data[6] = 32'h9999AAAA; partial_mask[6] = 4'b0111; partial_addr[6] = 7; // lower 3 bytes
        partial_data[7] = 32'hBBBBCCCC; partial_mask[7] = 4'b1110; partial_addr[7] = 8; // upper 3 bytes

        for (k = 0; k < 8; k = k + 1) begin
            i_addr = partial_addr[k];
            i_wdata = partial_data[k];
            i_bmask = partial_mask[k];
            i_wren = 1;
            @(posedge i_clk); 
            i_wren = 0;
            write_ref(i_addr, i_wdata, i_bmask);
            $display("WRITE Addr=%0d Data=0x%08X Mask=%b", i_addr, i_wdata, i_bmask);
        end

        // Verify after partial writes
        $display("\n=== Verify After Partial Writes ===");
        for (i = 0; i < DEPTH; i = i + 4) begin
            i_addr = i;
            @(posedge i_clk);
            #1;
            if (o_rdata !== read_ref(i_addr))
                $display("ERROR Addr=%0d Read=0x%08X Expected=0x%08X", i, o_rdata, read_ref(i_addr));
            else
                $display("READ Addr=%0d Data=0x%08X [OK]", i, o_rdata);
        end

        $display("\nTestbench done.");
        $finish;
    end

endmodule
