`include "define.v"

module MIPS(
    input wire clk,
    input wire rst
);

wire [31:0] pc;
wire [31:0] instruction;
wire romCe;

wire [31:0] regaData, regbData;
wire [31:0] aluOut;
wire [31:0] memOut;

wire [4:0] rs = instruction[25:21];
wire [4:0] rt = instruction[20:16];
wire [4:0] rd = instruction[15:11];

wire [5:0] op = instruction[31:26];
wire [5:0] func = instruction[5:0];

wire [31:0] imm = {{16{instruction[15]}},instruction[15:0]};

IF if0(clk,rst,0,0,romCe,pc);
InstMem im(romCe,pc,instruction);
RegFile rf(clk,rst,1,rd,aluOut,rs,rt,regaData,regbData);
EX ex0(rst,op,func,regaData,regbData,aluOut,,);

endmodule
