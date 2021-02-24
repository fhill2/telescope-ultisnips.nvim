# telescope-ultisnips.nvim

Integration for [ultisnips.nvim](https://github.com/SirVer/ultisnips) with [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).


## Requirements

- [snippets.nvim](https://github.com/SirVer/ultisnips) (required)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)

## Setup

You can setup the extension by doing

```lua
require('telescope').load_extension('ultisnips')
```

somewhere after your `require('telescope').setup()` call.

## Available functions

```lua
require'telescope'.extensions.ultisnips.ultisnips{}
```

or

```vim
:Telescope ultisnips ultisnips
```
