return {
    "mfussenegger/nvim-lint",
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        local lint = require("lint")

        -- Setup diagnostic config for linting
        vim.diagnostic.config({
            underline = true,
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            severity_sort = true,
        })

        lint.linters_by_ft = {
            javascript = {"eslint_d"},
            typescript = {"eslint_d"},
            javascriptreact = {"eslint_d"},
            typescriptreact = {"eslint_d"},
            svelte = {"eslint_d"},
            vue = {"eslint_d"},
            go = {"golangci-lint"},
            python = {"pylint"}
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", {
            clear = true
        })

        vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, {
            desc = "Trigger linting for current file"
        })
    end
}
