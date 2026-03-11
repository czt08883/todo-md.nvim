local M = {}

local default_config = {
  keymaps = {
    toggle = '<C-SPACE>',
    add = '<C-RETURN>',
  },
}

local setup_done = false

function M.setup(user_config)
  if setup_done then
    return
  end
  setup_done = true

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

M.setup()

return M
