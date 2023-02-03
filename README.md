# langmap-switch.nvim

A plugin for Neovim to switch `:h keymap` and display it in a status line.

### Table of contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Statusline](#statusline)

## Requirements

- Neovim 0.7

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'lostl1ght/langmap-switch.nvim',
  config = function()
    require('langmap_switch').setup({
      keymap = -- *required*, see :h keymap
      -- other configuration
    })
  end
}
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  'lostl1ght/langmap-switch.nvim',
  config = function()
    require('langmap_switch').setup({
      keymap = -- *required*, see :h keymap
      -- other configuration
    })
  end,
})
```

## Configuration

Default `setup` values:

```lua
{
  keymap = nil, -- *required*, see :h keymap
  iminsert = 0, -- :h iminsert
  imsearch = -1, -- :h imsearch
  -- key mappings, set to `nil` to disable
  map_insert = '<c-\\>', -- insert mode
  map_normal = '<c-\\>', -- normal mode
  map_command = '<c-\\>', -- command-line mode
}
```

## Statusline

`langmap-switch` exposes 2 functions for a status line plugin:

```lua
require('langmap_switch').condition()
```

```lua
require('langmap_switch').provider()
```

These functions can be used in a status line to display whether keymap is active.

For example, with [lualine](https://github.com/nvim-lualine/lualine.nvim):

```lua
require('lualine').setup({
  sections = {
    lualine_z = {
      {
        require('langmap_switch').provider,
        cond = require('langmap_switch').condition,
      }
    }
  }
})
```
