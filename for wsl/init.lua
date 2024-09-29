local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "simrat39/rust-tools.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} } },
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x", 
    dependencies = {
      "nvim-lua/plenary.nvim",  
      "nvim-tree/nvim-web-devicons",  
      "MunifTanjim/nui.nvim",  
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,  
        popup_border_style = "rounded",  
      })
    end,
  },
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },  
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",  
          section_separators = { left = '', right = '' },
          component_separators = { left = '│', right = '│' },
          disabled_filetypes = { "NvimTree", "lazy" },  
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = { 'filename', 'lsp_progress' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'location' },
          lualine_z = { 'progress', 'line_percentage' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = { "fugitive", "nvim-tree" },  
      })
    end,
  },
})

vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

local nvim_lsp = require('lspconfig')
local rust_tools = require("rust-tools")

rust_tools.setup({
    server = {
        on_attach = function(_, bufnr)
            
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
        end,
    },
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = "rust", -- or "all"
  highlight = {
    enable = true,
  },
}

local cmp = require'cmp'

cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})

vim.api.nvim_set_keymap('n', '<leader>cb', ':!cargo build<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ct', ':!cargo test<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cbr', ':!cargo build --release<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ch', ':!cargo check<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>r', ':!cargo run<CR>', { noremap = true, silent = true })