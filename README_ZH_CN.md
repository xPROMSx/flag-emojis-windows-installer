<div align="center">

[🇷🇺 Русский](README.md) · [🇬🇧 English](README_EN.md) · [🇪🇬 العربية](README_AR.md) · [🇮🇷 فارسی](README_FA.md) · 🇨🇳 **简体中文** · [🇪🇸 Español](README_ES.md) · [🇹🇷 Türkçe](README_TR.md)

<img src="assets/branding/hero.svg" width="100%" alt="在 Windows 中显示真实国旗，而不是 FI、RU、DE 等字母代码">

<h1>Flag Emojis Windows Installer</h1>

### 让 Windows 11 和 Chrome 正常显示国家旗帜，不再只有字母代码。

**一个安装程序 · 保留 Windows 原有表情 · 支持恢复原状**

![Windows](https://img.shields.io/badge/Windows-11-0078D4?logo=windows11&logoColor=white)
![许可证](https://img.shields.io/badge/license-MIT-247A65)

[安装与卸载](#installation) · [测试说明](docs/INSTALLER-TESTS.md) · [支持开发](docs/SUPPORT_ZH_CN.md) · [问题反馈](https://github.com/xPROMSx/flag-emojis-windows-installer/issues)

</div>

## ✨ 为什么需要这个工具？

Windows 通常不会以彩色表情显示多数国家旗帜。在 Chrome 中，你可能看到 `FI`、`DE` 等字母代码，而不是 🇫🇮 和 🇩🇪。修改版字体可以解决这一问题，但仅通过 Windows 的常规方式安装字体，不一定能让 Chromium 内核浏览器正确使用。

使用 **Flag Emojis Windows Installer**，无需运行 PowerShell 命令或手动修改注册表，就能启用国旗表情；不需要时也可以轻松卸载。

## ⚙️ 主要功能

- **几次点击即可安装。** 一个安装程序，步骤简单清晰。
- **浏览器显示国旗。** 支持 Chrome、Edge 等 Chromium 内核浏览器。
- **保留 Windows 原始字体。** 不会覆盖或删除系统原有字体。
- **安装和卸载方便。** 可以重复运行安装程序，卸载时恢复先前设置。
- **下载文件经过验证。** 从字体原项目下载，并在安装前校验文件。
- **没有额外后台服务。** 不自动启动、不收集使用数据，也不强制更新。

<a id="installation"></a>

## 🚀 安装与卸载

**安装**

1. 从 [GitHub Releases](https://github.com/xPROMSx/flag-emojis-windows-installer/releases) 下载 `FlagEmojisSetup-vx.x.x.exe`。
2. 运行文件，允许 Windows 管理员权限请求，然后按照安装向导操作。程序会自动下载并验证字体，配置国旗表情的显示。
3. 安装完成后，**重新启动 Windows**，使更改生效。

**卸载**

打开 **设置 → 应用 → 已安装的应用**，找到 **Flag Emojis Windows Installer**，选择 **卸载**。程序会恢复此前的字体设置，删除自身安装的文件，不会修改 Windows 原始字体。卸载完成后，请**重新启动 Windows**。

## 📚 技术说明

当前版本面向 **Windows 11** 和 Chromium 内核浏览器。安装需要管理员权限，并在完成后重启系统。

此仓库只负责**安装程序**，不开发新的表情图案，也不制作字体文件。字体的原始项目、使用说明及版权信息请参阅 [NOTICE.md](NOTICE.md)。

**代码许可证：** [MIT](LICENSE)。字体组件的权利和许可另行适用。

## 💬 反馈与建议

如需反馈问题或提出建议，请前往 [GitHub Issues](https://github.com/xPROMSx/flag-emojis-windows-installer/issues)。

---

## ❤️ 支持开发

如果这个项目对你有帮助，可以自愿[支持项目开发](docs/SUPPORT_ZH_CN.md)。无论是否捐赠，全部功能始终免费且开源。

<div align="center">

**让 Windows 和 Chrome 显示国家旗帜。安装简单，无需繁琐设置。**

⭐ 如果你喜欢这个项目，欢迎在 [GitHub 上点个 Star](https://github.com/xPROMSx/flag-emojis-windows-installer)，帮助更多人发现它。

[安装](#installation) · [发布版本](https://github.com/xPROMSx/flag-emojis-windows-installer/releases) · [问题反馈](https://github.com/xPROMSx/flag-emojis-windows-installer/issues)

</div>
