:: call build_all.bat
:: cmd /c build_all.bat
:: start build_all.bat

:: flutter clean
:: flutter pub get
:: flutter build web -t lib/20250118_resume-main.dart

:: NodeJS cmd
:: cd "C:\Users\tj\StudioProjects\first_flutter\build\web"
:: http-server

@echo off
:: Flutter 다트 파일 패턴별 빌드 스크립트

:: 빌드 대상 파일 패턴 설정
set PATTERN=20250118_resume-*.dart

:: 빌드할 파일 검색
for %%F in (lib\%PATTERN%) do (
    echo -------------------------------------
    echo Building %%F ...
    set "OUTPUT_DIR=build\web_%%~nF"
    flutter build web -t %%F --web-renderer html --output %%OUTPUT_DIR%
    echo Output saved to %%OUTPUT_DIR%
    echo -------------------------------------
)

echo All builds completed!
pause
