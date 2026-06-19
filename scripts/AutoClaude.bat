@echo off
rem =========================================================
rem  AutoClaude.bat - Agendador de execucoes do Claude Code
rem  Canal YouTube: "Parei de Esperar o Reset do Claude Code"
rem  Repositorio:   https://github.com/VolatusLab/VolatusLab
rem ---------------------------------------------------------
rem  IMPORTANTE: ajuste a variavel DIRETORIO_ALVO abaixo para
rem  a pasta do SEU projeto antes de executar. O valor padrao
rem  e apenas um exemplo e provavelmente NAO existe no seu PC.
rem =========================================================
set "DIRETORIO_ALVO=C:\VolatusLab\central-security-main"

echo =========================================================
echo    MOTOR DE AGENDAMENTO DE TAREFAS (MODO USUARIO)
echo =========================================================
echo [1] Horario Fixo   (Ex: Execucao diaria as 03:20)
echo [2] Temporizador   (Ex: Execucao unica daqui a 90 minutos)
echo =========================================================
set /p MODO="Selecione o modo operacional (1 ou 2): "

if "%MODO%"=="1" goto MODO_FIXO
if "%MODO%"=="2" goto MODO_TEMP

echo [ERRO] Modo invalido. A operacao sera cancelada.
pause
exit /b

:MODO_FIXO
set /p HORA_EXECUCAO="Informe o horario alvo (formato HH:mm): "
set "PARAMETROS_SCHTASKS=/sc daily /st %HORA_EXECUCAO%"
echo.
echo Configuracao: Execucao diaria as %HORA_EXECUCAO%.
goto DEFINIR_NOME

:MODO_TEMP
set /p MINUTOS="Informe o tempo de espera em minutos (Ex: 90 para 1h30): "
for /f "tokens=1,2" %%A in ('powershell -NoProfile -Command "$t = (Get-Date).AddMinutes(%MINUTOS%); Write-Output ($t.ToString('HH:mm') + ' ' + $t.ToString('dd/MM/yyyy'))"') do (
    set "HORA_EXECUCAO=%%A"
    set "DATA_EXECUCAO=%%B"
)
set "PARAMETROS_SCHTASKS=/sc once /st %HORA_EXECUCAO% /sd %DATA_EXECUCAO%"
echo.
echo Configuracao: Execucao unica programada para as %HORA_EXECUCAO% do dia %DATA_EXECUCAO%.
goto DEFINIR_NOME

:DEFINIR_NOME
set "NOME_BASE=ExecutarClaudePS_User"
set "NOME_TAREFA=%NOME_BASE%"
set /a CONTADOR=1

:LOOP_VERIFICA_NOME
schtasks /query /tn "%NOME_TAREFA%" >nul 2>&1
if %errorLevel% equ 0 (
    set /a CONTADOR+=1
    set "NOME_TAREFA=%NOME_BASE%%CONTADOR%"
    goto LOOP_VERIFICA_NOME
)
goto EXECUCAO

:EXECUCAO
echo.
echo Provisionando tarefa [%NOME_TAREFA%] no sistema (Contexto de Usuario)...
schtasks /create /tn "%NOME_TAREFA%" /tr "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command \"Set-Location -Path '%DIRETORIO_ALVO%'; cmd.exe /c claude\"" %PARAMETROS_SCHTASKS% /f

if %errorLevel% equ 0 (
    echo.
    echo [SUCESSO] Tarefa %NOME_TAREFA% agendada!
    echo.
    echo Iniciando painel de auditoria...
    timeout /t 2 >nul
    goto AUDITORIA
) else (
    echo.
    echo [ERRO] Falha na criacao. Politicas do sistema podem estar bloqueando agendamentos por usuarios padrao.
    pause
    exit /b
)

:AUDITORIA
cls
echo =========================================================
echo        AUDITORIA DE TAREFAS AGENDADAS (VolatusLab)
echo =========================================================
echo.

echo [1] VERIFICANDO MODO ADMINISTRADOR (ExecutarClaudePS)
echo ---------------------------------------------------------
schtasks /query /tn "ExecutarClaudePS" 2>nul
if %errorLevel% neq 0 (
    echo [Nao encontrada] Nenhuma tarefa ativa neste escopo.
)

echo.
echo.
echo [2] VERIFICANDO MODO USUARIO (Multiplas Tarefas)
echo ---------------------------------------------------------
set "TAREFA_USUARIO_ENCONTRADA=0"

:: Solicita a tabela completa e filtra as linhas que contem a raiz do nome
for /f "delims=" %%A in ('schtasks /query /fo table ^| findstr /C:"ExecutarClaudePS_User"') do (
    echo %%A
    set "TAREFA_USUARIO_ENCONTRADA=1"
)

if "%TAREFA_USUARIO_ENCONTRADA%"=="0" (
    echo [Nao encontrada] Nenhuma tarefa ativa neste escopo.
)

echo.
echo =========================================================
pause
