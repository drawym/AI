set pagination off
set confirm off
file e:/DJ/MY_AT32_CMake_Build/build/project/AT32F435_LedToggle.elf
target remote :2331
monitor reset halt
break main
continue

# Wait for breakpoint, then get info
info registers
print "Program stopped at breakpoint in main()"
disassemble main
quit
