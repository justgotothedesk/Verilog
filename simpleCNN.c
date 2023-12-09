#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TEST_SIZE 10000

int conv_kernel[5][5];  // convolution layer pre-trained weights
int fc_kernel[10][576]; // fc layer pre-trained weights
int image[10000][784];  // MNIST image 28x28 = 784
int label[10000];		// MNIST label

void read_data();
int inference(int index);

int main()
{
	read_data();

	int err = 0;
	for (int i = 0; i < TEST_SIZE; i++)
	{
		if (inference(i) != label[i]) err++;
	}
	printf("Accuracy: %.2f%%\n", (float)(TEST_SIZE - err) / TEST_SIZE * 100);

	return 0;
}

#define CONV_SIZE 5

int inference(int index)
{
    // convolution
    int conv_result[24][24];

    for (int i = 0; i < 24; i++) {
        for (int j = 0; j < 24; j++) {
            conv_result[i][j] = 0;
            for (int m = 0; m < CONV_SIZE; m++) {
                for (int n = 0; n < CONV_SIZE; n++) {
                    conv_result[i][j] += image[index][(i + m) * 28 + (j + n)] * conv_kernel[m][n];
                }
            }
        }
    }

    // ReLU
    for (int i = 0; i < 24; i++) {
        for (int j = 0; j < 24; j++) {
            conv_result[i][j] = (conv_result[i][j] > 0) ? conv_result[i][j] : 0;
        }
    }

    // fc
    int fc_result[10];

    for (int i = 0; i < 10; i++) {
        fc_result[i] = 0;
        for (int j = 0; j < 576; j++) {
            fc_result[i] += conv_result[j / 24][j % 24] * fc_kernel[i][j];
        }
        fc_result[i] = (fc_result[i] > 0) ? fc_result[i] : 0;
    }

    // Select result
    int result_index = 0;
    for (int i = 1; i < 10; i++) {
        if (fc_result[i] > fc_result[result_index]) {
            result_index = i;
        }
    }

    return result_index;
}


void read_data() // read conv_weight, fc_weight, and MNIST dataset %%% don't fix this function
{
	printf("read data: ");
	FILE* f_conv = fopen("c_conv_kernel.mem", "r");
	if (f_conv == NULL) {
		fprintf(stderr, "conv_kernel.mem read fail.\n");
		return;
	}
	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++) {
			fscanf(f_conv, "%d", &conv_kernel[i][j]);
		}
	}
	fclose(f_conv);

	FILE* f_fc = fopen("c_fc_kernel.mem", "r");
	if (f_fc == NULL) {
		fprintf(stderr, "fc_kernel.mem read fail.\n");
		return;
	}
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 576; j++) {
			fscanf(f_fc, "%d", &fc_kernel[i][j]);
		}
	}
	fclose(f_fc);

	FILE* f_image = fopen("c_image.mem", "r");
	if (f_image == NULL) {
		fprintf(stderr, "image.mem read fail.\n");
		return;
	}
	for (int i = 0; i < 10000; i++) {
		for (int j = 0; j < 784; j++) {
			fscanf(f_image, "%d", &image[i][j]);
		}
	}
	fclose(f_image);

	FILE* f_label = fopen("c_label.mem", "r");
	if (f_label == NULL) {
		fprintf(stderr, "label.mem read fail.\n");
		return;
	}
	for (int i = 0; i < 10000; i++) {
			fscanf(f_label, "%d", &label[i]);
	}
	fclose(f_label);
	printf("done\n");
}
