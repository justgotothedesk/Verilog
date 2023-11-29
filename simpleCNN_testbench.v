`timescale 1ns / 1ps

module simpleCNN_tb;

    reg CLK;
    reg nRST;
    reg START;
    reg X;
    reg Y;
    reg [199:0] IMGIN;
    
    wire DONE;
    wire [3:0] OUT;

    reg [7:0] conv_kernel [0:4][0:4];
    reg [7:0] fc_kernel [0:575];

    // Instantiate the simpleCNN module
    simpleCNN dut (
        .CLK(CLK),
        .nRST(nRST),
        .START(START),
        .X(X),
        .Y(Y),
        .IMGIN(IMGIN),
        .DONE(DONE),
        .OUT(OUT)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Testbench stimulus
    initial begin
        // Load pre-trained kernels
        $readmemh("conv_kernel.mem", conv_kernel);
        $readmemh("fc_kernel.mem", fc_kernel);

        nRST = 0;
        START = 0;
        X = 0;
        Y = 0;
        IMGIN = 0;

        // Reset and wait for a few clock cycles
        #10 nRST = 1;
        #100;

        // Test scenario
        START = 1;

        integer correct_predictions = 0;
        integer label_file;
        label_file = $fopen("label.mem", "r");

        // Perform inference for each test image
        for (int test_index = 0; test_index < 100; test_index = test_index + 1) begin
            // Load test image
            $readmemh("image.mem", IMGIN);

            // Wait for DONE signal
            wait (DONE);

            // Compare the predicted result with the label
            if (OUT == $fscanf(label_file, "%h")) begin
                correct_predictions = correct_predictions + 1;
            end

            // Reset START signal for the next iteration
            START = 0;
            #10 START = 1;
        end

        // Display inference accuracy
        if (correct_predictions == 96) begin
            $display("Inference accuracy: 96%% (96 correct outputs of 100 test images)");
        end else begin
            $display("Inference accuracy: %d%%", (correct_predictions * 100) / 100);
        end

        // End simulation
        #10 $finish;
    end

endmodule
