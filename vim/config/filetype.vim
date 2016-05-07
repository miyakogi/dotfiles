" Vim support file to detect file types
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2015 Dec 03

" Listen very carefully, I will say this only once
if exists("did_load_filetypes")
  finish
endif
let did_load_filetypes = 1

" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect

" Pattern used to match file names which should not be inspected.
" Currently finds compressed files.
if !exists("g:ft_ignore_pat")
  let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\)$'
endif

" Function used for patterns that end in a star: don't set the filetype if the
" file name matches ft_ignore_pat.
func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc

" Ant
au BufNewFile,BufRead build.xml			setf ant

" Apache style config file
au BufNewFile,BufRead proftpd.conf*		call s:StarSetf('apachestyle')

" Apache config file
au BufNewFile,BufRead .htaccess,*/etc/httpd/*.conf		setf apache

" ALSA configuration
au BufNewFile,BufRead .asoundrc,*/usr/share/alsa/alsa.conf,*/etc/asound.conf setf alsaconf

" AsciiDoc
au BufNewFile,BufRead *.asciidoc,*.adoc		setf asciidoc

" Active Server Pages (with Visual Basic Script)
au BufNewFile,BufRead *.asa
	\ if exists("g:filetype_asa") |
	\   exe "setf " . g:filetype_asa |
	\ else |
	\   setf aspvbs |
	\ endif

" Active Server Pages (with Perl or Visual Basic Script)
au BufNewFile,BufRead *.asp
	\ if exists("g:filetype_asp") |
	\   exe "setf " . g:filetype_asp |
	\ elseif getline(1) . getline(2) . getline(3) =~? "perlscript" |
	\   setf aspperl |
	\ else |
	\   setf aspvbs |
	\ endif

" Grub (must be before catch *.lst)
au BufNewFile,BufRead */boot/grub/menu.lst,*/boot/grub/grub.conf,*/etc/grub.conf setf grub

" Assembly (all kinds)
" *.lst is not pure assembly, it has two extra columns (address, byte codes)
au BufNewFile,BufRead *.asm,*.[sS],*.[aA],*.mac,*.lst	call s:FTasm()

" This function checks for the kind of assembly that is wanted by the user, or
" can be detected from the first five lines of the file.
func! s:FTasm()
  " make sure b:asmsyntax exists
  if !exists("b:asmsyntax")
    let b:asmsyntax = ""
  endif

  if b:asmsyntax == ""
    call s:FTasmsyntax()
  endif

  " if b:asmsyntax still isn't set, default to asmsyntax or GNU
  if b:asmsyntax == ""
    if exists("g:asmsyntax")
      let b:asmsyntax = g:asmsyntax
    else
      let b:asmsyntax = "asm"
    endif
  endif

  exe "setf " . fnameescape(b:asmsyntax)
endfunc

func! s:FTasmsyntax()
  " see if file contains any asmsyntax=foo overrides. If so, change
  " b:asmsyntax appropriately
  let head = " ".getline(1)." ".getline(2)." ".getline(3)." ".getline(4).
	\" ".getline(5)." "
  let match = matchstr(head, '\sasmsyntax=\zs[a-zA-Z0-9]\+\ze\s')
  if match != ''
    let b:asmsyntax = match
  elseif ((head =~? '\.title') || (head =~? '\.ident') || (head =~? '\.macro') || (head =~? '\.subtitle') || (head =~? '\.library'))
    let b:asmsyntax = "vmasm"
  endif
endfunc

" Autohotkey
au BufNewFile,BufRead *.ahk			setf autohotkey

" Automake
au BufNewFile,BufRead [mM]akefile.am,GNUmakefile.am	setf automake

" Awk
au BufNewFile,BufRead *.awk			setf awk

" BASIC or Visual Basic
au BufNewFile,BufRead *.bas			call s:FTVB("basic")

" Check if one of the first five lines contains "VB_Name".  In that case it is
" probably a Visual Basic file.  Otherwise it's assumed to be "alt" filetype.
func! s:FTVB(alt)
  if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'VB_Name\|Begin VB\.\(Form\|MDIForm\|UserControl\)'
    setf vb
  else
    exe "setf " . a:alt
  endif
endfunc

" Visual Basic Script (close to Visual Basic) or Visual Basic .NET
au BufNewFile,BufRead *.vb,*.vbs,*.dsm,*.ctl	setf vb

" Batch file for MSDOS.
au BufNewFile,BufRead *.bat,*.sys		setf dosbatch
" *.cmd is close to a Batch file, but on OS/2 Rexx files also use *.cmd.
au BufNewFile,BufRead *.cmd
	\ if getline(1) =~ '^/\*' | setf rexx | else | setf dosbatch | endif

" BibTeX bibliography database file
au BufNewFile,BufRead *.bib			setf bib

" BibTeX Bibliography Style
au BufNewFile,BufRead *.bst			setf bst

" BIND configuration
au BufNewFile,BufRead named.conf,rndc.conf	setf named

" BIND zone
au BufNewFile,BufRead named.root		setf bindzone
au BufNewFile,BufRead *.db			call s:BindzoneCheck('')

func! s:BindzoneCheck(default)
  if getline(1).getline(2).getline(3).getline(4) =~ '^; <<>> DiG [0-9.]\+ <<>>\|BIND.*named\|$ORIGIN\|$TTL\|IN\s\+SOA'
    setf bindzone
  elseif a:default != ''
    exe 'setf ' . a:default
  endif
endfunc

" Bazel (http://bazel.io)
autocmd BufRead,BufNewFile *.bzl,BUILD,WORKSPACE setfiletype bzl

" C
au BufNewFile,BufRead *.c			setf c

" Calendar
au BufNewFile,BufRead calendar			setf calendar

" C#
au BufNewFile,BufRead *.cs			setf cs

" CSDL
au BufNewFile,BufRead *.csdl			setf csdl

" Cabal
au BufNewFile,BufRead *.cabal			setf cabal

" ChaiScript
au BufRead,BufNewFile *.chai			setf chaiscript

" Comshare Dimension Definition Language
au BufNewFile,BufRead *.cdl			setf cdl

" .cc and .cpp files can be C++
au BufNewFile,BufRead *.cc setf cpp
au BufNewFile,BufRead *.cpp setf cpp

" C++
au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl setf cpp
if has("fname_case")
  au BufNewFile,BufRead *.C,*.H setf cpp
endif

" .h files can be C, Ch C++, ObjC or ObjC++.
" Set c_syntax_for_h if you want C, ch_syntax_for_h if you want Ch. ObjC is
" detected automatically.
au BufNewFile,BufRead *.h			call s:FTheader()

func! s:FTheader()
  if match(getline(1, min([line("$"), 200])), '^@\(interface\|end\|class\)') > -1
    if exists("g:c_syntax_for_h")
      setf objc
    else
      setf objcpp
    endif
  elseif exists("g:c_syntax_for_h")
    setf c
  elseif exists("g:ch_syntax_for_h")
    setf ch
  else
    setf cpp
  endif
endfunc

" TLH files are C++ headers generated by Visual C++'s #import from typelibs
au BufNewFile,BufRead *.tlh			setf cpp

" Cascading Style Sheets
au BufNewFile,BufRead *.css			setf css

" Century Term Command Scripts (*.cmd too)
au BufNewFile,BufRead *.con			setf cterm

" Changelog
au BufNewFile,BufRead changelog.Debian,changelog.dch,NEWS.Debian,NEWS.dch
					\	setf debchangelog

au BufNewFile,BufRead [cC]hange[lL]og
	\  if getline(1) =~ '; urgency='
	\|   setf debchangelog
	\| else
	\|   setf changelog
	\| endif

au BufNewFile,BufRead NEWS
	\  if getline(1) =~ '; urgency='
	\|   setf debchangelog
	\| endif

" Clipper (or FoxPro; could also be eviews)
au BufNewFile,BufRead *.prg
	\ if exists("g:filetype_prg") |
	\   exe "setf " . g:filetype_prg |
	\ else |
	\   setf clipper |
	\ endif

" Clojure
au BufNewFile,BufRead *.clj,*.cljs,*.cljx,*.cljc		setf clojure

" Cmake
au BufNewFile,BufRead CMakeLists.txt,*.cmake,*.cmake.in		setf cmake

" Cobol
au BufNewFile,BufRead *.cbl,*.cob,*.lib	setf cobol
"   cobol or zope form controller python script? (heuristic)
au BufNewFile,BufRead *.cpy
	\ if getline(1) =~ '^##' |
	\   setf python |
	\ else |
	\   setf cobol |
	\ endif

" Configure scripts
au BufNewFile,BufRead configure.in,configure.ac setf config

" CUDA  Cumpute Unified Device Architecture
au BufNewFile,BufRead *.cu			setf cuda

" Dockerfile
au BufNewFile,BufRead Dockerfile		setf dockerfile

" WildPackets EtherPeek Decoder
au BufNewFile,BufRead *.dcd			setf dcd

" Enlightenment configuration files
au BufNewFile,BufRead *enlightenment/*.cfg	setf c

" Eterm
au BufNewFile,BufRead *Eterm/*.cfg		setf eterm

" Lynx config files
au BufNewFile,BufRead lynx.cfg			setf lynx

" Quake
au BufNewFile,BufRead *baseq[2-3]/*.cfg,*id1/*.cfg	setf quake
au BufNewFile,BufRead *quake[1-3]/*.cfg			setf quake

" Quake C
au BufNewFile,BufRead *.qc			setf c

" Configure files
au BufNewFile,BufRead *.cfg			setf cfg

" Cucumber
au BufNewFile,BufRead *.feature			setf cucumber

" Debian Control
au BufNewFile,BufRead */debian/control		setf debcontrol
au BufNewFile,BufRead control
	\  if getline(1) =~ '^Source:'
	\|   setf debcontrol
	\| endif

" Debian Sources.list
au BufNewFile,BufRead */etc/apt/sources.list		setf debsources
au BufNewFile,BufRead */etc/apt/sources.list.d/*.list	setf debsources

" Deny hosts
au BufNewFile,BufRead denyhosts.conf		setf denyhosts

" dnsmasq(8) configuration files
au BufNewFile,BufRead */etc/dnsmasq.conf	setf dnsmasq

" the D language or dtrace
au BufNewFile,BufRead *.d			call s:DtraceCheck()

func! s:DtraceCheck()
  let lines = getline(1, min([line("$"), 100]))
  if match(lines, '^module\>\|^import\>') > -1
    " D files often start with a module and/or import statement.
    setf d
  elseif match(lines, '^#!\S\+dtrace\|#pragma\s\+D\s\+option\|:\S\{-}:\S\{-}:') > -1
    setf dtrace
  else
    setf d
  endif
endfunc

" Desktop files
au BufNewFile,BufRead *.desktop,.directory	setf desktop

" Dict config
au BufNewFile,BufRead dict.conf,.dictrc		setf dictconf

" Dictd config
au BufNewFile,BufRead dictd.conf		setf dictdconf

" Diff files
au BufNewFile,BufRead *.diff,*.rej,*.patch	setf diff

" Dircolors
au BufNewFile,BufRead .dir_colors,.dircolors,*/etc/DIR_COLORS	setf dircolors

" DCL (Digital Command Language - vms) or DNS zone file
au BufNewFile,BufRead *.com			call s:BindzoneCheck('dcl')

" DOT
au BufNewFile,BufRead *.dot			setf dot

" Microsoft Module Definition
au BufNewFile,BufRead *.def			setf def

" dsl
au BufNewFile,BufRead *.dsl			setf dsl

" DTD (Document Type Definition for XML)
au BufNewFile,BufRead *.dtd			setf dtd

" Elinks configuration
au BufNewFile,BufRead */etc/elinks.conf,*/.elinks/elinks.conf	setf elinks

" ERicsson LANGuage; Yaws is erlang too
au BufNewFile,BufRead *.erl,*.hrl,*.yaws	setf erlang

" Elm Filter Rules file
au BufNewFile,BufRead filter-rules		setf elmfilt

" ESMTP rc file
au BufNewFile,BufRead *esmtprc			setf esmtprc

" Falcon
au BufNewFile,BufRead *.fal			setf falcon

" Fortran
if has("fname_case")
  au BufNewFile,BufRead *.F,*.FOR,*.FPP,*.FTN,*.F77,*.F90,*.F95,*.F03,*.F08	 setf fortran
endif
au BufNewFile,BufRead   *.f,*.for,*.fortran,*.fpp,*.ftn,*.f77,*.f90,*.f95,*.f03,*.f08  setf fortran

" GDB command files
au BufNewFile,BufRead .gdbinit			setf gdb

" Git
au BufNewFile,BufRead COMMIT_EDITMSG		setf gitcommit
au BufNewFile,BufRead MERGE_MSG			setf gitcommit
au BufNewFile,BufRead *.git/config,.gitconfig,.gitmodules setf gitconfig
au BufNewFile,BufRead *.git/modules/*/config	setf gitconfig
au BufNewFile,BufRead */.config/git/config	setf gitconfig
if !empty($XDG_CONFIG_HOME)
  au BufNewFile,BufRead $XDG_CONFIG_HOME/git/config	setf gitconfig
endif
au BufNewFile,BufRead git-rebase-todo		setf gitrebase
au BufNewFile,BufRead .msg.[0-9]*
      \ if getline(1) =~ '^From.*# This line is ignored.$' |
      \   setf gitsendemail |
      \ endif
au BufNewFile,BufRead *.git/*
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   setf git |
      \ endif

" GPG
au BufNewFile,BufRead */.gnupg/options		setf gpg
au BufNewFile,BufRead */.gnupg/gpg.conf		setf gpg
au BufNewFile,BufRead */usr/*/gnupg/options.skel setf gpg

" gnash(1) configuration files
au BufNewFile,BufRead gnashrc,.gnashrc,gnashpluginrc,.gnashpluginrc setf gnash

" Gitolite
au BufNewFile,BufRead gitolite.conf		setf gitolite
au BufNewFile,BufRead */gitolite-admin/conf/*	call s:StarSetf('gitolite')
au BufNewFile,BufRead {,.}gitolite.rc,example.gitolite.rc	setf perl

" Gnuplot scripts
au BufNewFile,BufRead *.gpi			setf gnuplot

" Go (Google)
au BufNewFile,BufRead *.go			setf go

" Groovy
au BufNewFile,BufRead *.gradle,*.groovy		setf groovy

" Group file
au BufNewFile,BufRead */etc/group,*/etc/group-,*/etc/group.edit,*/etc/gshadow,*/etc/gshadow-,*/etc/gshadow.edit,*/var/backups/group.bak,*/var/backups/gshadow.bak  setf group

" GTK RC
au BufNewFile,BufRead .gtkrc,gtkrc		setf gtkrc

" Haml
au BufNewFile,BufRead *.haml			setf haml

" Haskell
au BufNewFile,BufRead *.hs,*.hs-boot		setf haskell
au BufNewFile,BufRead *.lhs			setf lhaskell
au BufNewFile,BufRead *.chs			setf chaskell

" HEX (Intel)
au BufNewFile,BufRead *.hex,*.h32		setf hex

" HTML (.shtml and .stm for server side)
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()

" Distinguish between HTML, XHTML and Django
func! s:FThtml()
  let n = 1
  while n < 10 && n < line("$")
    if getline(n) =~ '\<DTD\s\+XHTML\s'
      setf xhtml
      return
    endif
    if getline(n) =~ '{%\s*\(extends\|block\|load\)\>\|{#\s\+'
      setf htmldjango
      return
    endif
    let n = n + 1
  endwhile
  setf html
endfunc

" HTML with Ruby - eRuby
au BufNewFile,BufRead *.erb,*.rhtml		setf eruby

" HTML Cheetah template
au BufNewFile,BufRead *.tmpl			setf htmlcheetah

" Host config
au BufNewFile,BufRead */etc/host.conf		setf hostconf

" Hosts access
au BufNewFile,BufRead */etc/hosts.allow,*/etc/hosts.deny  setf hostsaccess

" Icon
au BufNewFile,BufRead *.icn			setf icon

" IDL (Interface Description Language)
au BufNewFile,BufRead *.idl			call s:FTidl()

" Distinguish between standard IDL and MS-IDL
func! s:FTidl()
  let n = 1
  while n < 50 && n < line("$")
    if getline(n) =~ '^\s*import\s\+"\(unknwn\|objidl\)\.idl"'
      setf msidl
      return
    endif
    let n = n + 1
  endwhile
  setf idl
endfunc

" Microsoft IDL (Interface Description Language)  Also *.idl
" MOF = WMI (Windows Management Instrumentation) Managed Object Format
au BufNewFile,BufRead *.odl,*.mof		setf msidl

" Indent RC
au BufNewFile,BufRead indentrc			setf indent

" Inform
au BufNewFile,BufRead *.inf,*.INF		setf inform

" Initng
au BufNewFile,BufRead */etc/initng/*/*.i,*.ii	setf initng

" Ipfilter
au BufNewFile,BufRead ipf.conf,ipf6.conf,ipf.rules	setf ipfilter

" .INI file for MSDOS
au BufNewFile,BufRead *.ini			setf dosini

" SysV Inittab
au BufNewFile,BufRead inittab			setf inittab

" Inno Setup
au BufNewFile,BufRead *.iss			setf iss

" Java
au BufNewFile,BufRead *.java,*.jav		setf java

" JavaCC
au BufNewFile,BufRead *.jj,*.jjt		setf javacc

" JavaScript, ECMAScript
au BufNewFile,BufRead *.js,*.javascript,*.es,*.jsx   setf javascript

" Java Server Pages
au BufNewFile,BufRead *.jsp			setf jsp

" JSON
au BufNewFile,BufRead *.json,*.jsonp		setf json

" Kivy
au BufNewFile,BufRead *.kv			setf kivy

" KDE script
au BufNewFile,BufRead *.ks			setf kscript

" Kconfig
au BufNewFile,BufRead Kconfig,Kconfig.debug	setf kconfig

" Limits
au BufNewFile,BufRead */etc/limits,*/etc/*limits.conf,*/etc/*limits.d/*.conf	setf limits

" LambdaProlog (*.mod too, see Modsim)
au BufNewFile,BufRead *.sig			setf lprolog

" LDAP LDIF
au BufNewFile,BufRead *.ldif			setf ldif

" Less
au BufNewFile,BufRead *.less			setf less

" Libao
au BufNewFile,BufRead */etc/libao.conf,*/.libao	setf libao

" Libsensors
au BufNewFile,BufRead */etc/sensors.conf,*/etc/sensors3.conf	setf sensors

" LFTP
au BufNewFile,BufRead lftp.conf,.lftprc,*lftp/rc	setf lftp

" Lilo: Linux loader
au BufNewFile,BufRead lilo.conf			setf lilo

" Lisp (*.el = ELisp, *.cl = Common Lisp, *.jl = librep Lisp)
if has("fname_case")
  au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,*.L,.emacs,.sawfishrc setf lisp
else
  au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,.emacs,.sawfishrc setf lisp
endif

" SBCL implementation of Common Lisp
au BufNewFile,BufRead sbclrc,.sbclrc		setf lisp

" Liquid
au BufNewFile,BufRead *.liquid			setf liquid

" Lite
au BufNewFile,BufRead *.lite,*.lt		setf lite

" Login access
au BufNewFile,BufRead */etc/login.access	setf loginaccess

" Login defs
au BufNewFile,BufRead */etc/login.defs		setf logindefs

" Lua
au BufNewFile,BufRead *.lua			setf lua

" Luarocks
au BufNewFile,BufRead *.rockspec		setf lua

" Mail aliases
au BufNewFile,BufRead */etc/mail/aliases,*/etc/aliases	setf mailaliases

" Mailcap configuration file
au BufNewFile,BufRead .mailcap,mailcap		setf mailcap

" Makefile
au BufNewFile,BufRead *[mM]akefile,*.mk,*.mak,*.dsp setf make

" Manpage
au BufNewFile,BufRead *.man			setf man

" Man config
au BufNewFile,BufRead */etc/man.conf,man.config	setf manconf

" Markdown
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md  setf markdown

" Matlab or Objective C
au BufNewFile,BufRead *.m			call s:FTm()

func! s:FTm()
  let n = 1
  while n < 10
    let line = getline(n)
    if line =~ '^\s*\(#\s*\(include\|import\)\>\|@import\>\|/\*\|//\)'
      setf objc
      return
    endif
    if line =~ '^\s*%'
      setf matlab
      return
    endif
    if line =~ '^\s*(\*'
      setf mma
      return
    endif
    let n = n + 1
  endwhile
  if exists("g:filetype_m")
    exe "setf " . g:filetype_m
  else
    setf matlab
  endif
endfunc

" Mathematica notebook
au BufNewFile,BufRead *.nb			setf mma

" Maya Extension Language
au BufNewFile,BufRead *.mel			setf mel

" Mercurial (hg) commit file
au BufNewFile,BufRead hg-editor-*.txt		setf hgcommit

" Mercurial config (looks like generic config file)
au BufNewFile,BufRead *.hgrc,*hgrc		setf cfg

" Messages (logs mostly)
au BufNewFile,BufRead */log/{auth,cron,daemon,debug,kern,lpr,mail,messages,news/news,syslog,user}{,.log,.err,.info,.warn,.crit,.notice}{,.[0-9]*,-[0-9]*} setf messages

" Metafont
au BufNewFile,BufRead *.mf			setf mf

" Modula 2  (.md removed in favor of Markdown)
au BufNewFile,BufRead *.m2,*.DEF,*.MOD,*.mi	setf modula2

" Modula 3 (.m3, .i3, .mg, .ig)
au BufNewFile,BufRead *.[mi][3g]		setf modula3

" Modconf
au BufNewFile,BufRead */etc/modules.conf,*/etc/modules,*/etc/conf.modules setf modconf

" Mplayer config
au BufNewFile,BufRead mplayer.conf,*/.mplayer/config	setf mplayerconf

" Mrxvtrc
au BufNewFile,BufRead mrxvtrc,.mrxvtrc		setf mrxvtrc

" Msql
au BufNewFile,BufRead *.msql			setf msql

" Mysql
au BufNewFile,BufRead *.mysql			setf mysql

" M$ Resource files
au BufNewFile,BufRead *.rc,*.rch		setf rc

" Nano
au BufNewFile,BufRead */etc/nanorc,*.nanorc  	setf nanorc

" Netrc
au BufNewFile,BufRead .netrc			setf netrc

" Ninja file
au BufNewFile,BufRead *.ninja			setf ninja

" Nroff or Objective C++
au BufNewFile,BufRead *.mm			setf objcpp

" OCAML
au BufNewFile,BufRead *.ml,*.mli,*.mll,*.mly,.ocamlinit	setf ocaml

" Omnimark
au BufNewFile,BufRead *.xom,*.xin		setf omnimark

" Oracle config file
au BufNewFile,BufRead *.ora			setf ora

" Packet filter conf
au BufNewFile,BufRead pf.conf			setf pf

" Pam conf
au BufNewFile,BufRead */etc/pam.conf		setf pamconf

" Password file
au BufNewFile,BufRead */etc/passwd,*/etc/passwd-,*/etc/passwd.edit,*/etc/shadow,*/etc/shadow-,*/etc/shadow.edit,*/var/backups/passwd.bak,*/var/backups/shadow.bak setf passwd

" Pascal (also *.p)
au BufNewFile,BufRead *.pas			setf pascal

" Delphi project file
au BufNewFile,BufRead *.dpr			setf pascal

" PDF
au BufNewFile,BufRead *.pdf			setf pdf

" Perl
if has("fname_case")
  au BufNewFile,BufRead *.pl,*.PL		call s:FTpl()
else
  au BufNewFile,BufRead *.pl			call s:FTpl()
endif
au BufNewFile,BufRead *.plx,*.al		setf perl
au BufNewFile,BufRead *.p6,*.pm6,*.pl6		setf perl6

func! s:FTpl()
  if exists("g:filetype_pl")
    exe "setf " . g:filetype_pl
  else
    " recognize Prolog by specific text in the first non-empty line
    " require a blank after the '%' because Perl uses "%list" and "%translate"
    let l = getline(nextnonblank(1))
    if l =~ '\<prolog\>' || l =~ '^\s*\(%\+\(\s\|$\)\|/\*\)' || l =~ ':-'
      setf prolog
    else
      setf perl
    endif
  endif
endfunc

" Perl, XPM or XPM2
au BufNewFile,BufRead *.pm
	\ if getline(1) =~ "XPM2" |
	\   setf xpm2 |
	\ elseif getline(1) =~ "XPM" |
	\   setf xpm |
	\ else |
	\   setf perl |
	\ endif

" Perl POD
au BufNewFile,BufRead *.pod			setf pod
au BufNewFile,BufRead *.pod6			setf pod6

" Php, php3, php4, etc.
" Also Phtml (was used for PHP 2 in the past)
" Also .ctp for Cake template file
au BufNewFile,BufRead *.php,*.php\d,*.phtml,*.ctp	setf php

" Pinfo config
au BufNewFile,BufRead */etc/pinforc,*/.pinforc	setf pinfo

" Pine config
au BufNewFile,BufRead .pinerc,pinerc,.pinercex,pinercex		setf pine

" PO and PO template (GNU gettext)
au BufNewFile,BufRead *.po,*.pot		setf po

" PostScript (+ font files, encapsulated PostScript, Adobe Illustrator)
au BufNewFile,BufRead *.ps,*.pfa,*.afm,*.eps,*.epsf,*.epsi,*.ai	  setf postscr

" PostScript Printer Description
au BufNewFile,BufRead *.ppd			setf ppd

" Povray, PHP or assembly
au BufNewFile,BufRead *.inc			setf php

" Printcap and Termcap
au BufNewFile,BufRead *printcap
	\ let b:ptcap_type = "print" | setf ptcap
au BufNewFile,BufRead *termcap
	\ let b:ptcap_type = "term" | setf ptcap

" Progress or Pascal
au BufNewFile,BufRead *.p			setf pascal

" Software Distributor Product Specification File (POSIX 1387.2-1995)
au BufNewFile,BufRead *.psf			setf psf
au BufNewFile,BufRead INDEX,INFO
	\ if getline(1) =~ '^\s*\(distribution\|installed_software\|root\|bundle\|product\)\s*$' |
	\   setf psf |
	\ endif

" Prolog
au BufNewFile,BufRead *.pdb			setf prolog

" Google protocol buffers
au BufNewFile,BufRead *.proto			setf proto

" Protocols
au BufNewFile,BufRead */etc/protocols		setf protocols

" Pyrex
au BufNewFile,BufRead *.pyx,*.pxd		setf pyrex

" Python
au BufNewFile,BufRead *.py,*.pyw,*pyi		setf python

" Ratpoison config/command files
au BufNewFile,BufRead .ratpoisonrc,ratpoisonrc	setf ratpoison

" Readline
au BufNewFile,BufRead .inputrc,inputrc		setf readline

" Registry for MS-Windows
au BufNewFile,BufRead *.reg
	\ if getline(1) =~? '^REGEDIT[0-9]*\s*$\|^Windows Registry Editor Version \d*\.\d*\s*$' | setf registry | endif

" R (Splus)
if has("fname_case")
  au BufNewFile,BufRead *.s,*.S			setf r
else
  au BufNewFile,BufRead *.s			setf r
endif

" R Help file
if has("fname_case")
  au BufNewFile,BufRead *.rd,*.Rd		setf rhelp
else
  au BufNewFile,BufRead *.rd			setf rhelp
endif

" R noweb file
if has("fname_case")
  au BufNewFile,BufRead *.Rnw,*.rnw,*.Snw,*.snw		setf rnoweb
else
  au BufNewFile,BufRead *.rnw,*.snw			setf rnoweb
endif

" R Markdown file
if has("fname_case")
  au BufNewFile,BufRead *.Rmd,*.rmd,*.Smd,*.smd		setf rmd
else
  au BufNewFile,BufRead *.rmd,*.smd			setf rmd
endif

" R reStructuredText file
if has("fname_case")
  au BufNewFile,BufRead *.Rrst,*.rrst,*.Srst,*.srst	setf rrst
else
  au BufNewFile,BufRead *.rrst,*.srst			setf rrst
endif

" Rexx, Rebol or R
au BufNewFile,BufRead *.r,*.R			call s:FTr()

func! s:FTr()
  let max = line("$") > 50 ? 50 : line("$")

  for n in range(1, max)
    " Rebol is easy to recognize, check for that first
    if getline(n) =~? '\<REBOL\>'
      setf rebol
      return
    endif
  endfor

  for n in range(1, max)
    " R has # comments
    if getline(n) =~ '^\s*#'
      setf r
      return
    endif
    " Rexx has /* comments */
    if getline(n) =~ '^\s*/\*'
      setf rexx
      return
    endif
  endfor

  " Nothing recognized, use user default or assume Rexx
  if exists("g:filetype_r")
    exe "setf " . g:filetype_r
  else
    " Rexx used to be the default, but R appears to be much more popular.
    setf r
  endif
endfunc

" Resolv.conf
au BufNewFile,BufRead resolv.conf		setf resolv

" Robots.txt
au BufNewFile,BufRead robots.txt		setf robots

" reStructuredText Documentation Format
au BufNewFile,BufRead *.rst			setf rst

" RTF
au BufNewFile,BufRead *.rtf			setf rtf

" Interactive Ruby shell
au BufNewFile,BufRead .irbrc,irbrc		setf ruby

" Ruby
au BufNewFile,BufRead *.rb,*.rbw		setf ruby

" RubyGems
au BufNewFile,BufRead *.gemspec			setf ruby

" Rackup
au BufNewFile,BufRead *.ru			setf ruby

" Bundler
au BufNewFile,BufRead Gemfile			setf ruby

" Ruby on Rails
au BufNewFile,BufRead *.builder,*.rxml,*.rjs	setf ruby

" Rantfile and Rakefile is like Ruby
au BufNewFile,BufRead [rR]antfile,*.rant,[rR]akefile,*.rake	setf ruby

" Samba config
au BufNewFile,BufRead smb.conf			setf samba

" SAS script
au BufNewFile,BufRead *.sas			setf sas

" Sass
au BufNewFile,BufRead *.sass			setf sass

" Scilab
au BufNewFile,BufRead *.sci,*.sce		setf scilab

" SCSS
au BufNewFile,BufRead *.scss			setf scss

" sed
au BufNewFile,BufRead *.sed			setf sed

" Sendmail
au BufNewFile,BufRead sendmail.cf		setf sm

" Sendmail .mc files are actually m4.  Could also be MS Message text file.
au BufNewFile,BufRead *.mc			call s:McSetf()

func! s:McSetf()
  " Rely on the file to start with a comment.
  " MS message text files use ';', Sendmail files use '#' or 'dnl'
  for lnum in range(1, min([line("$"), 20]))
    let line = getline(lnum)
    if line =~ '^\s*\(#\|dnl\)'
      setf m4  " Sendmail .mc file
      return
    elseif line =~ '^\s*;'
      setf msmessages  " MS Message text file
      return
    endif
  endfor
  setf m4  " Default: Sendmail .mc file
endfunc

" Services
au BufNewFile,BufRead */etc/services		setf services

" Service Location config
au BufNewFile,BufRead */etc/slp.conf		setf slpconf

" Service Location registration
au BufNewFile,BufRead */etc/slp.reg		setf slpreg

" Service Location SPI
au BufNewFile,BufRead */etc/slp.spi		setf slpspi

" Setserial config
au BufNewFile,BufRead */etc/serial.conf		setf setserial

" SGML
au BufNewFile,BufRead *.sgm,*.sgml
	\ if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'linuxdoc' |
	\   setf sgmllnx |
	\ elseif getline(1) =~ '<!DOCTYPE.*DocBook' || getline(2) =~ '<!DOCTYPE.*DocBook' |
	\   let b:docbk_type = "sgml" |
	\   let b:docbk_ver = 4 |
	\   setf docbk |
	\ else |
	\   setf sgml |
	\ endif

" SGMLDECL
au BufNewFile,BufRead *.decl,*.dcl,*.dec
	\ if getline(1).getline(2).getline(3) =~? '^<!SGML' |
	\    setf sgmldecl |
	\ endif

" SGML catalog file
au BufNewFile,BufRead catalog			setf catalog
au BufNewFile,BufRead sgml.catalog*		call s:StarSetf('catalog')

" Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
" Gentoo ebuilds are actually bash scripts
au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash[_-]profile*,.bash[_-]logout*,.bash[_-]aliases*,*.bash,*/{,.}bash[_-]completion{,.d,.sh}{,/*},*.ebuild,*.eclass call SetFileTypeSH("bash")
au BufNewFile,BufRead .kshrc*,*.ksh call SetFileTypeSH("ksh")
au BufNewFile,BufRead */etc/profile,.profile*,*.sh,*.env call SetFileTypeSH(getline(1))

" Also called from scripts.vim.
func! SetFileTypeSH(name)
  if expand("<amatch>") =~ g:ft_ignore_pat
    return
  endif
  if a:name =~ '\<csh\>'
    " Some .sh scripts contain #!/bin/csh.
    call SetFileTypeShell("csh")
    return
  elseif a:name =~ '\<tcsh\>'
    " Some .sh scripts contain #!/bin/tcsh.
    call SetFileTypeShell("tcsh")
    return
  elseif a:name =~ '\<zsh\>'
    " Some .sh scripts contain #!/bin/zsh.
    call SetFileTypeShell("zsh")
    return
  elseif a:name =~ '\<ksh\>'
    let b:is_kornshell = 1
    if exists("b:is_bash")
      unlet b:is_bash
    endif
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif exists("g:bash_is_sh") || a:name =~ '\<bash\>' || a:name =~ '\<bash2\>'
    let b:is_bash = 1
    if exists("b:is_kornshell")
      unlet b:is_kornshell
    endif
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif a:name =~ '\<sh\>'
    let b:is_sh = 1
    if exists("b:is_kornshell")
      unlet b:is_kornshell
    endif
    if exists("b:is_bash")
      unlet b:is_bash
    endif
  endif
  call SetFileTypeShell("sh")
endfunc

" For shell-like file types, check for an "exec" command hidden in a comment,
" as used for Tcl.
" Also called from scripts.vim, thus can't be local to this script.
func! SetFileTypeShell(name)
  if expand("<amatch>") =~ g:ft_ignore_pat
    return
  endif
  let l = 2
  while l < 20 && l < line("$") && getline(l) =~ '^\s*\(#\|$\)'
    " Skip empty and comment lines.
    let l = l + 1
  endwhile
  if l < line("$") && getline(l) =~ '\s*exec\s' && getline(l - 1) =~ '^\s*#.*\\$'
    " Found an "exec" line after a comment with continuation
    let n = substitute(getline(l),'\s*exec\s\+\([^ ]*/\)\=', '', '')
    if n =~ '\<tclsh\|\<wish'
      setf tcl
      return
    endif
  endif
  exe "setf " . a:name
endfunc

" tcsh scripts
au BufNewFile,BufRead .tcshrc*,*.tcsh,tcsh.tcshrc,tcsh.login	call SetFileTypeShell("tcsh")

" csh scripts, but might also be tcsh scripts (on some systems csh is tcsh)
au BufNewFile,BufRead .login*,.cshrc*,csh.cshrc,csh.login,csh.logout,*.csh,.alias  call s:CSH()

func! s:CSH()
  if exists("g:filetype_csh")
    call SetFileTypeShell(g:filetype_csh)
  elseif &shell =~ "tcsh"
    call SetFileTypeShell("tcsh")
  else
    call SetFileTypeShell("csh")
  endif
endfunc

" Z-Shell script
au BufNewFile,BufRead .zprofile,*/etc/zprofile,.zfbfmarks  setf zsh
au BufNewFile,BufRead .zsh*,.zlog*,.zcompdump*  call s:StarSetf('zsh')
au BufNewFile,BufRead *.zsh			setf zsh

" Scheme
au BufNewFile,BufRead *.scm,*.ss,*.rkt		setf scheme

" Screen RC
au BufNewFile,BufRead .screenrc,screenrc	setf screen

" Smalltalk (and TeX)
au BufNewFile,BufRead *.st			setf st
au BufNewFile,BufRead *.cls
	\ if getline(1) =~ '^%' |
	\  setf tex |
	\ elseif getline(1)[0] == '#' && getline(1) =~ 'rexx' |
	\  setf rexx |
	\ else |
	\  setf st |
	\ endif

" Smarty templates
au BufNewFile,BufRead *.tpl			setf smarty

" SMIL or XML
au BufNewFile,BufRead *.smil
	\ if getline(1) =~ '<?\s*xml.*?>' |
	\   setf xml |
	\ else |
	\   setf smil |
	\ endif

" SMIL or SNMP MIB file
au BufNewFile,BufRead *.smi
	\ if getline(1) =~ '\<smil\>' |
	\   setf smil |
	\ else |
	\   setf mib |
	\ endif

" Snort Configuration
au BufNewFile,BufRead *.hog,snort.conf,vision.conf	setf hog
au BufNewFile,BufRead *.rules			call s:FTRules()

let s:ft_rules_udev_rules_pattern = '^\s*\cudev_rules\s*=\s*"\([^"]\{-1,}\)/*".*'
func! s:FTRules()
  let path = expand('<amatch>:p')
  if path =~ '^/\(etc/udev/\%(rules\.d/\)\=.*\.rules\|lib/udev/\%(rules\.d/\)\=.*\.rules\)$'
    setf udevrules
    return
  endif
  if path =~ '^/etc/ufw/'
    setf conf  " Better than hog
    return
  endif
  if path =~ '^/\(etc\|usr/share\)/polkit-1/rules\.d'
    setf javascript
    return
  endif
  try
    let config_lines = readfile('/etc/udev/udev.conf')
  catch /^Vim\%((\a\+)\)\=:E484/
    setf hog
    return
  endtry
  let dir = expand('<amatch>:p:h')
  for line in config_lines
    if line =~ s:ft_rules_udev_rules_pattern
      let udev_rules = substitute(line, s:ft_rules_udev_rules_pattern, '\1', "")
      if dir == udev_rules
        setf udevrules
      endif
      break
    endif
  endfor
  setf hog
endfunc

" Spec (Linux RPM)
au BufNewFile,BufRead *.spec			setf spec

" Squid
au BufNewFile,BufRead squid.conf		setf squid

" SQL for Oracle Designer
au BufNewFile,BufRead *.tyb,*.typ,*.tyc,*.pkb,*.pks	setf sql

" SQL
au BufNewFile,BufRead *.sql			call s:SQL()

func! s:SQL()
  if exists("g:filetype_sql")
    exe "setf " . g:filetype_sql
  else
    setf sql
  endif
endfunc

" OpenSSH configuration
au BufNewFile,BufRead ssh_config,*/.ssh/config	setf sshconfig

" OpenSSH server configuration
au BufNewFile,BufRead sshd_config		setf sshdconfig

" Stored Procedures
au BufNewFile,BufRead *.stp			setf stp

" Standard ML
au BufNewFile,BufRead *.sml			setf sml

" Sysctl
au BufNewFile,BufRead */etc/sysctl.conf,*/etc/sysctl.d/*.conf	setf sysctl

" Systemd unit files
au BufNewFile,BufRead */systemd/*.{automount,mount,path,service,socket,swap,target,timer}	setf systemd

" Sudoers
au BufNewFile,BufRead */etc/sudoers,sudoers.tmp	setf sudoers

" SVG (Scalable Vector Graphics)
au BufNewFile,BufRead *.svg			setf svg

" Tags
au BufNewFile,BufRead tags			setf tags

" Task
au BufRead,BufNewFile {pending,completed,undo}.data  setf taskdata
au BufRead,BufNewFile *.task			setf taskedit

" Tcl (JACL too)
au BufNewFile,BufRead *.tcl,*.tk,*.itcl,*.itk,*.jacl	setf tcl

" Tera Term Language
au BufRead,BufNewFile *.ttl			setf teraterm

" Terminfo
au BufNewFile,BufRead *.ti			setf terminfo

" TeX
au BufNewFile,BufRead *.latex,*.sty,*.dtx,*.ltx,*.bbl	setf tex
au BufNewFile,BufRead *.tex			call s:FTtex()

" Choose context, plaintex, or tex (LaTeX) based on these rules:
" 1. Check the first line of the file for "%&<format>".
" 2. Check the first 1000 non-comment lines for LaTeX or ConTeXt keywords.
" 3. Default to "latex" or to g:tex_flavor, can be set in user's vimrc.
func! s:FTtex()
  let firstline = getline(1)
  if firstline =~ '^%&\s*\a\+'
    let format = tolower(matchstr(firstline, '\a\+'))
    let format = substitute(format, 'pdf', '', '')
    if format == 'tex'
      let format = 'plain'
    endif
  else
    " Default value, may be changed later:
    let format = exists("g:tex_flavor") ? g:tex_flavor : 'plain'
    " Save position, go to the top of the file, find first non-comment line.
    let save_cursor = getpos('.')
    call cursor(1,1)
    let firstNC = search('^\s*[^[:space:]%]', 'c', 1000)
    if firstNC " Check the next thousand lines for a LaTeX or ConTeXt keyword.
      let lpat = 'documentclass\>\|usepackage\>\|begin{\|newcommand\>\|renewcommand\>'
      let cpat = 'start\a\+\|setup\a\+\|usemodule\|enablemode\|enableregime\|setvariables\|useencoding\|usesymbols\|stelle\a\+\|verwende\a\+\|stel\a\+\|gebruik\a\+\|usa\a\+\|imposta\a\+\|regle\a\+\|utilisemodule\>'
      let kwline = search('^\s*\\\%(' . lpat . '\)\|^\s*\\\(' . cpat . '\)',
			      \ 'cnp', firstNC + 1000)
      if kwline == 1	" lpat matched
	let format = 'latex'
      elseif kwline == 2	" cpat matched
	let format = 'context'
      endif		" If neither matched, keep default set above.
      " let lline = search('^\s*\\\%(' . lpat . '\)', 'cn', firstNC + 1000)
      " let cline = search('^\s*\\\%(' . cpat . '\)', 'cn', firstNC + 1000)
      " if cline > 0
      "   let format = 'context'
      " endif
      " if lline > 0 && (cline == 0 || cline > lline)
      "   let format = 'tex'
      " endif
    endif " firstNC
    call setpos('.', save_cursor)
  endif " firstline =~ '^%&\s*\a\+'

  " Translation from formats to file types.  TODO:  add AMSTeX, RevTex, others?
  if format == 'plain'
    setf plaintex
  elseif format == 'context'
    setf context
  else " probably LaTeX
    setf tex
  endif
  return
endfunc

" ConTeXt
au BufNewFile,BufRead tex/context/*/*.tex,*.mkii,*.mkiv   setf context

" Texinfo
au BufNewFile,BufRead *.texinfo,*.texi,*.txi	setf texinfo

" TeX configuration
au BufNewFile,BufRead texmf.cnf			setf texmf

" Tidy config
au BufNewFile,BufRead .tidyrc,tidyrc		setf tidy

" TF mud client
au BufNewFile,BufRead *.tf,.tfrc,tfrc		setf tf

" TWIG files
au BufNewFile,BufReadPost *.twig		setf twig

" Udev conf
au BufNewFile,BufRead */etc/udev/udev.conf	setf udevconf

" Udev permissions
au BufNewFile,BufRead */etc/udev/permissions.d/*.permissions setf udevperm
"
" Udev symlinks config
au BufNewFile,BufRead */etc/udev/cdsymlinks.conf	setf sh

" Updatedb
au BufNewFile,BufRead */etc/updatedb.conf	setf updatedb

" Upstart (init(8)) config files
au BufNewFile,BufRead */usr/share/upstart/*.conf	       setf upstart
au BufNewFile,BufRead */usr/share/upstart/*.override	       setf upstart
au BufNewFile,BufRead */etc/init/*.conf,*/etc/init/*.override  setf upstart
au BufNewFile,BufRead */.init/*.conf,*/.init/*.override        setf upstart
au BufNewFile,BufRead */.config/upstart/*.conf		       setf upstart
au BufNewFile,BufRead */.config/upstart/*.override	       setf upstart

" Verilog HDL
au BufNewFile,BufRead *.v			setf verilog

" Verilog-AMS HDL
au BufNewFile,BufRead *.va,*.vams		setf verilogams

" SystemVerilog
au BufNewFile,BufRead *.sv,*.svh		setf systemverilog

" VHDL
au BufNewFile,BufRead *.hdl,*.vhd,*.vhdl,*.vbe,*.vst  setf vhdl
au BufNewFile,BufRead *.vhdl_[0-9]*		call s:StarSetf('vhdl')

" Vim script
au BufNewFile,BufRead *.vim,*.vba,.exrc,_exrc	setf vim

" Viminfo file
au BufNewFile,BufRead .viminfo,_viminfo		setf viminfo

" Virata Config Script File or Drupal module
au BufRead,BufNewFile *.hw,*.module,*.pkg
	\ if getline(1) =~ '<?php' |
	\   setf php |
	\ else |
	\   setf virata |
	\ endif

" Visual Basic (also uses *.bas) or FORM
au BufNewFile,BufRead *.frm			call s:FTVB("form")

" Vroom (vim testing and executable documentation)
au BufNewFile,BufRead *.vroom			setf vroom

" Wget config
au BufNewFile,BufRead .wgetrc,wgetrc		setf wget

" CVS RC file
au BufNewFile,BufRead .cvsrc			setf cvsrc

" CVS commit file
au BufNewFile,BufRead cvs\d\+			setf cvs

" WEB (*.web is also used for Winbatch: Guess, based on expecting "%" comment
" lines in a WEB file).
au BufNewFile,BufRead *.web
	\ if getline(1)[0].getline(2)[0].getline(3)[0].getline(4)[0].getline(5)[0] =~ "%" |
	\   setf web |
	\ else |
	\   setf winbatch |
	\ endif

" XHTML
au BufNewFile,BufRead *.xhtml,*.xht		setf xhtml

" X Pixmap (dynamically sets colors, use BufEnter to make it work better)
au BufEnter *.xpm
	\ if getline(1) =~ "XPM2" |
	\   setf xpm2 |
	\ else |
	\   setf xpm |
	\ endif
au BufEnter *.xpm2				setf xpm2

" Xorg config
au BufNewFile,BufRead xorg.conf,xorg.conf-4	let b:xf86conf_xfree86_version = 4 | setf xf86conf

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.conf		setf xinetd

" X resources file
au BufNewFile,BufRead .Xdefaults,.Xpdefaults,.Xresources,xdm-config,*.ad setf xdefaults

" XML  specific variants: docbk and xbl
au BufNewFile,BufRead *.xml			call s:FTxml()

func! s:FTxml()
  let n = 1
  while n < 100 && n < line("$")
    let line = getline(n)
    " DocBook 4 or DocBook 5.
    let is_docbook4 = line =~ '<!DOCTYPE.*DocBook'
    let is_docbook5 = line =~ ' xmlns="http://docbook.org/ns/docbook"'
    if is_docbook4 || is_docbook5
      let b:docbk_type = "xml"
      if is_docbook5
	let b:docbk_ver = 5
      else
	let b:docbk_ver = 4
      endif
      setf docbk
      return
    endif
    if line =~ 'xmlns:xbl="http://www.mozilla.org/xbl"'
      setf xbl
      return
    endif
    let n += 1
  endwhile
  setf xml
endfunc

" XMI (holding UML models) is also XML
au BufNewFile,BufRead *.xmi			setf xml

" CSPROJ files are Visual Studio.NET's XML-based project config files
au BufNewFile,BufRead *.csproj,*.csproj.user	setf xml

" Qt Linguist translation source and Qt User Interface Files are XML
au BufNewFile,BufRead *.ts,*.ui			setf xml

" TPM's are RDF-based descriptions of TeX packages (Nikolai Weibull)
au BufNewFile,BufRead *.tpm			setf xml

" Xdg menus
au BufNewFile,BufRead */etc/xdg/menus/*.menu	setf xml

" ATI graphics driver configuration
au BufNewFile,BufRead fglrxrc			setf xml

" XLIFF (XML Localisation Interchange File Format) is also XML
au BufNewFile,BufRead *.xlf			setf xml
au BufNewFile,BufRead *.xliff			setf xml

" XML User Interface Language
au BufNewFile,BufRead *.xul			setf xml

" X11 xmodmap (also see below)
au BufNewFile,BufRead *Xmodmap			setf xmodmap

" Xslt
au BufNewFile,BufRead *.xsl,*.xslt		setf xslt

" Yaml
au BufNewFile,BufRead *.yaml,*.yml		setf yaml

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.conf		setf dosini

" Zimbu
au BufNewFile,BufRead *.zu			setf zimbu
" Zimbu Templates
au BufNewFile,BufRead *.zut			setf zimbutempl

" Zope
"   dtml (zope dynamic template markup language), pt (zope page template),
"   cpt (zope form controller page template)
au BufNewFile,BufRead *.dtml,*.pt,*.cpt		call s:FThtml()
"   zsql (zope sql method)
au BufNewFile,BufRead *.zsql			call s:SQL()

augroup END


" Source the user-specified filetype file, for backwards compatibility with
" Vim 5.x.
if exists("myfiletypefile") && filereadable(expand(myfiletypefile))
  execute "source " . myfiletypefile
endif


" Check for "*" after loading myfiletypefile, so that scripts.vim is only used
" when there are no matching file name extensions.
" Don't do this for compressed files.
augroup filetypedetect
au BufNewFile,BufRead *
	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
	\ | runtime! scripts.vim | endif
au StdinReadPost * if !did_filetype() | runtime! scripts.vim | endif


" Extra checks for when no filetype has been detected now.  Mostly used for
" patterns that end in "*".  E.g., "zsh*" matches "zsh.vim", but that's a Vim
" script file.
" Most of these should call s:StarSetf() to avoid names ending in .gz and the
" like are used.

" More Apache config files
au BufNewFile,BufRead access.conf*,apache.conf*,apache2.conf*,httpd.conf*,srm.conf*	call s:StarSetf('apache')
au BufNewFile,BufRead */etc/apache2/*.conf*,*/etc/apache2/conf.*/*,*/etc/apache2/mods-*/*,*/etc/apache2/sites-*/*,*/etc/httpd/conf.d/*.conf*		call s:StarSetf('apache')

" Asterisk config file
au BufNewFile,BufRead *asterisk/*.conf*		call s:StarSetf('asterisk')
au BufNewFile,BufRead *asterisk*/*voicemail.conf* call s:StarSetf('asteriskvm')

" Bazaar version control
au BufNewFile,BufRead bzr_log.*			setf bzr

" BIND zone
au BufNewFile,BufRead */named/db.*,*/bind/db.*	call s:StarSetf('bindzone')

" Changelog
au BufNewFile,BufRead [cC]hange[lL]og*
	\ if getline(1) =~ '; urgency='
	\|  call s:StarSetf('debchangelog')
	\|else
	\|  call s:StarSetf('changelog')
	\|endif

" Crontab
au BufNewFile,BufRead crontab,crontab.*,*/etc/cron.d/*		call s:StarSetf('crontab')

" dnsmasq(8) configuration
au BufNewFile,BufRead */etc/dnsmasq.d/*		call s:StarSetf('dnsmasq')

" GTK RC
au BufNewFile,BufRead .gtkrc*,gtkrc*		call s:StarSetf('gtkrc')

" Kconfig
au BufNewFile,BufRead Kconfig.*			call s:StarSetf('kconfig')

" Lilo: Linux loader
au BufNewFile,BufRead lilo.conf*		call s:StarSetf('lilo')

" Logcheck
au BufNewFile,BufRead */etc/logcheck/*.d*/*	call s:StarSetf('logcheck')

" Makefile
au BufNewFile,BufRead [mM]akefile*		call s:StarSetf('make')

" Ruby Makefile
au BufNewFile,BufRead [rR]akefile*		call s:StarSetf('ruby')

" Modconf
au BufNewFile,BufRead */etc/modutils/*
	\ if executable(expand("<afile>")) != 1
	\|  call s:StarSetf('modconf')
	\|endif
au BufNewFile,BufRead */etc/modprobe.*		call s:StarSetf('modconf')

" Printcap and Termcap
au BufNewFile,BufRead *printcap*
	\ if !did_filetype()
	\|  let b:ptcap_type = "print" | call s:StarSetf('ptcap')
	\|endif
au BufNewFile,BufRead *termcap*
	\ if !did_filetype()
	\|  let b:ptcap_type = "term" | call s:StarSetf('ptcap')
	\|endif

" ReDIF
" Only used when the .rdf file was not detected to be XML.
au BufRead,BufNewFile *.rdf			call s:Redif()
func! s:Redif()
  let lnum = 1
  while lnum <= 5 && lnum < line('$')
    if getline(lnum) =~ "^\ctemplate-type:"
      setf redif
      return
    endif
    let lnum = lnum + 1
  endwhile
endfunc

" Vim script
au BufNewFile,BufRead *vimrc*			call s:StarSetf('vim')

" Subversion commit file
au BufNewFile,BufRead svn-commit*.tmp		setf svn

" X resources file
au BufNewFile,BufRead Xresources*,*/app-defaults/*,*/Xresources/* call s:StarSetf('xdefaults')

" X11 xmodmap
au BufNewFile,BufRead *xmodmap*			call s:StarSetf('xmodmap')

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.d/*		call s:StarSetf('xinetd')

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.repos.d/*	call s:StarSetf('dosini')

" Z-Shell script
au BufNewFile,BufRead zsh*,zlog*		call s:StarSetf('zsh')


" Plain text files, needs to be far down to not override others.  This avoids
" the "conf" type being used if there is a line starting with '#'.
au BufNewFile,BufRead *.txt,*.text,README	setf text


" Use the filetype detect plugins.  They may overrule any of the previously
" detected filetypes.
runtime! ftdetect/*.vim

" NOTE: The above command could have ended the filetypedetect autocmd group
" and started another one. Let's make sure it has ended to get to a consistent
" state.
augroup END

" Generic configuration file (check this last, it's just guessing!)
au filetypedetect BufNewFile,BufRead,StdinReadPost *
	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
	\    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
	\	|| getline(4) =~ '^#' || getline(5) =~ '^#') |
	\   setf conf |
	\ endif


" Function called for testing all functions defined here.  These are
" script-local, thus need to be executed here.
" Returns a string with error messages (hopefully empty).
func! TestFiletypeFuncs(testlist)
  let output = ''
  for f in a:testlist
    try
      exe f
    catch
      let output = output . "\n" . f . ": " . v:exception
    endtry
  endfor
  return output
endfunc

" Restore 'cpoptions'
let &cpo = s:cpo_save
unlet s:cpo_save
