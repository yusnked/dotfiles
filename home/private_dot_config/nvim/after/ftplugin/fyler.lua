local bufnr = vim.api.nvim_get_current_buf()

do -- デフォルトキーを無効化する.
    local keys = { "q", "<C-t>", "|", "^", "=", ".", "#" }
    local opts = { buffer = bufnr }
    local del = vim.keymap.del
    for _, lhs in ipairs(keys) do
        del("n", lhs, opts)
    end
end

do -- which-key.nvim
    local wk = {
        { "gx", desc = "Open system" },
        { "-", desc = "Go to parent" },
        { "_", desc = "Go to CWD" },
        { "<CR>", desc = "Select" },
        { "<BS>", desc = "Collapse all" },
        { "<localleader>c", desc = "cd to fyler root" },
        { "<localleader>g", desc = "Go to node" },
        { "<localleader>l", desc = "lcd to fyler root" },
        { "<localleader>t", desc = "tcd to fyler root" },
    }
    for i = 1, #wk do
        wk[i].buffer = bufnr
    end
    require("which-key").add(wk)
end

-- :Wq 保存(確認ダイアログ含む)が完了して "modified=false" になったら quit する.
-- モンキーパッチの FylerConfirm イベントに依存.
local ok, fyler_confirm = pcall(require, "fyler.inputs.confirm")
if ok and fyler_confirm.__patched_fyler_confirm then
    vim.api.nvim_buf_create_user_command(bufnr, "Wq", function()
        local wq_bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[wq_bufnr].filetype ~= "fyler" then
            vim.cmd.wq()
            return
        end

        local group = vim.api.nvim_create_augroup("plugins_fyler_wq_" .. wq_bufnr, { clear = true })

        local function cleanup()
            vim.b[wq_bufnr].__fyler_quit_after_write = false
            pcall(vim.api.nvim_del_augroup_by_id, group)
        end

        local function try_quit()
            if not vim.api.nvim_buf_is_valid(wq_bufnr) then
                cleanup()
                return
            end
            if vim.b[wq_bufnr].__fyler_quit_after_write and not vim.bo[wq_bufnr].modified then
                cleanup()
                vim.cmd.quit()
            end
        end

        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "FylerConfirm",
            callback = function(ctx)
                if ctx.buf ~= wq_bufnr then
                    return
                end

                if type(ctx.data.args) == "table" and ctx.data.args[1] == true then
                    vim.b[wq_bufnr].__fyler_quit_after_write = true
                    try_quit()
                else
                    cleanup()
                end
            end,
        })

        vim.api.nvim_create_autocmd("BufModifiedSet", {
            group = group,
            buffer = wq_bufnr,
            callback = try_quit,
        })

        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(wq_bufnr) then
                vim.api.nvim_set_current_buf(wq_bufnr)
                vim.cmd.write()
            end
        end)
    end, { bang = true })

    vim.cmd([[
        cnoreabbrev <buffer> wq  Wq
        cnoreabbrev <buffer> wq! Wq
        cnoreabbrev <buffer> x   Wq
        cnoreabbrev <buffer> x!  Wq
    ]])
end
