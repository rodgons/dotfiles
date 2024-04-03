require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("i", "<C-g>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
map("i", "<c-;>", function()
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true })
map("i", "<c-,>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true })
map("i", "<c-x>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })

-- CUSTOM

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the selected lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the selected lines down" })
map("v", "<leader>p", '"_dP', { desc = "Replace selection with buffer" })
map({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("n", "<leader>bo", function()
	require("nvchad.tabufline").closeOtherBufs()
end, { desc = "Closes all bufs except current one" })
map("n", "<C-b>a", function()
	require("nvchad.tabufline").closeAllBufs()
end, { desc = "Closes tab + all of its buffers" })
map("n", "J", "mzJ`z", { desc = "Move line bellow to current line without move cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Move cursor to middle when jumping page down" })
map("n", "<C-u>", "<C-U>zz", { desc = "Move cursor to middle when jumping page up" })
map("n", "n", "nzzzv", { desc = "Keeps cursor in the middle while search down" })
map("n", "N", "Nzzzv", { desc = "Keeps cursor in the middle while search up" })
map("n", "<leader>gtj", ":GoTagAdd json<CR>", { desc = "Add json tags to go structs" })
map("n", "<leader>gi", ":GoIfErr<CR>", { desc = "Add if err in go" })

-- TMUX KEYMAP
map("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Tmux Navigate Left" })
map("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Tmux Navigate Down" })
map("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Tmux Navigate Up" })
map("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Tmux Navigate Right" })

-- VIM-TEST
map("n", "<leader>tn", ":TestNearest<CR>", { desc = "Test nearest" })
map("n", "<leader>tf", ":TestFile<CR>", { desc = "Test file" })
map("n", "<leader>ts", ":TestSuite<CR>", { desc = "Test suite" })
map("n", "<leader>tl", ":TestLast<CR>", { desc = "Test last" })
map("n", "<leader>tv", ":TestVisit<CR>", { desc = "Test visit" })
