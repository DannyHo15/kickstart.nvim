return {
  'ravitemer/mcphub.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for async operations
  },
  build = 'npm install -g mcp-hub@latest', -- Installs core MCP Hub server
  config = function()
    require('mcphub').setup {
      -- Required configuration
      port = 3333, -- Default hub port
      config = vim.fn.expand '~/.config/nvim/mcpservers.json', -- Absolute path required

      -- Optional customization
      log = {
        level = vim.log.levels.WARN, -- DEBUG, INFO, WARN, ERROR
        to_file = true, -- Creates ~/.local/state/nvim/mcphub.log
      },
      on_ready = function()
        vim.notify 'MCP Hub is online!'
      end,
      auto_approve = true,
      auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        },
      },
    }
    -- Note: Avante setup is handled in lua/custom/plugins/avante.lua
    -- You can integrate MCP tools there if needed
  end,
}
