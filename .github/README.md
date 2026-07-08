# GitHub Configuration

CI/CD 配置文件, 入仓跟踪。

## 文件

| 文件 | 作用 | 触发 |
|---|---|---|
| `workflows/test.yml` | 主测试 (5 jobs) | push / PR / manual |
| `workflows/release.yml` | 打包 + GitHub release | push tag `v*` |
| `dependabot.yml` | 依赖自动更新 | 每周一 09:00 UTC |

## test.yml jobs 概览

```
push / PR
   ↓
┌─────────────┐
│ lint        │ Ubuntu: YAML + Python + .bat 编码
└──────┬──────┘
       ↓
┌─────────────┐  ┌──────────────┐  ┌────────────────┐
│ python-smoke│  │ pwsh-tests   │  │ installer-verify│
│ (Win)       │  │ (Win)        │  │ (Win, 仅 master)│
│             │  │              │  │                │
│ verify_     │  │ run_tests.ps1│  │ verify_        │
│ installers.py│ │ 39 用例      │  │ installers.py  │
└──────┬──────┘  └──────┬───────┘  └───────┬────────┘
       └────────────────┴────────────────┘
                         ↓
            ┌────────────────────────┐
            │ all-jobs-must-pass      │
            └────────────────────────┘
```

## 中文路径 + UTF-8 兼容

- pwsh-tests 设 `[Console]::OutputEncoding = UTF8` + `chcp 65001` (V1.2 修的 run_tests.ps1 v3 fix)
- Python 用 GB18030 读 .bat 避免中文乱码

## 本地测试 workflow

- YAML 语法: `python -c "import yaml; yaml.safe_load(open('.github/workflows/test.yml'))"`
- .bat 编码: `python .github/_check_bats.py` (在 lint job 里有同样逻辑)

## 加新 workflow

1. 在 `.github/workflows/` 加 `xxx.yml`
2. 包含 `name:` `on:` `jobs:` 三部分
3. 在 `test.yml` 的 `all-jobs-must-pass` 加新 job
4. 本地 `python -c "import yaml; yaml.safe_load(open(f))"` 验证
5. commit + push, GitHub Actions 自动跑
