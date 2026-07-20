vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
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

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
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

vim.pack.add({
  { src = 'https://github.com/Skardyy/makurai-nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/github/copilot.vim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/echasnovski/mini.nvim' },
})

pcall(vim.cmd.colorscheme, 'makurai_dark')

vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup('minimal-pack-hooks'),
  callback = function(ev)
    local data = ev.data
    if not data or data.spec.name ~= 'nvim-treesitter' then
      return
    end
    if data.kind == 'install' or data.kind == 'update' then
      vim.cmd.packadd('nvim-treesitter')
      local ok, ts = pcall(require, 'nvim-treesitter')
      if ok then
        pcall(ts.install, ts_languages)
      end
    end
  end,
})

local ts_ok = pcall(require, 'nvim-treesitter')

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('minimal-treesitter'),
  pattern = ts_languages,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    if ts_ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

local fzf_ok, fzf = pcall(require, 'fzf-lua')
if fzf_ok then
  fzf.setup({
    winopts = {
      preview = {
        hidden = 'nohidden',
      },
    },
    keymap = {
      builtin = {
        ['<C-d>'] = 'preview-page-down',
        ['<C-u>'] = 'preview-page-up',
      },
    },
    files = {
      fd_opts = table.concat({
        '--color=never',
        '--type=f',
        '--hidden',
        '--follow',
        '--exclude=.git',
      }, ' '),
    },
  })
end

local mini_icons_ok, mini_icons = pcall(require, 'mini.icons')
if mini_icons_ok then
  mini_icons.setup()
  mini_icons.mock_nvim_web_devicons()
end

local neo_tree_ok, neo_tree = pcall(require, 'neo-tree')
if neo_tree_ok then
  neo_tree.setup({
    filesystem = {
      hijack_netrw_behavior = 'open_current',
    },
  })
end

local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
if gitsigns_ok then
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
end

local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
  mason.setup()
end

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

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = lsp_servers,
  })
end

for _, lhs in ipairs({ 'gra', 'gri', 'grn', 'grr', 'grt', 'grx', 'gO' }) do
  pcall(vim.keymap.del, 'n', lhs)
end
pcall(vim.keymap.del, 'x', 'gra')

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
})

map('n', '<esc>', '<cmd>nohlsearch<cr>')
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left split' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower split' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper split' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right split' })

if neo_tree_ok then
  map('n', '<leader>pv', '<cmd>Neotree current reveal<cr>', { desc = 'Open file explorer' })
end

if fzf_ok then
  map('n', '<leader>sf', fzf.files, { desc = 'Search files' })
  map('n', '<leader>sg', fzf.live_grep, { desc = 'Search by grep' })
  map('n', '<leader>sb', fzf.buffers, { desc = 'Search buffers' })
  map('n', '<leader>sh', fzf.help_tags, { desc = 'Search help' })
  map('n', '<leader>sd', fzf.diagnostics_document, { desc = 'Search diagnostics' })
  map('n', '<leader>sr', fzf.oldfiles, { desc = 'Search recent files' })
end

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })

if gitsigns_ok then
  map('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
      return
    end
    gitsigns.nav_hunk('prev')
  end, { desc = 'Previous git hunk' })
  map('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({ ']c', bang = true })
      return
    end
    gitsigns.nav_hunk('next')
  end, { desc = 'Next git hunk' })
  map('n', '<leader>hp', gitsigns.preview_hunk_inline, { desc = 'Preview git hunk inline' })
  map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff current file' })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('minimal-lsp-attach'),
  callback = function(ev)
    local function lsp_map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    lsp_map('K', vim.lsp.buf.hover, 'LSP hover')
    lsp_map('<leader>rn', vim.lsp.buf.rename, 'LSP rename')
    lsp_map('<leader>ca', vim.lsp.buf.code_action, 'LSP code action', { 'n', 'x' })

    if fzf_ok then
      lsp_map('gd', fzf.lsp_definitions, 'LSP definitions')
      lsp_map('gr', fzf.lsp_references, 'LSP references')
      lsp_map('gi', fzf.lsp_implementations, 'LSP implementations')
      lsp_map('gt', fzf.lsp_typedefs, 'LSP type definitions')
    else
      lsp_map('gd', vim.lsp.buf.definition, 'LSP definitions')
      lsp_map('gr', vim.lsp.buf.references, 'LSP references')
      lsp_map('gi', vim.lsp.buf.implementation, 'LSP implementations')
      lsp_map('gt', vim.lsp.buf.type_definition, 'LSP type definitions')
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, ev.buf) then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, ev.buf) then
      local group = augroup('minimal-lsp-highlight-' .. ev.buf)
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'LspDetach' }, {
        buffer = ev.buf,
        group = group,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
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
