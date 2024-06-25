return {
  'EdenEast/nightfox.nvim',

  priority = 1000,
  init = function()
    vim.opt.background = 'dark'
    vim.cmd.colorscheme 'carbonfox'
  end,
  config = function()
    require('nightfox').setup {
      options = {
        styles = {
          comments = 'italic',
        },
      },
      -- groups = {
      --   carbonfox = {
      --     string = { fg = 'white' },
      --   },
      -- },
    }
  end,
}
--- vim: ts=2 sts=2 sw=2 et
