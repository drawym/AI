# 指定支持的最低 CMake 版本，低于此版本会报错
cmake_minimum_required(VERSION 3.15)

# ==============================================
# 告诉 CMake：去使用 toolchain-arm-none-eabi.cmake 这个文件里的配置来编译工程
# ==============================================
if(NOT CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/toolchain-arm-none-eabi.cmake")
    message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
endif()


# ==============================================
# 不生成 exe，不做系统级链接测试
# ==============================================
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


# ==============================================
# 定义项目名称、版本、使用的语言（C语言 + 汇编）
# ==============================================
project(AT32F435_LedToggle    # 项目名称，不影响编译结果
    VERSION 1.0.0             # 项目版本，不影响编译结果
    LANGUAGES C ASM             # 项目使用的语言，C语言 +汇编语言
)

# ==============================================
# 指定使用 C11 标准，并且强制要求支持
# ==============================================
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)


# ==============================================
# 禁止在源码目录内编译（防止污染源码）《即强制把编译出来的文件放在build目录下》
# ==============================================
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed!")
endif()

# ==============================================
# 如果没有指定编译类型，默认使用 Release（优化模式）
# ==============================================
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)    # 默认使用 最高优化模式 ，可以改成 Debug（调试模式）
endif()

# ==============================================
# 设置编译输出目录（最终 .bin .elf 放在这里）
# 自动创建目录
# ==============================================
set(BIN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/bin)
file(MAKE_DIRECTORY ${BIN_OUTPUT_DIR})


# ==============================================
# 把子目录加入编译
# common：驱动、库、系统文件
# project：主程序
# ==============================================
add_subdirectory(common)
add_subdirectory(project)



# 打印信息
message(STATUS "=== AT32F435 构建成功 ===")
message(STATUS "编译器: ${CMAKE_C_COMPILER}")
message(STATUS "输出目录: ${BIN_OUTPUT_DIR}")

