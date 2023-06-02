@echo off
chcp 65001 > nul
echo push_to_github.bat 启动...
setlocal

:: 获取当前系统时间
set "time=%TIME:~0,8%"
echo 当前时间：%time%

:: 获取当前系统日期
set "date=%DATE:~3%"
echo 当前日期：%date%

set "COMMIT_MSG=push_to_github.bat脚本自动提交 %date% %time%"

:: 这是远程仓库的别名/全地址
set "REPO_ADDR=note"

echo.
echo 开始添加暂存区...
git add .
IF ERRORLEVEL 1 (
    echo 添加失败！请检查是否有文件需要添加。
    pause
) ELSE (
    echo 添加成功！
)

echo.
echo 开始提交本地库...
git commit -m "%COMMIT_MSG%"
IF ERRORLEVEL 1 (
    echo 提交失败！请检查是否有更改需要提交。
    pause
) ELSE (
    echo 提交本地库成功！
)

echo.
echo 正在将本地仓库master分支推送到GitHub...
git push %REPO_ADDR% master
IF ERRORLEVEL 1 (
    echo 推送失败！请检查远程库是否存在，以及是否有推送权限。
    pause
    exit /b
)
echo 推送完成！
pause
