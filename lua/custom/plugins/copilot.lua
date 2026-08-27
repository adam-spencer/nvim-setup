-- GitHub Copilot inline completions
-- https://github.com/github/copilot.vim
--
-- After first install, restart Neovim and run `:Copilot setup`.

-- Disable the default <Tab> accept map so blink.cmp / autolist keep Tab.
vim.g.copilot_no_tab_map = true

-- Off by default in markdown; use <leader>tp to enable in a given buffer.
vim.g.copilot_filetypes = { markdown = false }

vim.pack.add { 'https://github.com/github/copilot.vim' }

-- Accept ghost-text with Ctrl-j (not Tab: blink.cmp / autolist use that).
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  silent = true,
  replace_keycodes = false,
  desc = 'Accept Copilot suggestion',
})

-- copilot.vim only has :Copilot enable/disable (global). Toggle the buffer
-- flag so markdown can stay off by filetype and still be turned on here.
vim.keymap.set('n', '<leader>tp', function()
  local enabled = vim.fn['copilot#Enabled']() == 1
  vim.b.copilot_enabled = not enabled
  if enabled then vim.fn['copilot#Dismiss']() end
  vim.notify('Copilot ' .. (enabled and 'disabled' or 'enabled') .. ' for this buffer')
end, { desc = '[T]oggle Co[p]ilot' })
