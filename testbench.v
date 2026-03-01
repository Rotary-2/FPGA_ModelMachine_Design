`include "define.v"

module soc_tb;
reg clk;
reg rst;

initial begin
    clk=0;
    rst=1;
    #100 rst=0;
    #2000 $stop;
end

always #10 clk=~clk;

MIPS mips0(clk,rst);

endmodule
