`include "define.v"

module MIPS(
    input wire clk,
    input wire rst
);

// =====================================================
// IF
// =====================================================
wire [31:0] pc;
wire [31:0] instruction;
wire romCe;

wire exception;
wire eret;
wire [31:0] epc;

wire jCe    = 1'b0;
wire [31:0] jAddr = 32'b0;

IF if0(
    .clk(clk),
    .rst(rst),
    .exception(exception),
    .eret(eret),
    .epc(epc),
    .jAddr(jAddr),
    .jCe(jCe),
    .romCe(romCe),
    .pc(pc)
);

// =====================================================
// 指令存储器
// =====================================================
InstMem im(
    .ce(romCe),
    .clk(clk),
    .addr(pc),
    .writeData(32'b0),
    .memWrite(1'b0),
    .data(instruction),
    .memOut()
);

// =====================================================
// 指令字段
// =====================================================
wire [4:0] rs   = instruction[25:21];
wire [4:0] rt   = instruction[20:16];
wire [4:0] rd   = instruction[15:11];
wire [5:0] op   = instruction[31:26];
wire [5:0] func = instruction[5:0];

// =====================================================
// 寄存器堆
// =====================================================
wire [31:0] regaData;
wire [31:0] regbData;
wire [31:0] writeData;
wire [4:0]  writeReg;
wire regWrite;

RegFile rf(
    .clk(clk),
    .rst(rst),
    .we(regWrite),
    .waddr(writeReg),
    .wdata(writeData),
    .regaAddr(rs),
    .regbAddr(rt),
    .regaData(regaData),
    .regbData(regbData)
);

// =====================================================
// EX
// =====================================================
wire [31:0] aluOut;
wire [31:0] Hi;
wire [31:0] Lo;

wire memWrite;
wire memCe;

wire cp0_we;
wire [4:0] cp0_waddr;
wire [31:0] cp0_wdata;
wire [4:0] cp0_raddr;

wire [4:0] excepttype;

wire [31:0] imm = {{16{instruction[15]}}, instruction[15:0]}; 

EX ex0(
    .clk(clk),
    .rst(rst),

    .op(op),
    .func(func),

    .regaData(regaData),
    .regbData(regbData),

    .regcData(aluOut),
    .Hi(Hi),
    .Lo(Lo),

    .memWrite(memWrite),
    .memCe(memCe),

    .exception(exception),
    .eret(eret),
    .excepttype(excepttype),

    .cp0_we(cp0_we),
    .cp0_waddr(cp0_waddr),
    .cp0_wdata(cp0_wdata),
    .cp0_raddr(cp0_raddr),

    .imm(imm),
    .shamt(instruction[10:6])
);

// =====================================================
// 数据存储器
// =====================================================
wire [31:0] memOut;

DataMem dm(
    .clk(clk),
    .ce(memCe),
    .we(memWrite),
    .addr(aluOut),
    .dataIn(regbData),
    .dataOut(memOut)
);

// =====================================================
// CP0
// =====================================================
wire [31:0] cp0_rdata;
wire [31:0] status;
wire [31:0] cause;

cp0 cp0_0(
    .clk(clk),
    .rst(rst),

    .we_i(cp0_we),
    .waddr_i(cp0_waddr),
    .data_i(cp0_wdata),

    .raddr_i(cp0_raddr),
    .data_o(cp0_rdata),

    .exception_i(exception),
    .current_pc_i(pc),
    .excepttype_i(excepttype),

    .eret_i(eret),

    .epc_o(epc),
    .status_o(status),
    .cause_o(cause)
);

// =====================================================
// 写回控制
// =====================================================

// 写回寄存器选择
assign writeReg =
    (op == `Inst_r)        ? rd :
    (op == `Inst_lw)       ? rt :
    (op == `Inst_addi)     ? rt :
    (op == `Inst_andi)     ? rt :
    (op == `Inst_ori)      ? rt :
    (op == `Inst_xori)     ? rt :
    (op == `Inst_lui)      ? rt :
    (op == `Inst_cop0)     ? rt :
                             5'b00000; // 默认写寄存器0，不写

// 寄存器写使能
assign regWrite =
    (op == `Inst_r)        ? 1'b1 :
    (op == `Inst_lw)       ? 1'b1 :
    (op == `Inst_addi)     ? 1'b1 :
    (op == `Inst_andi)     ? 1'b1 :
    (op == `Inst_ori)      ? 1'b1 :
    (op == `Inst_xori)     ? 1'b1 :
    (op == `Inst_lui)      ? 1'b1 :
    (op == `Inst_cop0)     ? 1'b1 :
                             1'b0;

// 写回数据选择
assign writeData =
    (op == `Inst_lw)       ? memOut :
    (op == `Inst_addi)     ? aluOut :
    (op == `Inst_andi)     ? aluOut :
    (op == `Inst_ori)      ? aluOut :
    (op == `Inst_xori)     ? aluOut :
    (op == `Inst_lui)      ? {imm[15:0],16'b0} : // LUI 高16位填 imm
    (op == `Inst_r)        ? aluOut :
    (op == `Inst_cop0)     ? cp0_rdata :
                             32'b0;

endmodule