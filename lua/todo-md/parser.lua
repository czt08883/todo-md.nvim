local M = {}

-- Regex patterns for task detection
-- Matches: - [ ] or - [x] or - [anything]
local TASK_PATTERN = '%-%s+%[.*%]'
local TASK_CHECKED_PATTERN = '%-%s+%[x%]'

function M.get_tasks_at_cursor(cursor_row)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  
  local tasks = {}
  local current_task = nil
  local parent_stack = {}  -- stack of tasks by indent level
  
  for row, line in ipairs(lines) do
    -- Check if line contains a task checkbox
    local is_task = line:match(TASK_PATTERN) ~= nil
    local is_checked = line:match(TASK_CHECKED_PATTERN) ~= nil
    
    if is_task then
      -- Calculate indent (including callout prefix > )
      local indent = #line:match('^%s*')
      
      -- Find parent task (most recent task with less indent)
      local parent = nil
      for i = #parent_stack, 1, -1 do
        if parent_stack[i].indent < indent then
          parent = parent_stack[i]
          break
        end
      end
      
      local task = {
        row = row - 1,
        end_row = row - 1,
        checked = is_checked,
        indent = indent,
        parent = parent,
      }
      
      table.insert(tasks, task)
      
      -- Update parent stack: remove tasks with >= indent, add current
      while #parent_stack > 0 and parent_stack[#parent_stack].indent >= indent do
        table.remove(parent_stack)
      end
      table.insert(parent_stack, task)
      
      -- Check if this is the task on the exact cursor line
      if row == cursor_row then
        current_task = task
      end
    end
  end
  
  return tasks, current_task
end

function M.find_current_callout(cursor_row)
  local line_num = cursor_row - 1
  local buf = vim.api.nvim_get_current_buf()

  for i = line_num, 0, -1 do
    local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1] or ''
    if line:match '^>%s*%[%!%w+%].*' then
      return i
    end
  end

  return nil
end

function M.find_next_task_row(start_row)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, start_row, -1, false)

  for i, line in ipairs(lines) do
    if line:match(TASK_PATTERN) then
      return start_row + i - 1
    end
  end

  return nil
end

return M
