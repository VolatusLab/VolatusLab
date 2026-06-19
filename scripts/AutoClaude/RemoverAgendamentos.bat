@echo off
setlocal EnableDelayedExpansion
rem =========================================================
rem  RemoverAgendamentos.bat - Limpeza do AutoClaude
rem  Canal YouTube: "Parei de Esperar o Reset do Claude Code"
rem  Repositorio:   https://github.com/VolatusLab/VolatusLab
rem ---------------------------------------------------------
rem  Remove TODAS as tarefas criadas pelo AutoClaude, dos
rem  dois metodos (prefixo "ExecutarClaudePS"):
rem    - Metodo antigo (admin) : ExecutarClaudePS
rem    - Metodo novo (usuario) : ExecutarClaudePS_User*
rem                              ExecutarClaudePS_User_M<id>_<n>
rem  Pede elevacao (UAC) e confirmacao antes de excluir.
rem =========================================================

set "PADRAO=ExecutarClaudePS*"

rem --- Auto-elevacao: garante privilegios para remover tarefas de admin ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando privilegios de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cls
echo =========================================================
echo     REMOVER AGENDAMENTOS DO AUTOCLAUDE (VolatusLab)
echo =========================================================
echo.

rem --- Conta as tarefas alvo ---
set "TOTAL=0"
for /f %%N in ('powershell -NoProfile -Command "@(Get-ScheduledTask -TaskName '%PADRAO%' -ErrorAction SilentlyContinue).Count"') do set "TOTAL=%%N"

if "%TOTAL%"=="0" (
    echo [OK] Nenhum agendamento do AutoClaude foi encontrado.
    echo Nada a remover.
    echo.
    pause
    exit /b
)

echo Foram encontrados %TOTAL% agendamento(s) que serao REMOVIDOS:
echo ---------------------------------------------------------
powershell -NoProfile -Command "Get-ScheduledTask -TaskName '%PADRAO%' -ErrorAction SilentlyContinue | ForEach-Object { '   - ' + $_.TaskName }"
echo ---------------------------------------------------------
echo.

set /p CONFIRMA="Confirmar a REMOCAO de TODOS os %TOTAL% agendamentos? (S/N): "
if /i not "%CONFIRMA%"=="S" (
    echo.
    echo Operacao cancelada. Nenhuma tarefa foi removida.
    echo.
    pause
    exit /b
)

echo.
echo Removendo agendamentos...
powershell -NoProfile -Command "Get-ScheduledTask -TaskName '%PADRAO%' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false"

rem --- Reauditoria: confere quantas restaram ---
set "RESTANTES=0"
for /f %%N in ('powershell -NoProfile -Command "@(Get-ScheduledTask -TaskName '%PADRAO%' -ErrorAction SilentlyContinue).Count"') do set "RESTANTES=%%N"
set /a REMOVIDAS=%TOTAL%-%RESTANTES%

echo.
echo =========================================================
if "%RESTANTES%"=="0" (
    echo [SUCESSO] %REMOVIDAS% de %TOTAL% agendamentos removidos!
) else (
    echo [ATENCAO] %REMOVIDAS% removidos; %RESTANTES% ainda presentes.
    echo           Politicas do sistema podem ter bloqueado os demais.
)
echo =========================================================
echo.
pause
exit /b
