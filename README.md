<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f172a,50:1e293b,100:020617&height=200&section=header&text=VolatusLab&fontSize=48&fontColor=ffffff&fontAlignY=38&desc=Ecosystem%20Architecture%20%7C%20AI-Native%20Development%20%7C%20OSINT&descSize=16&descAlignY=58&descColor=94a3b8" width="100%"/>

<a href="https://git.io/typing-svg">
  <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=20&pause=1000&color=94A3B8&center=true&vCenter=true&width=700&lines=Building+the+VolatusLab+software+ecosystem.;OSINT+%26+Public+Safety+intelligence.;AI-Native+development+and+automation.;Bitcoin,+Utilities+%26+Drone+Imaging." alt="Typing SVG" />
</a>

<br/>

</div>

---

## :: Mission Control

O **VolatusLab** é um ecossistema de software focado em aplicações AI-native, inteligência policial (OSINT) e ferramentas de utilidade pública e financeira. A arquitetura dos projetos prioriza o desenvolvimento de agentes autônomos, plataformas táticas (offline-first) e sistemas escaláveis de alta performance, projetados e mantidos por [Leandro Moreira](https://github.com/leandro-moreira).

---

## :: Repository Map

A topologia atual do ecossistema e a divisão estrutural dos repositórios:

```text
VolatusLab
├── Intelligence & OSINT
│   ├── mike-papa        (BNMP / Monitoramento de Mandados)
│   ├── codice-intel     (Plataforma de Inteligência)
│   ├── Wanted           (Frontend Público de Mandados)
│   └── DataJudAi        (Exploração de Dados Judiciais)
│
├── Public Safety
│   ├── desbrava-rural   (PWA Offline-First p/ Patrulha Rural)
│   ├── projeto-violeta  (Núcleo Aprova CHOA)
│   └── SubsidioPMTO     (Calculadora Legislativa PMTO)
│
├── Bitcoin & Finance
│   ├── BitcoinHome      (Carteira Web)
│   ├── VolatusMonitor   (Cotações Fiat/Cripto)
│   └── Bitcoin          (Gerador de Entropia)
│
├── Utilities
│   ├── prompts          (Coleção de Prompts Validados)
│   ├── matadata         (Visualizador de Metadados)
│   └── img2pdf          (Conversor de Imagens)
│
└── AI & Experiments
    ├── QTC-IN           (Laboratório OSINT)
    ├── P8               (Projeto Seção do Pracinha)
    └── Volatus-Media    (Drone Imaging & Computer Vision)

```

---

## :: Core Ecosystem

### Intelligence & Public Safety

Soluções de arquitetura tática voltadas para segurança pública, extração de dados e operação em ambientes restritos.

* **Mike Papa:** Motor de busca e análise de mandados com rotinas em workers, Supabase e Prisma.
* **Desbrava Rural:** Aplicação móvel PWA desenhada com arquitetura *offline-first* para garantir operação em zonas de sombra de conectividade.
* **DataJudAi & Wanted:** Exploração e visualização pública de mandados e dados judiciais via APIs.
* **Aprova CHOA & Subsidio:** Ferramentas utilitárias para a PMTO, incluindo simulações de remuneração legislativa.

### Bitcoin, Utilities & Media

Ferramentas descentralizadas, produtividade para desenvolvedores e mídia imersiva.

* **Volatus Media:** Vertente focada em *Drone Imaging, Computer Vision* e *Media*.
* **Bitcoin & Finance:** Infraestrutura leve para acompanhamento do mercado (VolatusMonitor) e operações seguras (BitcoinHome e geradores de entropia).
* **AI Prompts:** Coleção pública de prompts (`prompts`) operacionalizados e validados para integração com LLMs.
* **Ferramentas:** Utilitários de uso rápido como `matadata` e `img2pdf`.

---

## :: Stack Tecnológica

### Core & Backend

### Frontend & Mobile

### Dados & Infraestrutura

### Modelos & IA

---
