# RTT 日志查看 Skill

## 简介
本 Skill 将 `RTT日志查看指南.md` 中的操作步骤、PowerShell 示例与 JLink 命令整理为可复用的技能文档，方便在工作区内快速查阅与调用。

## 适用场景
- 需要通过 SEGGER J-Link 擦写、烧录或查看 RTT 日志时。
- 需把常用的 PowerShell 命令或 JLink 指令复制到脚本中执行时。

## 使用说明
- 直接查看本文件并复制对应命令到 PowerShell/终端执行。
- 若希望集成到自动化脚本，可把示例中的临时文件路径与设备型号替换为项目变量。

## 内容（按原文提取）

### 擦写整个 Flash（示例：AT32F435ZMT7 512KB）
PowerShell 示例：

```
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
```

### 烧录 hex/bin 文件（示例）
使用方法：运行下列命令，会在终端打印信息，直接读取终端内容即可。

```
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
```

### 获取 RTT 打印信息（建议先打开 JLinkRTT 客户端）
```
# 1. 关闭旧的 JLink 进程
Stop-Process -Name JLink -Force -ErrorAction SilentlyContinue
Stop-Process -Name JLinkRTTClient -Force -ErrorAction SilentlyContinue
# 2. 等待连接建立
Start-Sleep -Seconds 2
# 后台启动 JLink 连接单片机
Start-Process -FilePath "C:\Program Files (x86)\SEGGER\JLink_V698e\JLink.exe" -ArgumentList "-device", "-AT32F435ZMT7", "-if", "SWD", "-speed", "4000", "-CommandFile", "script\start_jlink_rtt.jlink" -NoNewWindow
# 3. 等待连接建立
Start-Sleep -Seconds 2
# 4. 执行 RTT 日志查看命令
& "C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe"
```

## 建议 / 可选改进
- 将设备型号、JLink 路径与临时文件路径抽成变量，方便 CI 或自动化脚本调用。
- 若希望由 Skill 自动执行，可提供一份 PowerShell 脚本模板（例如 `scripts/jlink_rtt.ps1`），并在项目 README 中指明用法。

## 抽象化与可配置模板
为了适配不同项目的 JLink 安装路径和芯片型号，我在 `script/` 目录下新增了一个可复用的 PowerShell 模板 `jlink_rtt.ps1` 和示例配置 `rtt-config.json.example`。该脚本支持：

- 从命令行参数覆盖默认值（`-JLinkPath`、`-Device`、`-Action` 等）。
- 在脚本同目录查找 `rtt-config.json` 作为默认值来源（项目可在根目录或脚本目录放置自己的 `rtt-config.json`）。

使用方式示例已包含在脚本头部，典型调用：

```powershell
# 以 flash 模式烧录指定 bin
.\script\jlink_rtt.ps1 -Action flash -Bin build/bin/AT32F435_LedToggle.bin -Device AT32F435ZMT7

# 仅打开 RTT 客户端查看日志（使用 config 中的默认 JLink 路径和设备）
.\script\jlink_rtt.ps1 -Action rtt
```

请查看脚本与示例配置：

- [script/jlink_rtt.ps1](script/jlink_rtt.ps1)
- [script/rtt-config.json.example](script/rtt-config.json.example)

如果你希望我把配置格式改为 YAML、或把默认配置放到特定位置（如 `.vscode/settings.json` 或 `project/` 目录），告诉我偏好，我会调整并更新 SKILL。

---

若你希望我把上述 skill 改成特定 SKILL 模板（例如包含 YAML frontmatter、intent/trigger 说明，或直接生成一个 VS Code 扩展/commands），告诉我你的目标格式与触发关键字，我可以继续完善。