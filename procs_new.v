`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2022 07:44:58 PM
// Design Name: 
// Module Name: procs_new
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module procsn32(
    input clock,
    input [31:0] inst,
    output [31:0] result
    );
    
    wire [4:0] rs1_num, rs2_num, rd_num;
    reg [4:0] rd_num_r, rd_num_rr;
    wire [3:0] ctrl;
    wire [31:0]  rs1, rs2;
    wire [31:0] inst_r,outP;
    
    //Instruction Decode Stage
    inst_dec ID (inst, rs1_num, rs2_num, rd_num, inst_r, clock);
    //Control Signal Stage
    control CTRL (inst_r, ctrl, clock);
    
    always@(posedge clock) begin
    rd_num_r <= rd_num;
    rd_num_rr <= rd_num_r;
    end 
    
    //ALU Stage
    ALU ALU (rs1, rs2, ctrl, outP, clock);
    //Register Bank module
    regBank regB(clock, rs1_num, rs2_num, rd_num_rr, outP, rs1, rs2);
            
    assign result = outP;
    
endmodule

module regBank(input clock, input [4:0] rs1_num, rs2_num, dataW_num, 
               input [31:0] dataW, output reg [31:0] data1, data2);
reg [31:0] regBank [0:31];  //register_bank
always@(posedge clock) begin
data1 <= regBank[rs1_num];
data2 <= regBank[rs2_num];
regBank[dataW_num] <= dataW;
end
endmodule

module inst_dec(input [31:0] inst, 
    output [4:0] rs1_num, rs2_num, rd_num,
    output reg [31:0] inst_r, input clock);
always@(posedge clock) inst_r = inst;

assign rs1_num = inst_r[19:15];   //rs1
assign rs2_num = inst_r[24:20];   //rs2
assign rd_num = inst_r[11:7];  //rd

endmodule

module control(input [31:0] inst, output reg [3:0] ctrl, input clock);
parameter   ADD = 10'b0000001, SUB = 10'b0010001, SLL = 10'b0000011,
            SRL = 10'b0010011, SRA = 10'b0100011, SLT = 10'b0000111,
            SLTU= 10'b0010111, XOR = 10'b0001111, OR  = 10'b0011111,
            AND = 10'b0101111;       //func_opcode
    always@(posedge clock) begin                 
    case({inst[14:12],inst[3:0]}) //func_opcode
            ADD : ctrl = 4'h1;
            SUB : ctrl = 4'h2;
            SLL : ctrl = 4'h3; 
            SRL : ctrl = 4'h4;
            SRA : ctrl = 4'h5;
            SLT : ctrl = 4'h6;
            SLTU: ctrl = 4'h7;
            XOR : ctrl = 4'h8;
            OR  : ctrl = 4'h9;
            AND : ctrl = 4'ha;
            default : ctrl = 4'h0;
    endcase
    end
endmodule

module ALU(input [31:0] rs1, input [31:0] rs2, input [3:0] ctrl,
             output reg [31:0] outP, input clock);
always@(posedge clock) begin//EX
case(ctrl) //func_opcode
4'h1 : outP = rs1 + rs2 ;
4'h2 : outP = rs1 - rs2 ;
4'h3 : outP = rs1 << rs2[4:0] ; 
4'h4 : outP = rs1 >> rs2[4:0] ;
4'h5 : outP = $signed(rs1) >>> rs2[4:0] ;
4'h6 : outP = ($signed(rs1) < $signed(rs2)) 
              ? 32'h00000001 : 32'h00000000 ;
4'h7 : outP = (rs1 < rs2) 
              ? 32'h00000001 : 32'h00000000 ;
4'h8 : outP = rs1 ^ rs2 ;
4'h9 : outP = rs1 | rs2 ;
4'ha : outP = rs1 & rs2 ;
default : outP = 32'hxxxxxxxx ;
endcase
end
endmodule

/*module regW(input [31:0] data, input [4:0] regnum);

endmodule*/