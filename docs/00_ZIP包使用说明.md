# V1.4.1 ZIP 包使用说明

1. 将 ZIP 和同名 `.sha256` 放在同一目录。
2. 执行 `certutil -hashfile kaiwu-office-suite-v1.4.1.zip SHA256`，与旁车文件第一列比较。
3. 解压后先运行 `verify_installers.bat`；任何 MISSING 或 FAIL 都必须停止安装。
4. `packages/raw/` 是唯一制品目录，不应再出现第二份 `installers/`。
5. 正式包不得包含 `runtime/reports/`、`runtime/results/`、`*.bak`、测试输出或 Git 元数据。
