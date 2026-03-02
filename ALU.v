module ALU(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] aluop,
    output reg [31:0] result
);

always @(*) begin
    case(aluop)
        4'b0000: result = a + b;
        4'b0001: result = a - b;
        default: result = 0;
    endcase
end

endmodule