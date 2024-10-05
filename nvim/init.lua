-- Packer initialization in init.lua
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager

  -- Python development plugins
  use 'neovim/nvim-lspconfig'  -- LSP configuration
  use 'hrsh7th/nvim-cmp'       -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'   -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip'       -- Snippets plugin
  use 'psf/black'              -- Python code formatter (Black)
  use 'mfussenegger/nvim-dap'  -- Debugger
  use 'nvim-treesitter/nvim-treesitter' -- Syntax highlighting
  
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }


  -- Optional: Git support
  use 'tpope/vim-fugitive' -- Git integration

  -- Optional: File tree explorer
  use 'kyazdani42/nvim-tree.lua'
  
  -- Install more plugins here...

end)


-- LSP setup in init.lua
local lspconfig = require('lspconfig')

lspconfig.pyright.setup {} -- Configure Pyright

-- Autocompletion setup in init.lua
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  })
})



-- Format on save
vim.cmd [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.py silent! lua vim.lsp.buf.format { async = true }
  augroup END
]]



-- tree sitter conf
require'nvim-treesitter.configs'.setup {
  ensure_installed = "python", -- ensure Python parser is installed
  highlight = {
    enable = true,              -- enable Tree-sitter syntax highlighting
    additional_vim_regex_highlighting = false,  -- Disable legacy Vim regex highlighting for better performance
  },

}

-- debuggiing
local dap = require('dap')

-- Configure the Python debug adapter
dap.adapters.python = {
  type = 'executable',
  command = 'python',  -- Change this if you're using a virtual environment or a specific Python version
  args = { '-m', 'debugpy.adapter' },
}

-- Define configurations for Python debugging
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",       -- This will show up as a debug configuration
    program = "${file}",        -- This runs the current file
    pythonPath = function()
      -- Use the appropriate Python executable (customize this if necessary)
      return '/usr/bin/python'  -- Replace with the path to your Python interpreter or virtual environment
    end,
  },
}

-- Keybindings for nvim-dap
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

-- Start debugging
vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })

-- Step over
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })

-- Step into
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })

-- Step out
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })

-- Toggle breakpoint
vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })

-- Set breakpoint with condition
vim.api.nvim_set_keymap('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })

-- View debug console
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })

-- nvim-tree setup in init.lua
require'nvim-tree'.setup {}

-- Optional keymap for opening the file explorer
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })

