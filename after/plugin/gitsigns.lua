require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    -- map('n', ']c', function()
    --   if vim.wo.diff then
    --     vim.cmd.normal({']c', bang = true})
    --   else
    --     gitsigns.nav_hunk('next')
    --   end
    -- end)
    --
    -- map('n', '[c', function()
    --   if vim.wo.diff then
    --     vim.cmd.normal({'[c', bang = true})
    --   else
    --     gitsigns.nav_hunk('prev')
    --   end
    -- end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk,{desc="Stage hunk"})
    map('n', '<C-g>', gitsigns.stage_hunk,{desc="Stage hunk"})
    map('n', '<leader>hr', gitsigns.reset_hunk,{desc="Reset hunk"})
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,{desc="Stage hunk (v)"})
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,{desc="Reset hunk (v)"})
    map('n', '<leader>hS', gitsigns.stage_buffer,{desc="Stage buffer"})
    map('n', '<leader>hu', gitsigns.undo_stage_hunk, {desc="Undo stage hunk"})
    map('n', '<leader>hR', gitsigns.reset_buffer,{desc="Reset buffer"})
    map('n', '<leader>hp', gitsigns.preview_hunk,{desc="Preview hunk"})
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end,{desc="Blame"})
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame,{desc="Toggle blame"})
    map('n', '<leader>hd', gitsigns.diffthis,{desc="Diff"})
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end,{desc="Diff ~"})
    map('n', '<leader>td', gitsigns.toggle_deleted,{desc="Toggle deleted"})
    map({'n','v'}, '[h',  gitsigns.next_hunk ,{desc="Next hunk"})
    map({'n','v'}, ']h',  gitsigns.prev_hunk ,{desc="Prev hunk"})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
