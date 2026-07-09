# Cipher

The open source AI coding agent harness — forked from [opencode](https://github.com/anomalyco/opencode).

Terminal-native, provider-agnostic, with **329+ sub-agents** and **13 skill categories**.

---

## Quick Start (New System)

### Prerequisites

- [Bun](https://bun.sh) v1.3+ (`powershell -ExecutionPolicy Bypass -c "npm install -g bun"`)
- Git
- Node.js 22+

### Setup from Source

```bash
# 1. Clone
git clone https://github.com/srinath200888-create/Cipher.git
cd Cipher

# 2. Install deps (skip native modules that fail on Windows)
bun install --ignore-scripts
```

### Run in Dev Mode

```bash
cd packages/cipher
bun run dev
```

This launches the TUI (terminal UI). Type your prompt and hit Enter.

### Build Binary (optional)

```powershell
cd packages\cipher
bun run build
```

Then use `node bin\cipher` from that directory.

### Link Globally

```powershell
cd packages\cipher
npm link
# or
bun link
cipher --help
```

---

## Architecture

```
.cipher/
├── skills/              # 13 skill categories
│   ├── cli-coding-agents/
│   ├── ai-coding-tools/
│   ├── ai-ides-assistants/
│   ├── ai-models-providers/
│   ├── devops-cloud-ai/
│   ├── code-review-quality/
│   ├── database-backend-ai/
│   ├── frontend-ui-ai/
│   ├── security-testing-ai/
│   ├── local-privacy-ai/
│   ├── multi-agent-orchestration/
│   ├── vim-neovim-ai/
│   └── agent-skills-development/
├── agents/
│   ├── registry.json     # 329 agents across 20 categories
│   ├── hermes-agent.json
│   ├── claw-code.json
│   ├── aider.json
│   ├── cline.json
│   ├── openhands.json
│   ├── goose.json
│   ├── qwen-code.json
│   ├── deepseek-tui.json
│   ├── plandex.json
│   └── ... (37 total agent files)
└── cipher.jsonc          # Master config
```

### 3 Built-in Agents

| Agent | Description |
|-------|-------------|
| **build** | Full-access agent for development |
| **plan** | Read-only agent for analysis |
| **general** | Subagent for complex multi-step tasks |

---

## Skills (13 Categories)

| Skill | Covers |
|-------|--------|
| CLI Coding Agents | Aider, Codex, Claude Code, Gemini CLI, Hermes, ClawCode |
| AI Coding Tools | Cursor, Windsurf, Copilot, Continue, Cline |
| IDEs & Assistants | VS Code, JetBrains, Neovim, Zed, PearAI |
| Models & Providers | OpenAI, Anthropic, Google, DeepSeek, Qwen, Ollama |
| DevOps & Cloud | Pulumi, Datadog, Harness, Spacelift, AWS CDK |
| Code Review | CodeRabbit, Qodo, Sourcery, Semgrep, Codacy |
| Database & Backend | Supabase, Hasura, Drizzle, Prisma, PostgreSQL |
| Frontend & UI | v0.dev, Bolt.new, Lovable, Tailwind, GSAP |
| Security & Testing | Snyk, Playwright, Meticulous, OctoMind |
| Local & Privacy | Ollama, LM Studio, Twinny, Tabby, NanoCoder |
| Multi-Agent Orchestration | Claude Code Teams, OpenHands, Orca, Emdash |
| Vim/Neovim | Copilot.vim, opencode.nvim, AstrBot |
| Agent Skills Dev | MCP servers, Skill creation, Plugin architecture |

---

## Providers

Cipher supports **75+ LLM providers** including:

- OpenAI (GPT-4o, GPT-5)
- Anthropic (Claude Opus 4.5, Sonnet)
- Google (Gemini 2.5 Pro, Gemini 3 Pro)
- DeepSeek, Qwen, Mistral, xAI Grok
- Local via Ollama, LM Studio, llama.cpp

---

## Desktop

Double-click `Cipher.bat` on your desktop to see the logo.

---

## Learn More

- [Docs](https://opencode.ai/docs) (Cipher shares the opencode docs format)
- [GitHub](https://github.com/srinath200888-create/Cipher)

