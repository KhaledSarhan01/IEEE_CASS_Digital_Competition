
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>      // For file control (open)
#include <sys/mman.h>   // For memory mapping (mmap)
#include <unistd.h>     // For close()
#include <stdint.h>     // For fixed-width types like uint32_t


// The Physical address of the Lightweight HPS-to-FPGA bridge
#define LW_BRIDGE_BASE 0xFF200000 
// How much memory to map (20KB). This covers most IP cores in Qsys/Platform Designer
#define LW_BRIDGE_SPAN 0x00005000 

// volatile ensures the compiler doesn't optimize away reads/writes to this memory
volatile uint32_t *virtual_base;

int main(int argc, char *argv[]) {
    int fd;
    off_t target;
    volatile uint32_t *addr;
    uint32_t value;

    // Check if the user provided enough command line arguments
    if (argc < 3) {
        printf("Usage: %s r|w <offset> [value_to_write]\n", argv[0]);
        return 1;
    }

     
    // Parse command line inputs: 'r' or 'w' and the address offset
    char mode = argv[1][0];
    target = strtoul(argv[2], NULL, 0); // Converts string address to unsigned long

    // Open /dev/mem, which is a special file representing the entire physical memory
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        perror("open"); // Standard error if not run as 'root' (sudo)
        return 1;
    }

     //* mmap: The Magic Step
     //* Maps the physical LW_BRIDGE_BASE to a "virtual_base" pointer our program can use.
     //* PROT_READ|PROT_WRITE: We want to read and write.
     //* MAP_SHARED: Changes to this memory should be shared with the hardware.
    virtual_base = (uint32_t *) mmap(NULL, LW_BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LW_BRIDGE_BASE);
    
    if (virtual_base == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 1;
    }

     //* Calculate the specific address. 
     //* We divide target by 4 (sizeof uint32_t) because pointer arithmetic in C 
     //* increments by the size of the data type.
     
    addr = virtual_base + (target/sizeof(uint32_t));

    // Logic for Reading
    if (mode == 'r') {
        value = *addr;// Direct hardware read
        printf("Read 0x%08X from offset 0x%X\n", value, (unsigned int) target);
    } // Logic for Writing
    else if (mode == 'w') {
        if (argc < 4) {
            printf("Write mode needs a value_to_write\n");
            munmap((void*)virtual_base, LW_BRIDGE_SPAN);
            close(fd);
            return 1;
        }
        value = strtoul(argv[3], NULL, 0);
        *addr = value;
        printf("Wrote 0x%08X to offset 0x%X\n", value, (unsigned int) target);
    } else {
        printf("Invalid mode. Use 'r' or 'w'.\n");
    }
    // Clean up: Release the memory map and close the file
    munmap((void*)virtual_base, LW_BRIDGE_SPAN);
    close(fd);
    return 0;
}
