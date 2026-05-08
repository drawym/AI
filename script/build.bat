@echo off
echo ==============================================
echo          AT32F435 项目编译脚本
echo ==============================================

rem 检查是否存在 build 目录
if not exist "build" (
    echo [INFO] 首次编译，生成构建系统...
    cmake -S . -B build -G Ninja
)

echo [INFO] 开始编译...
ninja -C build

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] 编译成功！
    echo 输出文件:
    echo   - build/bin/AT32F435_LedToggle.bin
    echo   - build/bin/AT32F435_LedToggle.hex
) else (
    echo [ERROR] 编译失败！
)

pause