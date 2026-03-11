local M = {}

function M.setup_keymaps(opts)
  local toggle_key = opts.keymaps.toggle or '<C-SPACE>'
  local add_key = opts.keymaps.add or '<C-RETURN>'

  local ops = require('todo-md.operations')

  vim.keymap.set('n', toggle_key, function()
    ops.toggle_task()
  end, { silent = true, buffer = true, desc = 'Toggle todo task' })

  vim.keymap.set('n', add_key, function()
    ops.add_task()
  end, { silent = true, buffer = true, desc = 'Add todo task' })
end

return M
