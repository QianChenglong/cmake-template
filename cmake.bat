@echo off

title CMake工程生成工具(V0.0.1) By QianChengLong

REM 默认选项配置
set default_project_type=1


call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat"
cls

:ProjectChooseMenu
cls
echo ===============================================================================
echo 1) VS2010
echo 2) VS2012
echo 3) NMake
echo.
echo 9) Exit
echo.
set choice=
set /p choice=选择项目类型：
if "%choice%"=="" set choice=%default_project_type%
if "%choice%"=="1" (
    set ProjectType="Visual Studio 10"
    set BuildDir="build(VS2010)"
) else if "%choice%"=="2" (
    set ProjectType="Visual Studio 11"
    set BuildDir="build(VS2012)"
) else if "%choice%"=="3" (
    set ProjectType="NMake Makefiles"
    set BuildDir="build(NMake)"
    set Build=True
) else if "%choice%"=="9" (
    exit
) else (
    goto ProjectChooseMenu
)
rem echo %ProjectType%
echo ===============================================================================

:DebugOrRelease
echo ===============================================================================
echo 1) Debug(Default)
echo 2) Release
echo.
echo 9) Exit
echo.
set choice=
set /p choice=选择生成类型：
if "%choice%"=="1" (
    set BuildType=Debug
) else if "%choice%"=="" (
    set BuildType=Debug
) else if "%choice%"=="2" (
    set BuildType=Release
) else if "%choice%"=="9" (
    exit
) else (
    goto DebugOrRelease
)
rem echo %BuildType%

echo ===============================================================================
echo 是否删除原有缓存（默认不删除）？
set choice=
set /p choice=Y/N?
if "%choice%"=="" set choice=n
if "%choice%"=="y" (
    echo 开始检测生成目录是否存在...
    if exist %BuildDir% (
        echo 生成目录存在，开始删除...
        rmdir /S /Q %BuildDir%
        if exist %BuildDir% (
            echo 删除失败
            goto eof
        ) else (
            echo 删除成功
        )
    ) else (
        echo 缓存不存在，无需删除.
    )
)

echo 检测生成目录是否存在...
if not exist %BuildDir%\ (
    echo 生成目录不存在，开始生成...
    mkdir %BuildDir%
)

cd %BuildDir%
echo 进入到生成目录(%BuildDir%)

cls
echo 开始生成项目文件...
cmake -G %ProjectType% -DCMAKE_BUILD_TYPE=%BuildType% ..

if "%Build%" == "True" nmake

:eof
pause
exit
