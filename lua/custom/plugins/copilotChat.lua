return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    selection = function()
      return vim.fn.visualmode() or vim.api.nvim_get_current_buf()
    end,
    opts = {
      show_help = true, -- Shows help message as virtual lines when waiting for user input
      show_folds = true, -- Shows folds for sections in chat
      highlight_selection = true, -- Highlight selection
      highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
      auto_follow_cursor = true, -- Auto-follow cursor in chat
      auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
      insert_at_end = true, -- Move cursor to end of buffer when inserting text
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
      debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      proxy = nil,
      disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
      chat_autocomplete = true,
      question_header = '## Danny ', -- Header to use for user questions
      answer_header = '## Copilot ', -- Header to use for AI answers
      error_header = '## Error ', -- Header to use for errors
      separator = '───', -- Separator to use in chat
      language = 'English', -- Copilot answer language settings when using default prompts. Default language is English.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
      -- temperature = 0.1,
      prompts = {
        Explain = {
          prompt = '> /COPILOT_EXPLAIN\n\nThere may be times where you need to explain complex algorithms or logic in your code. This can be challenging, especially when you are trying to make it understandable to others. Copilot Chat can help you with this task by providing you with suggestions on how to explain the algorithm or logic in a clear and concise manner.',
        },
        Review = {
          prompt = '> /COPILOT_REVIEW\n\nReview the selected code critically. Identify strengths, weaknesses, potential issues, and suggest improvements if necessary.',
        },
        Fix = {
          prompt = '> /COPILOT_GENERATE\n\nThe selected code contains a problem. Analyze it, identify the bug, and rewrite the code to fix the issue while ensuring readability and maintainability.',
        },
        Optimize = {
          prompt = '> /COPILOT_GENERATE\n\nRefactor and optimize the selected code to improve both performance and readability. Minimize complexity while adhering to best practices.',
        },
        Docs = {
          prompt = '> /COPILOT_GENERATE\n\nGenerate documentation comments for the selected code. Include explanations for parameters, return values, and provide usage examples if applicable.',
        },
        Tests = {
          prompt = '> /COPILOT_GENERATE\n\nWrite comprehensive test cases for the selected code. Use appropriate testing frameworks and cover edge cases where necessary.',
        },
        Commit = {
          prompt = '> #git:staged\n\nCreate a commit message for the staged changes following the commitizen convention. Ensure the title is concise (max 50 characters), and the message is wrapped at 72 characters. Format the entire message in a code block with language set to `gitcommit`.',
        },
        Improve = {
          prompt = '> /COPILOT_GENERATE\n\nCode with poor readability is difficult for other developers to maintain and extend. Copilot Chat can help in a number of ways. For example, by:Suggesting improvements to variable names Avoiding sequential conditional checks Reducing nested logic Splitting large methods into smaller, more readable ones',
        },
      },
      mappings = {
        complete = {
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-l>',
          insert = '<C-l>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        toggle_sticky = {
          detail = 'Makes line under cursor sticky or deletes sticky line.',
          normal = 'gr',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        jump_to_diff = {
          normal = 'gj',
        },
        quickfix_diffs = {
          normal = 'gq',
        },
        yank_diff = {
          normal = 'gy',
          register = '"',
        },
        show_diff = {
          normal = 'gd',
        },
        show_info = {
          normal = 'gi',
        },
        show_context = {
          normal = 'gc',
        },
        show_help = {
          normal = 'gh',
        },
      },
    },

    build = function()
      vim.notify "Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim."
    end,
    event = 'VeryLazy',
    keys = {
      {
        '<leader>ccq',
        function()
          local input = vim.ui.input({ prompt = 'Quick chat: ' }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
            end
          end)
        end,
        desc = 'CopilotChat - Quick chat',
      },
      { '<leader>cce', '<Cmd>CopilotChatExplain<cr>', desc = 'CopilotChat - Explain code' },
      { '<leader>cct', '<Cmd>CopilotChatTests<cr>', desc = 'CopilotChat - Generate tests' },
      {
        '<leader>ccT',
        '<Cmd>CopilotChatToggle<cr>',
        desc = 'CopilotChat - Toggle Vsplit', -- Toggle vertical split
      },
      {
        '<leader>ccv',
        ':CopilotChatVisual ',
        mode = 'x',
        desc = 'CopilotChat - Open in vertical split',
      },
      {
        '<leader>ccx',
        ':CopilotChatInPlace<cr>',
        mode = 'x',
        desc = 'CopilotChat - Run in-place code',
      },
      {
        '<leader>ccf',
        '<Cmd>CopilotChatFix<cr>', -- Get a fix for the diagnostic message under the cursor.
        desc = 'CopilotChat - Fix diagnostic',
      },
      {
        '<leader>ccr',
        '<Cmd>CopilotChatReset<cr>', -- Reset chat history and clear buffer.
        desc = 'CopilotChat - Reset chat history and clear buffer',
      },
    },
  },
}
