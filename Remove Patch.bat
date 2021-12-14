@echo off
cd /D "%~dp0"
powershell  -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ".\bin\Patcher.ps1 -RemovePatch"