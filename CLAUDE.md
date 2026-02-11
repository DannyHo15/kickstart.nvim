# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on kickstart.nvim, customized with additional plugins for AI-assisted development, LSP support, and enhanced editing experience. The configuration uses Lua and follows a modular structure under `lua/custom/plugins/`.

## Key Plugins & Their Purpose

- **blink.cmp** (`lua/custom/plugins/blink.lua`): Autocompletion engine using LuaSnip for snippets
- **avante.nvim** (`lua/custom/plugins/avante.lua`): AI assistant integration with support for multiple providers (Claude, Gemini, Copilot, OpenRouter, Mistral, etc.)
- **copilot.lua** (`lua/custom/plugins/copilot.lua`): GitHub Copilot integration with auto-triggered suggestions
- **mcphub.nvim** (`lua/custom/plugins/mcphub.lua`): MCP (Model Context Protocol) server hub for extending Avante with external tools
- **snacks.nvim** (`lua/custom/plugins/snacks.lua`): Terminal toggle (`<leader>tt`), image viewer, and other utilities
- **lazy.nvim**: Plugin manager (run `:Lazy` to manage plugins)

## Important Keymaps

| Keymap | Description |
|--------|-------------|
| `<leader>sf` | Search files (Telescope) |
| `<leader>sg` | Live grep (Telescope) |
| `<leader>sh` | Search help |
| `<C-b>` | Toggle Neo-tree file browser |
| `<leader>tt` | Toggle terminal (Snacks) |
| `<leader>tf` | Terminal in current file directory |
| `<leader>a+` / `<leader>a-` | Add/remove file in NvimTree for Avante |
| `<leader>ag` | Toggle Avante git commit prompt |
| `<leader>as` | Toggle Avante auto-suggestions |
| `<leader>f` | Format buffer (conform.nvim) |

## LSP Configuration

LSP servers are configured in `init.lua` (lines 842-983) using the modern `vim.lsp.config` API. Key servers:
- `ts_ls`: TypeScript/JavaScript with inlay hints enabled
- `gopls`: Go
- `pyright`: Python
- `solidity_ls`: Solidity with custom root patterns
- `lua_ls`: Lua with Neovim-specific workspace configuration
- `tailwindcss`: TailwindCSS with custom class regex for JSX/Svelte/Templ
- `eslint`: ESLint language server

Run `:Mason` to install/manage LSP servers and tools.

## Formatting

Formatters are configured via conform.nvim in `init.lua` (lines 1013-1067):
- Lua: `stylua`
- Go: `gofmt`, `gofumpt`
- TypeScript/JavaScript: `eslint_d`, `prettier`
- HTML/CSS/JSON/Markdown: `prettier`/`prettierd`
- Format on save is enabled (except for C/C++)

## AI Provider Setup (Avante)

Avante is configured to use `claude-code` as the default provider via the ACP protocol (`@zed-industries/claude-code-acp`). Additional providers include:
- `openrouter`: DeepSeek V3.2
- `claude`: Custom endpoint (z.ai API)
- `gemini`: Gemini 1.5 Pro
- `copilot`: GPT-4.1
- `mistral`: Mistral Large

Requires `ANTHROPIC_API_KEY` environment variable.

## MCP Integration

MCP servers are configured in `~/.config/nvim/mcpservers.json`. The hub runs on port 3333 and integrates with Avante for slash command generation. Auto-approval and auto-toggle are enabled.

## Common Commands

- `:Lazy` - Manage plugins (install, update, clean)
- `:Mason` - Manage LSP servers, formatters, linters
- `:checkhealth` - Check Neovim health
- `:Telescope` - Fuzzy finder interface
- `:ConformInfo` - Show formatter info
- `:Copilot panel` - Open Copilot suggestions panel
- `:Avante` - Open Avante AI assistant sidebar

## File Structure

```
├── init.lua                    # Main configuration file
├── lua/
│   ├── custom/
│   │   ├── keymaps.lua         # Custom keymaps (currently empty)
│   │   └── plugins/
│   │       ├── init.lua        # Plugin entry point
│   │       ├── avante.lua      # AI assistant config
│   │       ├── blink.lua       # Autocompletion
│   │       ├── copilot.lua     # GitHub Copilot
│   │       ├── mcphub.lua      # MCP server hub
│   │       ├── snacks.lua      # Terminal & utilities
│   │       └── *.lua           # Other plugin configs
│   └── kickstart/
│       └── plugins/            # Kickstart default plugins
└── CLAUDE.md                   # This file (read by Avante for context)
```

## Avante Behavior

- Mode: `agentic` (uses tools for code generation)
- Auto-suggestions: Disabled by default (toggle with `<leader>as`)
- Instructions file: `CLAUDE.md` (this file)
- Prompt logging: Enabled to `~/.cache/nvim/avante_prompts`
- Git commit prompt: Use `<leader>ag` to toggle commitizen-style commit message generation

## Development Notes

- Leader key: `<Space>`
- Relative line numbers: Enabled
- Swap files: Disabled
- Tab handling: 2 spaces, expandtab enabled
- Clipboard: Synced with system clipboard
- Nerd Font icons: Enabled
