# RTT 技能 (Skill)




# =================================通过以下命令可以擦写整个Flash=====================================

# 擦除整个Flash (AT32F435ZMT7 512KB)
# PowerShell 示例

# 写入多行指令到临时文件
@"
erase 0x08000000, 0x08080000
q
"@ | Out-File -FilePath "temp.jlink" -Encoding ASCII

# 调用 JLink 执行命令文件
& "C:\Program Files (x86)\SEGGER\JLink_V698e\JLink.exe" `
-device AT32F435ZMT7 -if SWD -speed 4000 -CommandFile "temp.jlink"

# 删除临时命令文件
Remove-Item "temp.jlink"




# =================================通过以下命令可以烧录hex文件=====================================
#使用方法，运行下面命令后，会在终端打印出来，然后直接读取终端内容，即可知道打印信息#



# 1. 生成 JLink 临时指令文件
@"
loadbin build/bin/AT32F435_LedToggle.bin, 0x08000000  # 烧录 bin 文件到 Flash 起始地址 0x08000000
r                                                    # 重启单片机，自动运行新程序
q                                                    # 退出 JLink
"@ | Out-File -FilePath "temp.jlink" -Encoding ASCII  # 将内容保存为 temp.jlink，编码 ASCII

# 2. 调用 JLink 执行烧录指令
& "C:\Program Files (x86)\SEGGER\JLink_V698e\JLink.exe" -device -AT32F435ZMT7 -if SWD -speed 4000 -CommandFile "temp.jlink"

# 3. 删除临时指令文件
Remove-Item "temp.jlink"





# =================================通过以下命令可以获取打印信息===一般情况下，需要让用户打开jlinkrtt客户端，然后直接调用第4点=====================================

# 1.关闭旧的JLink进程
Stop-Process -Name JLink -Force -ErrorAction SilentlyContinue
Stop-Process -Name JLinkRTTClient -Force -ErrorAction SilentlyContinue
# 2.等待连接建立
Start-Sleep -Seconds 2
# 后台启动JLink连接单片机
Start-Process -FilePath "C:\Program Files (x86)\SEGGER\JLink_V698e\JLink.exe" -ArgumentList "-device", "-AT32F435ZMT7", "-if", "SWD", "-speed", "4000", "-CommandFile", "script\start_jlink_rtt.jlink" -NoNewWindow
# 3.等待连接建立
Start-Sleep -Seconds 2
# 4.执行RTT日志查看命令
& "C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe"





