# 开悟个体增智智能办公套件 V1.3.3

> 面向 Windows 7 SP1 64 位的智能办公解决方案

版本：**V1.3.3** | 发布日期：**2026-07-08** | 测试通过率：**39/39 = 100%**

GitHub：https://github.com/xuemzhan/kaiwu-office-suite.git

## 系统要求

- 操作系统：Windows 7 SP1 64 位
- 内存：至少 4 GB
- 磁盘：至少 10 GB 可用空间
- 权限：管理员权限

## 快速开始

1. **校验安装包**：以管理员身份运行 `verify_installers.bat`，确认 SHA256 全部通过
2. **一键安装**：右键 `install.bat`，选择"以管理员身份运行"
3. **重启计算机**（建议）
4. **启动 Web 入口**：进入 `web-app/`，运行 `python -m http.server 8080`，浏览器打开 `http://localhost:8080`
5. **开始使用**：通过桌面快捷方式或 Web 入口启动各组件

## 组件列表

**运行环境：** .NET 4.8 · WebView2 109.0.1518.46 · VC++ 14.38.33135 · Git 2.46.2

**智能助理：** AionUI (Win7验证版) · Hermes Desktop (Win7验证版) · OpenCode (内网版)

**办公组件：** WPS Office 11.8.2.12068 · wps-kaiyu-addon (内部版) · KexStepup (内部版，**缺失**)

**工具：** Everything 1.4.1.1024 · Tesseract-OCR 5.3.1

**知识库：** Obsidian 1.4.16 · XMind 23.11 (**缺失**)

共 16 个组件，14 个已下载；KexStepup 和 XMind 安装包暂缺。

## 功能特性

- **一键安装**：全自动安装所有组件，无需手动干预
- **一键检测**：`check.bat` 检测组件安装状态与路径可用性
- **一键修复**：`repair.bat` 修复环境变量、快捷方式等 9 类问题
- **一键卸载**：`uninstall.bat` 安全卸载，保留基础运行环境
- **版本锁定**：`manifest/` 记录所有组件精确版本号与 SHA256 哈希
- **离线安装**：所有安装包随套件分发，无需联网
- **日志记录**：安装、检测、修复过程自动生成日志
- **回滚支持**：安装失败自动回滚

## 目录结构

```
kaiwu-office-suite-v1.0/
├── install.bat              # 一键安装
├── uninstall.bat            # 一键卸载
├── repair.bat               # 一键修复
├── check.bat                # 一键检测
├── verify_installers.bat    # SHA256 校验
├── verify_installers.py     # SHA256 校验后端
├── build_zip.bat            # 交付 ZIP 生成
├── README.md                # 本文件
├── web-app/                 # Web 入口应用
├── manifest/                # 版本锁定清单
├── packages/raw/            # 安装包 (1.4 GB)
├── scripts/                 # 集成、检测、修复、安装、下载脚本
├── config/                  # 配置文件
├── templates/               # 模板目录
├── examples/                # 4 个真实模板
├── docs/                    # 文档目录 (10 份)
├── tests/                   # 回归测试 (39/39)
└── logs/                    # 日志目录
```

## 集成脚本

`scripts/integration/` 包含 10 个 .bat 集成脚本和 1 个工具注册表：

| 脚本 | 用途 |
|------|------|
| `call_everything_search.bat` | Everything 文件搜索 |
| `call_git_status.bat` | Git 仓库状态检查 |
| `call_obsidian_note.bat` | Obsidian 笔记创建 |
| `call_tesseract_ocr.bat` | Tesseract OCR 文字识别 |
| `call_wps_summary.bat` | WPS 文档总结（占位） |
| `call_xmind_outline.bat` | XMind 思维导图大纲生成 |
| `collect_context.bat` | 上下文信息收集 |
| `open_project_folder.bat` | 打开项目文件夹 |
| `ocr_to_markdown.bat` | OCR 图片转 Markdown |
| `ocr_to_obsidian.bat` | OCR 图片转 Obsidian 笔记 |
| `tool_registry.json` | 工具注册表配置 |

`ocr_to_markdown.bat` 和 `ocr_to_obsidian.bat` 为 V1.3.3 新增。

## 测试

运行回归测试：

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_tests.ps1
```

通过率：**39/39 = 100%**。安装前请运行 `verify_installers.bat` 校验 SHA256。

## 维护

| 命令 | 用途 |
|------|------|
| `check.bat` | 检测组件的安装状态、路径可用性、环境变量 |
| `repair.bat` | 修复环境变量、快捷方式、工具注册等，修复后自动调用 check.bat 验证 |
| `uninstall.bat` | 安全移除套件组件，保留 .NET/VC++ 等运行环境 |

## Web 入口应用

基于 HTML/CSS/JavaScript 的可视化入口。启动方式：

```bash
cd web-app
python -m http.server 8080
# 浏览器打开 http://localhost:8080
```

模块：首页概览 · 6 大功能介绍 · 5 个场景案例 · 4 步使用指南 · 8 个快捷入口 · 5 个 FAQ · 8 份文档链接

## 文档列表

`docs/` 目录包含 10 份文档：

- `docs/00_ZIP包使用说明.md` - ZIP 包使用说明
- `docs/00_环境检查报告.md` - 环境检查报告
- `docs/01_安装手册.md` - 安装手册
- `docs/02_用户使用手册.md` - 用户使用手册
- `docs/03_管理员维护手册.md` - 管理员维护手册
- `docs/04_场景案例手册.md` - 场景案例手册
- `docs/05_常见问题FAQ.md` - 常见问题
- `docs/06_版本清单与依赖说明.md` - 版本清单与依赖
- `docs/07_安全与合规说明.md` - 安全与合规
- `docs/08_Win7验证清单.md` - Win7 验证清单

## 版本历史

### V1.3.3 (2026-07-08)
清理 SHA256SUMS.txt 冗余条目，修复 PATH 环境变量遮蔽 bug，新增 `ocr_to_markdown.bat` 和 `ocr_to_obsidian.bat`，修复 `install.bat` 中文文件名乱码，`repair.bat` 修复后自动调用 `check.bat` 验证。

### V1.3 (2026-07-07)
清理 6 个空示例目录，web-app 改用 `data.js` 静态数据源，修复 README 与实际数据不一致的问题（场景案例 6->5，FAQ 7->5）。

### V1.2 (2026-07-07)
修复测试框架在 PS 5.1 下的中文路径兼容问题，修复 `call_git_status.bat` errorlevel bug，调整 4 处期望。测试通过率从 27% 提升至 39/39 = 100%。

### V1.1 (2026-07-07)
路径与文件名错误修复（集成脚本加 mkdir，安装路径 `installers/` -> `packages/raw/`），实装 uninstall/repair，引入 SHA256 校验，补全版本清单。

### V1.0 (2026-06-17)
初始版本发布，包含全部核心组件。

## 许可证

本套件仅供内部使用。
