local M = {}

function M.setup_commands()
  vim.api.nvim_create_user_command('TodoToggle', function()
    local ops = require('todo-md.operations')
    ops.toggle_task()
  end, {})

  vim.api.nvim_create_user_command('TodoAdd', function()
    local ops = require('todo-md.operations')
    ops.add_task()
  end, {})
end

return M
