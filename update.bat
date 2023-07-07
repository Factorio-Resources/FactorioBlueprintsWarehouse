@echo off
chcp 65001
cd %~dp0

::初始化变量
set version=1.0

::日志输出
set LOG_PATH=.\update.log
dir>%LOG_PATH%
echo %date% %time% version:%version% >%LOG_PATH%
echo. >>%LOG_PATH%

::找git
if exist ".\MinGit\cmd\git.exe" (
set git_path=.\MinGit\cmd\git.exe
) else (
set git_path=git
)
echo [%time%][Information] git_path=%git_path%>>%LOG_PATH%

::测试git
%git_path% --version
if %errorlevel% NEQ 0 (
echo [错误] 无法找到git
echo [%time%][Error] 未找到git>>%LOG_PATH%
goto git_error
)

::检查.git/
if not exist ".git" (
echo [错误] 无法找到.git文件夹
echo [%time%][Error] 未找到.git文件夹>>%LOG_PATH%
goto git_error
)

::测试.git/
%git_path% rev-parse --is-inside-work-tree
if %errorlevel% NEQ 0 (
echo [错误] .git/已损坏 你可以尝试删除当前目录下隐藏的.git文件夹
echo [%time%][Error] .git/已损坏>>%LOG_PATH%
goto git_error
)

::update
set GIT_SSL_NO_VERIFY=true
%GIT_PATH% pull origin master --depth 1
if %errorlevel% NEQ 0 (
echo [错误] 更新失败,这一般是网络波动,请尝试重新启动.无效请尝试开加速器/挂梯子
echo [%time%][Error] %GIT_PATH% pull origin master --depth 1 >>%LOG_PATH%
goto git_error
) else (
echo [%time%][Information]  %GIT_PATH% pull origin master --depth 1 >>%LOG_PATH%
)

::压缩成蓝图书



::因为git导致的错误
:git_error
echo 更新因出现git相关的错误而终止
echo [%time%][Information] Exit>>%LOG_PATH%
pause
exit