---@class MnwGlobal
---@field configDir string Path to the MNW generated config directory

---@type MnwGlobal|nil
_G.mnw = _G.mnw

local M = {}

--- Check if running under MNW (Nix-managed)
---@type boolean
M.is_nix = mnw ~= nil

--- Return different values based on Nix environment
--- When using Nix, returns nix_value; otherwise returns non_nix_value
---@generic T
---@param non_nix_value T Value to use when NOT running under Nix
---@param nix_value? T Value to use when running under Nix (defaults to nil)
---@return T
function M.nix_add(non_nix_value, nix_value)
  if M.is_nix then
    return nix_value
  else
    return non_nix_value
  end
end

--- Get MNW config directory
---@return string|nil
function M.config_dir()
  if M.is_nix then
    return mnw.configDir
  end

  return nil
end

--- Get plugin path, checking both opt and start directories
--- Useful for lazy.nvim dev.path configuration
---@param plugin_name string
---@return string|nil
function M.plugin_path(plugin_name)
  if not M.is_nix then
    return nil
  end

  local packpath = mnw.configDir .. '/pack/mnw'
  local opt_path = packpath .. '/opt/' .. plugin_name

  if vim.fn.isdirectory(opt_path) == 1 then
    return opt_path
  end

  local start_path = packpath .. '/start/' .. plugin_name

  if vim.fn.isdirectory(start_path) == 1 then
    return start_path
  end

  return nil
end

return M
