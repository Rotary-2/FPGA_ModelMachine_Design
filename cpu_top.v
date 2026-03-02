`include "define.v"

module cpu_top(
    input wire clk,
    input wire rst
);

reg [31:0] pc;
wire [31:0] next_pc;

wire exception;
wire eret;

wire ll;
wire sc;
wire syscall;

reg LLbit;

wire [31:0] epc;
wire [31:0] cp0_data;

wire [5:0] opcode;
wire [5:0] funct;
wire [4:0] rs;

assign opcode = 6'b0;   // 这里应该来自指令
assign funct  = 6'b0;
assign rs     = 5'b0;

// ========================
// 控制器实例
// ========================
control u_control(
    .opcode(opcode),
    .funct(funct),
    .rs(rs),
    .regwrite(),
    .memwrite(),
    .memread(),
    .mfc0(),
    .mtc0(),
    .eret(eret),
    .syscall(syscall),
    .ll(ll),
    .sc(sc)
);

// ========================
// CP0 实例
// ========================
cp0 u_cp0(
    .clk(clk),
    .rst(rst),
    .we_i(1'b0),
    .waddr_i(5'b0),
    .data_i(32'b0),
    .raddr_i(5'b0),
    .data_o(cp0_data),
    .exception_i(exception),
    .current_pc_i(pc),
    .excepttype_i(5'b01000),
    .eret_i(eret),
    .epc_o(epc),
    .status_o(),
    .cause_o()
);

// ========================
// PC 更新
// ========================
always @(posedge clk) begin
    if(rst)
        pc <= 0;
    else
        pc <= next_pc;
end

assign next_pc =
        eret ? epc :
        exception ? 32'h80000180 :
        pc + 4;

// =======================
// LLbit
// =======================
always @(posedge clk) begin
    if(rst)
        LLbit <= 0;
    else if(ll)
        LLbit <= 1;
    else if(sc)
        LLbit <= 0;
end

assign exception = syscall;

endmodule