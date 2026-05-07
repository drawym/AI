# =============================================================================
# CMakeLists.txt for common CMSIS and drivers library
# =============================================================================

# 核心库名，即定义一个库模块，名字叫做 common，可被其他目标文件引用
add_library(common STATIC) 


# ========== 驱动程序 - 仅添加必要的驱动 《即keil里面添加c文件的操作》     ==========
# CMSIS 系统初始化
target_sources(common PRIVATE
    cmsis/system_at32f435_437.c
    cmsis/startup_at32f435_437.s
    cmsis/src/syscalls.c
)

# 时钟管理、GPIO、USART 是最核心的驱动
target_sources(common PRIVATE
    drivers/src/at32f435_437_crm.c
    drivers/src/at32f435_437_gpio.c
    drivers/src/at32f435_437_usart.c
    drivers/src/at32f435_437_exint.c      # 外部中断（可能需要）
    drivers/src/at32f435_437_misc.c       # 杂项（系统配置）
)



# ========== 包含目录    《即keil里面包含头文件的操作》     ==========
target_include_directories(common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/cmsis
    ${CMAKE_CURRENT_SOURCE_DIR}/cmsis/core_support
    ${CMAKE_CURRENT_SOURCE_DIR}/drivers/inc
)

# ========== 编译选项 ==========
target_compile_options(common PRIVATE
    -Wall     # 打开所有警告
    -Wextra   # 更多警告
)

# ========== 编译定义 - 指定目标设备 《即keil里面定义宏的操作》     ==========
# AT32F435ZMT7 是 256KB Flash 的 Cortex-M4 芯片
target_compile_definitions(common PRIVATE
    AT32F435ZMT7
)

# ========== 链接选项 ==========
target_link_options(common PRIVATE
    -nostartfiles    # 不使用默认的启动文件，启动文件我们自己定义
)

#常规信息输出，至此会生成common.a文件
message(STATUS "[common] Common library configured successfully")
