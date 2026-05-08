@echo off
chcp 65001 >nul
title J-Link RTT Client

:: J-Link RTT Client 路径
set "JLINK_PATH=C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe"

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║              J-Link RTT Client 日志查看器                 ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo 说明:
echo   - 请确保 J-Link RTT Viewer 已启动并连接到目标设备
echo   - 该工具会连接到 localhost:19021 获取RTT日志
echo   - 按 Ctrl+C 停止查看
echo.

:: 检查JLinkRTTClient是否存在
if not exist "%JLINK_PATH%" (
    echo 错误: 未找到 JLinkRTTClient.exe
    echo 路径: %JLINK_PATH%
    pause
    exit /b 1
)

echo 正在连接到 RTT Server...
echo.

:: 启动RTT Client
"%JLINK_PATH%"

echo.
echo RTT Client 已退出
pause