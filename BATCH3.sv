module BATCH3(
    input clk,
    input reset,
    input valid_in, // 上游模块数据有效信号
    input logic signed[15:0] input_data[0:15], // 16个Q4.12格式的输入数据
    output logic signed[15:0] output_data[0:15], // 归一化、缩放和偏移后的16个Q4.12格式的输出数据
    output logic valid_out, // 输出数据有效信号
    output ready_out // 准备好接收下游数据的信号
);


typedef logic signed [15:0] signed_matrix_1x16_t[16];

const signed_matrix_1x16_t running_mean_3= '{16'sd144, -16'sd720, 16'sd409, 16'sd249, 16'sd896, 16'sd1119, -16'sd3043, 16'sd1920, -16'sd4841, 16'sd1151, -16'sd650, 16'sd1872, 16'sd2581, -16'sd3056, -16'sd2729, -16'sd3248};
const signed_matrix_1x16_t running_var_3 = '{
    16'sd5974, 16'sd2176, 16'sd3538, 16'sd3053, 16'sd5221, 16'sd4005, 16'sd4275, 16'sd6195,
    16'sd2074, 16'sd3809, 16'sd4096, 16'sd3889, 16'sd3269, 16'sd3083, 16'sd4362, 16'sd5833
};
const signed_matrix_1x16_t gamma_3 = '{16'sd3632, 16'sd3825, 16'sd3938, 16'sd3490, 16'sd3855, 16'sd4132, 16'sd3856, 16'sd3917, 16'sd3949, 16'sd4231, 16'sd3928, 16'sd4082, 16'sd4077, 16'sd4325, 16'sd4267, 16'sd4302};
const signed_matrix_1x16_t beta_3 = '{-16'sd106, -16'sd315, 16'sd487, -16'sd459, -16'sd77, 16'sd496, -16'sd238, -16'sd298, 16'sd262, 16'sd369, -16'sd461, 16'sd423, 16'sd589, 16'sd618, 16'sd482, 16'sd353};

integer i;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 16; i = i + 1) begin
            output_data[i] <= 0;
        end
        valid_out <= 0;
    end else if (valid_in) begin
        valid_out <= 0; // 重置输出有效标志
        for (i = 0; i < 16; i = i + 1) begin
            // 使用临时阻塞性赋值进行中间计算
            logic signed [47:0] temp_result;
            temp_result = ($signed(input_data[i]) - $signed(running_mean_3[i]));
            temp_result = temp_result * $signed(gamma_3[i]);
            temp_result = temp_result * $signed(running_var_3[i]);

            // 使用非阻塞性赋值更新output_data
            output_data[i] <= ($signed(temp_result) >>> 24) + $signed(beta_3[i]);
        end
        valid_out <= 1; // 在处理完所有数据后，设置输出数据为有效
    end
end


assign ready_out = 1;



endmodule