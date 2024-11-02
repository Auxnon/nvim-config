---@class Vim
---@field diagnostic Diagnostic
---@field api Api
---@field bo VimBo
---@field lsp Lsp
---@field opt VimOpt
---@field fn VimFn
---@field loop VimLoop
---@field wo Wo
---@field o VimO
---@field g table
---@field cmd fun(cmd: string)

---@class Severity
---@field ERROR string
---@field WARN string
---@field INFO string
---@field HINT string

---@class Diagnostic
---@field severity Severity
---@field hide fun()
---@field enable fun()
---@field show fun()
---@field get fun( bufnr:integer, opts: GetOpts)
---@field count fun()

---@class GetOpts
---@field namespace? integer | integer[] Limit diagnostics to one or more
---@field lnum? integer Limit diagnostics to those spaning the specified line number.
---@field severity Severity

---@class Api
---@field nvim_buf_add_highlight fun(buffer:integer ,ns_id:integer,hl_group:string,line:integer,col_start:integer,col_end:integer)
---@field nvim_create_autocmd fun(event:string|string[],opts:AutocmdOpts)
---@field nvim_create_buf fun(listed:boolean,scratch:boolean) Creates a new, empty, unnamed buffer.
---@field nvim_del_current_line fun() Deletes the current line.

---@class AutocmdOpts
---@field group? string|integer autocommand group name or id to match against.
---@field pattern? string | string[] pattern(s) to match literally |autocmd-pattern|.
---@field buffer? integer buffer number for buffer-local autocommands |autocmd-buflocal|. Cannot be used with {pattern}
---@field desc? string  description (for documentation and troubleshooting).
---@field callback? fun(table:CBKeys)|string  Lua function (or Vimscript function name, if string) called when the event(s) is triggered. Lua callback can return a truthy value (not `false` or `nil`) to delete the autocommand. Receives one argument, a table with these keys:
---@field command? string Vim command to execute on event. Cannot be used with {callback}
---@field once? (boolean) defaults to false. Run the autocommand only once |autocmd-once|.
---@field nested? boolean defaults to false. Run nested autocommands |autocmd-nested|.

---@class CBKeys
---@field id number autocommand id
---@field event string name of the triggered event |autocmd-events|
---@field group number|nil autocommand group id, if any
---@field match string expanded value of <amatch>
---@field buf number expanded value of <abuf>
---@field file string expanded value of <afile>
---@field data any arbitrary data passed from |nvim_exec_autocmds()|

---@class Lsp
---

---@class VimOpt
---@field tabstop integer
---@field expandtab boolean
---@field smartindent boolean
---@field softtabstop integer
---@field shiftwidth integer
---@field rtp Rtp
---@field termguicolors boolean
---@field foldmethod string
---@field foldexpr string
---@field clipboard string

---@class Wo
---@field number boolean
---@field relativenumber boolean
---
---@class VimBo
---@field softtabstop integer

---@class VimO
---@field statuscolumn string
---@field timeout boolean
---@field timeoutlen integer

---@class VimFn
---@field stdpath fun(path:string)
---@field system fun(args: string[])
---@field getpos fun(expr:string):integer[] The result is a |List| with four numbers: [bufnum, lnum, col, off]

---
---@class VimLoop
---@field fs_stat fun(path: string):boolean
---
---@class Rtp
---@field prepend fun(self:self, path:string)



---@type Vim
vim = vim
-- vim.diagnostic.severity.ERROR

-- vim.diagnostic.get(0,{
-- fun(buffer,ns_id,hl_group,line,col_start,col_end)
