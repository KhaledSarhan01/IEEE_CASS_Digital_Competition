#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>

#define LW_BRIDGE_BASE 0xFF200000 
#define LW_BRIDGE_SPAN 0x00005000 

// Register Offsets
#define LENET_VALID_OFFSET  0x0000
#define LENET_OUT_OFFSET    0x0010
#define LENET_START_OFFSET  0x0020
#define LENET_WEN_OFFSET    0x0030
#define LENET_DATA_OFFSET   0x0040
#define LENET_ADDR_OFFSET   0x0050

#define WRITE_REG(base, offset, data) (*((volatile uint32_t *)((base) + ((offset) / sizeof(uint32_t)))) = (data))
#define READ_REG(base, offset)        (*((volatile uint32_t *)((base) + ((offset) / sizeof(uint32_t)))))

// Helper function to decode one-hot to an integer digit (0-9)
int decode_one_hot(uint32_t one_hot_val) {
    for (int i = 0; i < 10; i++) {
        if ((one_hot_val >> i) & 1) {
            return i;
        }
    }
    return -1; // Error or no bit set
}

int main(int argc, char *argv[]) {
    int fd;
    volatile uint32_t *virtual_base;
    FILE *list_file;

    if (argc < 2) {
        printf("Usage: %s <path_to_test_list.txt>\n", argv[0]);
        return 1;
    }

    // 1. Open the mapping file
    list_file = fopen(argv[1], "r");
    if (list_file == NULL) {
        perror("Error opening test list file");
        return 1;
    }

    // 2. Open /dev/mem for HPS-to-FPGA mapping
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        perror("Error opening /dev/mem");
        fclose(list_file);
        return 1;
    }

    virtual_base = (uint32_t *) mmap(NULL, LW_BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (virtual_base == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        fclose(list_file);
        return 1;
    }

    char mem_file_path[256];
    int ground_truth;
    int software_prediction; // NEW: Holds the 3rd parameter from the text file

    // Statistical Trackers
    int total_tests = 0;
    int hw_correct = 0;
    int sw_correct = 0;
    int hw_sw_match = 0; // Tracks when HW and SW give the exact same output

    printf("\n==================================================\n");
    printf("   Starting Automated LeNet HW/SW Co-Simulation   \n");
    printf("==================================================\n\n");

    // 3. Read mapping file line-by-line (Expecting 3 parameters now)
    while (fscanf(list_file, "%s %d %d", mem_file_path, &ground_truth, &software_prediction) == 3) {
        total_tests++;
        
        FILE *mem_file = fopen(mem_file_path, "r");
        if (mem_file == NULL) {
            printf("[%03d] Skip: Could not open %s\n", total_tests, mem_file_path);
            continue;
        }

        // --- Step A: Load the 120-byte feature map ---
        int current_addr = 0;
        uint32_t data_value;
        while (current_addr < 120 && fscanf(mem_file, "%x", &data_value) == 1) {
            WRITE_REG(virtual_base, LENET_ADDR_OFFSET, current_addr);
            WRITE_REG(virtual_base, LENET_DATA_OFFSET, data_value);
            
            WRITE_REG(virtual_base, LENET_WEN_OFFSET, 1);
            WRITE_REG(virtual_base, LENET_WEN_OFFSET, 0);
            
            current_addr++;
        }
        fclose(mem_file);

        // --- Step B: Trigger LeNet ---
        WRITE_REG(virtual_base, LENET_START_OFFSET, 1);
        WRITE_REG(virtual_base, LENET_START_OFFSET, 0); 

        // --- Step C: Poll for Out_Valid ---
        uint32_t is_valid = 0;
        int timeout = 1000000; 
        while (timeout > 0) {
            is_valid = READ_REG(virtual_base, LENET_VALID_OFFSET);
            if (is_valid == 1) {
                break;
            }
            timeout--;
        }

        // --- Step D: Analyze Result ---
        if (is_valid) {
            uint32_t raw_out = READ_REG(virtual_base, LENET_OUT_OFFSET);
            int hw_prediction = decode_one_hot(raw_out);

            // Update stats
            if (hw_prediction == ground_truth) hw_correct++;
            if (software_prediction == ground_truth) sw_correct++;
            if (hw_prediction == software_prediction) hw_sw_match++;

            // // Print per-file comparison
            // printf("[%03u] Target: %d | HW Predict: %d | SW Predict: %d ", 
            //        total_tests, ground_truth, hw_prediction, software_prediction);
            
            // if (hw_prediction == ground_truth) {
            //     printf("[ HW PASS ]\n");
            // } else {
            //     printf("[ HW FAIL ] (Raw HW: 0x%03X)\n", raw_out);
            // }
        } else {
            printf("[%03u] File: %-30s | TIMEOUT (Hardware hung up)\n", total_tests, mem_file_path);
        }
    }

    // --- Step 4: Display Final Accuracy Statistics ---
    printf("\n==================================================\n");
    printf("                  TEST SUMMARY                    \n");
    printf("==================================================\n");
    printf(" Total Processed Cases      : %d\n", total_tests);
    printf("--------------------------------------------------\n");
    printf(" Hardware Correct (RTL)     : %d\n", hw_correct);
    printf(" Software Correct (Ref)     : %d\n", sw_correct);
    printf(" HW/SW Exact Matches        : %d\n", hw_sw_match);
    printf("--------------------------------------------------\n");
    
    if (total_tests > 0) {
        float hw_accuracy = ((float)hw_correct / (float)total_tests) * 100.0f;
        float sw_accuracy = ((float)sw_correct / (float)total_tests) * 100.0f;
        float match_rate  = ((float)hw_sw_match / (float)total_tests) * 100.0f;

        printf(" Hardware Accuracy          : %.2f%%\n", hw_accuracy);
        printf(" Software Accuracy          : %.2f%%\n", sw_accuracy);
        printf(" HW/SW Match Rate (Parity)  : %.2f%%\n", match_rate);
    } else {
        printf(" Accuracy : N/A (No test cases run)\n");
    }
    printf("==================================================\n\n");

    // Clean up
    fclose(list_file);
    munmap((void*)virtual_base, LW_BRIDGE_SPAN);
    close(fd);

    return 0;
}