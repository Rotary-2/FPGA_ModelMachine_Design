module data_mem(
    input wire clk,
    input wire memread,
    input wire memwrite,
    input wire ll,
    input wire sc,
    input wire LLbit,

    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,
    output reg sc_success
);

reg [31:0] ram[0:1023];

always @(posedge clk) begin

    sc_success <= 0;

    if(memread)
        rdata <= ram[addr[11:2]];

    if(memwrite && !sc)
        ram[addr[11:2]] <= wdata;

    if(sc) begin
        if(LLbit) begin
            ram[addr[11:2]] <= wdata;
            sc_success <= 1;
        end
        else begin
            sc_success <= 0;
        end
    end

end

endmodule