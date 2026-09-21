-- =======================================================================
-- VSCode / Cursor Neovim Configuration
-- Loaded only when vim.g.vscode is true (via asvetliakov.vscode-neovim)
-- =======================================================================

local ok, vscode = pcall(require, 'vscode')
if not ok then
  vscode = {
    action = function(...) end,
    call = function(...) end,
    get_config = function(...) return 'off' end,
    update_config = function(...) end,
    notify = function(...) end,
  }
end

local function gh(repo) return 'https://github.com/' .. repo end

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Core Options
vim.o.ignorecase = true
vim.o.smartcase = true
-- Wait indefinitely on multi-key mappings (e.g. 'gt', '<leader>sf', 'grd') until completed or cancelled by <Esc>
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100
vim.o.updatetime = 250

-- Clear search highlights on <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('vscode-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- =======================================================================
-- Compatible Plugins
-- =======================================================================

-- Eyeliner (f/t unique letter highlighting - user favorite!)
vim.pack.add { gh 'jinh0/eyeliner.nvim' }
require('eyeliner').setup {
  highlight_on_key = true,
  dim = true,
}

-- Eyeliner highlights:
-- By default, eyeliner tries to copy colors from 'Constant' and 'Define'.
-- In VSCode Neovim, standard syntax groups are stripped to prevent clashing
-- with VSCode's syntax tokens, resulting in nil colors (white/grey).
-- Explicitly defining them restores your vibrant orange and blue highlights:
local function set_eyeliner_highlights()
  vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = '#ff9e3b', bold = true, underline = true })
  vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = '#61afef', underline = true })
  vim.api.nvim_set_hl(0, 'EyelinerDimmed', { fg = '#5c6370' })
end
set_eyeliner_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Maintain Eyeliner highlight colors in VSCode',
  callback = set_eyeliner_highlights,
})

-- mini.ai & mini.surround
vim.pack.add { gh 'nvim-mini/mini.nvim' }

require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

require('mini.surround').setup {
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    replace = 'gsr',
    update_n_lines = 'gsn',
  },
}

-- Leap (movement / jumping)
vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }
require('leap').setup {}
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>n', '<Plug>(leap)', { desc = 'Leap motion' })

-- =======================================================================
-- Window / Split Navigation (Cursor Editor Groups)
-- =======================================================================
vim.keymap.set('n', '<C-h>', function() vscode.action 'workbench.action.navigateLeft' end, { desc = 'Move focus left' })
vim.keymap.set('n', '<C-j>', function() vscode.action 'workbench.action.navigateDown' end, { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', function() vscode.action 'workbench.action.navigateUp' end, { desc = 'Move focus up' })
vim.keymap.set('n', '<C-l>', function() vscode.action 'workbench.action.navigateRight' end, { desc = 'Move focus right' })

-- =======================================================================
-- Search & Navigation (Telescope -> Cursor Native)
-- =======================================================================
vim.keymap.set('n', '<leader>sf', function() vscode.action 'workbench.action.quickOpen' end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function() vscode.action 'workbench.action.findInFiles' end, { desc = '[S]earch by [G]rep' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', function() vscode.action 'workbench.action.findInFiles' end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader><leader>', function() vscode.action 'workbench.action.showAllEditors' end, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sd', function() vscode.action 'workbench.actions.view.problems' end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', function() vscode.action 'workbench.action.showCommands' end, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader>sk', function() vscode.action 'workbench.action.openGlobalKeybindings' end, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>s.', function() vscode.action 'workbench.action.openRecent' end, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader>/', function() vscode.action 'actions.find' end, { desc = '[/] Search in current buffer' })

-- =======================================================================
-- LSP, Formatting & Code Actions (Cursor Native)
-- =======================================================================
vim.keymap.set('n', 'grd', function() vscode.action 'editor.action.revealDefinition' end, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'grr', function() vscode.action 'editor.action.goToReferences' end, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gri', function() vscode.action 'editor.action.goToImplementation' end, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', 'grt', function() vscode.action 'editor.action.goToTypeDefinition' end, { desc = '[G]oto [T]ype Definition' })
vim.keymap.set('n', 'gO', function() vscode.action 'workbench.action.gotoSymbol' end, { desc = 'Open Document Symbols' })
vim.keymap.set('n', 'gW', function() vscode.action 'workbench.action.showAllSymbols' end, { desc = 'Open Workspace Symbols' })
vim.keymap.set('n', 'grn', function() vscode.action 'editor.action.rename' end, { desc = '[R]e[n]ame' })
vim.keymap.set({ 'n', 'x' }, 'gra', function() vscode.action 'editor.action.quickFix' end, { desc = '[G]oto Code [A]ction' })
vim.keymap.set({ 'n', 'v' }, '<leader>f', function() vscode.action 'editor.action.formatDocument' end, { desc = '[F]ormat buffer' })
vim.keymap.set('n', '<leader>cf', function() vscode.action 'editor.action.fixAll' end, { desc = 'Fix lint issues' })

-- Toggle inlay / type hints via VSCode configuration
local function toggle_inlay_hints()
  local current = vscode.get_config 'editor.inlayHints.enabled'
  local new_val = (current == 'on' or current == 'onUnlessPressed') and 'off' or 'on'
  vscode.update_config('editor.inlayHints.enabled', new_val, 'global')
  vscode.notify('Inlay hints: ' .. new_val)
end
vim.keymap.set('n', '<leader>th', toggle_inlay_hints, { desc = '[T]oggle Inlay / Type [H]ints' })

-- Diagnostics navigation
vim.keymap.set('n', '[d', function() vscode.action 'editor.action.marker.prev' end, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', function() vscode.action 'editor.action.marker.next' end, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>q', function() vscode.action 'workbench.actions.view.problems' end, { desc = 'Open diagnostic [Q]uickfix list' })

-- =======================================================================
-- Cursor AI Actions (Normal Mode)
-- =======================================================================
vim.keymap.set('n', '<leader>k', function() vscode.action 'aipopup.action.modal.generate' end, { desc = 'Cursor Edit (Cmd+K)' })
vim.keymap.set('n', '<leader>ac', function() vscode.action 'workbench.action.chat.open' end, { desc = 'Cursor Chat (Cmd+L)' })
vim.keymap.set('n', '<leader>ai', function() vscode.action 'composer.startComposerPrompt' end, { desc = 'Cursor Composer (Cmd+I)' })
