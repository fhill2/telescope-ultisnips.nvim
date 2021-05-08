local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

local ultisnips = function(opts)
  opts = opts or {}
  local objs = {}

  -- if vim.fn.exists('*UltiSnips#SnippetsInCurrentScope') == 0 then
  --   print('telescope-ultisnips.nvim: no snippets available in empty buffer')
  --   return
  -- end

  vim.call("UltiSnips#SnippetsInCurrentScope", 1)
  local snippetsList = vim.g.current_ulti_dict_info

  for k, v in pairs(snippetsList) do
    local filepath = string.gsub(v.location, ".snippets:%d*", ".snippets")
    local filename = string.match(filepath, "([^\\/?%.]+)%.snippets$")

    local _, _, linenr = string.find(v.location, ":(%d+)")

    table.insert(objs, {
      name = k,
      desc = v.description,
      filepath = filepath,
      filename = filename,
      linenr = tonumber(linenr),
    })
  end

  table.sort(objs, function(a, b)
    if a.filename ~= b.filename then
      return a.filename > b.filename
    end
    return a.name > b.name
  end)

  local displayer = entry_display.create({
    separator = " ",
    items = { { width = 20 }, { width = 20 }, { remaining = true } },
  })

  local make_display = function(entry)
    return displayer({ entry.value.filename, entry.value.name, entry.value.desc })
  end

  pickers.new(opts, {
    prompt_title = "Ultisnips",
    finder = finders.new_table({

      results = objs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.filename .. ' ' .. entry.name .. ' ' .. entry.desc,
          preview_command = function(entry, bufnr)
            if entry.value.filepath ~= nil then
              filecontent = vim.fn.readfile(entry.value.filepath)

              snippet = {}
              count = 0
              for i, line in pairs(filecontent) do
                if i > entry.value.linenr - 1 then
                  count = count + 1
                  if
                    line:find("^endsnippet") ~= nil
                    or line:find("^snippet%s[^%s]") ~= nil and count ~= 1
                  then
                    break
                  end
                  table.insert(snippet, line)
                end
              end

              vim.api.nvim_buf_set_option(bufnr, "filetype", "snippets")
            end -- if entry.value.filepath ~= nil
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, snippet)
          end,
        }
      end,
    }),

    previewer = previewers.display_content.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_put({ selection.value.name }, "", true, true)
        vim.cmd([[call UltiSnips#ExpandSnippet()]])
      end)
      return true
    end,
  }):find()
end -- end custom function

return telescope.register_extension({ exports = { ultisnips = ultisnips } })
