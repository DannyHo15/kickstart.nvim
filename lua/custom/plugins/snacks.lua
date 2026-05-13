-- Configure snacks.nvim with proper settings
-- NOTE: snacks.nvim must NOT be lazy-loaded and must have priority >= 1000
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    input = { enabled = false }, -- dressing.nvim owns vim.ui.input
    picker = {
      enabled = true,
      ui_select = false, -- dressing.nvim owns vim.ui.select
      previewers = {
        diff = {
          style = 'syntax',
        },
      },
    },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    terminal = { enabled = true },
    toggle = { enabled = false },
    lazygit = { enabled = true },
    image = { enabled = true, force = true },
  },
  keys = {
    { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
  },
}
