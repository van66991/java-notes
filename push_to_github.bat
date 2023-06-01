@echo off
chcp 65001 > nul
echo 正在将本地仓库推送到GitHub...
setlocal
set TIMESTAMP=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
set COMMIT_MSG="push_to_github.bat脚本自动提交 %TIMESTAMP%"
git add .
IF ERRORLEVEL 1 (
    echo 添加文件失败！请检查是否有文件需要添加。
    pause
    exit /b
)
git commit -m %COMMIT_MSG%
IF ERRORLEVEL 1 (
    echo 提交失败！请检查是否有更改需要提交。
    pause
    exit /b
)
git push git@github.com:van66991/java-notes.git master
IF ERRORLEVEL 1 (
    echo 推送失败！请检查远程库是否存在，以及是否有推送权限。
    pause
    exit /b
)
echo 推送完成！
pause