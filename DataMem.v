`include "define.v"

module DataMem(
    input wire clk,
    input wire ce,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut
);

reg [31:0] datamem [1023:0];

assign dataOut = (ce==`RamEnable)? datamem[addr[11:2]] : 0;

always @(posedge clk)
    if(ce && we)
        datamem[addr[11:2]] <= dataIn;

endmodule
