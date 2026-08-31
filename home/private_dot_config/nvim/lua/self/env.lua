local M = {}

---@type boolean
M.is_windows = vim.fn.has('win32') == 1

---@type boolean
M.is_macos = vim.fn.has('macunix') == 1

---@type boolean
M.is_root = not M.is_windows and vim.uv.getuid() == 0

return M
