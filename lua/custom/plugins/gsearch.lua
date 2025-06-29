return {
  'dzfrias/gsearch.nvim',
  requires = { { 'nvim-telescope/telescope.nvim', tag = '0.1.0' } },
  config = function()
    require('gsearch').setup {
      telescope = {
        layout_config = {
          width = 0.9,
          height = 0.9,
        },
      },
      enabled = true,
      -- Whether to include what's in your Telescope prompt in the list of
      -- suggestions
      raw_included = true,
      -- The key to use to Google search for what's in your Telescope prompt
      -- without using one of the suggestions. Note that the <s-CR> keybinding may
      -- not work on all terminals/operating systems.
      open_raw_key = '<s-CR>',
      -- The shell command to use to open the URL. As an empty string, it
      -- defaults to your OS defaults ("open" for macOS, "xdg-open" for Linux)
      open_cmd = '',
    }
  end,
  keys = {
    { '<leader>ggs', ':Gsearch<CR>', desc = 'Google Search' },
  },
}
