-- LSP setup: Mason manages LSP server installation, mason-lspconfig wires them to Neovim
return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts_ls",        -- TypeScript / React
        "html",         -- HTML
        "cssls",        -- CSS
        "tailwindcss",  -- Tailwind CSS
        "gopls",        -- Go
        "clangd",       -- C
        "rust_analyzer",-- Rust
        "lua_ls",       -- Lua (Neovim config)
        "marksman",     -- Markdown
      },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
