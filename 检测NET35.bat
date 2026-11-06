@echo off
chcp 65001 >nul
title 检测 .NET Framework 3.5
setlocal EnableExtensions
set "FAIL=0"

echo.
echo ========== .NET Framework 3.5 检测 ==========
echo.

:: 1) Windows 可选功能状态
echo [1] 可选功能 NetFx3
set "STATE="
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-WindowsOptionalFeature -Online -FeatureName NetFx3).State" 2^>nul`) do set "STATE=%%A"
if not defined STATE (
  echo     无法读取（可尝试以管理员运行）
  set "FAIL=1"
) else (
  echo     状态: %STATE%
  if /i not "%STATE%"=="Enabled" set "FAIL=1"
)

:: 2) 运行库文件
echo.
echo [2] 运行库文件
set "F32=%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll"
set "F64=%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\mscorlib.dll"
if exist "%F32%" (echo     x86 mscorlib.dll: 存在) else (echo     x86 mscorlib.dll: 缺失 & set "FAIL=1")
if exist "%F64%" (echo     x64 mscorlib.dll: 存在) else (echo     x64 mscorlib.dll: 缺失 & set "FAIL=1")

:: 3) 注册表安装标记
echo.
echo [3] 注册表 NDP\v3.5
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" /v Install 2>nul | findstr /i "0x1" >nul
if errorlevel 1 (
  echo     Install 标记异常或缺失
  set "FAIL=1"
) else (
  echo     Install = 1  （正常）
)

:: 4) 能否加载 CLR 2.0
echo.
echo [4] CLR 可用性
powershell -NoProfile -Command "try { [void][Reflection.Assembly]::Load('mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'); Write-Host '     可加载 mscorlib 2.0'; exit 0 } catch { Write-Host ('     加载失败: ' + $_.Exception.Message); exit 1 }"
if errorlevel 1 set "FAIL=1"

echo.
echo ============================================
if "%FAIL%"=="0" (
  color 0A
  echo 结果: 正常
  echo .NET Framework 3.5 已启用，公司软件相关功能应可用。
) else (
  color 0C
  echo 结果: 异常
  echo 未正确安装。请右键「离线安装.bat」→ 以管理员身份运行，装完再测一次。
)
echo ============================================
echo.
pause
exit /b %FAIL%
