local M = {}

function M.toggle_task()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]

  local parser = require('todo-md.parser')
  local tasks, current_task = parser.get_tasks_at_cursor(cursor_row)

  if not current_task then
    vim.notify('No task found at cursor', vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, current_task.row, current_task.row + 1, false)[1]

  if current_task.checked then
    line = line:gsub('%[x%]', '[ ]')
  else
    line = line:gsub('%[%s*%]', '[x]')
  end
  vim.api.nvim_buf_set_lines(0, current_task.row, current_task.row + 1, false, { line })
end

function M.add_task()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]

  local parser = require('todo-md.parser')
  local tasks, current_task = parser.get_tasks_at_cursor(cursor_row)

  print(string.format('DEBUG: cursor_row=%d, current_task=%s', cursor_row, current_task and 'found' or 'nil'))

  local new_task_line

  if current_task then
    local parent_line = vim.api.nvim_buf_get_lines(0, current_task.row, current_task.row + 1, false)[1]
    local has_callout = parent_line:match('^>%s')
    
    if has_callout then
      -- Parent is in callout, get indent after "> " (2 chars)
      local after_callout = parent_line:sub(3)  -- skip "> "
      local leading_spaces = after_callout:match('^%s*') or ''
      local content_indent = #leading_spaces
      local new_content_indent = content_indent + 2
      new_task_line = '> ' .. string.rep(' ', new_content_indent) .. '- [ ] '
    else
      local parent_indent = current_task.indent
      local new_indent = parent_indent + 2
      new_task_line = string.rep(' ', new_indent) .. '- [ ] '
    end
    else
      local callout_row = parser.find_current_callout(cursor_row)
      print(string.format('DEBUG: callout_row=%s', callout_row and tostring(callout_row) or 'nil'))
      if callout_row then
        local callout_line = vim.api.nvim_buf_get_lines(0, callout_row, callout_row + 1, false)[1]
        local after_callout = callout_line:sub(3)
        local leading_spaces = after_callout:match('^%s*') or ''
        local content_indent = #leading_spaces
        new_task_line = '> ' .. string.rep(' ', content_indent + 2) .. '- [ ] '
    else
      -- Create new callout block
      local insert_row = cursor_row - 1  -- convert to 0-indexed
      print(string.format('DEBUG: creating callout at row %d', insert_row))
      vim.api.nvim_buf_set_lines(0, insert_row, insert_row + 1, false, { '> [!TODO]', '> - [ ] ' })
      vim.api.nvim_win_set_cursor(0, { insert_row + 2, 9 })
      return
    end
  end

  local insert_row = current_task and (current_task.row + 1) or cursor_row
  vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { new_task_line })
  vim.api.nvim_win_set_cursor(0, { insert_row + 1, #new_task_line })
end

return M
