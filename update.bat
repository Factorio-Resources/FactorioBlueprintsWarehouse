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
.\blueprint_conversion_app\main.exe
echo [%time%][Information].\blueprint_conversion_app\main.exe >>%LOG_PATH%
if %errorlevel% == 1 (
echo [错误] 没有找到打包的文件夹 请尝试重新启动
goto dump_error
)
if %errorlevel% == 2 (
echo [错误] 在打包蓝图时出现错误 请发送update.log文件向我们进行反馈
goto dump_error
)
if %errorlevel% == 3 (
echo [错误] 在转换为蓝图书字符串时出现了错误
goto dump_error
)
if %errorlevel% == 4 (
echo [错误] 保存蓝图字符串的时候出现错误
goto dump_error
)
if %errorlevel% NEQ 0 (
echo [错误] 未知错误
goto dump_error
)
goto end

:end
echo "蓝图更新完成,已经将蓝图字符串复制到你的剪切板中.现在可以在游戏内导入更新后的蓝图书"
echo 蓝图字符串已经在packagedBlueprintBook.txt中 也可以从那里复制
echo 现在可以安全的按任意键或直接关闭此窗口
echo [%time%][Information] Exit>>%LOG_PATH%
pause
exit

:dump_error
echo 更新因打包蓝图文件夹为蓝图书时发生错误而终止
echo [%time%][Information] Exit>>%LOG_PATH%
pause
exit

::因为git导致的错误
:git_error
echo 更新因出现git相关的错误而终止
echo [%time%][Information] Exit>>%LOG_PATH%
pause
exit