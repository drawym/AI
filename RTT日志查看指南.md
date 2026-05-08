# RTT 日志查看器技能 (Skill)

## 技能标识
- **技能名称**: rtt_log_viewer
- **技能版本**: 1.0.0
- **技能类型**: 工具调用型
- **适用平台**: Windows 10/11
- **依赖工具**: J-Link RTT Client

---

## 技能描述

通过命令行方式启动 J-Link RTT Client，连接到本地 RTT Server，实时获取目标嵌入式设备的日志输出。

---

## 输入参数

| 参数名称 | 类型 | 必填 | 默认值 | 说明 |
|---------|------|------|--------|------|
| jlink_path | string | 否 | `C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe` | JLinkRTTClient 可执行文件路径 |
| wait_ms | integer | 否 | 8000 | 等待连接超时时间（毫秒） |
| blocking | boolean | 否 | false | 是否阻塞执行 |

---

## 执行流程

### 阶段一：前置检查

1. **验证 J-Link RTT Server 是否已启动**
   - 检查 localhost:19021 端口是否可访问
   - 如未启动，提示用户先打开 J-Link RTT Viewer

2. **验证 JLinkRTTClient 路径**
   - 检查 `jlink_path` 指定的文件是否存在
   - 路径包含空格时需用引号包裹

### 阶段二：执行命令

```powershell
& "C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe"
```

### 阶段三：获取输出

连接成功后，终端将实时输出以下信息：
- J-Link 设备信息（型号、序列号）
- 目标设备发送的 RTT 日志

---

## 输出格式

### 成功输出

```json
{
  "status": "success",
  "message": "RTT Client 已成功连接",
  "device_info": {
    "jlink_version": "SEGGER J-Link V6.98e",
    "hardware_model": "SEGGER J-Link ARM V9.7",
    "serial_number": "69706027",
    "server_process": "JLinkRTTViewer.exe"
  },
  "logs": [

  ]
}
```

### 失败输出

```json
{
  "status": "error",
  "message": "连接失败",
  "error_code": "CONNECTION_FAILED",
  "suggestion": "请确保 J-Link RTT Viewer 已启动并连接到目标设备"
}
```

---

## 使用示例

### 示例 1：基本使用

**输入**:
```json
{
  "skill": "rtt_log_viewer",
  "params": {}
}
```

**输出**:
```
SEGGER J-Link V6.98e - Real time terminal output

SEGGER J-Link ARM V9.7, SN=69706027
Process: JLinkRTTViewer.exe
  Hello zzh
  Hello zzh
```

### 示例 2：指定自定义路径

**输入**:
```json
{
  "skill": "rtt_log_viewer",
  "params": {
    "jlink_path": "D:\\Tools\\SEGGER\\JLink_V700\\JLinkRTTClient.exe"
  }
}
```

---

## 注意事项

1. **前置条件**
   - 必须先启动 J-Link RTT Viewer 并连接到目标设备
   - RTT Server 默认端口为 19021

2. **权限要求**
   - 需要管理员权限访问 J-Link 设备
   - 防火墙需允许 19021 端口通信

3. **停止方式**
   - 按 `Ctrl+C` 组合键停止 RTT Client
   - 或发送停止命令终止进程

4. **日志编码**
   - 默认使用 UTF-8 编码
   - 支持中文日志输出

---

## 错误处理

| 错误类型 | 错误码 | 处理建议 |
|---------|--------|---------|
| 路径不存在 | PATH_NOT_FOUND | 检查 JLinkRTTClient 安装路径 |
| 连接超时 | CONNECTION_TIMEOUT | 检查 RTT Server 是否启动 |
| 权限不足 | PERMISSION_DENIED | 以管理员身份运行 |
| 设备未连接 | DEVICE_DISCONNECTED | 检查 J-Link 硬件连接 |

---

## 兼容性

- ✅ PowerShell 5.1+
- ✅ J-Link RTT Viewer V6.00+
- ✅ Windows 10/11 操作系统

---

## 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| 1.0.0 | 2024年 | 初始版本，支持基本 RTT 日志查看功能 |