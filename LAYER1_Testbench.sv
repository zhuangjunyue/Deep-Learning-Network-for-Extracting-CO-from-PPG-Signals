`timescale 1ns / 1ps

module LAYER1_Testbench;

// 定义测试所需的信号
reg clk;
reg reset;
reg start;
reg ready;
reg signed [15:0] input_data[0:23];
wire signed [15:0] output_data[0:63];
wire valid;

// 实例化待测试的模块
LAYER1 uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .input_data(input_data),
    .output_data(output_data),
    .valid(valid),
    .ready(ready)
);

// 生成时钟信号
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 产生100MHz的时钟信号
end

// 监视valid信号和打印output_data
always @(posedge clk) begin
    if (valid) begin
        $display("Output Data at time %t:", $time);
        for (int i = 0; i < 64; i = i + 1) begin
            $display("output_data[%0d] = %d", i, output_data[i]);
        end
    end
end

// 初始化测试信号并启动测试
initial begin
    // 初始化信号
    reset = 1;
    start = 0;
    ready = 0;
    #100; // 保持复位状态一段时间
    
    reset = 0; // 释放复位信号
    #100; // 等待系统稳定
    
    // 加载测试输入数据
    
    input_data[0] = 16'sd85;
    input_data[1] = 16'sd226;
    input_data[2] = 16'sd137;
    input_data[3] = 16'sd122;
    input_data[4] = 16'sd342;
    input_data[5] = 16'sd281;
    input_data[6] = 16'sd228;
    input_data[7] = 16'sd70;
    input_data[8] = 16'sd168;
    input_data[9] = 16'sd466;
    input_data[10] = 16'sd208;
    input_data[11] = 16'sd22;
    input_data[12] = 16'sd22;
    input_data[13] = 16'sd146;
    input_data[14] = 16'sd134;
    input_data[15] = 16'sd57;
    input_data[16] = 16'sd59;
    input_data[17] = 16'sd219;
    input_data[18] = 16'sd83;
    input_data[19] = 16'sd102;
    input_data[20] = 16'sd59;
    input_data[21] = 16'sd156;
    input_data[22] = 16'sd30;
    input_data[23] = 16'sd22;
    
    start = 1; // 触发模块开始处理
    #10000; // 等待模块处理一段时间
    start = 0; // 关闭开始信号
    
    // 在适当的时刻标记ready为高，表示下游模块准备好接收数据
    #100;
    ready = 1;
    
    #100; // 等待更多时间观察模块的行为
    $finish; // 结束测试
end

endmodule
