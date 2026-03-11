# todo-md.nvim

A Neovim plugin for manipulating markdown todo-lists with GitHub-style checkboxes embedded in callout blocks.

## Requirements

- Neovim 0.9+
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (for markdown parsing)

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'yourusername/todo-md.nvim',
  requires = { 'nvim-treesitter/nvim-treesitter' }
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'yourusername/todo-md.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
```

## Setup

```lua
require('todo-md').setup({
  keymaps = {
    toggle = '<C-SPACE>',  -- default
    add = '<C-RETURN>',    -- default
  },
})
```

## Usage

### Default Keybindings

| Keybinding | Action |
|------------|--------|
| `<C-SPACE>` | Toggle task at cursor |
| `<C-RETURN>` | Add new task or subtask |

### Commands

- `:TodoToggle` - Toggle task at cursor
- `:TodoAdd` - Add new task or subtask

### Add Task Logic

- If cursor is on an existing task → adds a subtask (indented)
- Otherwise → adds a top-level task in the current callout block

## Markdown Format

The plugin works with markdown files containing callout-style task blocks:

```markdown
# some priority

> [!SOME_TASK_TYPE]
> - [ ] some task
>   - [ ] some subtask
>   - [ ] another subtask

> [!SOME_TASK_TYPE]
> - [ ] another task
>   - [x] completed subtask
```
