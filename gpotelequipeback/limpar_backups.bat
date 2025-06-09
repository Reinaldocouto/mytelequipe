@echo off
echo Apagando pastas _history e _recovery (inclusive ocultas)...

powershell -Command "Get-ChildItem -Recurse -Force -Directory | Where-Object { $_.Name -in @('__history', '__recovery') } | Remove-Item -Recurse -Force"

echo Concluído!
pause
