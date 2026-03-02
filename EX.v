`include "define.v"

module EX(
    input wire clk,
    input wire rst,

    input wire [5:0] op,
    input wire [5:0] func,
    input wire [4:0] rs,
    input wire [4:0] shamt,

    input wire [31:0] regaData,
    input wire [31:0] regbData,
    input wire [31:0] imm,

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

reg [63:0] mulres;

always @(*) begin

    regcData = 32'bx;
    memWrite = 0;
    memCe    = 0;
    exception = 0;
    eret = 0;
    excepttype = 0;

    cp0_we = 0;
    cp0_waddr = 0;
    cp0_wdata = 0;
    cp0_raddr = 0;

    // ================= R 型 =================
    if(op == `Inst_r) begin
        case(func)

            `Inst_add: regcData = regaData + regbData;
            `Inst_sub: regcData = regaData - regbData;
            `Inst_and: regcData = regaData & regbData;
            `Inst_or : regcData = regaData | regbData;
            `Inst_xor: regcData = regaData ^ regbData;
            `Inst_slt: regcData = ($signed(regaData) < $signed(regbData)) ? 1 : 0;

            `Inst_sll: regcData = regbData << shamt;
            `Inst_srl: regcData = regbData >> shamt;
            `Inst_sra: regcData = $signed(regbData) >>> shamt;

            `Inst_mult: begin
                mulres = $signed(regaData) * $signed(regbData);
            end

            `Inst_multu: begin
                mulres = regaData * regbData;
            end

            `Inst_div: begin
                Hi = $signed(regaData) % $signed(regbData);
                Lo = $signed(regaData) / $signed(regbData);
            end

            `Inst_divu: begin
                Hi = regaData % regbData;
                Lo = regaData / regbData;
            end

            `Inst_mfhi: regcData = Hi;
            `Inst_mflo: regcData = Lo;
            `Inst_mthi: Hi = regaData;
            `Inst_mtlo: Lo = regaData;

            `Inst_syscall: begin
                exception = 1;
                excepttype = 5'b01000;
            end

        endcase
    end

    // ================= I 型 =================
    case(op)

        `Inst_addi: regcData = regaData + imm;
        `Inst_andi: regcData = regaData & imm;
        `Inst_ori : regcData = regaData | imm;
        `Inst_xori: regcData = regaData ^ imm;
        `Inst_lui : regcData = {imm[15:0],16'b0};

        `Inst_lw: begin
            memCe = 1;
        end

        `Inst_sw: begin
            memCe = 1;
            memWrite = 1;
        end

    endcase

    // ================= COP0 =================
    if(op == `Inst_cop0) begin

        if(rs == `Inst_mfc0) begin
            cp0_raddr = regbData[4:0];
        end
        else if(rs == `Inst_mtc0) begin
            cp0_we = 1;
            cp0_waddr = regbData[4:0];
            cp0_wdata = regaData;
        end
        else if(rs == `Inst_eret_rs && func == `Inst_eret_fun) begin
            eret = 1;
        end
    end

end

endmodule