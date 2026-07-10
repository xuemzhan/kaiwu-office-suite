# KaiWu Office Suite V1.4.1 构建说明

## 原则

正式 ZIP 只包含一份 `packages/raw/`，不得包含 `installers/`、日志、报告、结果、备份、测试临时文件或 Git 元数据。构建机可以是较新 Windows，但产物中的运行脚本必须兼容 Windows 7 SP1。

## 前置条件

1. 将经审批的安装文件放入 `packages/raw/`。
2. 补齐必装 `KexStepup-setup.exe`，计算 SHA256 并加入 `manifest/SHA256SUMS.txt`。
3. 运行 `release_preflight.bat`，必须仅剩已确认的外部阻断项。
4. 运行 `verify_installers.bat`，必须全部通过。
5. 运行 `tests/run_tests.ps1`，必须退出 0。
6. 完成两类 Win7 实机验收并保存证据。

## 构建

```cmd
build_zip.bat 1.4.1
```

脚本会再次校验哈希和 KexStepup，使用临时 staging 目录创建干净 ZIP，并输出标准单行 `.zip.sha256`。

## CI 发布

普通 CI 只运行无安装包的脚本回归和静态检查。正式 Release 采用手动触发、受控自托管 Windows 节点，从 `C:\KaiwuArtifacts` 复制已审批制品，验证后创建 Draft Release。不得在缺制品的 GitHub 托管节点生成“可安装版”。

## 上游来源准入

- Kaiwu 只能在 WPS 12.1.0.26375+、Windows 7 SP1 实机加载、AI 出站审批和日志/密钥策略均通过后启用。
- ppt-workflow 当前只允许作为参考源和 unsupported 门禁；真实集成前必须解决 Python 3.12+ 与 Win7 SP1 的兼容冲突。
- .upstream-audit/ 是父目录下的临时审查区，不属于发布包输入，不能复制进 ZIP。
- 新增上游组件必须先进入 manifest/software-lock.*、manifest/SHA256SUMS.txt 和 docs/09_上游来源审查报告.md。

## 发布检查

- 版本号、README、package-info、ZIP 文件名一致。
- SHA256 清单无缺失、无重复、无占位哈希。
- ZIP 中无重复制品、无 `.bak`、无 `runtime/`、无旧版 `logs/`、`reports/`、`results/`、`state/` 运行产物。
- Win7 安装、重启、检测、修复、卸载均有实测记录。
