# 回归测试说明

执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\run_tests.ps1
```

当前回归测试覆盖 34 项：集成脚本参数、退出码、输出文件、JSON 有效性、生命周期脚本存在性，以及 `check.bat` 中 WPS/Kaiwu 与 PPT workflow 门禁是否存在。

生命周期脚本只做静态存在性检查，避免测试意外安装、修复或卸载系统软件。测试在调用方指定的 `KAIWU_BASE` 下运行；未指定时使用当前目录。

测试通过不等于 Windows 7 实机验收通过。安装、重启、组件启动、WPS 插件、PPT workflow、修复和卸载必须按 `docs/08_Win7验证清单.md` 单独验证。
