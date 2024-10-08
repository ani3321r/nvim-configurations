
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
  { "neovim/nvim-lspconfig",
	dependencies = {
      'hrsh7th/nvim-cmp',      
      'hrsh7th/cmp-nvim-lsp',  
      'L3MON4D3/LuaSnip',      
      'saadparwaiz1/cmp_luasnip', 
    }
  },
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
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup {
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)  
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)        
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts) 
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts) 
  end
}


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

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)  
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, 
  }, {
    { name = 'buffer' },
  })
})


vim.api.nvim_set_keymap('n', '<leader>cb', ':!cargo build<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ct', ':!cargo test<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cbr', ':!cargo build --release<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ch', ':!cargo check<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>r', ':!cargo run<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>rc', ':w<CR>:!gcc % -o %:r && ./%:r<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>RC', ':w<CR>:!g++ % -o %:r && ./%:r<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "rust"},
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
