module OUTPUT(
    input clk,
    input reset,
    input valid_in, // 上游模块数据有效信号
    input logic signed[15:0] input_data[0:15], // 16个Q4.12格式的输入数据
    output logic signed[15:0] final_output, // 最终的Q4.12格式输出数据
    output logic valid_out // 输出数据有效信号
);

typedef logic signed [15:0] signed_matrix_1x16_t[16];

// 使用上面定义的类型来声明并初始化一个常量
const signed_matrix_1x16_t weights = '{-16'sd797, -16'sd1485, 16'sd1430, -16'sd1742, -16'sd257, 16'sd868, -16'sd949, -16'sd273, 16'sd2084, 16'sd741, -16'sd867, 16'sd853, 16'sd856, 16'sd336, 16'sd115, 16'sd403};

parameter logic signed [15:0] bias = 16'sd510;

integer i;
reg signed [31:0] sum; // 用于累加，扩展位宽以避免溢出

always @(posedge clk or posedge reset) begin
    if (reset) begin
        final_output <= 0; // 在复位时清零最终输出
        valid_out <= 0; // 重置时，输出数据无效
    end
    else if (valid_in) begin
        sum = 0; // 在循环开始前，初始化sum为零
        for (i = 0; i < 16; i = i + 1) begin
            // 执行矩阵乘法，累加
            sum = sum + (input_data[i] * weights[i]);
        end
        // 所有加法完成后再进行右移调整格式
        sum = (sum >>> 12) + bias; // 先右移调整格式，再加上bias
        // 确保最终的sum适合于最终输出的格式
        final_output <= sum[15:0]; // 将结果截断或调整到目标格式并赋值
        valid_out <= 1; // 处理完成后，标记输出数据为有效
    end
end

endmodule
