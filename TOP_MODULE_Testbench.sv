`timescale 1ns / 1ps

module TOP_MODULE_Testbench;

reg clk;
reg reset;
reg start;
logic signed [15:0] input_data[0:23];
logic signed [15:0] final_output;
wire done;

// 实例化顶层模块
TOP_MODULE uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .input_data(input_data),
    .final_output(final_output),
    .done(done)
);

initial begin
    // 初始化输入
    clk = 0;
    reset = 1;
    start = 0;
    
 input_data[0] = 16'sd733;
 input_data[1] = 16'sd2461;
 input_data[2] = 16'sd1358;
 input_data[3] = 16'sd1243;
 input_data[4] = 16'sd4178;
 input_data[5] = 16'sd4178;
 input_data[6] = 16'sd2932;
 input_data[7] = 16'sd1319;
 input_data[8] = 16'sd1554;
 input_data[9] = 16'sd4802;
 input_data[10] = 16'sd2862;
 input_data[11] = 16'sd79;
 input_data[12] = 16'sd587;
 input_data[13] = 16'sd1611;
 input_data[14] = 16'sd2297;
 input_data[15] = 16'sd1246;
 input_data[16] = 16'sd1168;
 input_data[17] = 16'sd2916;
 input_data[18] = 16'sd1463;
 input_data[19] = 16'sd1940;
 input_data[20] = 16'sd1168;
 input_data[21] = 16'sd2192;
 input_data[22] = 16'sd801;
 input_data[23] = 16'sd322;


    // 重置系统
    #100;
    reset = 0;
    start = 1;

    // 等待处理完成
    #10000;
    
    if (done) begin
        $display("Processing completed. Final output: %d", final_output);
    end else begin
        $display("Processing not completed.");
    end
    
    // 结束仿真
    #10;
    $finish;
end

// 时钟生成
always #5 clk = ~clk;

endmodule
