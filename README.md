# Logia Agent V5 — Gemini CLI Edition

Hybrid AI Business Analyst agent: **Antigravity** (BA skills) + **Gemini CLI** (CC execution).

## Quick Start

1. Clone this repo
2. Open the root directory in **Google Antigravity**
3. Tell the agent what you want to build
4. BA skills guide you through discovery, elicitation, design
5. CC skills (via Gemini CLI) handle prototype, proposal, and implementation

## Architecture

```
Antigravity (BA side)                  Gemini CLI (CC side)
  .agent/skills/ba-*/SKILL.md           project-template/.gemini/
  22 native tools (no MCP)              skills/ + agents/ + hooks/
  Conversation + JSON outputs            Autonomous execution
         |                                      ^
         +--- trigger-gemini-runner.ps1 --------+
```

## Directory Structure

```
Logia-Agent-v5-Gemini-cli/
├── .agent/                     <- BA skills (Antigravity auto-loads)
│   ├── skills/ba-*/SKILL.md       11 BA phase skills
│   └── rules/ba-rules.md         BA behavior rules
├── project-template/           <- CC setup (copied per project)
│   ├── .gemini/                   skills, agents, hooks, settings
│   ├── GEMINI.md                  CC-side rules
│   ├── .ba/                       BA output directories (skeleton)
│   └── prototype/                 Prototype output directory
├── scripts/                    <- Shared utilities
│   └── trigger-gemini-runner.ps1  Launch Gemini CLI from Antigravity
├── projects/                   <- User projects (runtime, gitignored)
├── active-project.json         <- Current project pointer (gitignored)
└── .gitignore
```

## How It Works

1. **ba-init** creates `projects/{name}/` by copying `project-template/`
2. BA skills write JSON outputs to `projects/{name}/.ba/`
3. When CC execution is needed, BA writes a trigger and launches Gemini CLI
4. Gemini CLI reads `.gemini/` config and executes the appropriate skill
5. **ba-resume** reads `active-project.json` to continue where you left off

## Migration Status

| Component | Status | Lines |
|-----------|--------|-------|
| BA Skills (11 Antigravity skills) | **Ready** | 4,203 |
| Infrastructure (GEMINI.md, rules, hooks, settings) | **Ready** | 957 |
| CC Prototype skill + 6 HTML patterns | **Ready** | 2,989 |
| CC Proposal skill + 6 agents | Placeholder | — |
| CC Foundation Builder skill + 4 agents | Placeholder | — |
| CC Implementation skill + 2 agents | Placeholder | — |

**BA side is fully functional.** CC prototype skill is ready. Proposal, foundation-builder, and implementation skills are placeholders pending migration.

## Requirements

- [Google Antigravity](https://idx.google.com/) (BA side)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) (CC side)
- PowerShell 5.1+ (trigger script)
- Windows Terminal (`wt`) recommended
