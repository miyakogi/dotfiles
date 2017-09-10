" Vim syntax file
" Language:	JavaScript
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" Updaters:	Scott Shattuck (ss) <ss@technicalpursuit.com>
" URL:		http://www.fleiner.com/vim/syntax/javascript.vim
" Changes:	(ss) added keywords, reserved words, and other identifiers
"		(ss) repaired several quoting and grouping glitches
"		(ss) fixed regex parsing issue with multiple qualifiers [gi]
"		(ss) additional factoring of keywords, globals, and members
" Last Change:	2012 Oct 05
" 		2013 Jun 12: adjusted javaScriptRegexpString (Kevin Locke)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
" tuning parameters:
" unlet javaScript_fold

let s:cpo_save = &cpo
set cpo&vim

" Drop fold if it set but vim doesn't support it.
" syn clear javaScriptLabel
" syn clear javaScriptBranch
" syn clear javaScriptExceptions
" syn clear javaScriptIdentifier
syn keyword javaScriptConditional	if else switch case default
syn keyword javaScriptType		Array Boolean Date Function Number Object String RegExp
syn keyword javaScriptStatement		return with break continue var try catch finally
syn keyword javaScriptStatement		yield const let
syn keyword javaScriptNull		void null undefined
" syn keyword javaScriptBuiltin	        arguments this
syn keyword javaScriptException		throw
syn keyword javaScriptBuiltin		alert confirm prompt status
syn keyword javaScriptBuiltin		self window top parent
syn keyword javaScriptBuiltin		document location 

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink javaScriptConditional		Conditional
  HiLink javaScriptRepeat		Repeat
  HiLink javaScriptStatement		Statement
  HiLink javaScriptNull			Keyword

  HiLink javaScriptException		Exception
  HiLink javaScriptDeprecated		Exception 
  HiLink javaScriptReserved		Keyword
  HiLink javaScriptDebug		Debug
  HiLink javaScriptConstant		Label
  HiLink javaScriptBuiltin  Function

  delcommand HiLink
endif

let b:current_syntax = "javascript"
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8

