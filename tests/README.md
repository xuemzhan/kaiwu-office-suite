# 开悟个体增智智能办公套件 V1.0 - 测试套件

> 在 Windows 7 SP1 64-bit / PowerShell 5.1 环境下验证通过（`check.bat` 子项除外，见下）
> 用例总数：**38** / **断言严格**：缺组件环境 `check.bat` 子项报 FAIL（不再虚报 PASS）

## 目录结构

```
tests/
├── run_tests.ps1                  # PowerShell 测试主框架
├── TEST_REPORT.md                 # 最近一次运行结果（运行时生成）
├── test_check/                    # check.bat 冒烟测试
├── test_collect_context/          # collect_context.bat 测试
├── test_everything/               # call_everything_search.bat 测试
├── test_git/                      # call_git_status.bat 测试（含 temprepo 临时仓库）
├── test_install/                  # install_runtime.bat 测试
├── test_obsidian/                 # call_obsidian_note.bat 测试
├── test_openfolder/               # open_project_folder.bat 测试
├── test_repair/                   # repair_agent.bat 测试
├── test_rootcheck/                # 14 项环境根检测测试
├── test_tesseract/                # call_tesseract_ocr.bat 测试
├── test_wps/                      # call_wps_summary.bat 测试
└── test_xmind/                    # call_xmind_outline.bat 测试
```

每个 `test_*/` 子目录包含：
- `test_script.bat` — 该集成脚本的独立测试入口（也常被主框架调用）
- `logs/` — 运行时日志（已通过 .gitignore 排除）
- `results/` — 运行时输出（已通过 .gitignore 排除）

## 快速运行

```powershell
# 在 PowerShell 5.1+ 中执行（建议以管理员身份）
cd <suite-root>
powershell -ExecutionPolicy Bypass -File tests\run_tests.ps1

# 自定义套件根路径（可选；不指定时自动取当前 PowerShell 工作目录）
$env:KAIWU_BASE = "D:\kaiwu-office-suite-v1.0"
powershell -ExecutionPolicy Bypass -File tests\run_tests.ps1
```

## 测试覆盖范围

| 编号 | 测试组 | 用例数 | 目标 |
|---|---|---|---|
| 1 | collect_context | 5 | `scripts\integration\collect_context.bat` |
| 2 | call_xmind_outline | 6 | `scripts\integration\call_xmind_outline.bat` |
| 3 | call_obsidian_note | 6 | `scripts\integration\call_obsidian_note.bat` |
| 4 | call_wps_summary | 3 | `scripts\integration\call_wps_summary.bat` |
| 5 | call_git_status | 4 | `scripts\integration\call_git_status.bat` |
| 6 | open_project_folder | 3 | `scripts\integration\open_project_folder.bat` |
| 7 | call_everything_search | 2 | `scripts\integration\call_everything_search.bat` |
| 8 | call_tesseract_ocr | 3 | `scripts\integration\call_tesseract_ocr.bat` |
| 9 | check_agent | 2 | `scripts\check\check_agent.bat` |
| 10 | repair_agent | 1 | `scripts\repair\repair_agent.bat` |
| 11 | install_runtime | 1 | `scripts\install\install_runtime.bat` |
| 12 | check (root) | 2 | `check.bat` |
| **合计** | | **38** | |

## 实现机制

- **wrapper 模式**：`run_tests.ps1` 把每个被测脚本路径写到一个临时 `tests\wrapper.bat` 中，由 `cmd.exe /c` 间接调用，规避 PowerShell 调用 .bat 时的 `Start-Process` 路径含空格问题
- **断言库**：
  - `Test-ExitCode` —— 校验退出码
  - `Test-FileExists` —— 校验输出文件存在
  - `Test-OutputContains` —— 校验输出文件内容包含子串
  - `Test-JsonValid` —— 校验 JSON 括号配对（`{` `}` 数量相等）
- **基路径**：测试基路径自动取 `Get-Location`（当前工作目录）；可通过环境变量 `$env:KAIWU_BASE` 覆盖，**无需修改脚本**。每个 `test_*.bat` 默认假设套件装在 `C:\KaiwuOfficeSuite`（与生产 `install.bat` 一致），独立运行时若实际装在别处需改对应 `INSTALL_DIR` 变量
- **报告输出**：每次运行结束自动写入 `tests\TEST_REPORT.md`（Markdown 表格）

## Windows 7 适配要点

- 测试框架使用 PowerShell 5.1 原生特性，**最低支持 PS 3.0**（用到 `Start-Process -RedirectStandardOutput` / `[PSCustomObject]@{…}`，PS 2.0 不可用）
- 调用 .bat 时使用 `cmd.exe /c` 包装，**不依赖 pwsh**
- 所有 .bat 测试脚本使用 `setlocal enabledelayedexpansion`、纯 `cmd.exe` 命令，**不依赖 `where`、`%errorLevel%` 以外的新语法**
- Git 测试脚本使用 `cd /d` 后再 `git remote -v`，**兼容 msysgit 1.x 老版本（避免使用 git 1.7+ 才支持的 `-C` 参数）**
- 唯一一处较新 Git 语法：`git branch --show-current`（Git 2.22+，2020）。v1.0 锁定的 Git for Windows 2.46.2 满足此要求

## 失败排查

1. **确认在 PowerShell 5.1+ 下运行**（`$PSVersionTable.PSVersion`）
2. **确认 Git 已安装**（`git --version`）—— 部分测试需要 Git
3. **确认未以只读模式打开仓库** —— 测试会写入 `tests/wrapper.bat`
4. **查看 `tests/TEST_REPORT.md` 中 FAIL 行的 Detail 列** —— 包含实际错误码、缺失路径、断言细节
5. **查看 `tests/test_*/logs/*.log`** —— 各被测脚本的原始输出

## 添加新测试

1. 在 `scripts/integration/` 添加新的 `call_xxx.bat`
2. 在 `tests/` 下创建 `test_xxx/test_script.bat`（参考已有范例）
3. 在 `tests/run_tests.ps1` 末尾添加新的测试块（参考已有 test 块）
4. 在本 README 的"测试覆盖范围"表格中追加一行
