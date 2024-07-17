-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      presets = 'modern',
      icons = {
        mappings = false,
        rules = false,
      },
    },
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', desc = '[C]ode' },
        { '<leader>d', desc = '[D]ocument' },
        { '<leader>r', desc = '[R]ename' },
        { '<leader>s', desc = '[S]earch' },
        { '<leader>w', desc = '[W]orkspace' },
        { '<leader>t', desc = '[T]oggle' },
        { '<leader>h', desc = 'Git [H]unk' },
        {
          mode = { 'v' },
          { '<leader>h', desc = 'Git [H]unk' },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
