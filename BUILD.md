# KaiWu Office Suite V1.3.1 - Build Guide

**Last updated**: 2026-07-07
**Target audience**: 套件维护者, 自动化打包 CI 工程师

本文档说明如何从 git 仓库**可重放地**构建出 `kaiwu-office-suite-v1.0.zip` 交付物。

---

## 1. 仓库布局

```
kaiwu-office-suite/                  ← Git 仓库根
├── .git/                            ← Git 元数据
├── .gitignore                       ← 排除 installers/ packages/raw/ 等
├── README.md                        ← 套件说明 (V1.2 实测 100% PASS)
├── install.bat                      ← 一键安装 (V1.3.1: errorlevel 检查)
├── uninstall.bat                    ← 一键卸载 (V1.1 实装)
├── repair.bat                       ← 一键修复 (V1.1 实装)
├── check.bat                        ← 一键检测
├── verify_installers.bat            ← 装前 SHA256 校验 (V1.1)
├── verify_installers.py             ← 装前 SHA256 Python 后端
├── kaiwu-office-suite-v1.0.sha256   ← 套件 ZIP 的 SHA256
├── web-app/                         ← Web 入口应用
│   ├── index.html
│   ├── styles.css
│   └── app.js / data.js
├── manifest/                        ← 版本锁定清单
│   ├── software-lock.yaml           ← 主清单 (YAML, 机器读)
│   ├── software-lock.md             ← 人读版本
│   ├── SHA256SUMS.txt               ← 14 个安装包 SHA256
│   └── package-info.json            ← V1.3.1 版本信息
├── scripts/
│   ├── integration/                 ← 8 个 integration .bat
│   │   ├── collect_context.bat
│   │   ├── call_xmind_outline.bat
│   │   ├── call_obsidian_note.bat
│   │   ├── call_wps_summary.bat     ← 占位实装
│   │   ├── call_git_status.bat
│   │   ├── call_tesseract_ocr.bat
│   │   ├── open_project_folder.bat
│   │   └── call_everything_search.bat
│   ├── check/check_agent.bat
│   ├── repair/repair_agent.bat
│   ├── install/install_runtime.bat
│   └── download/
│       ├── download_all.bat
│       ├── download_all.ps1         ← V1.1 8 个 SHA256 真值
│       └── download_one.ps1
├── config/                          ← 7 个 agent/config JSON
│   ├── aionui/aionui.json
│   ├── hermes/hermes.json
│   ├── opencode/opencode.json
│   ├── everything/everything.json
│   ├── tesseract/tesseract.json
│   ├── obsidian/obsidian.json
│   └── wps-addon/wps_addon.json
├── templates/                       ← 5 个模板
│   ├── todo_list.md
│   ├── weekly_report.md
│   ├── meeting_notes.md
│   ├── project_plan.md
│   └── note_template.md
├── examples/                        ← 4 个真实模板 (V1.3 删了 6 个空目录)
│   ├── example_todo_list.md
│   ├── example_weekly_report.md
│   ├── example_meeting_notes.md
│   └── example_project_plan.md
├── docs/                            ← 9 份文档
│   ├── 01_安装手册.md
│   ├── 02_用户使用手册.md
│   ├── 03_管理员维护手册.md
│   ├── 04_场景案例手册.md
│   ├── 05_常见问题FAQ.md
│   ├── 06_版本清单与依赖说明.md
│   ├── 07_安全与合规说明.md
│   ├── 08_Win7验证清单.md
│   └── 00_ZIP包使用说明.md
├── tests/                           ← V1.2 整目录入仓
│   ├── run_tests.ps1                ← 39 用例 100% PASS
│   ├── README.md
│   └── test_*/test_script.bat       ← 12 个
└── installers/                      ← 实际安装包 (1.4 GB)
    ├── 00_runtime/
    │   ├── ndp48-x86-x64-allos-enu.exe
    │   ├── MicrosoftEdgeWebView2RuntimeInstallerX64.exe
    │   ├── vc_redist.x64.exe
    │   └── Git-2.46.2-64-bit.exe
    ├── 01_agent/
    │   ├── AionUI-setup.exe
    │   ├── HermesDesktop-setup.exe
    │   └── OpenCode-setup.exe
    ├── 02_office/
    │   ├── WPS_Setup_26895.exe
    │   ├── wps-kaiyu-addon-setup.exe
    │   ├── KexStepup-setup.exe
    │   └── kaiwu_0.2.0/             ← 整个文件树 (web-app)
    ├── 03_tools/
    │   ├── Everything-1.4.1.1024.x64-Setup.exe
    │   ├── tesseract-ocr-w64-setup-5.3.1.20230401.exe
    │   ├── chi_sim.traineddata
    │   └── eng.traineddata
    ├── 04_knowledge/
    │   └── Obsidian.1.4.16.exe
    └── 05_optional/
        └── XMind-23.11.exe
```

注: `installers/` 在 .gitignore 中, 不入仓。

---

## 2. 构建流程

### 2.1 准备环境

需要的工具:
- Git 2.40+
- PowerShell 5.1+ (Windows 默认)
- Python 3.7+ (verify_installers.py)
- 7-Zip (打包成 .zip)
- Windows 7 SP1 64-bit 验证机 (可选, 但推荐)

### 2.2 克隆仓库

```bash
git clone https://github.com/xuemzhan/kaiwu-office-suite.git
cd kaiwu-office-suite
git checkout v1.3.1   # 或 master
```

### 2.3 准备 installers/

`.gitignore` 排除了 `installers/` —— **必须从内部制品库或本地 Downloads 准备**:

```bash
# 从 manifest/SHA256SUMS.txt 读 15 个文件 SHA256
# 从以下来源获取每个文件 (按 V1.1 manifest):

# 基础运行 (微软官方):
# - ndp48-x86-x64-allos-enu.exe
#   https://go.microsoft.com/fwlink/?linkid=2088631
# - MicrosoftEdgeWebView2RuntimeInstallerX64.exe
#   https://go.microsoft.com/fwlink/p/?LinkId=2124703
# - vc_redist.x64.exe
#   https://aka.ms/vs/17/release/vc_redist.x64.exe
# - Git-2.46.2-64-bit.exe
#   https://github.com/git-for-windows/git/releases/download/v2.46.2.windows.1/

# 工具 (官方):
# - Everything-1.4.1.1024.x64-Setup.exe
#   https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe
# - tesseract-ocr-w64-setup-5.3.1.20230401.exe
#   https://digi.bib.uni-mannheim.de/tesseract/
# - chi_sim.traineddata / eng.traineddata
#   https://github.com/tesseract-ocr/tessdata

# 办公 (用户本地):
# - WPS_Setup_26895.exe
#   来源: 用户 C:\Users\<user>\Downloads\
# - wps-kaiyu-addon-setup.exe + kaiwu_0.2.0/ (整个目录)
#   来源: https://github.com/xuemzhan/Kaiwu
# - KexStepup-setup.exe (VxKex 1.1.5.1679)
#   来源: https://github.com/i486/VxKex/releases/tag/Version1.1.5.1679

# Agent (内部制品库):
# - AionUI-setup.exe
# - HermesDesktop-setup.exe
# - OpenCode-setup.exe
```

把所有文件**按上面的目录结构**放到 `installers/`。

### 2.4 验证 SHA256

```cmd
verify_installers.bat
```

**期望输出**: `Total: 15  OK: 15  Mismatch: 0  Missing: 0` + `[PASS] All installers verified`

如果任何文件缺失或不匹配, 需重新下载或更新 `manifest/SHA256SUMS.txt`。

### 2.5 跑回归测试

```cmd
powershell -ExecutionPolicy Bypass -File tests\run_tests.ps1
```

**期望输出**: `Total: 39  Passed: 39  Failed: 0  Rate: 100.0%`

(V1.2 起, 100% PASS)

### 2.6 打包成 .zip

```bash
# 用 7-Zip (推荐, 压缩率好)
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx=9 kaiwu-office-suite-v1.0.zip ^
  install.bat uninstall.bat repair.bat check.bat ^
  verify_installers.bat verify_installers.py ^
  web-app\ manifest\ scripts\ config\ templates\ examples\ docs\ tests\ ^
  README.md kaiwu-office-suite-v1.0_release_note.md ^
  installers\ .gitignore

# 或用 PowerShell (Windows 内置)
Compress-Archive -Path .\install.bat,.\uninstall.bat,... -DestinationPath kaiwu-office-suite-v1.0.zip
```

**注意**:
- **不要** include `logs/` `results/` `state/` `packages/raw/` `tests/TEST_REPORT.md` `tests/test_git/temprepo/`
- 这些被 `.gitignore` 排除
- `installers/` **要** include (1.4 GB, 这是核心交付物)
- **不要** include `.git/` `.github/`

### 2.7 验证 .zip

```cmd
# 1. 算 SHA256
certutil -hashfile kaiwu-office-suite-v1.0.zip SHA256

# 2. 对比根目录 kaiwu-office-suite-v1.0.sha256
type kaiwu-office-suite-v1.0.sha256

# 3. (可选) 解压到临时目录, 跑 install.bat 测试
mkdir test-extract
Expand-Archive kaiwu-office-suite-v1.0.zip test-extract
cd test-extract
verify_installers.bat
```

### 2.8 发布

```bash
# 1. 创建 GitHub release
gh release create v1.3.1 kaiwu-office-suite-v1.0.zip ^
  --title "V1.3.1" ^
  --notes-file release_notes_v1.3.1.md

# 2. 上传 SHA256SUMS.txt
gh release upload v1.3.1 manifest/SHA256SUMS.txt
```

---

## 3. 持续集成建议

### 3.1 CI 流程 (.github/workflows/build.yml)

```yaml
name: build
on: [push, tag]
jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - name: Run unit tests
        shell: pwsh
        run: |
          cd ${{ github.workspace.path }}\kaiwu-office-suite-v1.0
          python verify_installers.py  # 必须先准备 installers/
          .\tests\run_tests.ps1
      - name: Verify SHA256 of release
        if: startsWith(github.ref, 'refs/tags/v')
        shell: pwsh
        run: |
          $hash = (Get-FileHash kaiwu-office-suite-v1.0.zip -Algorithm SHA256).Hash
          $expected = Get-Content kaiwu-office-suite-v1.0.sha256
          if ($hash -ne $expected) { throw "SHA256 mismatch" }
```

### 3.2 CI 必须满足的条件

- `run_tests.ps1` 跑通 100% PASS (V1.2 起)
- `verify_installers.bat` 跑出 15/15 PASS
- `install.bat` 在 Win7 SP1 验证机跑通 (手动)
- `uninstall.bat` 在 Win7 SP1 验证机跑通 (手动)

---

## 4. 版本号约定

V1.x.y 语义:
- **x** 大版本: 组件大升级 (Win7 → Win10, 或 加新组件)
- **y** 小版本: bug 修复 + 文档清理
- 当前: **V1.3.1** (V1.3 + install.bat errorlevel 修)

每次 tag 都要:
1. 改 `manifest/package-info.json` (version + release_date + changelog)
2. 改 `README.md` 加版本历史段
3. 重新跑 `run_tests.ps1` 确认通过率
4. 重新算 `kaiwu-office-suite-v1.0.sha256` (zip 重新打包后)
5. tag + push

---

## 5. 已知问题 (V1.3.1)

1. **CI 没接** — 没有 `.github/workflows/` —— 上面 §3 是建议配置
2. **packages/raw/ vs installers/** — 实际打包用 `installers/`, 但根目录 `packages/raw/` 也存在 (历史)
3. **kaiwu_0.2.0_installer.exe 同 SHA256 = wps-kaiyu-addon-setup.exe** — 这 2 个是同一文件, manifest 注释已说明
4. **run_tests.ps1 在 PS 5.1 + 中文路径下** — V1.2 已修 (chcp 65001 + UTF-8), 当前 100% PASS
5. **install.bat 异步安装器** — `.NET / Git / WPS` 启动后立即返回 0, 实际安装 5-30 分钟. V1.3.1 只验启动成功, 完整验证在 [19/19] 段

---

## 6. 验证矩阵

| 检查项 | 工具 | 期望 |
|---|---|---|
| install.bat 语法 | `cmd /c install.bat` (假 admin) | 至少跑到 [0/19] verify |
| 14 个 install 步骤 errorlevel | `run_tests.ps1` (跑 integration 段) | 100% PASS |
| verify_installers | `verify_installers.bat` | 15/15 PASS |
| run_tests 39 用例 | `run_tests.ps1` | 39/39 = 100% PASS |
| uninstall 8 步实装 | 手动跑 `uninstall.bat` 输 N | exit 0 + log |
| repair 9 种修复 | 手动跑 `repair.bat` option 9 | 10 个 OK |
| web-app 渲染 | `python -m http.server 8080` | localhost:8080 看 5 个场景 + 8 文档 |
