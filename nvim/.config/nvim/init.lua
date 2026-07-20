-- Editor
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }
vim.opt.clipboard = 'unnamedplus'

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('minimal-yank-highlight'),
  callback = function()
    vim.hl.on_yank()
  end,
})

map('<esc>', '<cmd>nohlsearch<cr>', 'Clear search highlights')
map('<C-h>', '<C-w><C-h>', 'Move to left split')
map('<C-j>', '<C-w><C-j>', 'Move to lower split')
map('<C-k>', '<C-w><C-k>', 'Move to upper split')
map('<C-l>', '<C-w><C-l>', 'Move to right split')

-- Packages
local ts_languages = {
  'bash',
  'css',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'javascript',
  'json',
  'python',
  'rust',
  'tsx',
  'typescript',
  'yaml',
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup('minimal-pack-hooks'),
  callback = function(ev)
    local data = ev.data
    if data.spec.name ~= 'nvim-treesitter' or (data.kind ~= 'install' and data.kind ~= 'update') then
      return
    end

    vim.cmd.packadd('nvim-treesitter')
    require('nvim-treesitter').install(ts_languages)
  end,
})

vim.pack.add({
  'https://github.com/Skardyy/makurai-nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/github/copilot.vim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') },
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/echasnovski/mini.nvim',
}, { load = true })

vim.cmd.colorscheme('makurai_dark')

-- Treesitter
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('minimal-treesitter'),
  pattern = ts_languages,
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Search and files
local fzf = require('fzf-lua')
fzf.setup({
  winopts = {
    preview = { hidden = 'nohidden' },
  },
  keymap = {
    builtin = {
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
  },
  files = {
    fd_opts = '--color=never --type=f --hidden --follow --exclude=.git',
  },
})

map('<leader>sf', fzf.files, 'Search files')
map('<leader>sg', fzf.live_grep, 'Search by grep')
map('<leader>sb', fzf.buffers, 'Search buffers')
map('<leader>sh', fzf.help_tags, 'Search help')
map('<leader>sd', fzf.diagnostics_document, 'Search diagnostics')
map('<leader>sr', fzf.oldfiles, 'Search recent files')

local mini_icons = require('mini.icons')
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

require('neo-tree').setup({
  filesystem = {
    hijack_netrw_behavior = 'open_current',
  },
})

map('<leader>pv', '<cmd>Neotree current reveal<cr>', 'Open file explorer')

-- Git
local gitsigns = require('gitsigns')
gitsigns.setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  preview_config = {
    border = 'rounded',
    style = 'minimal',
    relative = 'cursor',
  },
})

map('[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
    return
  end
  gitsigns.nav_hunk('prev')
end, 'Previous git hunk')

map(']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
    return
  end
  gitsigns.nav_hunk('next')
end, 'Next git hunk')

map('<leader>hp', gitsigns.preview_hunk_inline, 'Preview git hunk inline')
map('<leader>hd', gitsigns.diffthis, 'Diff current file')

-- LSP
local lsp_servers = {
  'lua_ls',
  'marksman',
  'vtsls',
  'basedpyright',
  'gopls',
  'html',
  'jsonls',
  'yamlls',
}

require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = lsp_servers })

for _, lhs in ipairs({ 'gra', 'gri', 'grn', 'grr', 'grt', 'grx', 'gO' }) do
  vim.keymap.del('n', lhs)
end
vim.keymap.del('x', 'gra')

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
})

map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
map('[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, 'Previous diagnostic')
map(']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, 'Next diagnostic')

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('minimal-lsp-attach'),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    local function lsp_map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    lsp_map('K', vim.lsp.buf.hover, 'LSP hover')
    lsp_map('<leader>rn', vim.lsp.buf.rename, 'LSP rename')
    lsp_map('<leader>ca', vim.lsp.buf.code_action, 'LSP code action', { 'n', 'x' })
    lsp_map('gd', fzf.lsp_definitions, 'LSP definitions')
    lsp_map('gr', fzf.lsp_references, 'LSP references')
    lsp_map('gi', fzf.lsp_implementations, 'LSP implementations')
    lsp_map('gt', fzf.lsp_typedefs, 'LSP type definitions')

    if client:supports_method('textDocument/completion', ev.buf) then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client:supports_method('textDocument/documentHighlight', ev.buf) then
      local group = augroup('minimal-lsp-highlight-' .. ev.buf)
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'LspDetach' }, {
        buffer = ev.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.env.VIMRUNTIME] = true,
        },
      },
    },
  },
})

vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'basic',
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.enable(lsp_servers)
