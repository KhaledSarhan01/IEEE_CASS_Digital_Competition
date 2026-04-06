# Project Name
TARGET = hps_mmap_test

# Source files
SRCS = main.c

# Compiler and Toolchain
# 'arm-linux-gnueabihf-' is the cross-compiler prefix provided by Intel EDS
# CROSS_COMPILE = arm-linux-gnueabihf-
# CC = $(CROSS_COMPILE)gcc
# POINT THIS TO YOUR ACTUAL COMPILER FOLDER
#TOOLCHAIN_PATH = /cygdrive/d/Programs/EDS/embedded/toolchains/arm-gnu-toolchain-15.2.rel1-mingw-w64-i686-arm-none-linux-gnueabihf/bin/
#TOOLCHAIN_PATH = D:\Programs\EDS\embedded\toolchains\arm-gnu-toolchain-15.2.rel1-mingw-w64-i686-arm-none-linux-gnueabihf\bin
TOOLCHAIN_PATH = D:\Programs\EDS\embedded\toolchains\arm-gnu-toolchain-15.2.rel1-mingw-w64-i686-arm-none-linux-gnueabihf\bin
CC = $(TOOLCHAIN_PATH)\arm-none-linux-gnueabihf-gcc.exe

# Compilation Flags
# -g: Include debug information
# -Wall: Enable all warnings
CFLAGS = -g -Wall

# Linking Flags
LDFLAGS = -g -Wall -static

# Default rule
all: $(TARGET)

# Link the object files to create the executable binary
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

# Clean rule to remove the binary
clean:
	rm -f $(TARGET)
