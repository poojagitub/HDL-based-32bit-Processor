`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2022 06:46:31 PM
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    
    reg clock;
    reg [31:0] inst;
    
    initial begin 
    clock <= 1;
    end
    
    always #10 clock = ~clock;
    
    procsn32 DUT(clock, inst);
    
    initial begin
        DUT.regB.regBank[0] = 0;
        DUT.regB.regBank[1] = 32'h0000000f;
        DUT.regB.regBank[2] = 32'h0000000c;
        DUT.regB.regBank[3] = 32'hff0000ff;
        DUT.regB.regBank[4] = 32'h00000004;
        DUT.regB.regBank[5] = 32'h70000000;
        DUT.regB.regBank[6] = 32'hf0000000;
    
    #20 inst = {7'h00,5'h02,5'h01,3'h0,5'h0a,7'h01};    //ADD
    #20 inst = {7'h00,5'h02,5'h01,3'h1,5'h0b,7'h01};    //SUB
    #20 inst = {7'h00,5'h04,5'h03,3'h0,5'h0c,7'h03};    //SLL
    #20 inst = {7'h00,5'h04,5'h03,3'h1,5'h0d,7'h03};    //SRL
    #20 inst = {7'h00,5'h04,5'h03,3'h2,5'h0e,7'h03};    //SRA
    #20 inst = {7'h00,5'h06,5'h05,3'h0,5'h0f,7'h07};    //SLT
    #20 inst = {7'h00,5'h06,5'h05,3'h1,5'h10,7'h07};    //SLTU
    #20 inst = {7'h00,5'h02,5'h01,3'h0,5'h11,7'h0f};    //XOR
    #20 inst = {7'h00,5'h02,5'h01,3'h1,5'h12,7'h0f};    //OR
    #20 inst = {7'h00,5'h02,5'h01,3'h2,5'h13,7'h0f};    //AND    
    end
    
endmodule
