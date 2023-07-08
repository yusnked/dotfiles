local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Normal
keymap('n', 's', '<NOP>', opts)
-- ESCを2回押しでハイライトを解除
keymap("n", "<Esc><Esc>", ":<C-u>nohlsearch<Return>", opts)

-- Visual
-- *で選択範囲で検索
keymap("v", "*", '"vy/\\V<C-r>=substitute(escape(@v,"\\/"),"\\n","\\\\n","g")<CR><CR>', opts)

