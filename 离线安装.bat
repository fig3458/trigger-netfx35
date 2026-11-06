@echo off
chcp 65001 >nul
title .NET Framework 3.5 离线安装
setlocal EnableExtensions

:: 已打包 Win10 22H2 的 sources\sxs（来自 D:\运维 里的 Win10 ISO）
set "SXS=%~dp0sxs"
set "WIN10_ISO=D:\运维\zh-cn_windows_10_consumer_editions_version_22h2_updated_dec_2022_x64_dvd_a95e3989.iso"
set "MOUNTED="

net session >nul 2>&1
if errorlevel 1 (
  echo 请右键本脚本 →「以管理员身份运行」。
  pause
  exit /b 1
)

echo.
echo 不走 Windows 更新，使用本地安装包安装 .NET Framework 3.5 ...
echo.

if exist "%SXS%\microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab" goto :INSTALL

echo 未找到打包的 sxs，尝试挂载 D:\运维 下的 Win10 22H2 镜像...
if not exist "%WIN10_ISO%" (
  echo 找不到镜像：%WIN10_ISO%
  echo 也找不到本地 sxs 包。请把 Win10 ISO 放到上述路径，或重新复制 sources\sxs 到本目录。
  pause
  exit /b 1
)

powershell -NoProfile -Command ^
  "$m=Mount-DiskImage -ImagePath '%WIN10_ISO%' -PassThru; ($m|Get-Volume).DriveLetter" > "%TEMP%\netfx35_mount.txt"
set /p LETTER=<"%TEMP%\netfx35_mount.txt"
del "%TEMP%\netfx35_mount.txt" >nul 2>&1
if not defined LETTER (
  echo 挂载 ISO 失败。
  pause
  exit /b 1
)
set "SXS=%LETTER%:\sources\sxs"
set "MOUNTED=1"
echo 已挂载为 %LETTER%: ，使用 %SXS%

:INSTALL
echo 安装源: %SXS%
echo.
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"%SXS%"
set "ERR=%ERRORLEVEL%"

if defined MOUNTED (
  powershell -NoProfile -Command "Dismount-DiskImage -ImagePath '%WIN10_ISO%'" >nul 2>&1
)

echo.
if not "%ERR%"=="0" (
  echo 安装失败，错误码 %ERR%。
  echo 提示：本机是 Win10，不要用 Win7 镜像；请确认以管理员运行。
) else (
  echo 安装完成。请重新打开公司软件验证功能。
)
pause
exit /b %ERR%
