`include "define.v"

module ALU(
    input wire clk,
    input wire rst,

    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0]  shamt,
    input wire [5:0]  aluop,

    output reg [31:0] result,
    output reg zero,
    output reg overflow
);

// HI LO 寄存器
reg [31:0] HI;
reg [31:0] LO;

reg [63:0] mult_temp;

always @(*) begin
    result   = 32'b0;
    zero     = 0;
    overflow = 0;

    case(aluop)

        // ========= 算术 =========
        `Inst_add, `Inst_addi: begin
            result = a + b;
            overflow = (~a[31] & ~b[31] & result[31]) |
                       (a[31] & b[31] & ~result[31]);
        end

        `Inst_sub: begin
            result = a - b;
            overflow = (~a[31] & b[31] & result[31]) |
                       (a[31] & ~b[31] & ~result[31]);
        end

        `Inst_slt: begin
            result = ($signed(a) < $signed(b)) ? 1 : 0;
        end

        // ========= 逻辑 =========
        `Inst_and, `Inst_andi: result = a & b;
        `Inst_or,  `Inst_ori : result = a | b;
        `Inst_xor, `Inst_xori: result = a ^ b;

        `Inst_lui: result = {b[15:0],16'b0};

        // ========= 移位 =========
        `Inst_sll: result = b << shamt;
        `Inst_srl: result = b >> shamt;
        `Inst_sra: result = $signed(b) >>> shamt;

        // ========= 乘法 =========
        `Inst_mult: begin
            mult_temp = $signed(a) * $signed(b);
            result = mult_temp[31:0];
        end

        `Inst_multu: begin
            mult_temp = a * b;
            result = mult_temp[31:0];
        end

        // ========= 除法 =========
        `Inst_div: begin
            result = $signed(a) / $signed(b);
        end

        `Inst_divu: begin
            result = a / b;
        end

        // ========= HI/LO 访问 =========
        `Inst_mfhi: result = HI;
        `Inst_mflo: result = LO;

        `Inst_mthi: result = a;
        `Inst_mtlo: result = a;

        // ========= 分支判断 =========
        `Inst_bgtz: result = ($signed(a) > 0) ? 1 : 0;
        `Inst_bltz: result = ($signed(a) < 0) ? 1 : 0;

        default: result = 32'b0;

    endcase

    if(result == 0)
        zero = 1;

end


// HI LO 更新（时序）
always @(posedge clk) begin
    if(rst) begin
        HI <= 0;
        LO <= 0;
    end
    else begin
        case(aluop)

            `Inst_mult: begin
                mult_temp = $signed(a) * $signed(b);
                HI <= mult_temp[63:32];
                LO <= mult_temp[31:0];
            end

            `Inst_multu: begin
                mult_temp = a * b;
                HI <= mult_temp[63:32];
                LO <= mult_temp[31:0];
            end

            `Inst_div: begin
                HI <= $signed(a) % $signed(b);
                LO <= $signed(a) / $signed(b);
            end

            `Inst_divu: begin
                HI <= a % b;
                LO <= a / b;
            end

            `Inst_mthi: HI <= a;
            `Inst_mtlo: LO <= a;

        endcase
    end
end

endmodule