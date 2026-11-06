# trigger-netfx35

触发与常见公司软件相同的「Windows 功能 / .NET Framework 3.5」安装对话框，并附带检测与离线安装脚本。

装旧软件提示缺少 .NET 3.5 时，可用本仓库脚本快速弹框或离线启用。

## 脚本说明

| 文件 | 作用 |
|------|------|
| `弹出NET35安装框.bat` / `show-netfx35-dialog.bat` | 调用 `fondue.exe` 弹出官方安装框 |
| `TriggerNetFx35.ps1` | 检测 NetFx3 状态后再弹框；已启用则跳过 |
| `检测NET35.bat` / `check-netfx35.bat` | 检测是否已安装 .NET 3.5 |
| `离线安装.bat` / `offline-install.bat` | 使用旁路 `sxs` 包离线启用 NetFx3 |

## 下载与使用

1. 到 [Releases](https://github.com/fig3458/trigger-netfx35/releases) 下载 zip 并解压
2. 普通场景：双击 `弹出NET35安装框.bat`（建议管理员）
3. 若提示安装包已删除：把官方 `microsoft-windows-netfx3-ondemand-package...cab` 放到 `sxs\`，再运行 `离线安装.bat`

## 仓库说明

`sxs\` 下的大型 `.cab` **默认不纳入 Git**（体积约 70MB+）。需要离线安装时请自行放入后再分发。

## 兼容

面向 Windows 10 / 11（依赖 `fondue.exe` / DISM 可选功能）。

## 许可证

[MIT](LICENSE)
