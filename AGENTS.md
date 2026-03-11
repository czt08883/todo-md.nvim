# todo-md.nvim

A Neovim plugin for manipulating markdown todo-lists with GitHub-style checkboxes embedded in callout blocks.

## Current Status

Plugin is functional with basic operations implemented.

## Implemented Features

1. **Toggle Task** (`<M-SPACE>` or `:TodoToggle`)
   - Toggles `[ ]` ↔ `[x]` on the task at cursor
   - Works on exact cursor line only

2. **Add Task** (`<M-RETURN>` or `:TodoAdd`)
   - If cursor on existing task → adds subtask (+2 indent, maintains `> ` prefix if in callout)
   - If cursor on callout header line → adds task to that callout
   - If cursor on empty line → creates new callout block:
     ```
     > [!TODO]
     > - [ ] 
     ```

## Keybindings

- `<M-SPACE>` - Toggle task (default)
- `<M-RETURN>` - Add task/subtask (default)

## File Structure

```
todo-md.nvim/
├── lua/todo-md/
│   ├── init.lua       -- Entry point, auto-setup with defaults
│   ├── commands.lua   -- :TodoToggle, :TodoAdd commands
│   ├── parser.lua     -- Regex-based task/callout detection
│   ├── operations.lua -- toggle_task(), add_task() logic
│   └── keymaps.lua   -- Buffer-local keybindings
├── README.md
└── LICENSE
```

## Known Issues

- Plugin auto-sets up on load but lazy.nvim may not trigger setup without explicit `opts` or `config` in the plugin spec
- Dependency on nvim-treesitter is declared but parser currently uses regex (could be removed or kept for future features)

## Future Enhancements (To Be Implemented)

- More operations (delete task, move up/down, priority, archive completed)
- More configurable options
- Potentially treesitter integration for more robust parsing
