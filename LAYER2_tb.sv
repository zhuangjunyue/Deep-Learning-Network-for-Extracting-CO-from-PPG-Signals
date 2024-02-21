`timescale 1ns / 1ps

module LAYER2_tb;

logic clk;
logic reset;
logic valid_in;
logic signed[15:0] input_data[0:63];
logic signed[15:0] output_data[0:31];
logic valid_out;
logic ready_out;

// 实例化LAYER2模块
LAYER2 dut(
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
    
    // 加载input_data，这里自定义输入数据
    // 请根据需要填充所有64个值
    
input_data[0] = 0;
input_data[1] = 3540;
input_data[2] = 0;
input_data[3] = 0;
input_data[4] = 0;
input_data[5] = 0;
input_data[6] = 0;
input_data[7] = 164;
input_data[8] = 5628;
input_data[9] = 0;
input_data[10] = 0;
input_data[11] = 1811;
input_data[12] = 1899;
input_data[13] = 0;
input_data[14] = 6868;
input_data[15] = 0;
input_data[16] = 6966;
input_data[17] = 50;
input_data[18] = 8441;
input_data[19] = 1336;
input_data[20] = 0;
input_data[21] = 0;
input_data[22] = 0;
input_data[23] = 6717;
input_data[24] = 0;
input_data[25] = 3607;
input_data[26] = 3304;
input_data[27] = 0;
input_data[28] = 6316;
input_data[29] = 0;
input_data[30] = 0;
input_data[31] = 5232;
input_data[32] = 0;
input_data[33] = 6040;
input_data[34] = 0;
input_data[35] = 0;
input_data[36] = 0;
input_data[37] = 1167;
input_data[38] = 0;
input_data[39] = 5617;
input_data[40] = 0;
input_data[41] = 0;
input_data[42] = 4761;
input_data[43] = 13678;
input_data[44] = 9562;
input_data[45] = 432;
input_data[46] = 0;
input_data[47] = 297;
input_data[48] = 2630;
input_data[49] = 2589;
input_data[50] = 0;
input_data[51] = 10477;
input_data[52] = 2236;
input_data[53] = 3379;
input_data[54] = 12468;
input_data[55] = 1034;
input_data[56] = 7564;
input_data[57] = 72;
input_data[58] = 0;
input_data[59] = 2786;
input_data[60] = 0;
input_data[61] = 0;
input_data[62] = 0;
input_data[63] = 0;

    // ...继续填充直到 input_data[63]

    // 激活valid_in信号以开始处理
    #10; // 等待一个时钟周期
    valid_in = 1;
    #10; // 继续处理
    valid_in = 0; // 只需一个时钟周期有效即可开始处理
end

// 监视输出数据和有效信号
initial begin
    $monitor("Time = %0t, valid_out = %0d", $time, valid_out);
    @(posedge valid_out) begin
        #1; // 稍等一段时间以确保output_data更新
        for (int i = 0; i < 32; i++) begin
            $display("output_data[%0d] = %0d", i, output_data[i]);
        end
    end
end

endmodule
