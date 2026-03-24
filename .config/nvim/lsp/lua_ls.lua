-- ~/.config/nvim/lsp/lua_ls.lua
return {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
