module iiitb_rv32i(clk, RN, NPC, WB_OUT);
input clk;
input RN;
integer k;
wire  EX_MEM_COND;

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

          ADDI = 3'd0,
          SUBI = 3'd1,
          ANDI = 3'd2,
          ORI  = 3'd3,
          XORI = 3'd4,

          LW = 3'd0,
          SW = 3'd1,

          BEQ = 3'd0,
          BNE = 3'd1,

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
                endcase
            end else begin
                case (ID_EX_IR[14:12])
                    ADDI: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
                    SUBI: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_IMMEDIATE;
                    ANDI: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_IMMEDIATE;
                    ORI:  EX_MEM_ALUOUT <= ID_EX_A | ID_EX_IMMEDIATE;
                    XORI: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_IMMEDIATE;
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
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_IR[19:15] == ID_EX_IR[11:7]) ? 1'd1 : 1'd0;
                end
                BNE: begin
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_IR[19:15] != ID_EX_IR[11:7]) ? 1'd1 : 1'd0;
                end
            endcase
        end

        SH_TYPE: begin
            case (ID_EX_IR[14:12])
                SLL: EX_MEM_ALUOUT <= ID_EX_A << ID_EX_B;
                SRL: EX_MEM_ALUOUT <= ID_EX_A >> ID_EX_B;
            endcase
        end
    endcase
end

// MEMORY STAGE
always @(posedge clk) begin
    MEM_WB_IR <= EX_MEM_IR;

    case (EX_MEM_IR[6:0])
        AR_TYPE, SH_TYPE: MEM_WB_ALUOUT <= EX_MEM_ALUOUT;

        M_TYPE: begin
            case (EX_MEM_IR[14:12])
                LW: MEM_WB_LDM <= DM[EX_MEM_ALUOUT];
                SW: DM[EX_MEM_ALUOUT] <= REG[EX_MEM_IR[11:7]];
            endcase
        end
    endcase
end

// WRITE BACK STAGE
always @(posedge clk) begin
    case (MEM_WB_IR[6:0])
        AR_TYPE, SH_TYPE: begin
            WB_OUT <= MEM_WB_ALUOUT;
            REG[MEM_WB_IR[11:7]] <= MEM_WB_ALUOUT;
        end

        M_TYPE: begin
            case (MEM_WB_IR[14:12])
                LW: begin
                    WB_OUT <= MEM_WB_LDM;
                    REG[MEM_WB_IR[11:7]] <= MEM_WB_LDM;
                end
            endcase
        end
    endcase
end

endmodule