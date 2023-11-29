module simpleCNN (
    CLK,
    nRST,
    START,
    X,
    Y,
    IMGIN,
    DONE,
    OUT
);

    input CLK;
    input nRST;
    input START;
    input X;
    input Y;
    input [199:0] IMGIN;
    
    output DONE;
    output [3:0] OUT;

    reg [7:0] conv_kernel [0:4][0:4];
    reg [7:0] fc_kernel [0:16383];
    reg [23:0] conv_result [0:23][0:23];
    reg [9:0] fc_result [0:9];
    reg [3:0] result_index;

    // Include the kernel functions
    `include "kernel.vh"

    always @(posedge CLK or negedge nRST) begin
        if (~nRST) begin
            // Reset logic here
        end else begin
            // Inference logic
            if (START) begin
                // Convolution layer
                for (int i = 0; i < 24; i = i + 1) begin
                    for (int j = 0; j < 24; j = j + 1) begin
                        conv_result[i][j] = 0;
                        for (int m = 0; m < 5; m = m + 1) begin
                            for (int n = 0; n < 5; n = n + 1) begin
                                conv_result[i][j] = conv_result[i][j] + IMGIN[(i + m) * 28 + (j + n)] * conv_kernel[m][n];
                            end
                        end
                    end
                end

                // ReLU activation
                for (int i = 0; i < 24; i = i + 1) begin
                    for (int j = 0; j < 24; j = j + 1) begin
                        if (conv_result[i][j] > 0) begin
                            conv_result[i][j] = conv_result[i][j];
                        end else begin
                            conv_result[i][j] = 0;
                        end
                    end
                end

                // Fully connected layer
                for (int i = 0; i < 10; i = i + 1) begin
                    fc_result[i] = 0;
                    for (int j = 0; j < 576; j = j + 1) begin
                        fc_result[i] = fc_result[i] + conv_result[j / 24][j % 24] * fc_kernel[i][j];
                    end
                    if (fc_result[i] > 0) begin
                        fc_result[i] = fc_result[i];
                    end else begin
                        fc_result[i] = 0;
                    end
                end

                // Select result
                result_index = 0;
                for (int i = 1; i < 10; i = i + 1) begin
                    if (fc_result[i] > fc_result[result_index]) begin
                        result_index = i;
                    end
                end

                // Output
                OUT = result_index;
                DONE = 1;
            end else begin
                DONE = 0;
            end
        end
    end
endmodule
