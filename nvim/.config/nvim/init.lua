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
vim.opt.relativenumber = false
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

vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup('minimal-pack-hooks'),
  callback = function(ev)
    local data = ev.data
    if not data or data.spec.name ~= 'nvim-treesitter' then
      return
    end

    if data.kind == 'install' or data.kind == 'update' then
      vim.cmd.packadd('nvim-treesitter')
      pcall(vim.cmd, 'TSUpdateSync')
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/Skardyy/makurai-nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/github/copilot.vim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/muniftanjim/nui.nvim' },
})

local function load_pack(name)
  pcall(vim.cmd.packadd, name)
end

for _, plugin in ipairs({
  'makurai-nvim',
  'fzf-lua',
  'gitsigns.nvim',
  'copilot.vim',
  'mason.nvim',
  'mason-lspconfig.nvim',
  'plenary.nvim',
  'nvim-lspconfig',
  'neo-tree.nvim',
  'nvim-web-devicons',
  'nvim-treesitter',
  'nui.nvim',
}) do
  load_pack(plugin)
end

pcall(vim.cmd.colorscheme, 'makurai_dark')

local ts_languages = {
  'bash',
  'css',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'python',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

local ts_install_ok, ts_install = pcall(require, 'nvim-treesitter.install')
local ts_configs_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if ts_install_ok and ts_configs_ok then
  ts_install.prefer_git = true
  ts_configs.setup({
    ensure_installed = ts_languages,
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  })
end

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

local neo_tree_ok, neo_tree = pcall(require, 'neo-tree')
if neo_tree_ok then
  neo_tree.setup({
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = false,
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
      window = {
        mappings = {
          ['<esc>'] = 'close_window',
        },
      },
    },
    window = {
      position = 'current',
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

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = {
      'lua_ls',
      'marksman',
      'vtsls',
      'basedpyright',
      'gopls',
      'html',
      'jsonls',
      'yamlls',
    },
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
map('n', '<leader>pv', '<cmd>Neotree reveal position=current<cr>', { desc = 'Open file explorer' })
map('n', '<leader>sf', function()
  if fzf_ok then
    fzf.files()
  end
end, { desc = 'Search files' })
map('n', '<leader>sg', function()
  if fzf_ok then
    fzf.live_grep()
  end
end, { desc = 'Search by grep' })
map('n', '<leader>sb', function()
  if fzf_ok then
    fzf.buffers()
  end
end, { desc = 'Search buffers' })
map('n', '<leader>sh', function()
  if fzf_ok then
    fzf.help_tags()
  end
end, { desc = 'Search help' })
map('n', '<leader>sd', function()
  if fzf_ok then
    fzf.diagnostics_document()
  end
end, { desc = 'Search diagnostics' })
map('n', '<leader>sr', function()
  if fzf_ok then
    fzf.oldfiles()
  end
end, { desc = 'Search recent files' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })
map('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
    return
  end
  require('gitsigns').nav_hunk('prev')
end, { desc = 'Previous git hunk' })
map('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
    return
  end
  require('gitsigns').nav_hunk('next')
end, { desc = 'Next git hunk' })
map('n', '<leader>hp', function()
  if gitsigns_ok then
    gitsigns.preview_hunk_inline()
  end
end, { desc = 'Preview git hunk inline' })
map('n', '<leader>hd', function()
  if gitsigns_ok then
    gitsigns.diffthis()
  end
end, { desc = 'Diff current file' })

vim.api.nvim_create_autocmd('UiEnter', {
  group = augroup('minimal-open-directory'),
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local stat = (vim.uv or vim.loop).fs_stat(path)
    if stat and stat.type == 'directory' then
      vim.cmd('Neotree current dir=' .. vim.fn.fnameescape(path))
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('minimal-lsp-attach'),
  callback = function(ev)
    local function lsp_map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    lsp_map('K', vim.lsp.buf.hover, 'LSP hover')
    lsp_map('gd', fzf_ok and fzf.lsp_definitions or vim.lsp.buf.definition, 'LSP definitions')
    lsp_map('gr', fzf_ok and fzf.lsp_references or vim.lsp.buf.references, 'LSP references')
    lsp_map('gi', fzf_ok and fzf.lsp_implementations or vim.lsp.buf.implementation, 'LSP implementations')
    lsp_map('gt', fzf_ok and fzf.lsp_typedefs or vim.lsp.buf.type_definition, 'LSP type definitions')
    lsp_map('<leader>rn', vim.lsp.buf.rename, 'LSP rename')
    lsp_map('<leader>ca', vim.lsp.buf.code_action, 'LSP code action', { 'n', 'x' })

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
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
