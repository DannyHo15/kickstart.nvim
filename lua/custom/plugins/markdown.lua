return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  init = function()
    vim.g.mkdp_command_for_global = 1
  end,
  build = function()
    vim.fn['mkdp#util#install']()
  end,
  keys = {
    {
      '<leader>cp',
      ft = 'markdown',
      '<cmd>MarkdownPreviewToggle<cr>',
      desc = 'Markdown Preview',
    },
  },
  config = function()
    vim.cmd [[do FileType]]
  end,
}
