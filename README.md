# telescope-ultisnips.nvim

Integration for [ultisnips.nvim](https://github.com/SirVer/ultisnips) with [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

![telescope-ultisnips](https://user-images.githubusercontent.com/16906982/109088570-7f84a880-76c4-11eb-99f4-223f3198f7e2.gif)

## Requirements

- [ultisnips.nvim](https://github.com/SirVer/ultisnips) (required)
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
:Telescope ultisnips
```
