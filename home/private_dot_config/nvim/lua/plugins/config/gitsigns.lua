local M = {}

function M.on_attach(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    local function nav_hunk(lhs, dir)
        return function()
            if vim.wo.diff and lhs then
                vim.cmd.normal { lhs, bang = true }
            else
                gitsigns.nav_hunk(dir)
            end
        end
    end

    -- preview系はgitsignsの仕様で二回呼ぶとPreviw windowにカーソルが飛ぶ.
    local function focus_preview(fn, args)
        args = args or {}
        return function()
            fn(unpack(args))
            vim.defer_fn(function()
                fn(unpack(args))
            end, 100)
        end
    end

    -- Navigation
    map("n", "[c", nav_hunk("[c", "prev"), { desc = "Go to previous hunk" })
    map("n", "]c", nav_hunk("]c", "next"), { desc = "Go to next hunk" })
    map("n", "[C", function() gitsigns.nav_hunk("first") end, { desc = "Go to first hunk" })
    map("n", "]C", function() gitsigns.nav_hunk("last") end, { desc = "Go to last hunk" })


    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
    map("x", "<leader>hs", function()
        gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
    end, { desc = "Stage hunk (visual)" })
    map("x", "<leader>hr", function()
        gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
    end, { desc = "Reset hunk (visual)" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })

    -- Preview / Diff
    map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "Preview hunk (inline)" })
    map("n", "<leader>hP", focus_preview(gitsigns.preview_hunk), { desc = "Preview hunk and focus (floating)" })
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Buffer diff (index)" })

    -- Lists
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "Hunks to qf (current)" })
    map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "Hunks to qf (repo)" })
    map("n", "<leader>h<C-q>", function() gitsigns.setqflist("attached") end, { desc = "Hunks to qf (attached)" })
    map("n", "<leader>hl", gitsigns.setloclist, { desc = "Hunks to loclist (current)" })
    map("n", "<leader>hL", function() gitsigns.setloclist(0, "all") end, { desc = "Hunks to loclist (repo)" })
    map("n", "<leader>h<C-L>", function() gitsigns.setloclist(0, "attached") end,
        { desc = "Hunks to loclist (attached)" })

    -- Blame
    map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "Blame line (floating)" })
    map("n", "<leader>hB", focus_preview(gitsigns.blame_line, { { full = true } }),
        { desc = "Blame line and focus (floating)" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "inner hunk" })

    -- which-key.nvim
    require("which-key").add { "<leader>h", group = "git hunk" }
end

return M
