-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Set additional path because the information is lost inside zellij
local bin_paths = {
  '/home/avinal/.nvm/versions/node/v22.1.0/bin',
  '/home/avinal/.local/bin',
  '/home/avinal/.krew/bin',
  '/home/avinal/bin',
  '/usr/local/go/bin',
  '/home/avinal/go/bin',
}

vim.env.PATH = table.concat(bin_paths, ':') .. ':' .. vim.env.PATH

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
