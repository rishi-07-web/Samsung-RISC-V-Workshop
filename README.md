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


endcase
end
//WRITE BACK STAGE END

endmodule

## Task 4: RISC-V Functional Simulation
### add r6,r3,r2 //32'h02328400
![Screenshot 2025-02-04 154801](https://github.com/user-attachments/assets/1c6fac7f-1ec6-4ea2-b493-d4707f81abec)
### sub r7,r4,r2 //32'h02429380;     
![Screenshot 2025-02-04 154830](https://github.com/user-attachments/assets/04c31289-1629-42da-970a-9f0cc6f7a040)
###  and r8,r6,r3 //32'h0263a400
![Screenshot 2025-02-04 154846](https://github.com/user-attachments/assets/4146502c-2653-4014-9eb5-103bbe040ce1)
###  or r9,r7,r5 //32'h02743480
![Screenshot 2025-02-04 154904](https://github.com/user-attachments/assets/ef7c01c7-3308-4171-adf1-f418a0d13778)
### xor r10,r8,r4 //32'h0284c500
![Screenshot 2025-02-04 154928](https://github.com/user-attachments/assets/39ff8442-8907-4de3-8906-827ab6c248ca)
### slt r11,r9,r4 //32'h02955580
![Screenshot 2025-02-04 154937](https://github.com/user-attachments/assets/cf0aad0a-cfaf-4cf4-9d20-719c6ca42639)
### addi r12,r10,5 //32'h00A60600
![Screenshot 2025-02-04 154947](https://github.com/user-attachments/assets/9609aff6-b572-4ad7-b33b-772877dbd75d)
### sw r5,r9,5 // 32'h00518181 
![Screenshot 2025-02-04 154959](https://github.com/user-attachments/assets/d05b75ae-4f67-492f-8b3a-fdf3d29116b0)
###  lw r13,r6,6 //32'h00628681
![Screenshot 2025-02-04 155010](https://github.com/user-attachments/assets/221f3984-b3b9-47bc-8a71-a2946a8fe93e)
###  beq r1,r1,15 //32'h00f10002
![Screenshot 2025-02-04 155020](https://github.com/user-attachments/assets/60df0192-b1f1-4da8-91c2-5d4d761da161)










