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
// LL/SC逻辑
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