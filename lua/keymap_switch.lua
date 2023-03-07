local config = {
  iminsert = 0,
  imsearch = -1,
  format = function(keymap_name)
    return keymap_name
  end,
}

local function switch_n()
  vim.o.iminsert = math.floor((2 - vim.o.iminsert) / 2)
end

local key = vim.api.nvim_replace_termcodes('<c-^>', true, true, true)
local function switch_ic()
  vim.api.nvim_feedkeys(key, 'n', false)
end

---Setup input_switch.nvim
---@param opts table
local function setup(opts)
  if not opts or not opts.keymap then
    vim.notify("Setting 'keymap' required", vim.log.levels.ERROR)
    return
  end

  config = vim.tbl_extend('force', config, opts)

  vim.o.keymap = config.keymap
  vim.o.iminsert = config.iminsert
  vim.o.imsearch = config.imsearch

  vim.keymap.set({'i', 'c'}, '<plug>(keymap-switch)', switch_ic)
  vim.keymap.set('n', '<plug>(keymap-switch)', switch_n)
end

---Statusline condition
---@return boolean
local function condition()
  return vim.b.keymap_name
    and (vim.o.imsearch ~= -1 and vim.fn.mode() == 'c' and vim.o.imsearch == 1 or vim.o.iminsert == 1)
end

---Statusline provider
---@return string
local function provider()
  return config.format(vim.b.keymap_name)
end

return { setup = setup, condition = condition, provider = provider }
