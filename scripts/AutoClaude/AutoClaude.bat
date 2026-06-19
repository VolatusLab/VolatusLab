@echo off
setlocal EnableDelayedExpansion
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

rem Comando que cada tarefa executara (Claude Code na pasta alvo).
set "COMANDO_CLAUDE=powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command \"Set-Location -Path '%DIRETORIO_ALVO%'; cmd.exe /c claude\""

echo =========================================================
echo    MOTOR DE AGENDAMENTO DE TAREFAS (MODO USUARIO)
echo =========================================================
echo [1] Horario Fixo   (Ex: Execucao diaria as 03:20)
echo [2] Temporizador   (Ex: Execucao unica daqui a 90 minutos)
echo [3] Multiplos      (Ex: A cada 5h01min, durante X dias)
echo =========================================================
set /p MODO="Selecione o modo operacional (1, 2 ou 3): "

if "%MODO%"=="1" goto MODO_FIXO
if "%MODO%"=="2" goto MODO_TEMP
if "%MODO%"=="3" goto MODO_MULTI

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
schtasks /create /tn "%NOME_TAREFA%" /tr "%COMANDO_CLAUDE%" %PARAMETROS_SCHTASKS% /f

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

:MODO_MULTI
rem ---------------------------------------------------------
rem  MULTIPLOS AGENDAMENTOS
rem  Cria varias tarefas "once", a cada 5h01min (301 min),
rem  comecando no horario definido pelo usuario, ao longo de
rem  uma janela de N dias. O +1 minuto evita esbarrar no
rem  limite de reset entre execucoes.
rem ---------------------------------------------------------
echo.
set /p DIAS="Por quantos DIAS deseja manter os agendamentos? "
echo.
echo Como deseja definir o PRIMEIRO horario?
echo   [A] Horario fixo (formato HH:mm)
echo   [B] Daqui a X minutos
set /p SUBMODO="Selecione (A ou B): "

set "GERADOR="
if /i "%SUBMODO%"=="A" (
    set /p INICIO="Informe o horario de inicio (HH:mm): "
    set "GERADOR=$p=('!INICIO!').Split(':'); $b=(Get-Date).Date.AddHours([int]$p[0]).AddMinutes([int]$p[1]); if($b -le (Get-Date)){$b=$b.AddDays(1)}"
) else if /i "%SUBMODO%"=="B" (
    set /p ATRASO="Daqui a quantos minutos comeca o primeiro disparo? "
    set "GERADOR=$b=(Get-Date).AddMinutes(!ATRASO!)"
) else (
    echo [ERRO] Opcao invalida. A operacao sera cancelada.
    pause
    exit /b
)

rem Gera a grade de horarios (uma linha "HH:mm dd/MM/yyyy" por ocorrencia).
set "TMP_SCHED=%TEMP%\autoclaude_sched_%RANDOM%%RANDOM%.txt"
powershell -NoProfile -Command "!GERADOR!; $e=$b.AddDays(%DIAS%); while($b -lt $e){ $b.ToString('HH:mm dd/MM/yyyy'); $b=$b.AddMinutes(301) }" > "!TMP_SCHED!"

set "TOTAL_PREV=0"
for /f %%C in ('type "!TMP_SCHED!" ^| find /c /v ""') do set "TOTAL_PREV=%%C"

set "PRIMEIRO="
set /p PRIMEIRO=<"!TMP_SCHED!"

if "%TOTAL_PREV%"=="0" (
    echo [ERRO] Nenhum horario gerado. Verifique os valores informados.
    del "!TMP_SCHED!" >nul 2>&1
    pause
    exit /b
)

echo.
echo ---------------------------------------------------------
echo  Resumo do agendamento multiplo:
echo  - Total de tarefas : %TOTAL_PREV%
echo  - Intervalo        : a cada 5h01min (301 min)
echo  - Primeiro disparo : !PRIMEIRO!
echo  - Janela total     : %DIAS% dia(s)
echo ---------------------------------------------------------
set /p CONFIRMA="Confirmar a criacao das %TOTAL_PREV% tarefas? (S/N): "
if /i not "%CONFIRMA%"=="S" (
    echo Operacao cancelada pelo usuario.
    del "!TMP_SCHED!" >nul 2>&1
    pause
    exit /b
)

set "STAMP=%RANDOM%%RANDOM%"
set /a TOTAL=0
set /a OK=0
echo.
echo Provisionando tarefas (Contexto de Usuario)...
for /f "usebackq tokens=1,2 delims= " %%A in ("!TMP_SCHED!") do (
    set /a TOTAL+=1
    set "NOME_TAREFA=ExecutarClaudePS_User_M!STAMP!_!TOTAL!"
    schtasks /create /tn "!NOME_TAREFA!" /tr "%COMANDO_CLAUDE%" /sc once /st %%A /sd %%B /f >nul 2>&1
    if !errorLevel! equ 0 (
        set /a OK+=1
    ) else (
        echo [FALHA] Ocorrencia !TOTAL! ^(%%A %%B^)
    )
)
del "!TMP_SCHED!" >nul 2>&1

echo.
if !OK! equ !TOTAL! (
    echo [SUCESSO] !OK! de !TOTAL! tarefas agendadas!
) else (
    echo [ATENCAO] !OK! de !TOTAL! tarefas agendadas. Politicas do sistema podem ter bloqueado as demais.
)
echo.
echo Iniciando painel de auditoria...
timeout /t 2 >nul
goto AUDITORIA

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

if "!TAREFA_USUARIO_ENCONTRADA!"=="0" (
    echo [Nao encontrada] Nenhuma tarefa ativa neste escopo.
)

echo.
echo =========================================================
pause
