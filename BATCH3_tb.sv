`timescale 1ns/1ps

module BATCH3_tb;

logic clk, reset, valid_in, valid_out, ready_out;
logic signed [15:0] input_data[0:15];
logic signed [15:0] output_data[0:15];

// 实例化待测试模块
BATCH3 dut(
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

input_data[0] = 2449;
input_data[1] = -3094;
input_data[2] = 6533;
input_data[3] = 14376;
input_data[4] = 5554;
input_data[5] = 4662;
input_data[6] = -8002;
input_data[7] = 3949;
input_data[8] = -9063;
input_data[9] = -4203;
input_data[10] = 438;
input_data[11] = 6829;
input_data[12] = 15173;
input_data[13] = 8248;
input_data[14] = -681;
input_data[15] = -4580;

    #10; // 等待输入数据处理
    valid_in = 0; // 重置输入有效标志，以模拟数据传输结束

    #1000; // 等待足够的时间，确保所有数据都已处理完毕

    // 打印输出数据
    for (int i = 0; i < 16; i++) begin
        $display("output_data[%0d] = %0d", i, output_data[i]);
    end

    $finish; // 结束测试
end

endmodule