module BATCH2(
    input clk,
    input reset,
    input valid_in, // 上游模块数据有效信号
    input logic signed[15:0] input_data[0:31], // 32个Q4.12格式的输入数据
    output logic signed[15:0] output_data[0:31], // 归一化、缩放和偏移后的32个Q4.12格式的输出数据
    output logic valid_out, // 输出数据有效信号
    output ready_out // 准备好接收下游数据的信号
);


typedef logic signed [15:0] signed_matrix_1x32_t[32];
const signed_matrix_1x32_t running_mean_2 = '{16'sd445, -16'sd437, -16'sd318, -16'sd2485, -16'sd1408, 16'sd3393, -16'sd1696, -16'sd4292, 16'sd1338, -16'sd583, 16'sd2267, 16'sd2278, -16'sd99, -16'sd1189, -16'sd3328, -16'sd2107, -16'sd1853, 16'sd725, -16'sd188, -16'sd5, 16'sd1125, -16'sd4050, 16'sd287, 16'sd228, -16'sd332, -16'sd755, 16'sd2110, -16'sd3216, 16'sd2602, -16'sd4747, -16'sd125, 16'sd1630};

const signed_matrix_1x32_t running_var_2 = '{
    16'sd4673, 16'sd4149, 16'sd5391, 16'sd3405, 16'sd4732, 16'sd3433, 16'sd3574, 16'sd3332,
    16'sd4582, 16'sd5436, 16'sd5648, 16'sd4269, 16'sd5282, 16'sd3996, 16'sd4571, 16'sd5076,
    16'sd5154, 16'sd3356, 16'sd4819, 16'sd4143, 16'sd4610, 16'sd5385, 16'sd3516, 16'sd3245,
    16'sd3185, 16'sd5426, 16'sd3298, 16'sd3483, 16'sd4629, 16'sd3093, 16'sd5226, 16'sd5107
};


const signed_matrix_1x32_t gamma_2 = '{16'sd3797, 16'sd4159, 16'sd4390, 16'sd4011, 16'sd4419, 16'sd3954, 16'sd4122, 16'sd4436, 16'sd4630, 16'sd3939, 16'sd4300, 16'sd4039, 16'sd4110, 16'sd4234, 16'sd4155, 16'sd4333, 16'sd4119, 16'sd3930, 16'sd3712, 16'sd4407, 16'sd4330, 16'sd3646, 16'sd4419, 16'sd3868, 16'sd4279, 16'sd4090, 16'sd4085, 16'sd4099, 16'sd3910, 16'sd4129, 16'sd4196, 16'sd3894};
const signed_matrix_1x32_t beta_2 = '{-16'sd20, 16'sd141, 16'sd634, 16'sd265, 16'sd297, 16'sd281, 16'sd107, 16'sd146, 16'sd104, 16'sd35, 16'sd114, -16'sd2, 16'sd93, 16'sd380, 16'sd372, 16'sd489, 16'sd7, 16'sd273, 16'sd114, 16'sd208, -16'sd283, -16'sd399, 16'sd405, 16'sd197, 16'sd2, 16'sd42, 16'sd359, 16'sd13, 16'sd274, 16'sd262, -16'sd54, -16'sd254};

integer i;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            output_data[i] <= 0;
        end
        valid_out <= 0;
    end else if (valid_in) begin
        valid_out <= 0; // 重置输出有效标志
        for (i = 0; i < 32; i = i + 1) begin
            // 使用临时阻塞性赋值进行中间计算
            logic signed [47:0] temp_result;
            temp_result = ($signed(input_data[i]) - $signed(running_mean_2[i]));
            temp_result = temp_result * $signed(gamma_2[i]);
            temp_result = temp_result * $signed(running_var_2[i]);

            // 使用非阻塞性赋值更新output_data
            output_data[i] <= ($signed(temp_result) >>> 24) + $signed(beta_2[i]);
        end
        valid_out <= 1; // 在处理完所有数据后，设置输出数据为有效
    end
end


assign ready_out = 1;



endmodule
