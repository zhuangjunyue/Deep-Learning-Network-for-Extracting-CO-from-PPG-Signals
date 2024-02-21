`timescale 1ns / 1ps

module BATCH1_tb;

// 输入和输出端口定义
reg clk;
reg reset;
reg valid_in;
reg signed [15:0] input_data[0:63];
wire signed [15:0] output_data[0:63];
wire valid_out;
wire ready_out;

// 实例化被测试模块
BATCH1 uut (
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .input_data(input_data),
    .output_data(output_data),
    .valid_out(valid_out),
    .ready_out(ready_out)
);

// 时钟信号生成
always #5 clk = ~clk;  // 产生100MHz时钟

initial begin
    // 初始化
    clk = 0;
    reset = 1;
    valid_in = 0;

input_data[0] =    302;
input_data[1] =   -256;
input_data[2] =    -56;
input_data[3] =    268;
input_data[4] =    278;
input_data[5] =    -34;
input_data[6] =    219;
input_data[7] =    316;
input_data[8] =   -298;
input_data[9] =     -7;
input_data[10] =   -112;
input_data[11] =   -213;
input_data[12] =    -83;
input_data[13] =     40;
input_data[14] =    -27;
input_data[15] =     61;
input_data[16] =   -184;
input_data[17] =    198;
input_data[18] =   -319;
input_data[19] =    267;
input_data[20] =   -166;
input_data[21] =    304;
input_data[22] =     73;
input_data[23] =   -179;
input_data[24] =    185;
input_data[25] =   -130;
input_data[26] =   -315;
input_data[27] =    -31;
input_data[28] =   -151;
input_data[29] =    198;
input_data[30] =    371;
input_data[31] =   -286;
input_data[32] =    102;
input_data[33] =   -264;
input_data[34] =    395;
input_data[35] =     -3;
input_data[36] =    266;
input_data[37] =   -130;
input_data[38] =     41;
input_data[39] =   -120;
input_data[40] =   -141;
input_data[41] =     36;
input_data[42] =    142;
input_data[43] =   -283;
input_data[44] =   -316;
input_data[45] =   -172;
input_data[46] =    381;
input_data[47] =   -257;
input_data[48] =     53;
input_data[49] =   -249;
input_data[50] =    -99;
input_data[51] =   -222;
input_data[52] =     78;
input_data[53] =   -274;
input_data[54] =   -205;
input_data[55] =   -310;
input_data[56] =   -165;
input_data[57] =    175;
input_data[58] =    375;
input_data[59] =    -68;
input_data[60] =   -227;
input_data[61] =    220;
input_data[62] =    196;
input_data[63] =     39;


    // 重置系统
    #100;  // 等待一段时间以确保系统完全重置
    reset = 0;
    
    // 生成测试案例
    #10;  // 等待直到系统稳定
    valid_in = 1;  // 设置输入数据有效标志
    #1000000;  // 给予足够的时间进行处理
    valid_in = 0;  // 清除输入数据有效标志
    
    // 等待输出数据稳定
    #20;
    for (int i = 0; i < 64; i++) begin
        $display("output_data[%0d] = %d", i, output_data[i]);
    end
    
    #100;  // 测试结束，等待所有操作完成
    $finish;  // 结束仿真
end

// 时钟、重置和有效信号的初始设置
initial begin
    clk = 0;
    reset = 1;
    #10 reset = 0; // 释放重置信号
end

// 监视输出
initial begin
    $monitor("Time = %t, valid_out = %d, output_data[0] = %d", $time, valid_out, output_data[0]);
end

endmodule
