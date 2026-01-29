vim.api.nvim_create_autocmd('User', {
  pattern = 'ToggleGitCommitPrompt',
  callback = function()
    require('avante.config').override {
      system_prompt = 'Create a commit message for the staged changes following the commitizen convention. Ensure the title is concise (max 50 characters), and the message is wrapped at 72 characters. Format the entire message in a code block with language set to `gitcommit`.',
    }
  end,
})

vim.keymap.set('n', '<leader>ag', function()
  vim.api.nvim_exec_autocmds('User', { pattern = 'ToggleGitCommitPrompt' })
end, { desc = 'avante: toggle my prompt' })

-- Toggle auto suggestions
vim.keymap.set('n', '<leader>as', function()
  local current = require('avante.config').get().behavior.auto_suggestions
  require('avante.config').override {
    behavior = {
      auto_suggestions = not current,
    },
  }
  vim.notify('Auto-suggestions: ' .. (not current and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'avante: toggle auto suggestions' })
return {
  'yetone/avante.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
      keys = {
        -- suggested keymap
        { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  system_prompt = function()
    local hub = require('mcphub').get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ''
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require('mcphub.extensions.avante').mcp_tool(),
    }
  end,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy', -- Load sau khi UI đã sẵn sàng
  lazy = true, -- Chỉ load khi cần
  version = false, -- use latest stable release
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    ---@alias Mode "agentic" | "legacy"
    ---@type Mode
    mode = 'agentic', -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
    -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
    -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
    -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
    auto_suggestions_provider = 'copilot',
    instructions_file = 'CLAUDE.md',
    provider = 'claude-code',
    acp_providers = {
      ['gemini-cli'] = {
        command = 'gemini',
        args = { '--experimental-acp' },
        env = {
          NODE_NO_WARNINGS = '1',
          GEMINI_API_KEY = os.getenv 'GEMINI_API_KEY',
        },
      },
      ['claude-code'] = {
        command = 'npx',
        args = { '@zed-industries/claude-code-acp' },
        env = {
          NODE_NO_WARNINGS = '1',
          ANTHROPIC_API_KEY = os.getenv 'ANTHROPIC_API_KEY',
        },
      },
    },
    providers = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'deepseek/deepseek-v3.2',
        env = {
          OPENROUTER_API_KEY = os.getenv 'OPENROUTER_API_KEY',
        },
      },
      claude = {
        endpoint = 'https://api.z.ai/api/anthropic',
        api_key_name = 'ANTHROPIC_API_KEY',
        model = 'glm-4.7',
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
      gemini = {
        api_key_name = 'GEMINI_API_KEY',
        model = 'gemini-1.5-pro',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          maxOutputTokens = 8192,
        },
      },
      copilot = {
        model = 'gpt-4.1-2025-04-14',
        auto_select_model = true,
      },
      morph = {
        model = 'morph-v3-large',
      },
      mistral = {
        __inherited_from = 'openai',
        api_key_name = 'MISTRAL_API_KEY',
        endpoint = 'https://api.mistral.ai/v1/',
        model = 'mistral-large-latest',
        extra_request_body = {
          max_tokens = 4096, -- to avoid using max_completion_tokens
        },
      },
      -- claude = {
      --   endpoint = 'https://api.anthropic.com',
      --   model = 'claude-sonnet-4-20250514',
      --   timeout = 30000, -- Timeout in milliseconds
      --   extra_request_body = {
      --     temperature = 0.75,
      --     max_tokens = 20480,
      --   },
      -- },
      -- moonshot = {
      --   endpoint = 'https://api.moonshot.ai/v1',
      --   model = 'kimi-k2-0711-preview',
      --   timeout = 30000, -- Timeout in milliseconds
      --   extra_request_body = {
      --     temperature = 0.75,
      --     max_tokens = 32768,
      --   },
      -- },
      -- deepseek = {
      --   endpoint = 'https://api.deepseek.ai/v1',
      --   model = 'deepseek-ai/DeepSeek-V3.1-Terminus',
      --   timeout = 30000, -- Timeout in milliseconds
      --   extra_request_body = {
      --     temperature = 0.75,
      --     max_tokens = 32768,
      --   },
      -- },
    },
    ---Specify the special dual_boost mode
    ---1. enabled: Whether to enable dual_boost mode. Default to false.
    ---2. first_provider: The first provider to generate response. Default to "openai".
    ---3. second_provider: The second provider to generate response. Default to "claude".
    ---4. prompt: The prompt to generate response based on the two reference outputs.
    ---5. timeout: Timeout in milliseconds. Default to 60000.
    ---How it works:
    --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
    ---Note: This is an experimental feature and may not work as expected.
    keys = {
      {
        '<leader>a+',
        function()
          local tree_ext = require 'avante.extensions.nvim_tree'
          tree_ext.add_file()
        end,
        desc = 'Select file in NvimTree',
        ft = 'NvimTree',
      },
      {
        '<leader>a-',
        function()
          local tree_ext = require 'avante.extensions.nvim_tree'
          tree_ext.remove_file()
        end,
        desc = 'Deselect file in NvimTree',
        ft = 'NvimTree',
      },
    },
    selector = {
      exclude_auto_select = { 'NvimTree' },
    },
    dual_boost = {
      enabled = false,
      first_provider = 'openai',
      second_provider = 'claude',
      prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
      timeout = 60000, -- Timeout in milliseconds
    },
    behavior = {
      enable_fastapply = true,
      auto_suggestions = false, -- Tắt để tránh lỗi khi khởi động
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
      enable_token_counting = true,
      auto_approve_tool_permissions = true,
    },
    prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
      enabled = true, -- toggle logging entirely
      log_dir = vim.fn.stdpath 'cache' .. '/avante_prompts', -- directory where logs are saved
      fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
      next_prompt = {
        normal = '<C-n>', -- load the next (newer) prompt log in normal mode
        insert = '<C-n>',
      },
      prev_prompt = {
        normal = '<C-p>', -- load the previous (older) prompt log in normal mode
        insert = '<C-p>',
      },
    },
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = 'co',
        theirs = 'ct',
        all_theirs = 'ca',
        both = 'cb',
        cursor = 'cc',
        next = ']x',
        prev = '[x',
      },
      suggestion = {
        accept = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
      jump = {
        next = ']]',
        prev = '[[',
      },
      submit = {
        normal = '<CR>',
        insert = '<C-s>',
      },
      cancel = {
        normal = { '<C-c>', '<Esc>', 'q' },
        insert = { '<C-c>' },
      },
      sidebar = {
        apply_all = 'A',
        apply_cursor = 'a',
        retry_user_request = 'r',
        edit_user_request = 'e',
        switch_windows = '<Tab>',
        reverse_switch_windows = '<S-Tab>',
        remove_file = 'd',
        add_file = '@',
        close = { '<Esc>', 'q' },
        close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
      },
    },
    hints = { enabled = true },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = 'right', -- the position of the sidebar
      width = 40, -- the width of the sidebar
      wrap = true, -- similar to vim.o.wrap
      height = 20,
      sidebar_header = {
        enabled = true, -- true, false to enable/disable the header
        align = 'left', -- left, center, right for title
        rounded = true,
      },
      spinner = {
        editing = {
          '⡀',
          '⠄',
          '⠂',
          '⠁',
          '⠈',
          '⠐',
          '⠠',
          '⢀',
          '⣀',
          '⢄',
          '⢂',
          '⢁',
          '⢈',
          '⢐',
          '⢠',
          '⣠',
          '⢤',
          '⢢',
          '⢡',
          '⢨',
          '⢰',
          '⣰',
          '⢴',
          '⢲',
          '⢱',
          '⢸',
          '⣸',
          '⢼',
          '⢺',
          '⢹',
          '⣹',
          '⢽',
          '⢻',
          '⣻',
          '⢿',
          '⣿',
        },
        generating = { '·', '✢', '✳', '∗', '✻', '✽' }, -- Spinner characters for the 'generating' state
        thinking = { '🤯', '🙄' }, -- Spinner characters for the 'thinking' state
      },
      input = {
        prefix = '> ',
        height = 10,
      },
      edit = {
        border = 'rounded',
        start_insert = true, -- Start insert mode when opening the edit window
      },
      ask = {
        floating = false, -- Open the 'AvanteAsk' prompt in a floating window
        start_insert = true, -- Start insert mode when opening the ask window
        border = 'rounded',
        ---@type "ours" | "theirs"
        focus_on_apply = 'ours', -- which diff to focus after applying
      },
    },
    highlights = {
      ---@type AvanteConflictHighlights
      diff = {
        current = 'DiffText',
        incoming = 'DiffAdd',
      },
    },
    --- @class AvanteConflictUserConfig
    diff = {
      autojump = true,
      ---@type string | fun(): any
      list_opener = 'copen',
      --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
      --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
      --- Disable by setting to -1.
      override_timeoutlen = 500,
    },
    suggestion = {
      debounce = 1000,
      throttle = 1000,
    },
    history = {
      max_tokens = 4096,
      carried_entry_count = nil,
      storage_path = (vim.fn.stdpath 'state' .. '/avante'),
      paste = {
        extension = 'png',
        filename = 'pasted-%Y-%m-%d-%H-%M-%S',
      },
    },
    --- @class AvanteRepoMapConfig
    repo_map = {
      ignore_patterns = {
        '%.git',
        '%.worktree',
        '__pycache__',
        'node_modules',
        '%.DS_Store',
        '%.png',
        '%.jpg',
        '%.jpeg',
        '%.gif',
        '%.svg',
        '%.ico',
        '%.woff',
        '%.woff2',
        '%.ttf',
        '%.eot',
        '%.wasm',
        '%.node',
        'js-debug',
        'vscode-chrome-debug',
      }, -- ignore files matching these
      negate_patterns = {}, -- negate ignore files matching these.
    },
    --- @class AvanteFileSelectorConfig
    file_selector = {
      provider = nil,
      -- Options override for custom providers
      provider_opts = {},
    },
    input = {
      provider = 'native',
      provider_opts = {},
    },
    disabled_tools = {}, ---@type string[]
    ---@type AvanteLLMToolPublic[] | fun(): AvanteLLMToolPublic[]
    custom_tools = {},
    ---@type AvanteSlashCommand[]
    slash_commands = {},
    ---@type AvanteShortcut[]
    shortcuts = {},
  },
}
