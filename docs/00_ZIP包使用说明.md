# 开悟个体增智智能办公套件 V1.0 ZIP包使用说明

**版本:** V1.0  
**发布日期:** 2026-06-18  
**文件:** `kaiwu-office-suite-v1.0.zip` (约 2.5 GB)  
**目标环境:** Windows 7 SP1 64位 / Windows 10 / Windows 11

---

## 一、ZIP包内容

| 目录/文件 | 说明 |
|-----------|------|
| `install.bat` | 一键安装脚本（管理员运行） |
| `uninstall.bat` | 一键卸载脚本 |
| `check.bat` | 安装状态检测脚本 |
| `repair.bat` | 一键修复脚本 |
| `packages/raw/` | 所有离线安装包源文件（15个组件） |
| `installers/` | 按分类整理的安装包目录 |
| `manifest/` | 版本锁定清单与SHA256校验文件 |
| `docs/` | 各类文档手册 |
| `scripts/` | 安装/检测/修复/卸载脚本 |
| `config/` | 配置文件 |
| `web-app/` | HTML网页入口应用 |
| `tests/` | 回归测试套件（38用例） |

---

## 二、系统要求

| 项目 | 最低要求 | 推荐配置 |
|------|----------|----------|
| 操作系统 | Windows 7 SP1 64位 | Windows 10/11 64位 |
| 处理器 | 1GHz | 2GHz或更高 |
| 内存 | 2GB | 4GB或更高 |
| 硬盘空间 | 10GB可用 | 20GB可用 |
| 权限 | 管理员权限 | 管理员权限 |

---

## 三、使用步骤

### 步骤1：校验ZIP包完整性

获取ZIP包后，先计算SHA256校验值并与 `manifest/SHA256SUMS.txt` 对比：

```cmd
certutil -hashfile "kaiwu-office-suite-v1.0.zip" SHA256
```

在 `manifest/SHA256SUMS.txt` 中找到 `kaiwu-office-suite-v1.0.zip` 对应的哈希值进行比对。值一致说明文件完整无损。

### 步骤2：解压

**方法一：系统自带（推荐）**
- 右键点击 `kaiwu-office-suite-v1.0.zip` → 选择"全部提取"
- 或使用系统文件资源管理器直接拖出

**方法二：命令行**
```cmd
tar -xf kaiwu-office-suite-v1.0.zip -C D:\KaiwuOfficeSuite
```

**解压建议路径：**
- `C:\KaiwuOfficeSuite\`（系统盘）
- `D:\KaiwuOfficeSuite\`（数据盘）
- **注意：** 解压路径不含中文或特殊字符

### 步骤3：安装

1. 打开解压后的文件夹
2. **右键点击 `install.bat` → 选择"以管理员身份运行"**
3. 安装程序将按以下顺序自动安装：
   - .NET Framework 4.8
   - VC++ Runtime
   - WebView2 Runtime
   - Git for Windows
   - Everything
   - Tesseract-OCR + 语言包
   - WPS Office
   - wps-kaiyu-addon (Kaiwu AI写作助手)
   - KexStepup (VxKex兼容层)
   - AionUI
   - Hermes Desktop
   - OpenCode
   - Obsidian
4. 全部安装完成后重启计算机（建议）

### 步骤4：验证

运行 `check.bat` 检测安装状态，查看生成的检测报告 `reports/check_report_*.md`，确认所有核心组件状态为"已安装"。

### 步骤5：可选组件

**XMind 23.11**（思维导图工具）为可选组件，如需安装请自行从官网下载。

---

## 四、常见问题

### ZIP包体积为什么这么大？
套件包含15个离线安装包（共约1.5GB），加上配置、脚本、文档等，压缩后约2.5GB。所有组件均为离线安装，无需网络。

### 解压失败怎么办？
- 先用 `certutil` 验证SHA256校验值
- 尝试用其他解压工具（如7-Zip、Bandizip）
- 重新下载ZIP包

### 安装过程中断怎么办？
安装脚本支持断点续装，重新以管理员身份运行 `install.bat` 即可继续未完成的安装。

### Windows Defender报毒？
KexStepup (VxKex) 因使用系统API Hook技术可能被Defender误报，请添加排除项或临时关闭Defender实时保护。

### 如何卸载？
右键以管理员身份运行 `uninstall.bat`，按提示完成卸载。个人文档和知识库不会被删除。

---

## 五、获取帮助

- 安装手册: `docs/01_安装手册.md`
- 用户手册: `docs/02_用户使用手册.md`
- 常见问题: `docs/05_常见问题FAQ.md`
- 版本清单: `docs/06_版本清单与依赖说明.md`
