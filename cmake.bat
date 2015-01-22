@echo off

title CMake�������ɹ���(V0.0.1) By QianChengLong

REM Ĭ��ѡ������
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
set /p choice=ѡ����Ŀ���ͣ�
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
set /p choice=ѡ���������ͣ�
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
echo �Ƿ�ɾ��ԭ�л��棨Ĭ�ϲ�ɾ������
set choice=
set /p choice=Y/N?
if "%choice%"=="" set choice=n
if "%choice%"=="y" (
    echo ��ʼ�������Ŀ¼�Ƿ����...
    if exist %BuildDir% (
        echo ����Ŀ¼���ڣ���ʼɾ��...
        rmdir /S /Q %BuildDir%
        if exist %BuildDir% (
            echo ɾ��ʧ��
            goto eof
        ) else (
            echo ɾ���ɹ�
        )
    ) else (
        echo ���治���ڣ�����ɾ��.
    )
)

echo �������Ŀ¼�Ƿ����...
if not exist %BuildDir%\ (
    echo ����Ŀ¼�����ڣ���ʼ����...
    mkdir %BuildDir%
)

cd %BuildDir%
echo ���뵽����Ŀ¼(%BuildDir%)

cls
echo ��ʼ������Ŀ�ļ�...
cmake -G %ProjectType% -DCMAKE_BUILD_TYPE=%BuildType% ..

if "%Build%" == "True" nmake

:eof
pause
exit
