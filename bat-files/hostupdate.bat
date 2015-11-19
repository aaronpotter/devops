@echo off

set "hostpath=%systemroot%\system32\drivers\etc"
set "hostfile=hosts"

set find=54.209.218.132


setlocal enabledelayedexpansion
:start
for /f "delims=" %%i in ('dig univision-web-2-1444712993.us-east-1.elb.amazonaws.com +nocomments +noquestion +noauthority +noadditional +nostats +short') do set replace=%%i

echo %replace%
attrib -r -s -h "%hostpath%\%hostfile%"
for /f "delims=" %%a in ('type "%hostpath%\%hostfile%"') do (
set "string=%%a"
set "string=!string:%find%=%replace%!"
>> "newfile.txt" echo !string!
)
move /y "newfile.txt" "%hostpath%\%hostfile%"
attrib +r  "%hostpath%\%hostfile%"

set find=%replace%
echo %find%
TIMEOUT /t 1
goto start
echo Done.
pause
