# 🤖 AutoClaude

Agendador de execuções do **Claude Code** via Agendador de Tarefas do Windows
(`schtasks`), apresentado no vídeo do YouTube **"Parei de Esperar o Reset do
Claude Code"**.

Permite programar a execução do Claude Code de três formas:

- **[1] Horário Fixo** — execução diária em um horário definido (ex: `03:20`).
- **[2] Temporizador** — execução única daqui a X minutos (ex: `90` para 1h30).
- **[3] Múltiplos** — várias execuções **a cada 5h01min**, durante uma janela
  de X dias. O `+1 minuto` por ciclo evita esbarrar no limite de reset.

Ao final, exibe um painel de auditoria com as tarefas agendadas.

### 🔁 Modo Múltiplos (Opção 3)

1. Informe por **quantos dias** os agendamentos devem cobrir.
2. Defina o **primeiro disparo**:
   - **[A]** Horário fixo (`HH:mm`) — se já tiver passado hoje, começa amanhã; ou
   - **[B]** Daqui a X minutos.
3. O script gera a grade completa (a cada 5h01min até o fim da janela), mostra
   um resumo com o total de tarefas e o primeiro disparo, e pede confirmação
   antes de criar.

As tarefas recebem nomes como `ExecutarClaudePS_User_M<id>_<n>` e aparecem
normalmente no painel de auditoria.

### ⏰ Despertador (acorda o PC da suspensão)

Todas as tarefas criadas (em qualquer modo) são configuradas para **acordar o
computador da suspensão** no horário agendado, e também para **rodar na
bateria**:

- `WakeToRun = true` (acordar o PC para executar);
- `DisallowStartIfOnBatteries = false` e `StopIfGoingOnBatteries = false`.

O script ainda tenta habilitar **"Permitir despertadores"** no plano de energia
ativo (via `powercfg`), pois no Windows 11 o padrão costuma ser *"Somente
despertadores importantes"*, o que bloquearia o disparo. Se esse ajuste exigir
privilégios e falhar, o script exibe um aviso com o caminho para ativar
manualmente.

> Observação: o despertador funciona a partir da suspensão (S3/Modern Standby).
> Em **hibernação** ou com o PC **desligado**, o Windows não dispara a tarefa.

### ⚙️ Antes de usar

Abra o arquivo e ajuste a variável `DIRETORIO_ALVO` para a pasta do **seu**
projeto. O valor padrão é apenas um exemplo:

```bat
set "DIRETORIO_ALVO=C:\Caminho\Para\Seu\Projeto"
```

### ▶️ Como executar

1. Baixe o arquivo `AutoClaude.bat`.
2. Dê um duplo clique (ou execute pelo terminal).
3. Escolha o modo (`1` ou `2`) e siga as instruções na tela.

> Requisitos: Windows com `claude` (Claude Code) instalado e acessível no PATH.
