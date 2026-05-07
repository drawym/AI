# =============================================================================
# CMakeLists.txt for AT32F435 LED Toggle Application
# =============================================================================

# ========== 生成可执行文件 ==========
add_executable(AT32F435_LedToggle.elf)

# ========== 应用程序源文件 《即keil里面添加c文件的操作》     ==========
target_sources(AT32F435_LedToggle.elf PRIVATE
    src/main.c
    src/at32f435_437_board.c
    src/at32f435_437_clock.c
    src/at32f435_437_int.c
    rttview/SEGGER_RTT.c
    rttview/SEGGER_RTT_printf.c
)

# ========== 包含目录   《即keil里面添加头文件目录的操作》     ==========
target_include_directories(AT32F435_LedToggle.elf PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/rttview
)

# ========== 共享目录 《即把自己的头文件目录分享给其他目标文件使用》     ==========
# ========== 等同于在 common 库中添加包含这个目录    ==========
target_include_directories(common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

# ==========  链接 common 库（驱动、CMSIS、系统文件） ==========
target_link_libraries(AT32F435_LedToggle.elf PRIVATE
    -Wl,--whole-archive #设置链接选项，将 common 库的全部文件链接进来，包括未使用的函数，此举是为了防止链接器优化掉启动函数
    common     # 链接 common 库（驱动、CMSIS、系统文件）
    -Wl,--no-whole-archive  # 恢复默认行为，只链接需要的文件
)

# ========== 链接脚本 - AT32F435ZMT7 使用 xM 型号 ==========
# 选择合适的链接脚本：ZMT7 对应 xM 型号（最大 flash）
set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/common/cmsis/linker/AT32F435xM_FLASH.ld")
# ========== 检查链接脚本是否存在 ==========
if(NOT EXISTS ${LINKER_SCRIPT})
    message(FATAL_ERROR "Linker script not found: ${LINKER_SCRIPT}")
endif()

# ========== 链接脚本的选项 ==========
target_link_options(AT32F435_LedToggle.elf PRIVATE
    -T${LINKER_SCRIPT}   # 使用链接脚本来指定内存布局
    -Wl,-Map=${BIN_OUTPUT_DIR}/AT32F435_LedToggle.map   # 生成内存映射文件map
    -Wl,--gc-sections    # 扔掉没用的函数（减小体积）
)



# ========== 编译选项 ==========
target_compile_options(AT32F435_LedToggle.elf PRIVATE
    -Wall     # 打开所有警告
    -Wextra   # 更多警告
    -fno-common   # 不允许重复定义变量
)




# ========== 板级定义   《即keil里面添加宏定义的操作操作》     ==========
target_compile_definitions(AT32F435_LedToggle.elf PRIVATE
    AT_START_F435_V1   # 开发板型号-即宏定义
    AT32F435ZMT7       # 选择 AT32F435ZMT7 型号
)


# ========== 生成额外输出格式 (hex, bin) ==========
add_custom_command(TARGET AT32F435_LedToggle.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY_EXECUTABLE} -O ihex
        ${CMAKE_CURRENT_BINARY_DIR}/AT32F435_LedToggle.elf
        ${BIN_OUTPUT_DIR}/AT32F435_LedToggle.hex
    COMMAND ${CMAKE_OBJCOPY_EXECUTABLE} -O binary
        ${CMAKE_CURRENT_BINARY_DIR}/AT32F435_LedToggle.elf
        ${BIN_OUTPUT_DIR}/AT32F435_LedToggle.bin
    COMMAND ${SIZE_EXECUTABLE}
        ${CMAKE_CURRENT_BINARY_DIR}/AT32F435_LedToggle.elf
    COMMENT "Building ${BIN_OUTPUT_DIR}/AT32F435_LedToggle"
)

# ========== 打印信息 ==========   
message(STATUS "[led_toggle] Application configured successfully")
message(STATUS "Output files will be generated at: ${BIN_OUTPUT_DIR}")
