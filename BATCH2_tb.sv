`timescale 1ns/1ps

module BATCH2_tb;

logic clk, reset, valid_in, valid_out, ready_out;
logic signed [15:0] input_data[0:31];
logic signed [15:0] output_data[0:31];

// 实例化待测试模块
BATCH2 dut(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .input_data(input_data),
    .output_data(output_data),
    .valid_out(valid_out),
    .ready_out(ready_out)
);

// 生成时钟信号
always #5 clk = ~clk; // 生成一个100MHz的时钟

// 初始化测试
initial begin
    clk = 0;
    reset = 1;
    valid_in = 0;
    // 初始化输入数据
    #100; // 等待一段时间以模拟复位过程
    reset = 0;
    valid_in = 1; // 设置输入数据为有效

input_data[0] = 8644;
input_data[1] = -199;
input_data[2] = 5674;
input_data[3] = 4268;
input_data[4] = 6131;
input_data[5] = 12466;
input_data[6] = 2027;
input_data[7] = 1436;
input_data[8] = 3791;
input_data[9] = 915;
input_data[10] = 1757;
input_data[11] = -5514;
input_data[12] = 4213;
input_data[13] = -8026;
input_data[14] = -1032;
input_data[15] = -4121;
input_data[16] = -31;
input_data[17] = -181;
input_data[18] = 5020;
input_data[19] = -4544;
input_data[20] = -4801;
input_data[21] = -8104;
input_data[22] = 3643;
input_data[23] = -14889;
input_data[24] = -1207;
input_data[25] = -5258;
input_data[26] = 4557;
input_data[27] = -1007;
input_data[28] = 8131;
input_data[29] = -9590;
input_data[30] = 4998;
input_data[31] = 3042;

    #10; // 等待输入数据处理
    valid_in = 0; // 重置输入有效标志，以模拟数据传输结束

    #1000; // 等待足够的时间，确保所有数据都已处理完毕

    // 打印输出数据
    for (int i = 0; i < 32; i++) begin
        $display("output_data[%0d] = %0d", i, output_data[i]);
    end

    $finish; // 结束测试
end

endmodule
