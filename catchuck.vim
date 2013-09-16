" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Mark Morris <karplusstrong@gmail.com>
" Last Change:	2013 July 31

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "catchuck"
hi Normal		term=bold					ctermfg=171		        guifg=#19ba14  guibg=black
hi Comment		term=bold					ctermfg=14				guifg=#e3b6c5
hi String		term=bold					ctermfg=250
hi Number   								ctermfg=172
hi Constant		term=underline				ctermfg=Cyan			guifg=Cyan
hi Special		term=bold					ctermfg=105				guifg=Red
hi Identifier 	term=underline	cterm=bold	ctermfg=Cyan 			guifg=#40ffff
hi Statement	term=bold					ctermfg=Yellow 			gui=bold	guifg=#aa4444
hi PreProc		term=underline				ctermfg=LightBlue		guifg=#ff80ff
hi Type			term=underline				ctermfg=LightGreen		guifg=#60ff60 gui=bold
hi Function		term=bold					ctermfg=White			guifg=White
hi Repeat		term=underline				ctermfg=White			guifg=white
hi Operator									ctermfg=10				guifg=Red
hi Ignore									ctermfg=black			guifg=bg
hi Error		term=reverse 	ctermbg=Red 		ctermfg=White guibg=Red guifg=White
hi Todo			term=standout 	ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi MatchParen					ctermbg=57

" Groups for the ChucK musical programming language
" visit chuck.cs.princeton.edu for more information
hi ckUgen									ctermfg=167
hi ckCommunication							ctermfg=Red


" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String		Constant
hi link Character	Constant
hi link Number		Constant
hi link Boolean		Constant
hi link Float		Number
hi link Conditional	Repeat
hi link Label		Statement
hi link Keyword		Statement
hi link Exception	Statement
hi link Include		PreProc
hi link Define		PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Statement
hi link Typedef		Type
hi link Tag			Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special
