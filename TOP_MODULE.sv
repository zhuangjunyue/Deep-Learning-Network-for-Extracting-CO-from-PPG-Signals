module TOP_MODULE(
    input clk,
    input reset,
    input start,
    input logic signed [15:0] input_data[0:23],
    output logic signed[15:0] final_output,
    output logic done
);

// 握手信号
wire valid_layer1, ready_batch1;
wire valid_batch1, ready_relu1;
wire valid_relu1, ready_layer2;
wire valid_layer2, ready_batch2;
wire valid_batch2, ready_relu2;
wire valid_relu2, ready_layer3;
wire valid_layer3, ready_batch3;
wire valid_batch3, ready_relu3;
wire valid_relu3, ready_output;
wire valid_output;

// 模块间连接的数据线
logic signed [15:0] layer1_output[0:63];
logic signed [15:0] batch1_output[0:63];
logic signed [15:0] relu1_output[0:63];

logic signed [15:0] layer2_output[0:31];
logic signed [15:0] batch2_output[0:31];
logic signed [15:0] relu2_output[0:31];

logic signed [15:0] layer3_output[0:15];
logic signed [15:0] batch3_output[0:15];
logic signed [15:0] relu3_output[0:15];

// 实例化模块
LAYER1 layer1(.clk(clk), .reset(reset), .start(start), .input_data(input_data), .output_data(layer1_output), .valid(valid_layer1), .ready(ready_batch1));
BATCH1 batch1(.clk(clk), .reset(reset), .valid_in(valid_layer1), .input_data(layer1_output), .output_data(batch1_output), .valid_out(valid_batch1), .ready_out(ready_relu1));
RELU1 relu1(.clk(clk), .reset(reset), .valid_in(valid_batch1), .input_data(batch1_output), .output_data(relu1_output), .valid_out(valid_relu1), .ready_out(ready_layer2));

LAYER2 layer2(.clk(clk), .reset(reset), .valid_in(valid_relu1), .input_data(relu1_output), .output_data(layer2_output), .valid_out(valid_layer2), .ready_out(ready_batch2));
BATCH2 batch2(.clk(clk), .reset(reset), .valid_in(valid_layer2), .input_data(layer2_output), .output_data(batch2_output), .valid_out(valid_batch2), .ready_out(ready_relu2));
RELU2 relu2(.clk(clk), .reset(reset), .valid_in(valid_batch2), .input_data(batch2_output), .output_data(relu2_output), .valid_out(valid_relu2), .ready_out(ready_layer3));

LAYER3 layer3(.clk(clk), .reset(reset), .valid_in(valid_relu2), .input_data(relu2_output), .output_data(layer3_output), .valid_out(valid_layer3), .ready_out(ready_batch3));
BATCH3 batch3(.clk(clk), .reset(reset), .valid_in(valid_layer3), .input_data(layer3_output), .output_data(batch3_output), .valid_out(valid_batch3), .ready_out(ready_relu3));
RELU3 relu3(.clk(clk), .reset(reset), .valid_in(valid_batch3), .input_data(batch3_output), .output_data(relu3_output), .valid_out(valid_relu3), .ready_out(ready_output));

OUTPUT output_module(.clk(clk), .reset(reset), .valid_in(valid_relu3), .input_data(relu3_output), .final_output(final_output), .valid_out(valid_output));

// 完成信号逻辑
reg processing;
// 完成信号逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        done <= 0;
    end else if (valid_output) begin
        // 当valid_output为高，无论processing状态如何，都将done置位为高
        done <= 1;
    end
end


endmodule
