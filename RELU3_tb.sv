`timescale 1ns / 1ps

module RELU3_tb;

logic clk;
logic reset;
logic valid_in;
logic signed[15:0] input_data[0:15];
logic signed[15:0] output_data[0:15];
logic valid_out;
logic ready_out;

// 实例化RELU1模块
RELU3 dut(
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
input_data[0] = 2875;
input_data[1] = -1493;
input_data[2] = 5572;
input_data[3] = 8512;
input_data[4] = 5511;
input_data[5] = 3990;
input_data[6] = -5111;
input_data[7] = 2636;
input_data[8] = -1800;
input_data[9] = -4774;
input_data[10] = 582;
input_data[11] = 5113;
input_data[12] = 10592;
input_data[13] = 9602;
input_data[14] = 2754;
input_data[15] = -1640;


    // 激活valid_in信号以开始处理
    #10; // 等待一个时钟周期
    valid_in = 1;
    #10; // 继续处理
    valid_in = 0; // 只需一个时钟周期有效即可开始处理
end

// 监视输出数据和有效信号
always @(posedge valid_out) begin
    #1; // 稍等一段时间以确保output_data更新
    for (int i = 0; i < 16; i++) begin
        $display("Time = %0t, output_data[%0d] = %0d", $time, i, output_data[i]);
    end
end

endmodule