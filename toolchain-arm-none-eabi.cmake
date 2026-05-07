# =============================================================================
# ARM Cortex-M 单片机专用 CMake 工具链配置文件
# 作用：告诉 CMake 使用 ARM 编译器，编译裸机嵌入式程序
# =============================================================================

# 1. 设置系统类型：Generic = 无操作系统（裸机）
#    arm = 处理器架构是 ARM
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_SYSTEM_VERSION 1)


# 2. 【最重要】告诉 CMake 不要测试生成 exe 文件
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


# 3. 定义编译器前缀：所有工具都以 arm-none-eabi- 开头
set(TOOLCHAIN_PREFIX "arm-none-eabi-")

# 尝试查找工具链路径，支持多个常见位置
if(WIN32)
    # 优先查找 PATH 中的编译器
    find_program(ARM_COMPILER_PATH ${TOOLCHAIN_PREFIX}gcc)
    # 如果找到了，提取路径
    if(ARM_COMPILER_PATH)
        get_filename_component(TOOLCHAIN_PATH "${ARM_COMPILER_PATH}" DIRECTORY)
        message(STATUS "[Toolchain] Found arm-none-eabi-gcc at: ${TOOLCHAIN_PATH}")
    else()
        # 如果 PATH 中没有，尝试常见安装路径
        set(POSSIBLE_PATHS
            "C:/Program Files (x86)/GNU Arm Embedded Toolchain/bin"
            "C:/GNU Arm Embedded Toolchain/bin"
            "C:/Keil_v5/ARM/10 2021.10/bin"
            "D:/GNU Arm Embedded Toolchain/bin"
        )
        # 遍历查找
        foreach(POSSIBLE_PATH ${POSSIBLE_PATHS})
            if(EXISTS "${POSSIBLE_PATH}/arm-none-eabi-gcc.exe")
                set(TOOLCHAIN_PATH "${POSSIBLE_PATH}")
                message(STATUS "[Toolchain] Found arm-none-eabi-gcc at: ${TOOLCHAIN_PATH}")
                break()
            endif()
        endforeach()
        # 如果没有找到，报错
        if(NOT TOOLCHAIN_PATH)
            message(FATAL_ERROR "Cannot find arm-none-eabi-gcc! Please install GNU ARM Embedded Toolchain "
                               "and add it to PATH, or update POSSIBLE_PATHS in toolchain-arm-none-eabi.cmake")
        endif()
    endif()
    # 把编译器路径加入系统环境变量
    set(ENV{PATH} "${TOOLCHAIN_PATH};$ENV{PATH}")
endif()


# =============================================================================
# 5. 指定 C 编译器、汇编编译器、打包工具
# =============================================================================
set(CMAKE_C_COMPILER "arm-none-eabi-gcc" CACHE STRING "C compiler" FORCE)
set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc" CACHE STRING "ASM compiler" FORCE)
set(CMAKE_C_COMPILER_AR "arm-none-eabi-ar" CACHE STRING "AR tool" FORCE)
set(CMAKE_C_COMPILER_RANLIB "arm-none-eabi-ranlib" CACHE STRING "RANLIB tool" FORCE)

# 找到 objcopy（转 bin 文件）、size（查看固件大小）工具
find_program(CMAKE_OBJCOPY_EXECUTABLE ${TOOLCHAIN_PREFIX}objcopy REQUIRED)
find_program(SIZE_EXECUTABLE ${TOOLCHAIN_PREFIX}size REQUIRED)


# =============================================================================
# 6. 【芯片关键配置】AT32F435 = Cortex-M4 + FPU 硬件浮点
# =============================================================================
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# 通用编译选项
set(COMMON_FLAGS
    ${MCU_FLAGS}     # 芯片架构
    -ffunction-sections   # 函数独立分段
    -fdata-sections       # 数据独立分段
    -Wall                 # 开启警告
    -g                    # 生成调试信息
)
# 把列表转成字符串（CMake 语法要求）
string(REPLACE ";" " " COMMON_FLAGS_STR "${COMMON_FLAGS}")

# 设置 C 语言编译参数
set(CMAKE_C_FLAGS "${COMMON_FLAGS_STR}" CACHE STRING "" FORCE)

# 汇编文件使用相同参数
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" FORCE)

# =============================================================================
# 链接参数
# --gc-sections：自动清理未使用的代码（减小固件体积）-配合-ffunction-sections
# --specs=nano.specs：使用精简版 C 库（单片机专用）
# =============================================================================
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -Wl,--gc-sections -specs=nano.specs" CACHE STRING "" FORCE)

# 最终输出文件后缀为 .elf（嵌入式标准格式）
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

