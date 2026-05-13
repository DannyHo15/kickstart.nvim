return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  opts = {
    auto_close = true,
    auto_preview = true,
    auto_refresh = true,
    follow = true,
    focus = false,
    max_items = 500,
    multiline = true,
    pinned = true,
    warn_no_results = false,
    win = {
      type = 'split',
      position = 'bottom',
      size = { height = 0.3 },
    },
    preview = {
      type = 'main',
      scratch = true,
    },
    modes = {
      symbols = {
        focus = false,
        win = { position = 'right' },
        filter = {
          ['not'] = { ft = 'lua', kind = 'Package' },
          any = {
            ft = { 'help', 'markdown' },
            kind = {
              'Class',
              'Constructor',
              'Enum',
              'Field',
              'Function',
              'Interface',
              'Method',
              'Module',
              'Namespace',
              'Package',
              'Property',
              'Struct',
              'Trait',
            },
          },
        },
      },
    },
  },
}
