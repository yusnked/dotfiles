local M = {}

---@type boolean
M.is_root = not vim.uv.os_uname().sysname:match('Windows') and vim.uv.getuid() == 0

return M
