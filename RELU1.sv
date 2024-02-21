module RELU1(
    input clk,
    input reset,
    input valid_in, // 上游模块数据有效信号
    input logic signed[15:0] input_data[0:63],  // 64个Q4.12格式的输入数据
    output logic signed[15:0] output_data[0:63],  // RELU激活后的64个Q4.12格式的输出数据
    output logic valid_out, // 输出数据有效信号
    output ready_out // 准备好接收下游数据的信号
);

integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 重置输出数据和有效位
        for (i = 0; i < 64; i = i + 1) begin
            output_data[i] <= 0;
        end
        valid_out <= 0;
    end
    else if (valid_in) begin
        // 对每个输入数据应用ReLU激活
        for (i = 0; i < 64; i = i + 1) begin
            // ReLU激活：f(x) = max(0, x)
            output_data[i] <= (input_data[i][15] == 1'b0) ? input_data[i] : 16'b0;
        end
        valid_out <= 1; // 处理完成，标记输出数据为有效
    end
end


assign ready_out = 1;


endmodule
