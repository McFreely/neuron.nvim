local api = vim.api
local config = require("neuron/config")

local M = {}

function M.map_buf(key, rhs)
  local lhs = string.format("%s%s", config.leader, key)
  api.nvim_buf_set_keymap(0, "n", lhs, rhs, {noremap = true, silent = true})
end

function M.map(key, rhs)
  local lhs = string.format("%s%s", config.leader, key)
  api.nvim_set_keymap("n", lhs, rhs, {noremap = true, silent = true})
end

function M.set_keymaps()
  M.map("o", ":lua require'neuron'.enter_link('edit')<CR>", {noremap = true, silent = true})
  M.map("so", ":lua require'neuron'.enter_link('split')<CR>", {noremap = true, silent = true})
  M.map("vo", ":lua require'neuron'.enter_link('vsplit')<CR>", {noremap = true, silent = true})

  -- new_edit => create new note
  -- TODO no insert true ? 
  -- NOTE new_edit creates note with neuron server
  M.map_buf("n", "<cmd>lua require'neuron/cmd'.new_edit(require'neuron/config'.neuron_dir, 'edit')<CR>")
  M.map_buf("sn", "<cmd>lua require'neuron/cmd'.new_edit(require'neuron/config'.neuron_dir, 'split')<CR>")
  M.map_buf("vn", "<cmd>lua require'neuron/cmd'.new_edit(require'neuron/config'.neuron_dir, 'vsplit')<CR>")

  -- find_zettels => look in existing notes
  -- insert = true => create link
  -- does not create new note
  M.map_buf("fz", "<cmd>lua require'neuron/telescope'.find_zettels()<CR>")
  M.map_buf("fa", "<cmd>lua require'neuron/telescope'.find_zettels {tag = 'garden', mode = 'normal'}<CR>")
  M.map_buf("fZ", "<cmd>lua require'neuron/telescope'.find_zettels {insert = true}<CR>")

  -- Show backlinks, ie: links going to note
  M.map_buf("b", "<cmd>lua require'neuron/telescope'.find_backlinks()<CR>")
  M.map_buf("B", "<cmd>lua require'neuron/telescope'.find_backlinks {insert = true}<CR>")

  -- Show tags
  M.map_buf("t", "<cmd>lua require'neuron/telescope'.find_tags()<CR>")

  -- Launch web preview
  M.map_buf("sz", "<cmd>lua require'neuron'.rib()<CR>")

  M.map_buf("j", "<cmd>lua require'neuron'.goto_next_extmark()<CR>")
  M.map_buf("k", "<cmd>lua require'neuron'.goto_prev_extmark()<CR>")
end

function M.setup()
  vim.cmd(string.format("au BufRead %s/*.md lua require'neuron/mappings'.set_keymaps()", config.neuron_dir))
  M.map("<TAB>", "<cmd>lua require'neuron'.goto_index()<CR>")
end

return M
