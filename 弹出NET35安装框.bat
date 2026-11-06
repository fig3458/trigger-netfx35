@echo off
chcp 65001 >nul
title 触发 .NET Framework 3.5 安装提示

echo.
echo 即将弹出 Windows 功能安装框（与公司软件弹出的是同一个）...
echo 请选择「下载并安装此功能」
echo.

:: fondue = Features On Demand User Experience
:: 这就是系统弹出那个「Windows 功能」对话框的官方入口
"%SystemRoot%\System32\fondue.exe" /enable-feature:NetFx3

echo.
echo 若弹框安装失败（常见：Windows 更新被禁用），请改用「离线安装.bat」
pause
