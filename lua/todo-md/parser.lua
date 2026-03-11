local M = {}

local function get_ts_parser()
  local ok, parser = pcall(require, 'nvim-treesitter.parser')
  if not ok then
    return nil
  end
  local buf = vim.api.nvim_get_current_buf()
  return parser.get_parser(buf, 'markdown')
end

function M.get_tasks_at_cursor(cursor_row)
  local parser = get_ts_parser()
  if not parser then
    return nil
  end

  local tree = parser:parse()
  if not tree or #tree == 0 then
    return nil
  end

  local root = tree[1]:root()
  local tasks = {}

  local function process_node(node, parent_task)
    local node_type = node:type()
    local start_row, _, end_row, _ = node:range()

    if node_type == 'list_item' then
      local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1] or ''
      if line:match '%-%s+%[%s*%]' or line:match '%-%s+%[x%]' then
        local task = {
          row = start_row,
          end_row = end_row,
          checked = line:match '%-%s+%[x%]' ~= nil,
          indent = (#line:match('^%s*') or 0),
          parent = parent_task,
        }
        table.insert(tasks, task)
        parent_task = task
      end
    end

    for child in node:iter_children()
    do
      process_node(child, parent_task)
    end
  end

  process_node(root, nil)

  local current_task = nil
  local min_distance = math.huge

  for _, task in ipairs(tasks) do
    if task.row == cursor_row - 1 then
      current_task = task
      break
    end
    local distance = math.abs(task.row - (cursor_row - 1))
    if distance < min_distance then
      min_distance = distance
      current_task = task
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
    if line:match '%-%s+%[%]' or line:match '%-%s+%[x%]' then
      return start_row + i - 1
    end
  end

  return nil
end

return M
