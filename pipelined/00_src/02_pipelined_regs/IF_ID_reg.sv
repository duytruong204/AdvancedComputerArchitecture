//==============================================================
//  IF/ID Pipeline Register
//  - Holds PC, PC+4, and instruction between IF → ID stage
//  - Supports STALL and FLUSH control
//==============================================================
module IF_ID_reg(
    input wire        i_clk,    // Clock
    input wire        i_reset,  // Active-low reset
    input wire        i_stall,  // Stall signal (0 = update, 1 = hold)
    input wire        i_flush,  // Flush signal (0 = normal, 1 = clear)
    
    input wire [31:0] i_pc,     // Incoming PC value
    output reg [31:0] o_pc,     // Latched PC output
    
    input wire [31:0] i_inst,   // Incoming instruction
    output reg [31:0] o_inst    // Latched instruction output
);
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin          
            o_pc     <= 32'b0;
            o_inst   <= 32'h13; // NOP instruction
        end 
        else if(i_flush) begin
            o_pc     <= 32'b0;
            o_inst   <= 32'h13; // NOP instruction
        end
        else if(!i_stall) begin
            o_pc     <= i_pc;
            o_inst   <= i_inst;
        end
    end
endmodule