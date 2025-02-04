module iiitb_rv32i(clk, RN, NPC, WB_OUT);
input clk;
input RN;
integer k;
wire EX_MEM_COND;

reg BR_EN;

// I_FETCH STAGE
reg [31:0] IF_ID_IR, IF_ID_NPC;

// I_DECODE STAGE
reg [31:0] ID_EX_A, ID_EX_B, ID_EX_RD, ID_EX_IMMEDIATE, ID_EX_IR, ID_EX_NPC;

// EXECUTION STAGE
reg [31:0] EX_MEM_ALUOUT, EX_MEM_B, EX_MEM_IR;

parameter ADD = 3'd0,
          SUB = 3'd1,
          AND = 3'd2,
          OR  = 3'd3,
          XOR = 3'd4,
          SLT = 3'd5,
          MUL = 3'd6,    // New instruction
          DIV = 3'd7,    // New instruction
          MOD = 3'd8,    // New instruction
          LUI = 3'd9,    // New instruction
          NOP = 3'd10,   // New instruction
          SLTI = 3'd11,  // New instruction
          SLTU = 3'd12,  // New instruction
          XORI = 3'd13,  // Same as XOR but with immediate
          ROTL = 3'd14,  // New instruction
          ROTR = 3'd15,  // New instruction

          LW = 3'd0,
          SW = 3'd1,

          BEQ = 3'd0,
          BNE = 3'd1,
          BLT = 3'd2,     // New instruction
          BGT = 3'd3,     // New instruction

          SLL = 3'd0,
          SRL = 3'd1;

parameter AR_TYPE = 7'd0,
          M_TYPE  = 7'd1,
          BR_TYPE = 7'd2,
          SH_TYPE = 7'd3;

// MEMORY STAGE
reg [31:0] MEM_WB_IR, MEM_WB_ALUOUT, MEM_WB_LDM;

output reg [31:0] WB_OUT, NPC;

// REG FILE
reg [31:0] REG[0:31];                                               
// 64x32 IMEM
reg [31:0] MEM[0:63];                                             
// 64x32 DMEM
reg [31:0] DM[0:63];

always @(posedge clk or posedge RN) begin
    if (RN) begin
        NPC <= 32'd0;
        BR_EN <= 1'd0;
        REG[0] <= 32'h00000000;
        REG[1] <= 32'd10;
        REG[2] <= 32'd20;
        REG[3] <= 32'd30;
        REG[4] <= 32'd40;
        REG[5] <= 32'd50;
        REG[6] <= 32'd60;
        REG[7] <= 32'd70;
        REG[8] <= 32'd80;
        REG[9] <= 32'd90;
        REG[10] <= 32'd100;
    end else begin
        NPC <= BR_EN ? EX_MEM_ALUOUT : NPC + 32'd1;
        BR_EN <= 1'd0;
        IF_ID_IR <= MEM[NPC];
        IF_ID_NPC <= NPC + 32'd1;
    end
end

// Initialize some instructions in memory
always @(posedge RN) begin
    MEM[0] <= 32'h02208300;  // ADD r6, r1, r2
    MEM[1] <= 32'h02209380;  // SUB r7, r1, r2
    MEM[2] <= 32'h0230A400;  // AND r8, r1, r3
    MEM[3] <= 32'h02513480;  // OR r9, r2, r5
    MEM[4] <= 32'h0240C500;  // XOR r10, r1, r4
    MEM[5] <= 32'h02415580;  // SLT r11, r2, r4
    MEM[6] <= 32'h00520600;  // ADDI r12, r4, 5
    MEM[7] <= 32'h00209181;  // SW r3, r1, 2
    MEM[8] <= 32'h00208681;  // LW r13, r1, 2
    MEM[9] <= 32'h00F00002;  // BEQ r0, r0, 15
    MEM[10] <= 32'h01409002; // BNE r0, r1, 20
    MEM[11] <= 32'h00520601; // ADDI r14, r4, 5
    MEM[12] <= 32'h00208783; // SLL r15, r1, r2
    MEM[13] <= 32'h00271803; // SRL r16, r14, r2
    MEM[14] <= 32'h03200D00; // MUL r17, r1, r2  // New instruction
    MEM[15] <= 32'h03600D80; // DIV r18, r1, r3  // New instruction
    MEM[16] <= 32'h03A00F00; // MOD r19, r1, r3  // New instruction
    MEM[17] <= 32'h03E00100; // LUI r20, 0x00100  // New instruction
    MEM[18] <= 32'h00000000; // NOP  // New instruction
    MEM[19] <= 32'h00C00000; // SLTI r21, r2, 10  // New instruction
    MEM[20] <= 32'h02000000; // SLTU r22, r2, r3  // New instruction
    MEM[21] <= 32'h02800D80; // ROTL r23, r1, 4  // New instruction
    MEM[22] <= 32'h02C00D80; // ROTR r24, r1, 4  // New instruction
end

// I_DECODE STAGE
always @(posedge clk) begin
    ID_EX_A <= REG[IF_ID_IR[19:15]];
    ID_EX_B <= REG[IF_ID_IR[24:20]];
    ID_EX_RD <= REG[IF_ID_IR[11:7]];
    ID_EX_IR <= IF_ID_IR;
    ID_EX_IMMEDIATE <= {{20{IF_ID_IR[31]}}, IF_ID_IR[31:20]};
    ID_EX_NPC <= IF_ID_NPC;
end

// EXECUTION STAGE
always @(posedge clk) begin
    EX_MEM_IR <= ID_EX_IR;

    case (ID_EX_IR[6:0])
        AR_TYPE: begin
            if (ID_EX_IR[31:25] == 7'd1) begin
                case (ID_EX_IR[14:12])
                    ADD: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_B;
                    SUB: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_B;
                    AND: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
                    OR:  EX_MEM_ALUOUT <= ID_EX_A | ID_EX_B;
                    XOR: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
                    SLT: EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;
                    MUL: EX_MEM_ALUOUT <= ID_EX_A * ID_EX_B;  // New instruction
                    DIV: EX_MEM_ALUOUT <= ID_EX_A / ID_EX_B;  // New instruction
                    MOD: EX_MEM_ALUOUT <= ID_EX_A % ID_EX_B;  // New instruction
                endcase
            end else begin
                case (ID_EX_IR[14:12])
                    ADDI: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
                    SUBI: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_IMMEDIATE;
                    ANDI: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_IMMEDIATE;
                    ORI:  EX_MEM_ALUOUT <= ID_EX_A | ID_EX_IMMEDIATE;
                    XORI: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_IMMEDIATE;
                    SLTI: EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_IMMEDIATE) ? 32'd1 : 32'd0;  // New instruction
                    SLTU: EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;  // New instruction
                    LUI: EX_MEM_ALUOUT <= {ID_EX_IMMEDIATE[31:12], 12'd0};  // New instruction
                endcase
            end
        end

        M_TYPE: begin
            case (ID_EX_IR[14:12])
                LW:  EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
                SW:  DM[ID_EX_A + ID_EX_IMMEDIATE] <= REG[ID_EX_IR[11:7]];
            endcase
        end

        BR_TYPE: begin
            case (ID_EX_IR[14:12])
                BEQ: begin
                    EX