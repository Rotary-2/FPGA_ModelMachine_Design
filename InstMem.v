`include "define.v"

module InstMem(
    input wire ce,
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] writeData,
    input wire memWrite,       // 对应 sw
    output reg [31:0] data,    // lw输出
    output reg [31:0] memOut   // 方便调试
);

reg [31:0] instmem [1023:0];
reg [31:0] datamem [1023:0];

always @(posedge clk) begin
    if (ce) begin
        data <= instmem[addr[11:2]]; // 输出指令

        if (memWrite) begin
            datamem[addr[11:2]] <= writeData; // sw写内存
            memOut <= writeData;              // memOut显示写入的数据
        end else begin
            memOut <= datamem[addr[11:2]];   // lw时显示读出的数据
        end
    end else begin
        data <= 32'b0;
        memOut <= 32'b0;
    end
end

initial begin
    // -----------------------------
    // 基础数据准备
    // -----------------------------
    instmem[0]  = 32'h2001000A; // addi $1,$0,10
    instmem[1]  = 32'h20020003; // addi $2,$0,3
    instmem[2]  = 32'h00221820; // add  $3,$1,$2
    instmem[3]  = 32'h00222022; // sub  $4,$1,$2
    //instmem[4]  = 32'h00222824; // and  $5,$1,$2
    //instmem[5]  = 32'h00223025; // or   $6,$1,$2
    //instmem[6]  = 32'h00223826; // xor  $7,$1,$2
    //instmem[7]  = 32'h00024080; // sll  $8,$2,2
    //instmem[8]  = 32'h00024882; // srl  $9,$2,2
    //instmem[9]  = 32'h00025083; // sra  $10,$2,2
    //instmem[10] = 32'h00200008; // jr   $1
    //instmem[11] = 32'h0022582A; // slt  $11,$1,$2
    //instmem[12] = 32'h00220018; // mult $1,$2
    //instmem[13] = 32'h00006012; // mflo $12
    //instmem[14] = 32'h00006810; // mfhi $13
    //instmem[15] = 32'h00220019; // multu $1,$2
    //instmem[16] = 32'h0022001A; // div  $1,$2
    //instmem[17] = 32'h0022001B; // divu $1,$2
    //instmem[18] = 32'h00007011; // mthi $14
    //instmem[19] = 32'h00007813; // mtlo $15
    //instmem[20] = 32'h0020F809; // jalr $31,$1
    //instmem[21] = 32'h3023000F; // andi $3,$1,15
    //instmem[22] = 32'h3424000F; // ori  $4,$1,15
    //instmem[23] = 32'h3825000F; // xori $5,$1,15
    //instmem[24] = 32'h3C060001; // lui  $6,1
    //instmem[25] = 32'hAC030000; // sw $3,0($0)
    //instmem[26] = 32'h8C070000; // lw $7,0($0)
    //instmem[27] = 32'h10220002; // beq $1,$2,2
    //instmem[28] = 32'h14220002; // bne $1,$2,2
    //instmem[29] = 32'h08000010; // j 0x40
    //instmem[30] = 32'h0C000010; // jal 0x40
    //instmem[31] = 32'h0000000C; // syscall
    //instmem[32] = 32'h40816000; // mtc0 $1,$12
    //instmem[33] = 32'h40016800; // mfc0 $1,$13
    //instmem[34] = 32'h42000018; // eret
end

endmodule