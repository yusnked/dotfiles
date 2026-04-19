local pack_dir = vim.env.VIMRUNTIME .. '/pack/dist/opt/'

---@type LazySpec
return {
    {
        dir = pack_dir .. 'cfilter',
        name = 'builtin-cfilter',
        cmd = { 'Cfilter', 'Lfilter' },
    },
}
