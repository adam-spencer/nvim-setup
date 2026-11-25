-- Eyeliner setup with self-managed f/F/t/T mappings.
--
-- The plugin's own mappings only clear highlights on CursorMoved or <Esc>, so
-- a search that doesn't move the cursor (e.g. `fq` with no `q` on the line)
-- leaves the line dimmed. Here we read the target char ourselves, always clear
-- the highlights, then hand `f<char>` back to Neovim (counts and `.` repeat
-- still work since the real keys are replayed).
local M = {}

function M.setup()
  require('eyeliner').setup {
    highlight_on_key = true, -- jinh0's version defaults to always-on; the fork ignores this
    dim = true,
    default_keymaps = false, -- f/F/t/T are mapped below
  }

  local ns = vim.api.nvim_create_namespace 'eyeliner'
  for _, key in ipairs { 'f', 'F', 't', 'T' } do
    vim.keymap.set({ 'n', 'x', 'o' }, key, function()
      require('eyeliner').highlight { forward = (key == 'f' or key == 't') }
      local ok, char = pcall(vim.fn.getcharstr)
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      if not ok or char == '\27' then -- <Esc> / <C-c>: cancel the motion
        return vim.fn.mode(1):find 'o' and '\27' or ''
      end
      return key .. char
    end, { expr = true, replace_keycodes = false, desc = 'Eyeliner ' .. key })
  end
end

return M
