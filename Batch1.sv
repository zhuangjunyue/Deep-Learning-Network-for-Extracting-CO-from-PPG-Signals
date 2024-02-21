module BATCH1(
    input clk,
    input reset,
    input valid_in,  // 上游模块数据有效信号
    input logic signed[15:0] input_data[0:63],  // 64个Q4.12格式的输入数据
    output logic signed [15:0] output_data[0:63],  // 归一化后的64个Q4.12格式的输出数据
    output logic valid_out,  // 输出数据有效信号
    output ready_out  // 准备好接收下游数据的信号
);


typedef logic signed [15:0] signed_matrix_1x64_t[64];

const signed_matrix_1x64_t gamma_1 = '{
    16'sd3931, 16'sd4358, 16'sd4311, 16'sd3925, 16'sd3958, 16'sd4448, 16'sd4004, 16'sd3842, 16'sd4177, 16'sd4101, 
    16'sd4032, 16'sd3785, 16'sd3990, 16'sd3987, 16'sd4029, 16'sd4278, 16'sd3952, 16'sd3869, 16'sd3844, 16'sd4202, 
    16'sd3930, 16'sd3718, 16'sd4036, 16'sd4320, 16'sd4122, 16'sd3825, 16'sd3992, 16'sd3954, 16'sd4297, 16'sd3845, 
    16'sd4199, 16'sd4586, 16'sd4293, 16'sd4121, 16'sd4405, 16'sd3904, 16'sd4316, 16'sd3994, 16'sd4292, 16'sd4102, 
    16'sd4064, 16'sd4246, 16'sd4249, 16'sd4101, 16'sd4146, 16'sd3989, 16'sd4299, 16'sd4215, 16'sd4111, 16'sd4149, 
    16'sd4198, 16'sd4311, 16'sd4118, 16'sd4117, 16'sd4490, 16'sd3819, 16'sd4064, 16'sd4274, 16'sd4100, 16'sd4200, 
    16'sd4204, 16'sd4228, 16'sd4126, 16'sd3780
};



const signed_matrix_1x64_t running_var_1= '{
    16'sd10665, 16'sd8830, 16'sd17439, 16'sd9024, 16'sd10817, 16'sd14193, 16'sd10929, 16'sd15183, 
    16'sd12856, 16'sd12078, 16'sd17641, 16'sd13220, 16'sd6495, 16'sd15534, 16'sd10652, 16'sd12748, 
    16'sd13443, 16'sd14339, 16'sd10082, 16'sd9367, 16'sd9494, 16'sd14820, 16'sd20535, 16'sd12807, 
    16'sd10571, 16'sd12436, 16'sd19284, 16'sd10466, 16'sd15694, 16'sd9863, 16'sd14703, 16'sd12623, 
    16'sd11966, 16'sd13651, 16'sd16100, 16'sd9372, 16'sd9243, 16'sd11507, 16'sd13911, 16'sd14703, 
    16'sd9816, 16'sd16194, 16'sd14074, 16'sd23629, 16'sd8924, 16'sd21988, 16'sd11507, 16'sd9909, 
    16'sd7601, 16'sd16131, 16'sd14939, 16'sd11499, 16'sd13706, 16'sd11514, 16'sd15665, 16'sd10810, 
    16'sd14051, 16'sd13573, 16'sd8322, 16'sd10512, 16'sd15060, 16'sd13411, 16'sd10672, 16'sd13992
};

const signed_matrix_1x64_t beta_1 = '{ 
    16'sd175, 16'sd50, 16'sd98, -16'sd6, 16'sd153, 16'sd102, 16'sd198, 16'sd244, 16'sd50, 16'sd228, -
    16'sd74, -16'sd127, -16'sd150, -16'sd38, 16'sd425, -16'sd156, -16'sd98, -16'sd188, -16'sd75, 16'sd131, -
    16'sd153, -16'sd65, 16'sd58, 16'sd165, 16'sd166, 16'sd338, 16'sd244, -16'sd175, -16'sd55, -16'sd145, 
    16'sd416, 16'sd360, 16'sd11, 16'sd199, 16'sd142, 16'sd150, 16'sd101, -16'sd268, 16'sd75, 16'sd398, 
    16'sd58, 16'sd103, -16'sd54, 16'sd117, 16'sd155, 16'sd385, 16'sd302, -16'sd195, 16'sd42, 16'sd296, -
    16'sd146, 16'sd334, 16'sd198, 16'sd62, 16'sd198, 16'sd203, 16'sd550, 16'sd335, -16'sd128, 16'sd268, 
    16'sd303, -16'sd5, -16'sd121, 16'sd239
 };


const signed_matrix_1x64_t running_mean_1 = '{ 
    16'sd1309, -16'sd1778, 16'sd436, 16'sd3211, 16'sd4209, 16'sd1389, 16'sd898, 16'sd339, -16'sd2041, 16'sd1468,
    16'sd597, -16'sd863, -16'sd1410, 16'sd997, -16'sd2546, 16'sd790, -16'sd2415, 16'sd126, -16'sd4006, -16'sd247,
    16'sd471, 16'sd4581, 16'sd261, -16'sd2166, 16'sd3417, -16'sd1283, -16'sd982, 16'sd1178, -16'sd1736, 16'sd257,
    16'sd3091, -16'sd1698, 16'sd1665, -16'sd2006, 16'sd2964, 16'sd369, 16'sd2127, -16'sd654, 16'sd1124, -16'sd1572,
    16'sd560, 16'sd1222, -16'sd1209, -16'sd2631, -16'sd4582, -16'sd181, 16'sd4120, -16'sd455, -16'sd1337, -16'sd824,
    16'sd2356, -16'sd3655, -16'sd528, -16'sd1448, -16'sd3132, -16'sd648, -16'sd2226, 16'sd251, 16'sd947, -16'sd1025,
    16'sd2184, 16'sd224, 16'sd1702, 16'sd1477
 };



integer i;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 64; i = i + 1) begin
            output_data[i] <= 0;
        end
        valid_out <= 0;
    end else if (valid_in) begin
        valid_out <= 0; // 重置输出有效标志
        for (i = 0; i < 64; i = i + 1) begin
            // 使用临时阻塞性赋值进行中间计算
            logic signed [47:0] temp_result;
            temp_result = ($signed(input_data[i]) - $signed(running_mean_1[i]));
            temp_result = temp_result * $signed(gamma_1[i]);
            temp_result = temp_result * $signed(running_var_1[i]);

            // 使用非阻塞性赋值更新output_data
            output_data[i] <= ($signed(temp_result) >>> 24) + $signed(beta_1[i]);
        end
        valid_out <= 1; // 在处理完所有数据后，设置输出数据为有效
    end
end


// 模块总是准备好接收新数据
assign ready_out = 1;

endmodule
