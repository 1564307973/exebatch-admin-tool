@echo off
chcp 936 >nul
setlocal enabledelayedexpansion

:: 检查是否以管理员身份运行
>nul 2>&1 ( net session )
if not "%errorlevel%"=="0" (
    echo 正在尝试申请管理员权限，请点击“是”授权...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "root=%~dp0"
set "regPath=HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

:: 获取 ANSI 转义码
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: 设置窗口标题
Title 批量设置或清除 EXE 管理员权限脚本

:main_menu
cls
echo %ESC%[1;32m╔════════════════════════════════════╗%ESC%[0m
call :center "★ 批量设置或清除 EXE 管理员权限脚本 ★"
echo %ESC%[1;32m╚════════════════════════════════════╝%ESC%[0m
echo.
echo 请选择操作：
echo %ESC%[1;36m───────────────────────────────────────────────%ESC%[0m
echo   %ESC%[1;32m[1]%ESC%[0m %ESC%[1;37m设置所有 EXE 以管理员身份运行%ESC%[0m
echo.
echo   %ESC%[1;32m[2]%ESC%[0m %ESC%[1;37m清除所有 EXE 的管理员权限设置（恢复默认）%ESC%[0m
echo.
echo   %ESC%[1;32m[3]%ESC%[0m %ESC%[1;37m查询所有 EXE 管理员权限状态%ESC%[0m
echo.
echo   %ESC%[1;31m[0] 退出脚本%ESC%[0m
echo %ESC%[1;36m───────────────────────────────────────────────%ESC%[0m
echo %ESC%[1;33m当前目标目录：%root%%ESC%[0m
echo.

set /p choice=请输入选项（0-3）： 
set choice=%choice:~0,1%
if /i "%choice%"=="0" goto :exit
if /i "%choice%"=="1" goto :set_admin
if /i "%choice%"=="2" goto :clear_admin
if /i "%choice%"=="3" goto :query_status

echo 输入错误，请输入 0、1、2 或 3。
pause
goto :main_menu

:set_admin
echo.
call :highlight "正在批量设置管理员权限..." "1;36"
set count=0
for /R "%root%" %%F in (*.exe) do (
    set "full=%%~fF"
    call :is_safe "!full!"
    if "!safe!"=="0" (
        echo %ESC%[1;30m[已跳过系统目录] !full!%ESC%[0m
        continue
    )
    set /a count+=1
    for %%A in ("%%F") do set "short=%%~sA"
    reg add "%regPath%" /v "!short!" /d "RUNASADMIN" /f >nul
    call :highlight "已设置管理员权限：!short!" "1;32"
)
if %count%==0 (
    echo 未找到任何有效 EXE 文件。
) else (
    echo.
    call :highlight "共设置 %count% 个 EXE 以管理员身份运行。" "1;32"
)
pause
goto :main_menu

:clear_admin
echo.
call :highlight "正在批量清除管理员权限设置..." "1;36"
set count=0
for /R "%root%" %%F in (*.exe) do (
    set "full=%%~fF"
    call :is_safe "!full!"
    if "!safe!"=="0" (
        echo %ESC%[1;30m[已跳过系统目录] !full!%ESC%[0m
        continue
    )
    set /a count+=1
    for %%A in ("%%F") do set "short=%%~sA"
    reg delete "%regPath%" /v "!short!" /f >nul 2>&1
    call :highlight "已清除管理员权限：!short!" "1;31"
)
if %count%==0 (
    echo 没有找到任何可清除的 EXE 文件。
) else (
    echo.
    call :highlight "共清除 %count% 个 EXE 的管理员权限设置。" "1;31"
)
pause
goto :main_menu

:query_status
echo.
call :highlight "正在查询 EXE 管理员权限状态..." "1;36"
set count=0
set admin_count=0
set normal_count=0
for /R "%root%" %%F in (*.exe) do (
    set "full=%%~fF"
    call :is_safe "!full!"
    if "!safe!"=="0" (
        echo %ESC%[1;30m[跳过系统目录] !full!%ESC%[0m
        continue
    )
    set /a count+=1
    for %%A in ("%%F") do set "short=%%~sA"
    reg query "%regPath%" /v "!short!" >nul 2>&1
    if !errorlevel! == 0 (
        call :highlight "[管理员] !short!" "1;32"
        set /a admin_count+=1
    ) else (
        call :highlight "[普通]   !short!" "0"
        set /a normal_count+=1
    )
)
echo.
call :highlight "共检测到 %count% 个 EXE 文件：" "1;36"
echo   以管理员身份运行：%admin_count%
echo   普通权限运行：%normal_count%
pause
goto :main_menu

:exit
call :highlight "感谢使用，再见！" "1;35"
pause
endlocal
exit /b

:: 居中显示函数
:center
setlocal EnableDelayedExpansion
set "str=%~1"
set "len=0"
for /l %%i in (12,-1,0) do (
    set /a "len|=1<<%%i"
    for %%j in (!len!) do if not "!str:~%%j,1!"=="" set /a "len+=1<<%%i"
)
set /a pad=(45-len)/2
set "spaces="
for /l %%i in (1,1,!pad!) do set "spaces=!spaces! "
echo.!ESC![1;36m!spaces!!str!!ESC![0m
endlocal & goto :eof

:: 高亮输出函数
:highlight
:: %1=文本 %2=颜色代码（如 1;32 绿色）
echo %ESC%[%~2m%~1%ESC%[0m
goto :eof

:: 判断是否为安全目录
:is_safe
setlocal
set "file=%~1"
set "safe=1"
set "file_lc=%file%"
call set "file_lc=%%file_lc:%SystemRoot%=%%"
call set "file_lc=%%file_lc:C:\Windows=%%"
call set "file_lc=%%file_lc:C:\Program Files=%%"
call set "file_lc=%%file_lc:C:\Program Files (x86)=%%"
call set "file_lc=%%file_lc:%USERPROFILE%\AppData=%%"
if not "%file%"=="%file_lc%" (
    endlocal & set "safe=0" & goto :eof
)
endlocal & set "safe=1" & goto :eof
