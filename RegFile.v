`include "define.v"

module RegFile(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    input wire [4:0] regaAddr,
    input wire [4:0] regbAddr,
    output wire [31:0] regaData,
    output wire [31:0] regbData
);

reg [31:0] reg32 [31:0];

assign regaData = (regaAddr==0)?0:reg32[regaAddr];
assign regbData = (regbAddr==0)?0:reg32[regbAddr];

always @(posedge clk)
    if(we && waddr!=0)
        reg32[waddr] <= wdata;

endmodule
