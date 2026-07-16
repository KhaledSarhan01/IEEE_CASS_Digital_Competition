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

int main(int argc, char *argv[]) {
    int fd;
    volatile uint32_t *virtual_base;
    FILE *mem_file;
    uint32_t data_value;

    if (argc < 2) {
        printf("Usage: %s <path_to_data.mem>\n", argv[0]);
        return 1;
    }

    mem_file = fopen(argv[1], "r");
    if (mem_file == NULL) {
        perror("Error opening .mem file");
        return 1;
    }

    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        perror("Error opening /dev/mem");
        fclose(mem_file);
        return 1;
    }

    virtual_base = (uint32_t *) mmap(NULL, LW_BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (virtual_base == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        fclose(mem_file);
        return 1;
    }

    printf("1. Loading Feature Map to LeNet...\n");
    
    // Step 1: Write exactly 120 values
    int current_addr = 0;
    while (current_addr < 120 && fscanf(mem_file, "%x", &data_value) == 1) {
        WRITE_REG(virtual_base, LENET_ADDR_OFFSET, current_addr);
        WRITE_REG(virtual_base, LENET_DATA_OFFSET, data_value);
        
        // Pulse write enable to latch data into BRAM/Registers
        WRITE_REG(virtual_base, LENET_WEN_OFFSET, 1);
        WRITE_REG(virtual_base, LENET_WEN_OFFSET, 0);
        
        current_addr++;
    }
    printf("Loaded %d bytes.\n", current_addr);

    // Step 2: Pulse LeNet_start
    printf("2. Sending Start Signal...\n");
    WRITE_REG(virtual_base, LENET_START_OFFSET, 1);
    WRITE_REG(virtual_base, LENET_START_OFFSET, 0);

    // Step 3: Poll for out_valid
    printf("3. Waiting for prediction...\n");
    uint32_t is_valid = 0;
    int timeout = 1000000; // Safety timeout to prevent infinite hangs

    while (timeout > 0) {
        is_valid = READ_REG(virtual_base, LENET_VALID_OFFSET);
        if (is_valid == 1) {
            break;
        }
        timeout--;
    }

   // Step 4: Read out_argmax_prediction
    if (is_valid) {
        uint32_t prediction_out = READ_REG(virtual_base, LENET_OUT_OFFSET);
        
        int predicted_digit = -1; // Default to -1 in case no bits are high
        
        // Loop through the 10 bit positions (0 to 9) to find the '1'
        for (int i = 0; i < 10; i++) {
            if ((prediction_out >> i) & 1) {
                predicted_digit = i;
                break; // Stop looking once we find the high bit
            }
        }

        printf("\n===================================\n");
        // Print the raw hardware value and the translated digit
        printf("Raw HW Output: 0x%03X\n", prediction_out);
        printf("SUCCESS! LeNet Predicted: %d\n", predicted_digit);
        printf("===================================\n");
    } else {
        printf("\nERROR: Timeout waiting for out_valid.\n");
    }

    // Clean up
    fclose(mem_file);
    munmap((void*)virtual_base, LW_BRIDGE_SPAN);
    close(fd);

    return 0;
}