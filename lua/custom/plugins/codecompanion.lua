vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd [[cab cc CodeCompanion]]
return {
  'olimorris/codecompanion.nvim',
  opts = {
    strategies = {
      show_model_choices = true,
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = 'ga' },
            description = 'Accept the suggested change',
          },
          reject_change = {
            modes = { n = 'gr' },
            description = 'Reject the suggested change',
          },
        },
      },
      chat = {
        adapter = 'copilot',
        model = 'claude-sonnet-4-20250514',
        keymaps = {
          send = {
            modes = { n = '<C-s>', i = '<C-s>' },
            opts = {},
          },
          close = {
            modes = { n = '<C-c>', i = '<C-c>' },
            opts = {},
          },
        },
      },
    },
    log_level = 'DEBUG',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
  },
  config = function(_, opts)
    require('codecompanion').setup {
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      prompt_library = {
        ['Docusaurus'] = {
          strategy = 'chat',
          description = 'Write documentation for me',
          opts = {
            index = 11,
            is_slash_cmd = false,
            auto_submit = false,
            short_name = 'docs',
          },
          references = {
            {
              type = 'file',
              path = {
                'doc/.vitepress/config.mjs',
                'lua/codecompanion/config.lua',
                'README.md',
              },
            },
          },
          prompts = {
            {
              role = 'user',
              content = [[I'm rewriting the documentation for my plugin CodeCompanion.nvim, as I'm moving to a vitepress website. Can you help me rewrite it?

I'm sharing my vitepress config file so you have the context of how the documentation website is structured in the `sidebar` section of that file.

I'm also sharing my `config.lua` file which I'm mapping to the `configuration` section of the sidebar.
]],
            },
          },
        },
      },
      strategies = {
        inline = {
          layout = 'vertical',
          keymaps = {
            accept_change = {
              modes = { n = 'ga' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = 'gr' },
              description = 'Reject the suggested change',
            },
          },
        },
      },
      display = {
        chat = {
          icons = {
            buffer_pin = ' ',
            buffer_watch = '👀 ',
          },
          opts = {
            goto_file_action = 'tabnew',
          },
          debug_window = {
            width = vim.o.columns - 5,
            height = vim.o.lines - 2,
          },
          intro_message = 'Welcome to CodeCompanion ✨! Press ? for options',
          show_header_separator = false,
          separator = '─',
          show_references = true,
          show_settings = false,
          show_token_count = true,
          start_in_insert_mode = false,
          window = {
            layout = 'vertical',
            position = nil,
            border = 'single',
            height = 0.8,
            width = 0.45,
            relative = 'editor',
            full_height = true,
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = '0',
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = 'no',
              spell = false,
              wrap = true,
            },
          },
          diff = {
            enabled = true,
            close_chat_at = 240,
            layout = 'vertical',
            opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
            provider = 'default',
          },
          token_count = function(tokens, adapter)
            return ' (' .. tokens .. ' tokens)'
          end,
        },
      },
    }
  end,
}
