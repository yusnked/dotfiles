local M = {}
M.normal_mode = {
    c = {
        s = 'Change Surround',
        S = 'Change Surround, New-line',
    },
    d = {
        s = 'Delete a surrounding pair',
    },
    g = {
        b = {
            desc = 'Comment Block',
            name = 'Comment toggle blockwise',
            c = 'Comment toggle current block',
        },
        c = {
            desc = 'Comment Line',
            name = 'Comment toggle linewise',
            c = 'Comment toggle current line',
            O = 'Comment insert below',
            o = 'Comment insert above',
            A = 'Comment insert end of line',
        },
        f = 'Go to file (line can be specified)',
        j = 'Down (logical)',
        k = 'Up (logical)',
        F = 'Go to file',
        J = 'Join lines without leading whitespace',
        ['<C-a>'] = 'Increment N to number continuously',
        ['<C-x>'] = 'Decrement N from number continuously',
    },
    j = 'Down',
    k = 'Up',
    y = {
        s = {
            desc = 'Surround Add',
            name = 'Add Surround',
            s = 'Add Surround, Current-line',
        },
        S = {
            desc = 'Surround Add NL',
            name = 'Add Surround, New-line',
            S = 'Add Surround, Current-line, New-line',
        },
    },
    ['-'] = 'Open parent dir by oil.nvim',
    ['['] = {
        b = 'Previous buffer',
        l = 'Previous location list',
        q = 'Previous quickfix list',
        B = 'First buffer',
        L = 'First location list',
        Q = 'First quickfix list',
    },
    [']'] = {
        b = 'Next buffer',
        l = 'Next location list',
        q = 'Next quickfix list',
        B = 'Last buffer',
        L = 'Last location list',
        Q = 'Last quickfix list',
    },
    ['<C-a>'] = 'Increment N to number',
    ['<C-b>'] = 'Scroll upwards a screen',
    ['<C-d>'] = 'Scroll downwords half a screen',
    ['<C-f>'] = 'Scroll downwords a screen',
    ['<C-u>'] = 'Scroll upwards half a screen',
    ['<C-x>'] = 'Decrement N from number',
    ['<Leader>'] = {
        f = {
            name = 'Telescope',
            a = 'Telescope all pickers',
            b = 'Telescope buffers',
            c = 'Telescope commands',
            f = 'Telescope live_grep',
            g = {
                name = 'Telescope Git',
                b = 'Telescope git_branches',
                c = 'Telescope git_bcommits',
                f = 'Telescope git_file',
                h = 'Telescope ghq list',
                q = 'Telescope git_stash',
                s = 'Telescope git_status',
                C = 'Telescope git_commits',
            },
            j = 'Telescope jumplist',
            l = 'Telescope loclist',
            m = 'Telescope marks',
            n = 'Telescope notify',
            o = 'Telescope vim_options',
            p = 'Telescope project',
            q = 'Telescope quickfixhistory',
            t = 'Telescope treesitter',
            R = 'Telescope registers',
        },
        p = 'Telescope fd',
        s = {
            desc = 'Substitute',
            name = 'Substitute Operator',
            s = 'Substitute Line',
            x = {
                desc = 'Substitute Exchange',
                name = 'Substitute Exchange Operator',
                x = 'Substitute Exchange Line',
            },
        },
        S = 'Substitute EOL',
        ['*'] = 'Telescope grep_string',
        ['<C-a>'] = 'Convert case next',
        ['<C-x>'] = 'Convert case previous',
    },
}

M.visual_mode = {
    g = {
        b = 'Comment toggle blockwise',
        c = 'Comment toggle linewise',
        f = 'Go to file (line can be specified)',
        j = 'Down (logical)',
        k = 'Up (logical)',
        o = 'Sort the selection in ascending order',
        C = 'Comment out and copy',
        F = 'Go to file',
        J = 'Join lines without leading whitespace',
        O = 'Sort the selection in descending order',
        S = 'Add Surround, New-line',
        ['<C-a>'] = 'Increment N to number continuously',
        ['<C-o>'] = 'Sort the selection by specifying arguments',
        ['<C-x>'] = 'Decrement N from number continuously',
    },
    j = 'Down',
    k = 'Up',
    S = 'Add Surround',
    ['<Leader>'] = {
        s = 'Substitute Visual',
        S = 'Substitute Exchange Visual',
        ['<C-a>'] = 'Convert case next',
        ['<C-x>'] = 'Convert case previous',
    },
    ['<C-a>'] = 'Increment N to number',
    ['<C-x>'] = 'Decrement N from number',
    ['<RightMouse>'] = 'which_key_ignore',
}

M.insert_mode = {
    ['<C-g>'] = {
        s = 'Add Surround around Cursor',
        S = 'Add Surround around Cursor, New-line',
    },
    ['<C-y>'] = {
        name = 'Emmet',
    },
}

M.command_mode = {
    ['<C-t>'] = 'Telescope command_history',
}

return M
