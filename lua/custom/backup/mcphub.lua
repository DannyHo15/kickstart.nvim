return {
  'ravitemer/mcphub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for async operations
  },
  build = 'npm install -g mcp-hub@latest', -- Installs core MCP Hub server
  config = function()
    require('mcphub').setup {
      -- Required configuration
      port = 3000, -- Default hub port
      config = vim.fn.expand '~/.config/nvim/mcpservers.json', -- Absolute path required

      -- Optional customization
      log = {
        level = vim.log.levels.WARN, -- DEBUG, INFO, WARN, ERROR
        to_file = true, -- Creates ~/.local/state/nvim/mcphub.log
      },
      on_ready = function()
        vim.notify 'MCP Hub is online!'
      end,
    }
    require('avante').setup {
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      custom_tools = {
        require('mcphub.extensions.avante').mcp_tool(),
      },
    }
  end,
}
