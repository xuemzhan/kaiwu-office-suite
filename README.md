# 开悟个体增智智能办公套件 V1.4.1

面向 Windows 7 SP1 64 位的离线办公工具集成工程。V1.4.1 是修复审查问题后的工程候选版，尚需通过 Win7 实机验收后才能标记为正式发布。

## 当前状态

- 已具备：离线安装框架、SHA256 强制校验、检测/修复/卸载脚本、Everything 搜索、Tesseract OCR、Obsidian 笔记、Git 状态、模板和静态 Web 导航页。
- 当前缺失：必装的 `KexStepup-setup.exe`、可选的 XMind 安装包。
- 未实装：WPS 文档智能总结；调用会明确返回“不支持”，不会生成假结果。
- 未实装：PPT 自动生成/排版；`scripts/integration/call_ppt_workflow.bat` 是门禁脚本，缺参数返回 1，有参数返回 2。
- 来源边界：WPS AI 插件参考 [xuemzhan/Kaiwu](https://github.com/xuemzhan/Kaiwu)，上游要求 Windows 10/11 与 WPS 12.1.0.26375+，本套件 Win7 SP1 兼容性为阻断待验证；PPT 能力参考 [xuemzhan/ppt-workflow](https://github.com/xuemzhan/ppt-workflow)，当前仅登记为参考源，未随 V1.4.1 交付。
- 待验收：AionUI、Hermes、OpenCode、WPS 插件及完整安装链在 Windows 7 SP1 实机上的兼容性。

## 系统要求

- Windows 7 SP1 64 位
- 管理员权限
- 至少 4 GB 内存、10 GB 可用磁盘
- 系统自带 `certutil`
- 集成脚本建议使用 PowerShell 5.1；安装包校验不依赖 Python

## 安装

1. 核对 ZIP 旁车 `.sha256`。
2. 解压到不含特殊权限限制的本地目录。
3. 运行 `release_preflight.bat` 查看交付阻断项。
4. 以管理员身份运行 `verify_installers.bat`。
5. 只有所有清单文件均存在且哈希一致时，才运行 `install.bat`。
6. 安装结束后重启，再运行 `check.bat`。

> 当前工作目录缺少必装 KexStepup，因此 `install.bat` 会主动终止。这是安全保护，不是安装故障。取得安装包后，先运行 `scripts/admin/compute_kexstepup_hash.bat` 生成哈希报告，再按审批结果更新清单。

## 验证

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\run_tests.ps1
```

测试报告以本次实际运行输出为准。项目不再在 README 固定声明“39/39”或“100%”。回归测试是脚本级验证，不能替代 Win7 实机安装与功能验收。

## 目录

- `packages/raw/`：唯一安装制品目录
- `manifest/`：版本与 SHA256 清单
- `scripts/integration/`：本地工具调用脚本
- `docs/`：安装、使用、维护、安全、上游来源审查、阻断清单和验收文档
- `tests/`：非破坏性回归测试
- `runtime/`：运行时生成目录，统一承载日志、报告、结果和状态；不进入 Git/正式 ZIP
- `web-app/`：静态说明与路径导航，不具备浏览器直接启动本地程序的权限

## 已知限制

- KexStepup 缺失时禁止正式打包和安装。
- XMind 为可选组件，当前未随包交付。
- WPS 总结、PPT 自动生成/排版、MCP/A2A 服务、端到端加密、自动备份和等保认证不属于当前已验证能力。
- 上游实审记录见 `docs/09_上游来源审查报告.md`；交付前阻断项见 `docs/10_交付前阻断清单.md`；目录规范见 `docs/11_工程目录规范.md`。
- 三个内部制品缺少 Authenticode 签名，正式发布前须补充来源审批和恶意代码扫描记录。

## 版本

V1.4.1（2026-07-10）：修复完整性校验假成功、安装状态假成功、集成脚本故障、测试失真、CI 路径、发布包重复、文档乱码及能力表述问题。
