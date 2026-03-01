`include "define.v"

module EX(
    input wire rst,
    input wire [5:0] op,
    input wire [5:0] func,
    input wire [31:0] regaData,
    input wire [31:0] regbData,
    output reg [31:0] regcData,
    output reg [31:0] Hi,
    output reg [31:0] Lo
);

always @(*) begin
    regcData = 0;
    if(op == `Inst_r) begin
        case(func)
            `Inst_add: regcData = regaData + regbData;
            `Inst_sub: regcData = regaData - regbData;
            `Inst_and: regcData = regaData & regbData;
            `Inst_or : regcData = regaData | regbData;
            `Inst_xor: regcData = regaData ^ regbData;
            `Inst_sll: regcData = regbData << regaData[4:0];
            `Inst_srl: regcData = regbData >> regaData[4:0];
            `Inst_slt: regcData = ($signed(regaData)<$signed(regbData));
            `Inst_mult: {Hi,Lo} = $signed(regaData)*$signed(regbData);
            `Inst_div: begin
                Lo = $signed(regaData)/$signed(regbData);
                Hi = $signed(regaData)%$signed(regbData);
            end
            `Inst_mfhi: regcData = Hi;
            `Inst_mflo: regcData = Lo;
        endcase
    end
end

endmodule
