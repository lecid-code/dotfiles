return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    opts = function(_, opts)
      opts.options = opts.options or {}
    end,
  },
  {
    "vimpostor/vim-tpipeline",
    config = function()
      vim.g.tpipeline_autoembed = 1
    end,
  },
}
