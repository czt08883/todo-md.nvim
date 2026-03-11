local M = {}

local default_config = {
  keymaps = {
    toggle = '<C-SPACE>',
    add = '<C-RETURN>',
  },
}

function M.setup(user_config)
  local config = vim.tbl_deep_extend('force', default_config, user_config or {})

  local commands = require('todo-md.commands')
  commands.setup_commands()

  local keymaps = require('todo-md.keymaps')

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(args)
      keymaps.setup_keymaps(config)
    end,
  })
end

return M
