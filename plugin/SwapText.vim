" SwapText.vim: Mappings to exchange text with the previously deleted text.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - SwapText.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2007-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #470: Map to quickly swap/exchange arbitrary text by
"	  Piet Delport and an enhancement by ad_scriven@postmaster.co.uk.
"
" REVISION	DATE		REMARKS
"   1.01.019	22-Jul-2014	BUG: <Leader>X includes the newline unless :set
"				selection=exclusive. Thanks to Enno Nagel for
"				reporting this.
"				Minor: Supply the count to "$", no need for a
"				separate "count times j".
"   1.00.018	05-May-2014	Abort on error.
"	017	19-Mar-2013	Revert: Last change broke swapping. Replace
"				<Bar> with <CR>; because SwapText#Visual() uses
"				gv, the selection must have been established.
"	016	18-Feb-2013	Reformat and replace <CR>: with <Bar>.
"				Change <Plug>-mapping names.
"	015	26-Nov-2011	BUG: Incorrectly placed if..endif broke
"				<Plug>SwapTextLines.
"	014	17-Nov-2011	Split off separate autoload script and
"				documentation.
"	001	06-Jun-2007	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SwapText') || (v:version < 700)
    finish
endif
let g:loaded_SwapText = 1
let s:save_cpo = &cpo
set cpo&vim

" How it works:
" <ESC>	exits visual mode
" `.	returns to exact spot of last modification (the deleted text)
" m`	put the `. mark into ``, as it'll be overridden by the first paste
" gv	re-selects last visual text
" P	put/paste last deleted text over visually selected text
" ``	moves to where text was deleted
" P	visually selected text is now in the default register, so just paste it.
"
"vnoremap <Leader>x <Esc>`.m`gvP``P

" The simple mapping doesn't work when the deleted text occurs on the right of
" the selected text (i.e. when you edit against the typical left-to-right
" direction) _and_ both text elements are on the same line.
" This implementation explicitly checks for that condition and takes corrective
" actions.
vnoremap <silent> <Plug>(SwapTextVisual)
\ :<C-u>if SwapText#UndoJoin()<Bar>call SwapText#Visual()<Bar>else<Bar>echoerr ingo#err#Get()<Bar>endif<CR>
if ! hasmapto('<Plug>(SwapTextVisual)', 'x')
    xmap <Leader>x <Plug>(SwapTextVisual)
endif

nnoremap <silent> <Plug>(SwapTextLines)
\ :<C-u>execute 'normal! V' . v:count1 . '_'<CR>
\:<C-u>if SwapText#UndoJoin()<Bar>call SwapText#Visual()<Bar>else<Bar>echoerr ingo#err#Get()<Bar>endif<CR>
if ! hasmapto('<Plug>(SwapTextLines)', 'n')
    nmap <Leader>xx <Plug>(SwapTextLines)
endif

nnoremap <silent> <Plug>(SwapTextUntilEnd)
\ :<C-u>execute 'normal! v' . (v:count ? v:count : '') . '$' . (&selection ==# 'exclusive' ? '' : 'h')<CR>
\:<C-u>if SwapText#UndoJoin()<Bar>call SwapText#Visual()<Bar>else<Bar>echoerr ingo#err#Get()<Bar>endif<CR>
if ! hasmapto('<Plug>(SwapTextUntilEnd)', 'n')
    nmap <Leader>X <Plug>(SwapTextUntilEnd)
endif

nnoremap <silent> <expr> <Plug>(SwapTextOperator) SwapText#OperatorExpr()
if ! hasmapto('<Plug>(SwapTextOperator)', 'n')
    nmap <Leader>x <Plug>(SwapTextOperator)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
