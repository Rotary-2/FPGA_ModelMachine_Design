`include "define.v"

module InstMem(
    input wire ce,
    input wire [31:0] addr,
    output wire [31:0] data
);

reg [31:0] instmem [1023:0];

assign data = (ce)? instmem[addr[11:2]] : 0;

initial begin
    instmem[0] = 32'h20010005; // addi
    instmem[1] = 32'h20020003;
    instmem[2] = 32'h00221820; // add
    instmem[3] = 32'hac030000; // sw
    instmem[4] = 32'h8c040000; // lw
end

endmodule
