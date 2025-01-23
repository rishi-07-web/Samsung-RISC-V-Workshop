# Samsung-RISC-V-Workshop

# Samsung RISC-V Workshop Documentation


## Table of Contents
- [Task 1: RISC-V ISA and GNU Toolchain](#task-1-risc-v-isa-and-gnu-toolchain)
- [Task 2: RISC-V Architecture Analysis](#task-2-risc-v-architecture-analysis)
- [Task 3: RISC-V Instruction Sets](#task-3-risc-v-instruction-sets)
- [Task 4: RISC-V Functional Simulation](#task-4-risc-v-functional-simulation)
## Task 1: RISC-V ISA and GNU Toolchain

### Overview
This task introduces the fundamental concepts of RISC-V Instruction Set Architecture (ISA) and sets up the development environment using the VSDSquadron board.

### Implementation Steps

#### 1. Commands to run C program in Ubantu
![RISC-V GNU Toolchain Setup](image/vsd-1.png)


#### 2. C program for Sum of n integer
![Cross-Compilation Workflow](image/vsd-2.png)


#### 3. Commands for Examination of generated RISC-V assembly code
![Assembly Code Analysis](image/vsd-3.png)


#### 4. Memory Architecture Analysis (main function)
![Memory Mapping Details](image/vsd-4.png)


## License
This project documentation is licensed under the MIT License.

## Task 2: RISC-V Architecture Analysis
### Analysis of RISC-V architecture using spike function
![riskv -task 2](image/riscv-task2.jpg)


## Task 3: RISC-V Instruction Sets

RISC-V (Reduced Instruction Set Computer - V) is an open-standard instruction set architecture (ISA) rooted in established reduced instruction set computing principles. Unlike proprietary ISAs, RISC-V is freely available, allowing unrestricted academic and commercial use without licensing fees. This openness has made RISC-V a compelling choice for research, education, and industry applications, promoting innovation and development across various fields.

**Significance of Instruction Formats**

Grasping the structure of instruction formats is vital for several reasons:

- Instruction Decoding: Understanding different instruction formats enables accurate decoding, essential for the CPU's correct execution of instructions.

- Pipeline Design: Instruction formats influence CPU pipeline design. Proper management ensures efficient stages of instruction fetch, decode, execution, memory access, and write-back.

- Compiler Design: Compilers generate machine code adhering to the ISA's instruction formats. A thorough understanding aids in optimizing code generation, enhancing performance and efficiency.

- Debugging and Verification: Knowledge of instruction formats assists in debugging and verifying hardware and software, helping identify issues related to incorrect instruction execution or pipeline hazards.

- Extensibility and Customization: RISC-V's modular and extensible design allows for custom extensions. Understanding base instruction formats is crucial for creating and integrating custom instructions tailored to specific applications or performance needs.

RISC-V instructions are categorized based on their field organization, with each type containing specific fields such as opcode, func3, func7, immediate values, and register numbers. The primary instruction types include:

- R-type: Register type
- I-type: Immediate type
- S-type: Store type
- B-type: Branch type
- U-type: Upper immediate type
- J-type: Jump type

**Opcode and Function Fields**

- Opcode: Specifies the instruction type.
- func3 and func7: Further define the operation within the instruction type. For instance, in R-type instructions, func3 and func7 distinguish between operations like addition and subtraction.

Immediate Values and Registers

- Immediate Values: Encoded in specific instruction fields. For example, I-type instructions use a 12-bit immediate value field along with source and destination registers.
- Registers: Specified in fields such as rd (destination register), rs1 (source register 1), and rs2 (source register 2).

Example - U-Type Instruction

Consider the `lui` (Load Upper Immediate) instruction:

- Assembly: `lui x5, 0x12345`
- Encoding: The immediate value `0x12345` is placed in the instruction’s immediate field, and the destination register `x5` is specified in the `rd` field.
- Machine Execution: The machine loads the upper 20 bits of the immediate value into the upper 20 bits of register `x5`.

Instruction Categories

- Arithmetic Instructions:
  - ADD: Adds values in two registers and stores the result in a third register.
    - Example: `ADD rd, rs1, rs2` (rd = rs1 + rs2)
  - ADDI: Adds a register and an immediate value (constant) and stores the result.
    - Example: `ADDI rd, rs1, imm` (rd = rs1 + imm)

- Logical Instructions:
  - AND, OR, XOR: Perform bitwise operations.
    - Example: `AND rd, rs1, rs2` (rd = rs1 & rs2)

- Branch Instructions:
  - BEQ: Branch if equal.
    - Example: `BEQ rs1, rs2, offset` (if rs1 == rs2, PC = PC + offset)
  - BNE: Branch if not equal.
    - Example: `BNE rs1, rs2, offset` (if rs1 != rs2, PC = PC + offset)

- Load and Store Instructions:
  - LW: Load word from memory.
    - Example: `LW rd, offset(rs1)` (rd = memory[rs1 + offset])
  - SW: Store word to memory.
    - Example: `SW rs1, offset(rs2)` (memory[rs2 + offset] = rs1)

- Special Instructions:
  - AUIPC: Add upper immediate to PC.
    - Example: `AUIPC rd, imm` (rd = PC + imm << 12)

- Branch and Jump Instructions:
  - Jump (J): Unconditional branch to a specified address.
  - Branch (B): Conditional branch based on a comparison.
# r-type instruction
![riskv -task 3](image/r-type.png)
# i-type insruction
![riskv -task 3](image/r-type.png)
# s and b type instruction
![riskv -task 3](image/s-type.png)
# u and j type instruction
![riskv -task 3](image/u-type.png)

# 1.addi(I-type)
- Instruction: addi a5, a5, 1
- Binary: 0x00178793
- Fields:
  - opcode: 0010011
  - rd: 01111 (a5)
  - rs1: 01111 (a5)
  - imm[11:0]: 000000000001
# 2.or(R-type) 
- Instruction: or a1, a1, a3
- Binary: 0x00B5B633
Fields:
   - opcode: 0110011
   - rd: 01011 (a1)
   - rs1: 01011 (a1)
   - rs2: 01101 (a3)
   - funct3: 110
# 3.add(R-type)
- instruction add a5, a4, a5:
- Binary: 0x00F78733
Fields: 
  - opcode: 0110011
  - rd: 01111 (a5)
  - rs1: 01110 (a4)
  - rs2: 01111 (a5)
  - funct3: 000
# 4.lw(I-type)
- instruction lw a2,-24(s0)
- Binary: 0xFF443603
Fields: 
  - opcode: 0000011
  - rd: 01100 (a2)
  - rs1: 01000 (s0)
  - imm[11:0]: 111111110100 (-24)
# 5.jarl(u-Type)
- instruction a5
- Binary: 0x0000F067
Fields: 
  - opcode: 1100111
  - rd: 01111 (a5)
  - rs1: 00000 (zero)
  - imm[11:0]: 000000000000
# 6.BEQ (B-type)
- instruction beq a0,zero,10
- Binary: 0x00050863
  - Fields:
  - opcode: 1100011
  - funct3: 000
  - rs1: 01010 (a0)
  - rs2: 00000 (zero)
  - imm[12:1]: 000000001000
# 7. SW (S-type)
- instruction  sw a0,0(s1)
- Binary: 0x00A4A023
Fields:
  - opcode: 0100011
  - funct3: 010
  - s1: 01001 (s1)
  - rs2: 01010 (a0)
  - imm[11:0]: 000000000000
# 8.JAL (J-type)
- instruction jal ra,800
- Binary: 0x008000EF
Fields:
  - opcode: 1101111
  - rd: 00001 (ra)
  - imm[20:1]: 00000001000
# 9.SUB (R-type)
- instruction sub a0,a0,a1
- Binary: 0x40B50533
Fields:
  - opcode: 0110011
  - rd: 01010 (a0)
  - rs1: 01010 (a0)
  - rs2: 01011 (a1)
  - funct7: 0100000
# 10.mv(I-type)
- Instruction: mv a0, a5 (encoded as addi a0, a5, 0)
- Binary: 0x00078513
Fields:
  - opcode: 0010011
  - rd: 01010 (a0)
  - rs1: 01111 (a5)
  - imm[11:0]: 000000000000 (0)
# 11.blt(SB type)
- Instruction: blt a1, a2, 16
- Binary: 0x0085C463
Fields:
  - opcode: 1100011
  - rs1: 01011 (a1)
  - rs2: 01100 (a2)
  - imm[12|10:5|4:1|11]: 000000001000 (offset = 16)
# 12.s11(R-type)
- Instruction: sll a2, a1, a0
Fields:
  - opcode: 0110011 (R-type)
  - funct7: 0000000
  - rs2: 01010 (a0)
  - rs1: 01011 (a1)
  - funct3: 001 (shift left logical)
  - rd: 01100 (a2)
  - 32-bit Representation: `0x00A5C
## Task 4: RISC-V Functional Simulation
module iiitb_rv32i(clk,RN,NPC,WB_OUT);
input clk;
input RN;
//input EN;
integer k;
wire  EX_MEM_COND ;

reg 
BR_EN;

//I_FETCH STAGE
reg[31:0] 
IF_ID_IR,
IF_ID_NPC;                                

//I_DECODE STAGE
reg[31:0] 
ID_EX_A,
ID_EX_B,
ID_EX_RD,
ID_EX_IMMEDIATE,
ID_EX_IR,ID_EX_NPC;      

//EXECUTION STAGE
reg[31:0] 
EX_MEM_ALUOUT,
EX_MEM_B,EX_MEM_IR;                        

parameter 
ADD=3'd0,
SUB=3'd1,
AND=3'd2,
OR=3'd3,
XOR=3'd4,
SLT=3'd5,

ADDI=3'd0,
SUBI=3'd1,
ANDI=3'd2,
ORI=3'd3,
XORI=3'd4,

LW=3'd0,
SW=3'd1,

BEQ=3'd0,
BNE=3'd1,

SLL=3'd0,
SRL=3'd1;


parameter 
AR_TYPE=7'd0,
M_TYPE=7'd1,
BR_TYPE=7'd2,
SH_TYPE=7'd3;


//MEMORY STAGE
reg[31:0] 
MEM_WB_IR,
MEM_WB_ALUOUT,
MEM_WB_LDM;                      


output reg [31:0]WB_OUT,NPC;

//REG FILE
reg [31:0]REG[0:31];                                               
//64*32 IMEM
reg [31:0]MEM[0:31];                                             
//64*32 DMEM
reg [31:0]DM[0:31];   


//assign EX_MEM_COND = (EX_MEM_IR[6:0]==BR_TYPE) ? 1'b1 : 1'b0;
                     //1'b1 ? (ID_EX_A!=ID_EX_RD) : 1'b0;

always @(posedge clk or posedge RN) begin
    if(RN) begin
    NPC<= 32'd0;
    //EX_MEM_COND <=1'd0;
    BR_EN<= 1'd0; 
    REG[0] <= 32'h00000000;
    REG[1] <= 32'd1;
    REG[2] <= 32'd2;
    REG[3] <= 32'd3;
    REG[4] <= 32'd4;
    REG[5] <= 32'd5;
    REG[6] <= 32'd6;
    end
    //else if(EX_MEM_COND)
    //NPC <= EX_MEM_ALUOUT;

    //else if (EX_MEM_COND)begin
    //NPC = EX_MEM_COND ? EX_MEM_ALUOUT : NPC +32'd1;
    //NPC <= EX_MEM_ALUOUT;
    //EX_MEM_COND = BR_EN;
    //NPC = BR_EN ? EX_MEM_ALUOUT : NPC +32'd1;
    //BR_EN = 1'd0;
    //EX_MEM_COND <= 1'd0;
    //end
    else begin
    NPC <= BR_EN ? EX_MEM_ALUOUT : NPC +32'd1;
    BR_EN <= 1'd0;
    //NPC <= NPC +32'd1;
    //EX_MEM_COND <=1'd0;
    IF_ID_IR <=MEM[NPC];
    IF_ID_NPC <=NPC+32'd1;
    end
end

always @(posedge RN) begin
    //NPC<= 32'd0;
MEM[0] <= 32'h02208300;         // add r6,r1,r2.(i1)
MEM[1] <= 32'h02209380;         //sub r7,r1,r2.(i2)
MEM[2] <= 32'h0230a400;         //and r8,r1,r3.(i3)
MEM[3] <= 32'h02513480;         //or r9,r2,r5.(i4)
MEM[4] <= 32'h0240c500;         //xor r10,r1,r4.(i5)
MEM[5] <= 32'h02415580;         //slt r11,r2,r4.(i6)
MEM[6] <= 32'h00520600;         //addi r12,r4,5.(i7)
MEM[7] <= 32'h00209181;         //sw r3,r1,2.(i8)
MEM[8] <= 32'h00208681;         //lw r13,r1,2.(i9)
MEM[9] <= 32'h00f00002;         //beq r0,r0,15.(i10)
MEM[25] <= 32'h00210700;         //add r14,r2,r2.(i11)
//MEM[27] <= 32'h01409002;         //bne r0,r1,20.(i12)
//MEM[49] <= 32'h00520601;         //addi r12,r4,5.(i13)
//MEM[50] <= 32'h00208783;         //sll r15,r1,r2(2).(i14)
//MEM[51] <= 32'h00271803;         //srl r16,r14,r2(2).(i15) */

//for(k=0;k<=31;k++)
//REG[k]<=k;
/*REG[0] <= 32'h00000000;
REG[1] <= 32'd1;
REG[2] <= 32'd2;
REG[3] <= 32'd3;
REG[4] <= 32'd4;
REG[5] <= 32'd5;
REG[6] <= 32'd6;
REG[7] = 32'd7;
REG[6] = 32'd6;
REG[7] = 32'd7;
REG[8] = 32'd8;
REG[9] = 32'd9;
REG[10] = 32'd10;
REG[11] = 32'd11;
REG[12] = 32'd12;
REG[13] = 32'd13;
REG[14] = 32'd14;
REG[15] = 32'd15;
REG[16] = 32'd16;
REG[17] = 32'd17;*/
/*end
else begin
    if(EX_MEM_COND==1 && EX_MEM_IR[6:0]==BR_TYPE) begin
    NPC=EX_MEM_ALUOUT;
    IF_ID=MEM[NPC];
    end

    else begin
    NPC<=NPC+32'd1;
    IF_ID<=MEM[NPC];
    IF_ID_NPC<=NPC+32'd1;
    end
end*/
end
//I_FECT STAGE

/*always @(posedge clk) begin

//NPC <= rst ? 32'd0 : NPC+32'd1;

if(EX_MEM_COND==1 && EX_MEM_IR[6:0]==BR_TYPE) begin
NPC=EX_MEM_ALUOUT;
IF_ID=MEM[NPC];
end

else begin
NPC<=NPC+32'd1;
IF_ID<=MEM[NPC];
IF_ID_NPC<=NPC+32'd1;
end
end*/


//FETCH STAGE END

//I_DECODE STAGE 
always @(posedge clk) begin

ID_EX_A <= REG[IF_ID_IR[19:15]];
ID_EX_B <= REG[IF_ID_IR[24:20]];
ID_EX_RD <= REG[IF_ID_IR[11:7]];
ID_EX_IR <= IF_ID_IR;
ID_EX_IMMEDIATE <= {{20{IF_ID_IR[31]}},IF_ID_IR[31:20]};
ID_EX_NPC<=IF_ID_NPC;
end
//DECODE STAGE END

/*always@(posedge clk) begin
if(ID_EX_IR[6:0]== BR_TYPE)
EX_MEM_COND <= EN;
else
EX_MEM_COND <= !EN;
end*/


//EXECUTION STAGE

always@(posedge clk) begin

EX_MEM_IR <=  ID_EX_IR;
//EX_MEM_COND <= (ID_EX_IR[6:0] == BR_TYPE) ? 1'd1 :1'd0;


case(ID_EX_IR[6:0])

AR_TYPE:begin
    if(ID_EX_IR[31:25]== 7'd1)begin
    case(ID_EX_IR[14:12])

    ADD:EX_MEM_ALUOUT <= ID_EX_A + ID_EX_B;
    SUB:EX_MEM_ALUOUT <= ID_EX_A - ID_EX_B;
    AND:EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
    OR :EX_MEM_ALUOUT <= ID_EX_A | ID_EX_B;
    XOR:EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
    SLT:EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;

    endcase
    end
    else begin
        case(ID_EX_IR[14:12])
        ADDI:EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
        SUBI:EX_MEM_ALUOUT <= ID_EX_A - ID_EX_IMMEDIATE;
        ANDI:EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
        ORI:EX_MEM_ALUOUT  <= ID_EX_A | ID_EX_B;
        XORI:EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
        endcase
    end

end

M_TYPE:begin
    case(ID_EX_IR[14:12])
    LW  :EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
    SW  :EX_MEM_ALUOUT <= ID_EX_IR[24:20] + ID_EX_IR[19:15];
    endcase
end

BR_TYPE:begin
    case(ID_EX_IR[14:12])
    BEQ:begin 
    EX_MEM_ALUOUT <= ID_EX_NPC+ID_EX_IMMEDIATE;
    BR_EN <= 1'd1 ? (ID_EX_IR[19:15] == ID_EX_IR[11:7]) : 1'd0;
    //BR_PC = EX_MEM_COND ? EX_MEM_ALUOUT : 1'd0; 
end
BNE:begin 
    EX_MEM_ALUOUT <= ID_EX_NPC+ID_EX_IMMEDIATE;
    BR_EN <= (ID_EX_IR[19:15] != ID_EX_IR[11:7]) ? 1'd1 : 1'd0;
end
endcase
end

SH_TYPE:begin
case(ID_EX_IR[14:12])
SLL:EX_MEM_ALUOUT <= ID_EX_A << ID_EX_B;
SRL:EX_MEM_ALUOUT <= ID_EX_A >> ID_EX_B;
endcase
end

endcase
end


//EXECUTION STAGE END
		
//MEMORY STAGE
always@(posedge clk) begin

MEM_WB_IR <= EX_MEM_IR;

case(EX_MEM_IR[6:0])

AR_TYPE:MEM_WB_ALUOUT <=  EX_MEM_ALUOUT;
SH_TYPE:MEM_WB_ALUOUT <=  EX_MEM_ALUOUT;

M_TYPE:begin
case(EX_MEM_IR[14:12])
LW:MEM_WB_LDM <= DM[EX_MEM_ALUOUT];
SW:DM[EX_MEM_ALUOUT]<=REG[EX_MEM_IR[11:7]];
endcase
end

endcase
end

// MEMORY STAGE END


//WRITE BACK STAGE
always@(posedge clk) begin

case(MEM_WB_IR[6:0])

AR_TYPE:begin 
WB_OUT<=MEM_WB_ALUOUT;
REG[MEM_WB_IR[11:7]]<=MEM_WB_ALUOUT;
end

SH_TYPE:begin
WB_OUT<=MEM_WB_ALUOUT;
REG[MEM_WB_IR[11:7]]<=MEM_WB_ALUOUT;
end

M_TYPE:begin
case(MEM_WB_IR[14:12])
LW:begin
WB_OUT<=MEM_WB_LDM;
REG[MEM_WB_IR[11:7]]<=MEM_WB_LDM;
end
endcase
end



endcase
end
//WRITE BACK STAGE END

endmodule

