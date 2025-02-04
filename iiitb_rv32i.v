module iiitb_rv32i(clk,RN,NPC,WB_OUT);
input clk;
input RN;
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


always @(posedge clk or posedge RN) begin
    if(RN) begin
    NPC<= 32'd0;
    BR_EN<= 1'd0; 
    REG[0] <= 32'h00000000;
    REG[1] <= 32'd10;
    REG[2] <= 32'd20;
    REG[3] <= 32'd30;
    REG[4] <= 32'd40;
    REG[5] <= 32'd50;
    REG[6] <= 32'd60;
    end
    else begin
    NPC <= BR_EN ? EX_MEM_ALUOUT : NPC +32'd1;
    BR_EN <= 1'd0;
    IF_ID_IR <=MEM[NPC];
    IF_ID_NPC <=NPC+32'd1;
    end
end

always @(posedge RN) begin
MEM[0] <= 32'h02328400;         // add r6,r3,r2.
MEM[1] <= 32'h02429380;         //sub r7,r4,r2.
MEM[2] <= 32'h0263a400;         //and r8,r6,r3.
MEM[3] <= 32'h02743480;         //or r9,r7,r5.
MEM[4] <= 32'h0284c500;         //xor r10,r8,r4.
MEM[5] <= 32'h02955580;         //slt r11,r9,r4.
MEM[6] <= 32'h00A60600;         //addi r12,r10,5.
MEM[7] <= 32'h00319181;         //sw r3,r9,3.
MEM[8] <= 32'h00428681;         //lw r13,r4,4.
MEM[9] <= 32'h00f10002;         //beq r1,r1,15.
MEM[20] <= 32'h00620700;        //add r14,r12,r2.
end

always @(posedge clk) begin

ID_EX_A <= REG[IF_ID_IR[19:15]];
ID_EX_B <= REG[IF_ID_IR[24:20]];
ID_EX_RD <= REG[IF_ID_IR[11:7]];
ID_EX_IR <= IF_ID_IR;
ID_EX_IMMEDIATE <= {{20{IF_ID_IR[31]}},IF_ID_IR[31:20]};
ID_EX_NPC<=IF_ID_NPC;
end

always@(posedge clk) begin
EX_MEM_IR <=  ID_EX_IR;

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
    BR_EN <= (ID_EX_IR[19:15] == ID_EX_IR[11:7]) ? 1'd1 : 1'd0;
    end
    BNE:begin 
    EX_MEM_ALUOUT <= ID_EX_NPC+ID_EX_IMMEDIATE;
    BR_EN <= (ID_EX_IR[19:15] != ID_EX_IR[11:7]) ? 1'd1 : 1'd0;
    end
    endcase
end

endcase
end
endmodule
