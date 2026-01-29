-- Configure snacks.nvim with proper settings
-- NOTE: snacks.nvim must NOT be lazy-loaded and must have priority >= 1000
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    words = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    input = { enabled = true },
    picker = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    terminal = {},
    toggle = { enabled = false },
    lazygit = { enabled = true },
    image = { enabled = true },
  },
  keys = {
    {
      '<leader>tt',
      function()
        require('snacks').terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>tf',
      function()
        require('snacks').terminal(nil, {
          cwd = vim.fn.expand '%:p:h',
        })
      end,
      desc = 'Terminal in current file directory',
    },
  },
}
