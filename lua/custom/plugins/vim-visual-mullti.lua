return {
  'mg979/vim-visual-multi',
  event = 'VeryLazy',
  config = function()
    vim.g.VM_mouse_mappings = 0
    vim.g.VM_leader = '<C-n>'
    vim.g.VM_theme = 'wombat'
    vim.g.VM_highlight_matches = 'Visual'
    vim.g.VM_show_warnings = 0
    vim.g.VM_default_mappings = 0
  end,
}
