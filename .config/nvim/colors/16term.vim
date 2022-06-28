hi clear
if exists("syntax_on")
  syntax reset
endif
set t_Co=16

let colors_name = "16term"

if &background ==# "dark"
  "hi Normal ctermbg=black ctermfg=lightgrey cterm=NONE
  hi NonText ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi EndOfBuffer ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi LineNr ctermbg=black ctermfg=lightgrey cterm=NONE
  hi FoldColumn ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Folded ctermbg=black ctermfg=lightgrey cterm=NONE
  hi MatchParen ctermbg=black ctermfg=yellow cterm=NONE
  hi SignColumn ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Comment ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi Conceal ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi Constant ctermbg=NONE ctermfg=red cterm=NONE
  hi Error ctermbg=NONE ctermfg=darkred cterm=reverse
  hi SignError ctermbg=black ctermfg=red cterm=NONE
  hi Identifier ctermbg=NONE ctermfg=darkblue cterm=NONE
  hi Ignore ctermbg=NONE ctermfg=NONE cterm=NONE
  hi PreProc ctermbg=NONE ctermfg=darkcyan cterm=NONE
  hi Special ctermbg=NONE ctermfg=blue cterm=NONE
  hi Statement ctermbg=NONE ctermfg=blue cterm=NONE
  hi String ctermbg=NONE ctermfg=green cterm=NONE
  hi Todo ctermbg=NONE ctermfg=NONE cterm=reverse
  hi Type ctermbg=NONE ctermfg=blue cterm=NONE
  hi Underlined ctermbg=NONE ctermfg=NONE cterm=underline
  hi Pmenu ctermbg=black ctermfg=lightgrey cterm=NONE
  hi PmenuSbar ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi PmenuSel ctermbg=darkcyan ctermfg=black cterm=NONE
  hi PmenuThumb ctermbg=darkcyan ctermfg=darkcyan cterm=NONE
  hi ErrorMsg ctermbg=darkred ctermfg=black cterm=NONE
  hi ModeMsg ctermbg=green ctermfg=black cterm=NONE
  hi MoreMsg ctermbg=NONE ctermfg=darkcyan cterm=NONE
  hi Question ctermbg=NONE ctermfg=green cterm=NONE
  hi WarningMsg ctermbg=NONE ctermfg=darkred cterm=NONE
  hi TabLine ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi TabLineFill ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi TabLineSel ctermbg=darkyellow ctermfg=black cterm=NONE
  hi ToolbarLine ctermbg=black ctermfg=NONE cterm=NONE
  hi ToolbarButton ctermbg=darkgrey ctermfg=lightgrey cterm=NONE
  hi Cursor ctermbg=lightgrey ctermfg=NONE cterm=NONE
  hi CursorColumn ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi CursorLineNr ctermbg=black ctermfg=lightgrey cterm=NONE
  hi CursorLine ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi helpLeadBlank ctermbg=NONE ctermfg=NONE cterm=NONE
  hi helpNormal ctermbg=NONE ctermfg=NONE cterm=NONE
  hi StatusLine ctermbg=black ctermfg=darkgrey cterm=NONE
  hi StatusLineNC ctermbg=black ctermfg=lightgrey cterm=NONE
  hi StatusLineTerm ctermbg=black ctermfg=lightgrey cterm=NONE
  hi StatusLineTermNC ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Visual ctermbg=black ctermfg=blue cterm=reverse
  hi VisualNOS ctermbg=NONE ctermfg=NONE cterm=underline
  hi VertSplit ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi WildMenu ctermbg=blue ctermfg=black cterm=NONE
  hi Function ctermbg=NONE ctermfg=NONE cterm=NONE
  hi SpecialKey ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi Title ctermbg=NONE ctermfg=white cterm=NONE
  hi DiffAdd ctermbg=black ctermfg=green cterm=reverse
  hi DiffChange ctermbg=black ctermfg=magenta cterm=reverse
  hi DiffDelete ctermbg=black ctermfg=darkred cterm=reverse
  hi DiffText ctermbg=black ctermfg=red cterm=reverse
  hi IncSearch ctermbg=darkred ctermfg=black cterm=NONE
  hi Search ctermbg=yellow ctermfg=black cterm=NONE
  hi Directory ctermbg=NONE ctermfg=cyan cterm=NONE
  hi debugPC ctermbg=darkblue ctermfg=NONE cterm=NONE
  hi debugBreakpoint ctermbg=darkred ctermfg=NONE cterm=NONE
  hi SpellBad ctermbg=NONE ctermfg=darkred cterm=undercurl guisp=#af5f5f
  hi SpellCap ctermbg=NONE ctermfg=darkcyan cterm=undercurl guisp=#5f8787
  hi SpellLocal ctermbg=NONE ctermfg=darkgreen cterm=undercurl guisp=#5f87f5
  hi SpellRare ctermbg=NONE ctermfg=red cterm=undercurl guisp=#ff8700
  hi ColorColumn ctermbg=black ctermfg=NONE cterm=NONE
else
  hi Normal ctermbg=NONE ctermfg=black cterm=NONE
  hi NonText ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi EndOfBuffer ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi LineNr ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi FoldColumn ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Folded ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi MatchParen ctermbg=black ctermfg=yellow cterm=NONE
  hi SignColumn ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi Comment ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi Conceal ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi Constant ctermbg=NONE ctermfg=blue cterm=NONE
  hi Error ctermbg=NONE ctermfg=darkred cterm=reverse
  hi Identifier ctermbg=NONE ctermfg=darkblue cterm=NONE
  hi Ignore ctermbg=NONE ctermfg=NONE cterm=NONE
  hi PreProc ctermbg=NONE ctermfg=red cterm=NONE
  hi Special ctermbg=NONE ctermfg=darkgreen cterm=NONE
  hi Statement ctermbg=NONE ctermfg=blue cterm=NONE
  hi String ctermbg=NONE ctermfg=darkgreen cterm=NONE
  hi Todo ctermbg=NONE ctermfg=NONE cterm=reverse
  hi Type ctermbg=NONE ctermfg=blue cterm=NONE
  hi Underlined ctermbg=NONE ctermfg=darkcyan cterm=underline
  hi Pmenu ctermbg=lightgrey ctermfg=black cterm=NONE
  hi PmenuSbar ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi PmenuSel ctermbg=darkgrey ctermfg=black cterm=NONE
  hi PmenuThumb ctermbg=darkcyan ctermfg=darkcyan cterm=NONE
  hi ErrorMsg ctermbg=darkred ctermfg=black cterm=NONE
  hi ModeMsg ctermbg=green ctermfg=black cterm=NONE
  hi MoreMsg ctermbg=NONE ctermfg=darkcyan cterm=NONE
  hi Question ctermbg=NONE ctermfg=green cterm=NONE
  hi WarningMsg ctermbg=NONE ctermfg=darkred cterm=NONE
  hi TabLine ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi TabLineFill ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi TabLineSel ctermbg=darkyellow ctermfg=black cterm=NONE
  hi ToolbarLine ctermbg=black ctermfg=NONE cterm=NONE
  hi ToolbarButton ctermbg=darkgrey ctermfg=lightgrey cterm=NONE
  hi Cursor ctermbg=lightgrey ctermfg=NONE cterm=NONE
  hi CursorColumn ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi CursorLineNr ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi CursorLine ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi helpLeadBlank ctermbg=NONE ctermfg=NONE cterm=NONE
  hi helpNormal ctermbg=NONE ctermfg=NONE cterm=NONE
  hi StatusLine ctermbg=darkyellow ctermfg=black cterm=NONE
  hi StatusLineNC ctermbg=darkgrey ctermfg=white cterm=NONE
  hi StatusLineTerm ctermbg=darkyellow ctermfg=black cterm=NONE
  hi StatusLineTermNC ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi Visual ctermbg=black ctermfg=blue cterm=reverse
  hi VisualNOS ctermbg=NONE ctermfg=NONE cterm=underline
  hi VertSplit ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi WildMenu ctermbg=blue ctermfg=black cterm=NONE
  hi Function ctermbg=NONE ctermfg=blue cterm=NONE
  hi SpecialKey ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi Title ctermbg=NONE ctermfg=white cterm=NONE
  hi DiffAdd ctermbg=black ctermfg=green cterm=reverse
  hi DiffChange ctermbg=black ctermfg=magenta cterm=reverse
  hi DiffDelete ctermbg=black ctermfg=darkred cterm=reverse
  hi DiffText ctermbg=black ctermfg=red cterm=reverse
  hi IncSearch ctermbg=darkred ctermfg=black cterm=NONE
  hi Search ctermbg=yellow ctermfg=black cterm=NONE
  hi Directory ctermbg=NONE ctermfg=cyan cterm=NONE
  hi debugPC ctermbg=darkblue ctermfg=NONE cterm=NONE
  hi debugBreakpoint ctermbg=darkred ctermfg=NONE cterm=NONE
  hi SpellBad ctermbg=NONE ctermfg=darkred cterm=undercurl guisp=#af5f5f
  hi SpellCap ctermbg=NONE ctermfg=darkcyan cterm=undercurl guisp=#5f8787
  hi SpellLocal ctermbg=NONE ctermfg=darkgreen cterm=undercurl guisp=#5f87f5
  hi SpellRare ctermbg=NONE ctermfg=red cterm=undercurl guisp=#ff8700
  hi ColorColumn ctermbg=lightgrey ctermfg=NONE cterm=NONE

  hi CIncluded ctermbg=NONE ctermfg=darkblue cterm=NONE
  hi CStructure ctermbg=NONE ctermfg=red cterm=NONE
  hi CType ctermbg=NONE ctermfg=blue cterm=NONE
endif
hi link Terminal Normal
hi link Number Constant
hi link CursorIM Cursor
hi link Boolean Constant
hi link Character Constant
hi link Conditional Statement
hi link Debug Special
hi link Define PreProc
hi link Delimiter Special
hi link Exception Statement
hi link Float Number
hi link HelpCommand Statement
hi link HelpExample Statement
hi link Include PreProc
hi link Keyword Statement
hi link Label Statement
hi link Macro PreProc
hi link Number Constant
hi link Operator Statement
hi link PreCondit PreProc
hi link Repeat Statement
hi link SpecialChar Special
hi link SpecialComment Special
hi link StorageClass Type
hi link Structure Type
hi link Tag Special
hi link Terminal Normal
hi link Typedef Type
hi link htmlEndTag htmlTagName
hi link htmlLink Function
hi link htmlSpecialTagName htmlTagName
hi link htmlTag htmlTagName
hi link htmlBold Normal
hi link htmlItalic Normal
hi link xmlTag Statement
hi link xmlTagName Statement
hi link xmlEndTag Statement
hi link markdownItalic Preproc
hi link asciidocQuotedEmphasized Preproc
hi link diffBDiffer WarningMsg
hi link diffCommon WarningMsg
hi link diffDiffer WarningMsg
hi link diffIdentical WarningMsg
hi link diffIsA WarningMsg
hi link diffNoEOL WarningMsg
hi link diffOnly WarningMsg
hi link diffRemoved WarningMsg
hi link diffAdded String
hi link QuickFixLine Search
hi link jsGlobalObjects Normal
hi link jsGlobalNodeObjects Normal
hi link pythonInclude Type
hi link asmIdentifier Normal
hi link rustOperator Normal
hi link rustModPathSep Normal
hi link rustMacro Keyword
hi link cInclude Keyword
hi link cDefine Normal

hi link TSComment Comment
hi link TSConditional Statement
hi link TSKeyword Statement
hi link TSAnnotation Normal
hi link TSRepeat Statement
hi link TSAttribute Normal
hi link TSKeywordFunction Statement
hi link TSCharacter Constant
hi link TSBoolean Constant
hi link TSFunction Function
hi link TSMethod Function
hi link TSConstructor Function
hi link TSFuncBuiltin Function
hi link TSConstant Normal
hi link TSVariable Normal
hi link TSVariableBuiltin Normal
hi link TSConstMacro Normal
hi link TSError Keyword
hi link TSException Keyword
hi link TSField Normal
hi link TSFloat Normal
hi link TSFuncMacro Normal
hi link TSInclude Keyword
hi link TSLabel Normal
hi link TSNamespace Normal
hi link TSNumber Normal
hi link TSOperator Normal
hi link TSParameter Normal
hi link TSParameterReference Normal
hi link TSProperty Normal
hi link TSPunctDelimiter Normal
hi link TSPunctBracket Normal
hi link TSPunctSpecial Normal
hi link TSString String
hi link TSStringRegex String
hi link TSStringEscape String
hi link TSSymbol Normal
hi link TSType Normal
hi link TSTypeBuiltin Normal
hi link TSTag Normal
hi link TSTagDelimiter Normal
hi link TSText Normal
hi link TSTextReference Normal
hi link TSEmphasis Normal
hi link TSUnderline Normal
hi link TSStrike Normal
hi link TSTitle Normal
hi link TSLiteral Normal
hi link TSURI Normal
hi link TSNone Normal
