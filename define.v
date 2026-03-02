`define RstEnable  1'b1
`define RstDisable 1'b0

`define Zero 32'h00000000

`define Valid   1'b1
`define Invalid 1'b0

`define RomEnable  1'b1
`define RomDisable 1'b0

`define RamEnable  1'b1
`define RamDisable 1'b0
`define RamWrite   1'b1
`define RamUnWrite 1'b0

`define Nop 6'b000000


//======================
// opcode
//======================

`define Inst_r     6'b000000
`define Inst_ori   6'b001101
`define Inst_andi  6'b001100
`define Inst_addi  6'b001000
`define Inst_lw    6'b100011
`define Inst_sw    6'b101011
`define Inst_beq   6'b000100
`define Inst_bne   6'b000101
`define Inst_j     6'b000010
`define Inst_jal   6'b000011
`define Inst_ll    6'b110000
`define Inst_sc    6'b111000
`define Inst_cop0  6'b010000


//======================
// R-type funct
//======================

`define Inst_add   6'b100000
`define Inst_sub   6'b100010
`define Inst_and   6'b100100
`define Inst_or    6'b100101
`define Inst_xor   6'b100110
`define Inst_sll   6'b000000
`define Inst_srl   6'b000010
`define Inst_slt   6'b101010
`define Inst_jr    6'b001000
`define Inst_mult  6'b011000
`define Inst_div   6'b011010
`define Inst_mfhi  6'b010000
`define Inst_mflo  6'b010010
`define Inst_syscall 6'b001100
`define Inst_eret     6'b011000


//======================
// COP0 rs field
//======================

`define Inst_mfc0  5'b00000
`define Inst_mtc0  5'b00100
`define Inst_eret_rs 5'b10000