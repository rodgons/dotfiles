return {
  {
    "vim-test/vim-test",
    lazy = false,
    dependencies = {
      "preservim/vimux",
    },
    vim.cmd("let test#strategy = 'vimux'")
  }
}
