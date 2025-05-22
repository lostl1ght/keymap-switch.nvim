---@class DefaultConfig
---@field keymap string
---@field iminsert integer
---@field imsearch integer
---@field format fun(keymap_name:string):string
local C = {
  iminsert = 0,
  imsearch = -1,
  format = function(keymap_name) return keymap_name end,
}

local switch_nsx = function() vim.o.iminsert = bit.bxor(vim.o.iminsert, 1) end

local key = vim.api.nvim_replace_termcodes('<c-^>', true, true, true)
local switch_ic = function() vim.api.nvim_feedkeys(key, 'n', false) end

---@class Config
---@field keymap string
---@field format (fun(keymap_name:string):string)|nil

---@class KeymapSwitch
---@field setup fun(opts:Config) Setup keymap-switch.nvim
---@field condition fun():boolean Status line condition
---@field provider fun():string Status line provider
local M = {}

M.setup = function(opts)
  vim.validate({
    keymap = { opts.keymap, 'string' },
    format = {
      opts.format,
      function(v) return v == nil or type(v) == 'function' end,
      "'format' must be a function with 1 string argument",
    },
  })

  C.keymap = opts.keymap
  C.format = opts.format or C.format

  vim.o.keymap = C.keymap
  vim.o.iminsert = C.iminsert
  vim.o.imsearch = C.imsearch

  vim.keymap.set({ 'i', 'c' }, '<plug>(keymap-switch)', switch_ic)
  vim.keymap.set({ 'n', 's', 'x' }, '<plug>(keymap-switch)', switch_nsx)
end

M.condition = function()
  return vim.b.keymap_name
    and (
      vim.o.imsearch ~= -1 and vim.fn.mode() == 'c' and vim.o.imsearch == 1
      or vim.o.iminsert == 1
    )
end

M.provider = function() return C.format(M.condition() and vim.b.keymap_name or 'en') end

return M
