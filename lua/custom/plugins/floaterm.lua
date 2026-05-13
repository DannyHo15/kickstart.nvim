return {
  'voldikss/vim-floaterm',
  lazy = false,
  keys = {
    { '<leader>tt', '<cmd>FloatermToggle<cr>', desc = 'Toggle Terminal' },
    { '<leader>tn', '<cmd>FloatermNew<cr>', desc = 'New Terminal' },
    { '<leader>tk', '<cmd>FloatermKill<cr>', desc = 'Kill Terminal' },
    { '<leader>tx', '<cmd>FloatermNext<cr>', desc = 'Next Terminal' },
    { '<leader>tp', '<cmd>FloatermPrev<cr>', desc = 'Prev Terminal' },
    { '<leader>tT', '<cmd>FloatermToggle --width=0.9 --height=0.9<cr>', desc = 'Toggle Big Terminal' },
    { '<leader>gg', '<cmd>FloatermNew lazygit<cr>', desc = 'LazyGit' },
  },
  init = function()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.6
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_borderchars = '─│─│╭╮╯╰'
    vim.g.floaterm_title = 'Terminal $1/$2'

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'floaterm',
      callback = function()
        local opts = { buffer = true, silent = true }

        vim.keymap.set('t', '<leader>tt', [[<C-\><C-n><cmd>FloatermToggle<cr>]], opts)
        vim.keymap.set('t', '<leader>tn', [[<C-\><C-n><cmd>FloatermNew<cr>]], opts)
        vim.keymap.set('t', '<leader>tk', [[<C-\><C-n><cmd>FloatermKill<cr>]], opts)
        vim.keymap.set('t', '<leader>tx', [[<C-\><C-n><cmd>FloatermNext<cr>]], opts)
        vim.keymap.set('t', '<leader>tp', [[<C-\><C-n><cmd>FloatermPrev<cr>]], opts)
        vim.keymap.set('t', '<leader>tT', [[<C-\><C-n><cmd>FloatermToggle --width=0.9 --height=0.9<cr>]], opts)
        vim.keymap.set('t', '<leader>gg', [[<C-\><C-n><cmd>FloatermNew lazygit<cr>]], opts)
      end,
    })
  end,
}
