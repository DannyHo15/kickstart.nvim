-- Autocompletion using blink.cmp
return {
  'saghen/blink.cmp',
  version = '*',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet.body)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').session.in_direction(filter.direction) > 0
        else
          return require('luasnip').session and require('luasnip').session.current() ~= nil
        end
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
  },
  opts_extend = { 'sources.default' },
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      config = function()
        require('luasnip').setup {
          history = true,
          delete_check_events = { 'TextChanged', 'InsertLeave' },
        }
      end,
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
  },
}
