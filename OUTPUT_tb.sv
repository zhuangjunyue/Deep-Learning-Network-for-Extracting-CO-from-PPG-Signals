`timescale 1ns/1ps

module OUTPUT_tb;

logic clk, reset, valid_in, valid_out;
logic signed [15:0] input_data[0:15];
logic signed [15:0] final_output;

// 实例化待测试模块
OUTPUT dut(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .input_data(input_data),
    .final_output(final_output),
    .valid_out(valid_out)
);

// 生成时钟信号
always #5 clk = ~clk; // 生成一个100MHz的时钟

// 初始化测试
initial begin
    clk = 0;
    reset = 1;
    valid_in = 0;
    // 初始化输入数据
    #10; // 等待一段时间以模拟复位过程
    reset = 0;
    valid_in = 1; // 设置输入数据为有效

input_data[0] = 2875;
input_data[1] = 0;
input_data[2] = 5572;
input_data[3] = 8512;
input_data[4] = 5511;
input_data[5] = 3990;
input_data[6] = 0;
input_data[7] = 2636;
input_data[8] = 0;
input_data[9] = 0;
input_data[10] = 582;
input_data[11] = 5113;
input_data[12] = 10592;
input_data[13] = 9602;
input_data[14] = 2754;
input_data[15] = 0;


    #10; // 等待输入数据处理
    valid_in = 0; // 重置输入有效标志，以模拟数据传输结束

    #20; // 等待输出数据稳定

    // 打印最终输出数据
    $display("final_output = %0d", final_output);

    $finish; // 结束测试
end

endmodule
