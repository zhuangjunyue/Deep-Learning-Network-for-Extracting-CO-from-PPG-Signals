`timescale 1ns / 1ps

module RELU2_tb;

logic clk;
logic reset;
logic valid_in;
logic signed[15:0] input_data[0:31];
logic signed[15:0] output_data[0:31];
logic valid_out;
logic ready_out;

// 实例化RELU1模块
RELU2 dut(
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .input_data(input_data),
    .output_data(output_data),
    .valid_out(valid_out),
    .ready_out(ready_out)
);

// 时钟生成
always #5 clk = ~clk; // 生成100MHz时钟

// 初始化和输入数据加载
initial begin
    clk = 0;
    reset = 1;
    valid_in = 0;
    #10; // 持续复位状态一段时间
    reset = 0;
input_data[0] = 8651;
input_data[1] = 385;
input_data[2] = 9086;
input_data[3] = 5762;
input_data[4] = 9693;
input_data[5] = 7621;
input_data[6] = 3376;
input_data[7] = 5192;
input_data[8] = 3205;
input_data[9] = 1946;
input_data[10] = -625;
input_data[11] = -8011;
input_data[12] = 5672;
input_data[13] = -6515;
input_data[14] = 2971;
input_data[15] = -2152;
input_data[16] = 2312;
input_data[17] = -440;
input_data[18] = 5666;
input_data[19] = -4732;
input_data[20] = -7334;
input_data[21] = -5144;
input_data[22] = 3512;
input_data[23] = -11113;
input_data[24] = -709;
input_data[25] = -5915;
input_data[26] = 2323;
input_data[27] = 1892;
input_data[28] = 6238;
input_data[29] = -3425;
input_data[30] = 6641;
input_data[31] = 1419;

    // 激活valid_in信号以开始处理
    #10; // 等待一个时钟周期
    valid_in = 1;
    #10; // 继续处理
    valid_in = 0; // 只需一个时钟周期有效即可开始处理
end

// 监视输出数据和有效信号
always @(posedge valid_out) begin
    #1; // 稍等一段时间以确保output_data更新
    for (int i = 0; i < 32; i++) begin
        $display("Time = %0t, output_data[%0d] = %0d", $time, i, output_data[i]);
    end
end

endmodule