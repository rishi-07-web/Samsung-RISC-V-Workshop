module iiitb_rv32i_tb;

reg clk, RN;
wire [31:0] WB_OUT, NPC;

iiitb_rv32i rv32(clk, RN, NPC, WB_OUT);

always #3 clk = !clk;

initial begin
    // Initialize reset signal and clock
    RN = 1'b1;
    clk = 1'b1;

    // Initialize dumpfile for simulation trace
    $dumpfile("iiitb_rv32i.vcd");
    $dumpvars(0, iiitb_rv32i_tb);

    // Apply reset
    #5 RN = 1'b0;

    // Run the simulation for a given time
    #300 $finish;
end

endmodule