local helpers = {}

helpers.get_listed_buffers = function()
    local buffers = {}
    local len = 0
    local vim_fn = vim.fn
    local buflisted = vim_fn.buflisted

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if buflisted(buffer) == 1 then
            len = len + 1
            buffers[len] = buffer
        end
    end

    return buffers
end

return helpers

