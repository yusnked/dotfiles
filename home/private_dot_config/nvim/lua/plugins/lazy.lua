local M = {}

local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

---@type LazyConfig
local opts = {
    defaults = { lazy = true, cond = nil },
    install = { colorscheme = { 'tokyonight' } },
    ui = {
        border = 'single',
        custom_keys = {
            ['<localleader>r'] = {
                function(plugin)
                    require('lazy').load { plugins = { plugin.name } }
                end,
                desc = 'Load plugin (lazy)',
            },
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'netrwPlugin',
                'shada',
                'spellfile',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
    pkg = { enabled = false },
    -- 遅い理由を調べたいときだけ有効にする.
    profiling = { loader = false, require = false },
}

---@type LazySpec[]
local specs = {}

local did_setup = false
local disabled = false

---@return boolean success
local function clone_lazy()
    local job = vim.system({
        'git', 'clone', '--filter=blob:none', '--branch=stable',
        lazyrepo, lazypath,
    }, { text = true })

    local res = job:wait()
    if res.code == 0 then
        return true
    end

    vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { (res.stderr ~= '' and res.stderr or res.stdout), 'WarningMsg' },
    }, true, {})
    return false
end

--- lazy.nvim の読み込みを無効にする.
function M.disable()
    assert(not did_setup, 'plugins.lazy.disable() must be called before setup()')
    disabled = true
end

--- Spec の配列を追加する. 必ず setup の前に呼ぶ必要がある.
---@param lazy_specs LazySpec[]
function M.add_specs(lazy_specs)
    assert(not did_setup, 'plugins.lazy.add_specs() must be called before setup()')

    -- 毎回通る起動パスなので vim.list_extend ではなく直接追加する.
    local n = #specs
    for i = 1, #lazy_specs do
        specs[n + i] = lazy_specs[i]
    end
end

function M.setup()
    assert(not did_setup, 'plugins.lazy.setup() was already called')
    did_setup = true

    if disabled or not (vim.fn.isdirectory(lazypath) == 1 or clone_lazy()) then
        return
    end

    vim.opt.rtp:prepend(lazypath)

    opts.spec = specs
    require('lazy').setup(opts)
end

return M
