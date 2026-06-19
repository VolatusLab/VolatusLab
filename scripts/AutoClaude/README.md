# 🤖 AutoClaude

Agendador de execuções do **Claude Code** via Agendador de Tarefas do Windows
(`schtasks`), apresentado no vídeo do YouTube **"Parei de Esperar o Reset do
Claude Code"**.

Permite programar a execução do Claude Code de duas formas:

- **[1] Horário Fixo** — execução diária em um horário definido (ex: `03:20`).
- **[2] Temporizador** — execução única daqui a X minutos (ex: `90` para 1h30).

Ao final, exibe um painel de auditoria com as tarefas agendadas.

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
