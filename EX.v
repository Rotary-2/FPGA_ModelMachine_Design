`include "define.v"

module EX(
    input wire clk,
    input wire rst,

    input wire [5:0] op,
    input wire [5:0] func,

    input wire [31:0] regaData,
    input wire [31:0] regbData,

    output reg [31:0] regcData,
    output reg [31:0] Hi,
    output reg [31:0] Lo,

    output reg memWrite,
    output reg memCe,

    output reg exception,
    output reg eret,
    output reg [4:0] excepttype,

    output reg cp0_we,
    output reg [4:0] cp0_waddr,
    output reg [31:0] cp0_wdata,
    output reg [4:0] cp0_raddr
);

// 默认值
always @(*) begin
    regcData = 0;
    memWrite = 0;
    memCe    = 0;
    exception = 0;
    eret = 0;
    excepttype = 0;

    cp0_we = 0;
    cp0_waddr = 0;
    cp0_wdata = 0;
    cp0_raddr = 0;

    if(op == `Inst_r) begin
        case(func)
            `Inst_add: regcData = regaData + regbData;
            `Inst_sub: regcData = regaData - regbData;
        endcase
    end

    // lw
    if(op == `Inst_lw) begin
        memCe = 1;
    end

    // sw
    if(op == `Inst_sw) begin
        memCe = 1;
        memWrite = 1;
    end

    // mfc0
    if(op == `Inst_cop0 && func == `Inst_mfc0) begin
        cp0_raddr = regbData[4:0];
    end

    // mtc0
    if(op == `Inst_cop0 && func == `Inst_mtc0) begin
        cp0_we = 1;
        cp0_waddr = regbData[4:0];
        cp0_wdata = regaData;
    end

    // eret
    if(op == `Inst_cop0 && func == `Inst_eret) begin
        eret = 1;
    end
end

endmodule