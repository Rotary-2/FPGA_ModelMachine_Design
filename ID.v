`include "define.v"

module ID (
    input wire rst,
    input wire [31:0] inst,
    input wire [31:0] regaData_i,
    input wire [31:0] regbData_i,
    output reg [5:0] op,
    output reg [31:0] regaData,
    output reg [31:0] regbData,
    output reg regaRead,
    output reg regbRead,
    output reg regcWrite,
    output reg [4:0] regaAddr,
    output reg [4:0] regbAddr,
    output reg [4:0] regcAddr
);

    wire [5:0] inst_op = inst[31:26];  // Extract opcode
    wire [5:0] func = inst[5:0];       // Extract function code (for R-type)
    reg [31:0] imm;                    // Immediate value

    always @(*) begin
        if (rst == `RstEnable) begin
            // Reset state
            op = `Nop;
            regaRead = `Invalid;
            regbRead = `Invalid;
            regcWrite = `Invalid;
            regaAddr = `Zero;
            regbAddr = `Zero;
            regcAddr = `Zero;
            imm = `Zero;
        end else begin
            case(inst_op)
                `Inst_ori: begin
                    op = `Inst_or;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = `Zero;       // zero
                    regcAddr = inst[20:16]; // rt
                    imm = {16'h0, inst[15:0]};
                end
                `Inst_addi: begin
                    op = `Inst_add;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = `Zero;       // zero
                    regcAddr = inst[20:16]; // rt
                    imm = {{16{inst[15]}}, inst[15:0]}; // Sign-extended immediate
                end
                `Inst_lw: begin
                    op = `Inst_lw;
                    regaRead = `Valid;
                    regbRead = `Invalid;
                    regcWrite = `Valid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = `Zero;       // zero
                    regcAddr = inst[20:16]; // rt
                    imm = {{16{inst[15]}}, inst[15:0]}; // Sign-extended immediate
                end
                `Inst_sw: begin
                    op = `Inst_sw;
                    regaRead = `Valid;
                    regbRead = `Valid;
                    regcWrite = `Invalid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = inst[20:16];  // rt
                    regcAddr = `Zero;
                    imm = {{16{inst[15]}}, inst[15:0]}; // Sign-extended immediate
                end
                `Inst_beq: begin
                    op = `Inst_beq;
                    regaRead = `Valid;
                    regbRead = `Valid;
                    regcWrite = `Invalid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = inst[20:16];  // rt
                    regcAddr = `Zero;
                    imm = {{16{inst[15]}}, inst[15:0]}; // Sign-extended immediate
                end
                `Inst_bne: begin
                    op = `Inst_bne;
                    regaRead = `Valid;
                    regbRead = `Valid;
                    regcWrite = `Invalid;
                    regaAddr = inst[25:21];  // rs
                    regbAddr = inst[20:16];  // rt
                    regcAddr = `Zero;
                    imm = {{16{inst[15]}}, inst[15:0]}; // Sign-extended immediate
                end
                `Inst_j: begin
                    op = `Inst_j;
                    regaRead = `Invalid;
                    regbRead = `Invalid;
                    regcWrite = `Invalid;
                    regaAddr = `Zero;
                    regbAddr = `Zero;
                    regcAddr = `Zero;
                    imm = inst[25:0]; // Jump target address (shifted)
                end
                default: begin
                    op = `Nop;
                    regaRead = `Invalid;
                    regbRead = `Invalid;
                    regcWrite = `Invalid;
                    regaAddr = `Zero;
                    regbAddr = `Zero;
                    regcAddr = `Zero;
                    imm = `Zero;
                end
            endcase
        end
    end

    always @(*) begin
        if (rst == `RstEnable)
            regaData = `Zero;
        else if (regaRead == `Valid)
            regaData = regaData_i;
        else
            regaData = imm;
    end

    always @(*) begin
        if (rst == `RstEnable)
            regbData = `Zero;
        else if (regbRead == `Valid)
            regbData = regbData_i;
        else
            regbData = imm;
    end

endmodule
