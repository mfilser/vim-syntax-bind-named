" Vim syntax file for ISC BIND named configuration file
" Language:     ISC BIND named configuration file
" Maintainer:   egberts <egberts@github.com>
" Last change:  2020-04-04
" Filenames:    named.conf, rndc.conf
" Filenames:    named[-_]*.conf, rndc[-_]*.conf
" Filenames:    *[-_]named.conf
" Location:     http://github.com/egberts/bind-named-vim-syntax
" License:      MIT license
" Remarks:
"
" Still in BETA version
"
" Inspired by Nick Hibma <nick@van-laarhoven.org> 'named.vim',
" also by glory hump <rnd@web-drive.ru>, and Marcin Dalecki.
"
" Jumpstarted to Bind 9.15 by Egberts <egberts@github.com>
"
" This file could do with a lot of improvements, so comments are welcome.
" Please submit the named.conf (segment) with any comments.
"
" Basic highlighting is covered for all Bind configuration 
" options.  Only normal (defaults is white) highlight gets 
" used to show 'undetected' Bind syntax.  
"
" Every valid keywords get colorized. Every character-valid 
" values get colorized, some range-checking here.
"
" New Bind 9.13+ terminologies here:
"    Stmt   - top-level keyword (formerly 'clause' from Bind 4 
"             to 9.11)
"    Opt    - an option keyword found within each of its 
"             top-level keywords.
"    Clause - very specific keywords used within each of its 
"             option statement
"
" Syntax Naming Convention: 
"    All macro names that are defined here start with 
"    'named' prefix. This is a Vim standard.
"
"    Each macro name contains a camel-case notation to 
"    denote each shorten word that identifies the:
"
"      -  its statement (top-level keyword), 
"        - any ONE of its options used, then 
"          - any ONE of its clauses used.  
"
"    For example, 'ControlsInetSection' represents the 
"    curly braces region of a particular 'inet' of that 
"    'controls' statement
"
"        controls xxx { inet { ... }; };
"                            ^^^^^^^
"
"    Additionally, following sub-notations may be used 
"    within each of the camel-cased macro names:
"    Section - Surrounded by curly braces, followed by an
"              ending semicolon.
"    Element - entire item(s) that must have an ending
"              semicolon terminators.  
"              Element are used one or more times within 
"              a Section.
"    Ident   - the declaration of an identifier
"    Name    - the usage of an Ident identifier
"    Error   - denotes that Vim Error color is used
"    Not     - an inverse pattern, useful for Errors
"
" Clarification: In the following Vim syntax macros, 
" there is an 'Options' notation as one of the 
" top-level Bind keyword statements, and then there 
" is an 'Opt' notation for those 'option' used under 
" each (top-level) statement: 
" Opt <> Options.
"
" 'iskeyword' is a Vim script function used here or ONLY 
" for Bind-builtins because such keywords transcend all 
" syntax processing (including nested curly-braces 
" sections; so you don't want to be using the bruteforce 
" absolute Vim '\k'\keyword\iskeyword too much
" other than Bind 'builtins'; 
" Same deal for '\i'/isident/identifiers.
"
" Bind builtins are 'any', 'none', 'localhost', 
" 'localnets' because we shouldn't be using those builtins 
" anywhere else as an identifier or a label names either.  
"
" ACL names are like identifier but will not be treated
" like Vim identifier here.
" Another reason why you shouldn't use period or slashes 
" in ACL names because it would only confuses our 
" simplistic IP address syntax processing here.
"
" isident is used for the most-lax naming convention of 
" all Bind identifiers combined.  Those naming convention
" are ordered from VIEW_name, Zone_name, ACL_name, 
" master_name, and then to the most strictest naming 
" convention, domain_name.  
"
" I'm moving away from isident within this syntax file.
"
" charset_view_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_zone_name_base = alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed

" charset_acl_name_base =  alphanums + '_-.+~@$%^&*()=[]\\|:<>`?'  # no semicolon nor curly braces allowed
" charset_master_name = alphanums + '_-.'
" charset_fqdn_name_base = alphanums + '_-.'
"
" NOTE: you can't use nextgroup for proper ordering of its multi-statements,
"       only line position of statements of those referenced by 
"       that 'nextgroup'.
"
" NOTE: DON'T put inline comment on continuation lines for `syntax ...`.
"       It hurts, badly.
"
" quit when a syntax file was already loaded
if !exists('main_syntax')
  if exists('b:current_syntax')
    finish
  endif
  let main_syntax='bind-named'
endif

syn case match

" iskeyword severly impacts '\<' and '\>' atoms
setlocal iskeyword=.,-,48-58,A-Z,a-z,_
setlocal isident=.,-,48-58,A-Z,a-z,_

" syn sync match namedSync grouphere NONE "^(zone|controls|acl|key)"
syn sync fromstart

let s:save_cpo = &cpoptions
set cpoptions-=C

" First-level highlighting
highlight namedHL_Statement1 guifg=#ffff00 guibg=#000000 gui=bold ctermfg=Yellow ctermbg=Black cterm=bold
highlight namedHL_Statement2 guifg=#dddd00 guibg=#000000 ctermfg=Yellow ctermbg=Black
highlight namedHL_Statement3 guifg=#bbbb00 guibg=#000000 ctermfg=Yellow ctermbg=Black
highlight namedHL_Builtin guifg=#cc0000 guibg=#000000 ctermfg=DarkRed ctermbg=Black
highlight namedHL_Operator guifg=#ff0000 guibg=#000000 gui=bold ctermfg=DarkRed ctermbg=Black

hi link namedHL_Comment     Comment
hi link namedHL_Include     DiffAdd
hi link namedHL_ToDo        Todo
hi link namedHL_Identifier  Identifier
hi link namedHL_Statement   namedHL_Statement1
hi link namedHL_Option      namedHL_Statement2
hi link namedHL_Clause      namedHL_Statement3    " could use a 3rd color here
hi link namedHL_Type        Type
" Bind has only one operator '!'
" hi link namedHL_Operator    Operator  
hi link namedHL_Number      Number
hi link namedHL_String      String
" Bind's builtins: 'any', 'none', 'localhost', 'localnets'
"hi link namedHL_Builtin     Special 
hi link namedHL_Underlined  Underlined
" Do not use Vim's "Boolean" highlighter, Bind has its own syntax.
hi link namedHL_Error       Error

" Second-level highlight alias
hi link namedOK           21
hi link namedHL_Boolean     namedHL_Type 
hi link namedHL_Domain      namedHL_String 
hi link namedHL_Hexidecimal namedHL_Number
hi link namedHL_Wildcard    namedHL_Builtin
hi link namedHL_Base64      namedHL_Identifier "  RFC 3548

" Third-level highlight alias should be next to their keywords

" Down-Top/Bottom-Up syntax approach.
" Smallest granular definition starts here.
" Largest granular definition goes at the bottom.
" Pay attention to tighest-pattern-first ordering of syntax.
"
" Many Vim-match/region/keyword are mixed together here by
" reusing its same macro name, to attain that desired 
" First-match method.

" 'Vim-uncontained' statements are the ones used GLOBALLY

hi link namedE_UnexpectedSemicolon namedHL_Error
syn match namedE_UnexpectedSemicolon contained /;\+/ skipwhite skipempty

hi link namedE_MissingSemicolon namedHL_Error
syn match namedE_MissingSemicolon contained /[ \n\r]*\zs[^;]*/he=s+1|

" Keep this 'uncontained' EOF search shallow and short
hi link namedE_MissingLastSemicolon namedHL_Error
syn match namedE_MissingLastSemicolon /[^; \n\r][ \n\r]\{0,10}\%$/rs=s,he=s+1 skipwhite skipnl skipempty

hi link namedE_MissingLParen namedHL_Error
syn match namedE_MissingLParen contained /[ \n\r#]*\zs[^\{]*/he=s+1|

hi link namedE_UnexpectedRParen namedHL_Error
syn match namedE_UnexpectedSemicolon contained /;\+/ skipwhite skipempty

hi link namedSemicolon namedHL_Type
" syn match namedSemicolon contained /\(;\+\s*\)\+/ skipwhite skipempty
syn match namedSemicolon contained /;/ skipwhite skipempty

hi link namedA_Semicolon namedHL_Type
syn match namedA_Semicolon contained /;/ skipwhite skipempty



hi link named_ToDo namedHL_ToDo
syn keyword named_ToDo xxx contained XXX FIXME TODO TODO: FIXME:

hi link namedComment namedHL_Comment
syn match namedComment "//.*" contains=named_ToDo
syn match namedComment "#.*" contains=named_ToDo
syn region namedComment start="/\*" end="\*/" contains=named_ToDo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIXED-LENGTH FIXED-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


hi link namedA_Bind_Builtins namedHL_Builtin
syn keyword namedA_Bind_Builtins contained skipwhite skipempty
\    any
\    none
\    localhost
\    localnets
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedA_Semicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIXED-LENGTH VARIABLE-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_AllowMaintainOff namedHL_Type
syn match named_AllowMaintainOff contained /\callow/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff contained /\cmaintain/ skipwhite nextgroup=namedSemicolon
syn match named_AllowMaintainOff contained /\coff/ skipwhite nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VARIABLE-LENGTH FIXED-NONSPACE PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VARIABLE-LENGTH VARIABLE-CHARACTERS PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variable-length variable-characters patterns - Number
hi link namedNumber namedHL_Number
syn match namedNumber contained "\d\{1,10}"

hi link named_Number_SC namedHL_Number
syn match named_Number_SC contained "\d\{1,10}" skipwhite 
\ nextgroup=namedSemicolon

hi link named_Keyname_SC namedHL_String
syn match named_Keyname_SC contained skipwhite
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon

" Variable-length variable-characters patterns - String
hi link named_Filespec namedHL_String
syn match named_Filespec contained skipwhite skipempty skipnl
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
syn match named_Filespec contained skipwhite skipempty skipnl
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
syn match named_Filespec contained skipwhite skipempty skipnl
\ /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 

hi link named_E_Filespec_SC namedHL_String
" TODO those curly braces and semicolon MUST be able to work within quotes.
syn match named_E_Filespec_SC contained /\'[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|"`~!@#$%\^&*\\(\\)=\+{}]\{1,1024}\'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /"[ a-zA-Z\]\-\[0-9\._,:\;\/?<>|'`~!@#$%\^&*\\(\\)=\+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedSemicolon
syn match named_E_Filespec_SC contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)=\+]\{1,1024}/ skipwhite skipempty skipnl nextgroup=namedSemicolon

hi link namedNotSemicolon namedHL_Error
syn match namedNotSemicolon contained /[^;]\+/he=e-1 skipwhite

" hi link namedError        namedHL_Error
" syn match namedError /[^;{#]$/

hi link namedNotNumber    namedHL_Error
syn match namedNotNumber contained "[^  0-9;]\+"

" <0-30000> (resolver-query-timeout in millisecond)
hi link named_Interval_Max30ms_SC namedHL_Number
syn match named_Interval_Max30ms_SC contained /\d\+/ skipwhite
\ nextgroup=namedSemicolon

" <0-30> (servfail-ttl)
hi link named_Ttl_Max30sec_SC namedHL_Number
syn match named_Ttl_Max30sec_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-90> (min-cache-ttl)
hi link named_Ttl_Max90sec_SC namedHL_Number
syn match named_Ttl_Max90sec_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-1200> ([max-]clients-per-query)
hi link named_Number_Max20min_SC namedHL_Number
syn match named_Number_Max20min_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon

" edns-udp-size: range: 512 to 4096 (default 4096)
hi link named_Number_UdpSize namedHL_Number
syn match named_Number_UdpSize contained skipwhite
\  /\(409[0-6]\)\|\(40[0-8][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\(5[2-9][0-9]\)\|\(51[2-9]\)/
" \  /\(51[2-9]\)\|\(5[2-9][0-9]\)\|\([6-9][0-9][0-9]\)\|\([1-3][0-9][0-9][0-9]\)\|\(40[0-8][0-9]\)\|\(409[0-6]\)/
\ nextgroup=namedSemicolon

" TTL <0-10800> (max-ncache-ttl)
hi link named_Ttl_Max3hour_SC namedHL_Number
syn match named_Ttl_Max3hour_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" TTL <0-1800> (lame-ttl)
hi link named_Ttl_Max30min_SC namedHL_Number
syn match named_Ttl_Max30min_SC contained 
\ /\d\+/
\ nextgroup=namedSemicolon

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=namedSemicolon

" <0-604800> (max-cache-ttl)
hi link named_Ttl_Max1week_SC namedHL_Number
syn match named_Ttl_Max1week_SC contained skipwhite
\ /\d\+/
\ nextgroup=namedSemicolon

" heartbeat-interval: range: 0-40320
hi link named_Number_Max28day_SC namedHL_Number
syn match named_Number_Max28day_SC contained
\ /\%(40320\)\|\%(403[0-1][0-9]\)\|\%(40[0-2][0-9][0-9]\)\|\%([1-3][0-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9]\)\|\%([1-9][0-9]\)\|\%([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

" <0-2419200> (max-refresh-time, min-refresh-time, min-retry-time,
" max-retry-time)
hi link named_Number_Max24week_SC namedHL_Number
syn match named_Number_Max24week_SC contained "\d\{1,10}" skipwhite nextgroup=namedSemicolon

hi link named_Number_GID namedHL_Number
syn match named_Number_GID contained "[0-6]\{0,1}[0-9]\{1,4}"

hi link namedUserID namedHL_Number
syn match namedUserID contained "[0-6]\{0,1}[0-9]\{1,4}"

hi link namedFilePerm   namedHL_Number
syn match namedFilePerm contained "[0-7]\{3,4}"

hi link namedDSCP   namedHL_Number
syn match namedDSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/

hi link named_Port namedHL_Number
syn match named_Port contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link named_Port_SC namedHL_Number
syn match named_Port_SC contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/ skipwhite nextgroup=namedSemicolon

hi link named_PortWild    namedHL_Builtin
syn match named_PortWild contained /\*/
syn match named_PortWild contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
hi link namedElementPortWild namedHL_Number
syn match namedElementPortWild contained /\*\s*;/ skipwhite
"syn match namedElementPortWild contained /\d\{1,5}\s*;/hs=s,me=e-1
syn match namedElementPortWild contained /\%([1-9]\|[1-5]\?[0-9]\{2,4}\|6[1-4][0-9]\{3}\|65[1-4][0-9]\{2}\|655[1-2][0-9]\|6553[1-5]\)\s*;/he=e-1
\ contains=named_Port skipwhite

hi link namedWildcard     namedHL_Builtin
syn match namedWildcard contained /\*/

hi link named_Boolean_SC namedHL_Boolean
syn match named_Boolean_SC contained /\cyes/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cno/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\ctrue/ skipwhite nextgroup=namedSemicolon
syn match named_Boolean_SC contained /\cfalse/ skipwhite nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 1 skipwhite nextgroup=namedSemicolon
syn keyword named_Boolean_SC contained 0 skipwhite nextgroup=namedSemicolon

hi link namedNotBool  namedHL_Error
syn match namedNotBool contained "[^  ;]\+"

hi link namedTypeBool  namedHL_Boolean
syn match namedTypeBool contained /\cyes/
syn match namedTypeBool contained /\cno/
syn match namedTypeBool contained /\ctrue/
syn match namedTypeBool contained /\cfalse/
syn keyword namedTypeBool contained 1
syn keyword namedTypeBool contained 0

hi link named_IgnoreWarnFail_SC namedHL_Type
syn match named_IgnoreWarnFail_SC contained /\cwarn/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cfail/ skipwhite nextgroup=namedSemicolon
syn match named_IgnoreWarnFail_SC contained /\cignore/ skipwhite nextgroup=namedSemicolon

hi link named_StrictRelaxedDisabledOff namedHL_Type
syn match named_StrictRelaxedDisabledOff  contained /\cstrict/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\crelaxed/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\cdisabled/ skipwhite nextgroup=namedSemicolon
syn match named_StrictRelaxedDisabledOff  contained /\coff/ skipwhite nextgroup=namedSemicolon

hi link namedACLName namedHL_Identifier
syn match namedACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ skipwhite

hi link named_E_ACLName_SC namedHL_Identifier
syn match named_E_ACLName_SC contained /\<[0-9a-zA-Z\-_\[\]\<\>]\{1,63}\>/
\ skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedE_MissingSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REGEX PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOV_CZ_MasterName_SC namedHL_Identifier
syn match namedOV_CZ_MasterName_SC contained /\<[0-9a-zA-Z\-_\.]\{1,63}/
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_CZ_DefMasters_MML

hi link namedA_ACL_Name namedHL_String
syn match namedA_ACL_Name contained "\<\(\w\|\.\|\-\)\{1,63}\ze[^;]*" 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IP patterns, 
" organized by IP4 to IP6; global to specific subgroups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link named_IP4Addr namedHL_Number
syn match named_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/

hi link named_IP4AddrPrefix namedHL_Number
syn match named_IP4AddrPrefix contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/

hi link named_E_IP4Addr_SC namedHL_Number
syn match named_E_IP4Addr_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
hi link named_E_IP4AddrPrefix_SC namedHL_Number
syn match named_E_IP4AddrPrefix_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon

hi link namedA_IP4Addr_SC namedHL_Type
syn match namedA_IP4Addr_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\ze[^;]*\ze[^;]*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon

hi link namedA_IP4AddrPrefix_SC namedHL_Number
syn match namedA_IP4AddrPrefix_SC contained /\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}\ze[^;]*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon

" named_IP6Addr  should match:
"  IPv6 addresses
"    zero compressed IPv6 addresses (section 2.2 of rfc5952)
"    link-local IPv6 addresses with zone index (section 11 of rfc4007)
"    IPv4-Embedded IPv6 Address (section 2 of rfc6052)
"    IPv4-mapped IPv6 addresses (section 2.1 of rfc2765)
"    IPv4-translated addresses (section 2.1 of rfc2765)
"  IPv4 addresses
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link named_E_IP6Addr_SC namedHL_Number

syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,7}:/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6Addr_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6Addr_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6Addr_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
\ containedin=namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6Addr_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6Addr_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ nextgroup=namedSemicolon
\ containedin=
\    namedElementAMLSection,
\    namedOV_ResponsePaddingSection

hi link namedA_IP6Addr_SC namedHL_Number
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedA_IP6Addr_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedA_IP6Addr_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedA_IP6Addr_SC contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedA_IP6Addr_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedA_IP6Addr_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedA_IP6Addr_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6Addr_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon


" Full IPv6 with Prefix with trailing semicolon
hi link named_E_IP6AddrPrefix_SC namedHL_Number
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
\ skipwhite skipnl skipempty
\ nextgroup=
\    named_A_AML_Nested_Semicolon,
\    named_E_MissingSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_E_IP6AddrPrefix_SC /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ contained nextgroup=namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_E_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/ nextgroup=namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_E_IP6AddrPrefix_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}/ nextgroup=namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_E_IP6AddrPrefix_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_E_IP6AddrPrefix_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/ nextgroup=namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_E_IP6AddrPrefix_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/ nextgroup=namedSemicolon

" Full IPv6 with Prefix with trailing semicolon (used by AML only)
hi link namedA_IP6AddrPrefix_SC namedHL_Number
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/ 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedA_IP6AddrPrefix_SC contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedA_IP6AddrPrefix_SC contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedA_IP6AddrPrefix_SC contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedA_IP6AddrPrefix_SC contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}\/[0-9]\{1,3}%[a-zA-Z0-9]\{1,64}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedA_IP6AddrPrefix_SC contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedA_IP6AddrPrefix_SC contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedA_IP6AddrPrefix_SC contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_Missing_Semicolon
"
" Full IPv6 with Prefix (without semicolon)
hi link named_IP6AddrPrefix namedHL_Number
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}\/[0-9]\{1,3}/ 
" 1::                              1:2:3:4:5:6:7::
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,7}:\/[0-9]\{1,3}/ 
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}\/[0-9]\{1,3}/ 
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}/ 
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}\/[0-9]\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}\/[0-9]\{1,3}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_IP6AddrPrefix contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}\/[0-9]\{1,3}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_IP6AddrPrefix contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)\/[0-9]\{1,3}/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_IP6AddrPrefix contained /fe80\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_IP6AddrPrefix contained /fe80:\%(:\x\{1,4}\)\{1,2}\/[0-9]\{1,3}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_IP6AddrPrefix contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}\/[0-9]\{1,3}/
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_IP6AddrPrefix contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\/[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6AddrPrefix contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\/[0-9]\{1,3}/

" Full IPv6 (without the trailing '/') (without semicolon)
hi link named_IP6Addr namedHL_Number
syn match named_IP6Addr /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/ contained
" 1::                              1:2:3:4:5:6:7::
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,7}:/ contained
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/ contained
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match named_IP6Addr /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/ contained
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match named_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match named_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match named_IP6Addr contained /fe80%[a-zA-Z0-9\-_\.]\{1,64}/
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match named_IP6Addr contained /fe80:\%(:\x\{1,4}\)\{1,2}%[a-zA-Z0-9\-_\.]\{1,64}/
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match named_IP6Addr /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/ contained
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match named_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match named_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/



" --- string 
hi link named_AlgorithmName_SC namedHL_String
syn match named_AlgorithmName_SC contained skipwhite
\ /\<[0-9A-Za-z\-_]\{1,63}/
\ nextgroup=namedSemicolon

hi link namedString namedHL_String
syn region namedString start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region namedString start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
syn match namedString contained /\<[a-zA-Z0-9_\.\-]\{1,63}\>/

hi link named_String_DQuoteForced namedHL_String
syn region named_String_DQuoteForced start=/"/ skip=/\\"/ end=/"/ contained

hi link named_String_SQuoteForced namedHL_String
syn region named_String_SQuoteForced start=/'/ skip=/\\'/ end=/'/ contained

hi link named_String_QuoteForced namedHL_String
syn region named_String_QuoteForced start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
syn region named_String_QuoteForced start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
hi link named_String_DQuoteForced_SC namedHL_String
syn region named_String_DQuoteForced_SC start=/"/ skip=/\\"/ end=/"/ contained nextgroup=namedSemicolon
hi link named_String_SQuoteForced_SC namedHL_String
syn region named_String_SQuoteForced_SC start=/'/ skip=/\\'/ end=/'/ contained nextgroup=namedSemicolon
hi link named_String_QuoteForced_SC namedHL_String
syn region named_String_QuoteForced_SC start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained nextgroup=namedSemicolon
syn region named_String_QuoteForced_SC start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained nextgroup=namedSemicolon

" -- Identifier
hi link namedTypeBase64 namedHL_Base64
syn match namedTypeBase64 contained /\<[0-9a-zA-Z\/\-\_\,+=]\{1,4099}/

hi link namedKeySecretValue   namedHL_Base64
syn match namedKeySecretValue contained /\<[0-9a-zA-Z\+\=\/]\{1,4099}\s*;/he=e-1 skipwhite

hi link namedKeyName namedHL_Identifier
syn match namedKeyName contained /\<[0-9a-zA-Z\-_]\{1,63}/ skipwhite

hi link namedKeyAlgorithmName namedHL_String
syn match namedKeyAlgorithmName contained /\<[0-9A-Za-z\-_]\{1,4096}/ skipwhite

hi link namedMasterName namedHL_Identifier
syn match namedMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}/ skipwhite

hi link namedElementMasterName namedHL_Identifier
syn match namedElementMasterName contained /\<[0-9a-zA-Z\-_\.]\{1,64}\s*;/he=e-1 skipwhite

hi link namedHexSecretValue   namedHL_Hexidecimal
syn match namedHexSecretValue contained /\<'[0-9a-fA-F]\+'\>/ skipwhite
syn match namedHexSecretValue contained /\<"[0-9a-fA-F]\+"\>/ skipwhite

hi link namedViewName namedHL_Identifier
" syn match namedViewName contained /[a-zA-Z0-9_\-\.+~@$%\^&*()=\[\]\\|:<>`?]\{1,64}/ skipwhite
syn match namedViewName contained /[a-zA-Z0-9\-_\.]\{1,64}/ skipwhite

hi link named_E_ViewName_SC namedHL_Identifier
syn match named_E_ViewName_SC contained /[a-zA-Z0-9\-_\.]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedZoneName namedHL_Identifier
syn match namedZoneName contained /[a-zA-Z0-9]\{1,64}/ skipwhite

hi link namedElementZoneName namedHL_Identifier
syn match namedElementZoneName contained /[a-zA-Z0-9]\{1,63}\s*;/he=e-1 skipwhite

hi link namedDlzName namedHL_Identifier
syn match namedDlzName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite
hi link namedDyndbName namedHL_Identifier
syn match namedDyndbName contained /[a-zA-Z0-9_\.\-]\{1,63}/ skipwhite

syn match namedKRB5username contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5realm contained /\i\+;/he=e-1 skipwhite
syn match namedKRB5principal contained /\i\+;/he=e-1 skipwhite

syn match namedTypeSeconds /\d\{1,11}\s*;/he=e-1 contained skipwhite

hi link namedTypeMinutes namedHL_Number
syn match namedTypeMinutes contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeDays contained /\d\{1,11}\s*;/he=e-1 skipwhite
syn match namedTypeCacheSize contained /\d\{1,3}\s*;/he=e-1 skipwhite

" --- syntax errors
hi link namedIllegalDom   namedHL_Error
syn match namedIllegalDom contained /"\S*[^-A-Za-z0-9.[:space:]]\S*"/ms=s+1,me=e-1

hi link namedIPerror      namedHL_Error
syn match namedIPerror contained /\<\S*[^0-9.[:space:];]\S*/

hi link namedNotParenError namedHL_Error
syn match namedNotParenError contained /\%([^{]\|$\)/ skipwhite

hi link namedEParenError  namedHL_Error
syn match namedEParenError contained +{+

hi link namedParenError   namedHL_Error
syn match namedParenError /}\%([^;]\|$\)/


" --- IPs & Domains


hi link namedIPwild   namedHL_Wildcard
syn match namedIPwild contained /\*/

hi link namedSpareDot     namedHL_Error
syn match namedSpareDot contained /\./
syn match namedSpareDot_SC contained /\.\s\+;/



" syn match namedDomain contained /"\."/ms=s+1,me=e-1 skipwhite
hi link namedDomain namedHL_Domain
syn match namedDomain contained /\<[0-9A-Za-z\._\-]\+\>/ nextgroup=namedSpareDot
hi link named_QuotedDomain namedHL_Domain
syn match named_QuotedDomain contained /\<[0-9A-Za-z\._\-]\{1,1023}\>/ nextgroup=namedSpareDot
syn match named_QuotedDomain contained /'\<[0-9A-Za-z\.\-_]\{1,1023}'\>/hs=s+1,he=e-1 nextgroup=namedSpareDot
syn match named_QuotedDomain contained /"\<[0-9A-Za-z\.\-_]\{1,1023}"\>\"/ nextgroup=namedSpareDot
hi link named_QuotedDomain_SC namedHL_Domain
syn match named_QuotedDomain_SC contained /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/ nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite
syn match named_QuotedDomain_SC contained /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 nextgroup=namedSemicolon skipwhite

hi link named_E_Domain_SC namedHL_Domain
syn match named_E_Domain_SC contained /\<[0-9A-Za-z\._\-]\+\>/
\ nextgroup=namedSemicolon

hi link named_E_SuffixDomain_SC namedHL_Domain
syn match named_E_SuffixDomain_SC contained /\<[0-9A-Za-z\._\-]{1,1023}[A-Za-z\.]\>/
\ nextgroup=namedSemicolon

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nesting of PATTERNS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedInclude namedHL_Include
syn match namedInclude /\_s*include/ 
\ nextgroup=named_E_Filespec_SC
\ skipwhite skipnl skipempty


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -- Vim syntax clusters
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedClusterBoolean_SC namedHL_Error
syntax cluster namedClusterBoolean_SC contains=named_Boolean_SC
syntax cluster namedClusterBoolean contains=namedTypeBool,namedNotBool,@namedClusterCommonNext
syntax cluster namedDomainFQDNCluster contains=namedDomain,namedError
syn cluster namedCommentGroup contains=named_ToDo


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_SizeSpec namedHL_Number
syn match named_SizeSpec contained skipwhite
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ 

hi link named_SizeSpec_SC namedHL_Number
syn match named_SizeSpec_SC contained skipwhite
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/ 
\ nextgroup=namedSemicolon


hi link named_DefaultUnlimited_SC namedHL_Builtin
syn match named_DefaultUnlimited_SC contained skipwhite /\cunlimited/
\ nextgroup=namedSemicolon
syn match named_DefaultUnlimited_SC contained skipwhite /\cdefault/
\ nextgroup=namedSemicolon


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'acl' statement
"
" acl acl-name {
"    [ address_match_nosemicolon | any | all ];
"    ... ;
" };
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedA_AML_Nested_Semicolon namedHL_Normal
syn match namedA_AML_Nested_Semicolon contained /;/ skipwhite skipempty 
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Nested_Not_Operator,
\    namedA_AML_Nested_Semicolon

hi link namedA_AML_Not_Operator namedHL_Operator
syn match namedA_AML_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedA_AML,
\    namedE_UnexpectedSemicolon,
\    namedE_MissingLParen,
\    namedE_UnexpectedRParen

hi link namedA_AML_Nested_Not_Operator namedHL_Operator
syn match namedA_AML_Nested_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedInclude,
\    namedComment,
\    namedA_AML_Recursive,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_IP6AddrPrefix_SC,
\    namedA_Bind_Builtins,
\    namedA_ACL_Name,
\    namedE_UnexpectedSemicolon,
\    namedE_MissingLParen,
\    namedE_UnexpectedRParen
" \    named_E_IP4AddrPrefix_SC,


" Keep keepend/extend on AML_Recursive!!!
syn region namedA_AML_Recursive contained start=+{+ end=+}+ keepend extend
\ skipnl skipwhite skipempty
\ contains=
\    namedA_AML_Recursive,
\    namedInclude,
\    namedComment,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_Bind_Builtins,
\    namedA_ACL_Name,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon
\ containedin=
\    namedA_AML_Recursive,

" \    named_E_IP6AddrPrefix_SC,
" \    named_E_IP4AddrPrefix_SC,

" acl <acl_name> { ... } ;
syn region namedA_AML contained start=+{+ end=+}+  
\ skipwhite skipnl skipempty
\ contains=
\    namedInclude,
\    namedComment,
\    namedA_IP4Addr_SC,
\    namedA_IP4AddrPrefix_SC,
\    namedA_IP6Addr_SC,
\    namedA_Bind_Builtins,
\    namedA_ACL_Name,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_Semicolon,
\    namedE_MissingSemicolon

" \ contains=
" \    named_E_IP6AddrPrefix_SC,
" \    named_E_IP4AddrPrefix_SC,

" acl <acl_name> { ... } 
hi link namedA_ACLIdentifier  namedHL_Identifier
syn match namedA_ACLIdentifier contained /\<[0-9a-zA-Z\-_]\{1,63}\>/ 
\ skipwhite skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen


" Syntaxes that are found only within 'controls' statement
"
" controls { inet ( * | <ip46_addr> ) 
"                [ port <port_no> ] 
"                allow { <address_match_element>; ... };
"                [ keys { <key_name>; ... } ] 
"                [ read-only <boolean> ]; 
"          };
" controls { unix <quoted_string> 
"                 perm <perm_integer> 
"                 owner <owner_id> 
"                 group <group_id> 
"                 [ keys { <key_name>; ... } ] 
"                 [ read-only <boolean> ]; 
"          };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Identifiers

hi link namedC_InetOptACLName namedHL_Identifier
syn match namedC_InetOptACLName contained /[0-9a-zA-Z\-_\[\]\<\>]\{1,63}/ 
\ skipwhite skipnl skipempty
\ contains=namedACLName
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_OptReadonlyBool /\i/ contained skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedC_OptReadonlyKeyword namedHL_Option
syn match namedC_OptReadonlyKeyword /read\-only/ contained skipwhite
\ nextgroup=
\    namedC_OptReadonlyBool,
\    namedError

syn match namedC_UnixOptKeysElement /[a-zA-Z0-9_\-\.]\+/
\ contained 
\ contains=namedKeyName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError
\ containedin=
\    namedC_UnixOptKeysSection

syn region namedC_UnixOptKeysSection start=+{+ end=+}+
\ contained skipwhite skipempty skipnl
\ contains=namedC_UnixOptKeysElement
\ nextgroup=
\    namedC_OptReadonlyKeyword,
\    namedSemicolon

hi link namedC_UnixOptKeysKeyword namedHL_Option
syn match namedC_UnixOptKeysKeyword /keys/ contained skipwhite skipempty skipnl
\ nextgroup=namedC_UnixOptKeysSection

syn match namedC_UnixOptGroupInteger /\d\+/ contained skipwhite skipempty skipnl
\ contains=named_Number_GID
\ nextgroup=
\     namedC_OptReadonlyKeyword,
\     namedC_UnixOptKeysKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_UnixOptGroupKeyword namedHL_Option
syn match namedC_UnixOptGroupKeyword /group/ contained skipwhite skipempty skipnl
\ nextgroup=namedC_UnixOptGroupInteger,namedError

syn match namedC_UnixOptOwnerInteger /\d\+/ contained skipwhite skipempty skipnl
\ contains=namedUserID
\ nextgroup=namedC_UnixOptGroupKeyword,namedError

hi link namedC_UnixOptOwnerKeyword namedHL_Option
syn match namedC_UnixOptOwnerKeyword /owner/ contained skipwhite skipempty skipnl
\ nextgroup=namedC_UnixOptOwnerInteger,namedError

syn match namedC_UnixOptPermInteger /\d\+/ contained skipwhite skipempty skipnl
\ contains=namedFilePerm
\ nextgroup=namedC_UnixOptOwnerKeyword,namedError

hi link namedC_UnixOptPermKeyword namedHL_Option
syn match namedC_UnixOptPermKeyword /perm/ contained skipwhite skipempty skipnl
\ nextgroup=namedC_UnixOptPermInteger,namedError

syn match namedC_UnixOptSocketName contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

" Dirty trick, use a single '"' char for a string match
hi link namedC_UnixOptSocketName namedHL_Number
syn match namedC_UnixOptSocketName contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

syn match namedC_UnixOptSocketName contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=
\     namedC_UnixOptPermKeyword,
\     namedC_OptReadonlyKeyword,
\     namedSemicolon,
\     namedError

hi link namedC_ClauseUnix namedHL_Option
syn keyword namedC_ClauseUnix contained unix
\ skipwhite skipnl skipempty
\ nextgroup=namedC_UnixOptSocketName
\ containedin=namedStmtControlSection

hi link namedC_InetOptReadonlyBool namedHL_Option
syn match namedC_InetOptReadonlyBool contained /\i/
\ skipwhite skipnl skipempty
\ contains=@namedClusterBoolean
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedC_InetOptReadonlyKeyword namedHL_Option
syn match namedC_InetOptReadonlyKeyword contained /read\-only/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptReadonlyBool

syn region namedC_InetAMLSection contained start=/{/ end=/}/
\ skipwhite skipnl skipempty
\ contains=
\    named_E_IP6Addr_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedSemicolon,
\    namedInclude,
\    namedComment
\ nextgroup=
\    namedC_InetOptReadonlyKeyword,
\    namedC_UnixOptKeysKeyword,
\    namedSemicolon

hi link namedC_InetOptAllowKeyword namedHL_Option
syn match namedC_InetOptAllowKeyword contained /\<allow\>/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetAMLSection,namedComment

hi link namedC_InetOptPortWild namedHL_Builtin
syn match namedC_InetOptPortWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptAllowKeyword

hi link namedC_InetOptPortNumber namedHL_Number
syn match namedC_InetOptPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptAllowKeyword

hi link namedC_InetOptPortKeyword namedHL_Option
syn match namedC_InetOptPortKeyword contained /port/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptPortWild,
\    namedC_InetOptPortNumber


hi link namedC_InetOptIPaddrWild namedHL_Builtin
syn match namedC_InetOptIPaddrWild contained /\*/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

" hi link namedC_InetOptIPaddr namedHL_Number
syn match namedC_InetOptIPaddr contained /[0-9a-fA-F\.:]\{3,45}/ 
\ skipwhite skipnl skipempty
\ contains=named_IP6Addr,named_IP4Addr
\ nextgroup=
\    namedC_InetOptPortKeyword,
\    namedC_InetOptAllowKeyword

hi link namedC_ClauseInet namedHL_Option
syn match namedC_ClauseInet contained /inet/
\ skipnl skipempty skipwhite 
\ containedin=namedStmtControlSection
\ nextgroup=
\    namedC_InetOptACLName,
\    namedC_InetOptIPaddrWild,
\    namedC_InetOptIPaddr

syn region namedStmt_ControlsSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=
\    namedC_ClauseInet,
\    namedC_ClauseUnix,
\    namedComment,
\    namedInclude
\ nextgroup=
\    namedSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dlz' statement
" 
" dlz <dlz_name> { database <string> search <boolean>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedDlzSearchBoolean namedHL_String
syn match namedDlzSearchBoolean contained /\i/
\ skipwhite
\ contains=namedTypeBool
\ nextgroup=namedSemicolon,namedDlzDatabaseKeyword

hi link namedDlzSearchKeyword namedHL_Option
syn match namedDlzSearchKeyword contained /\<search\>/
\ skipwhite
\ nextgroup=namedDlzSearchBoolean
\ containedin=namedStmt_DlzSection

hi link namedDlzDatabaseString namedHL_String
syn region namedDlzDatabaseString start=/"/ skip=/\\"/ end=/"/ contained
syn region namedDlzDatabaseString start=/'/ skip=/\\'/ end=/'/ contained
\ skipwhite
\ containedin=namedStmt_DlzSection
\ nextgroup=namedSemicolon,namedDlzSearchKeyword

hi link namedDlzDatabaseKeyword namedHL_Option
syn match namedDlzDatabaseKeyword contained /\<database\>/
\ skipwhite
\ nextgroup=namedDlzDatabaseString
\ containedin=namedStmt_DlzSection

syn region namedStmt_DlzSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedStmt_DlzName_Identifier namedHL_Identifier
syn match namedStmt_DlzName_Identifier contained skipwhite
\    /\S\+/
\ skipwhite 
\ nextgroup=namedStmt_DlzSection
" \    /\<[a-zA-Z0-9_\.\-]\{1,63}\>/ 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'dyndb' statement
" 
" dyndb <dyndb_name> <device_driver_filename> { <arguments> };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link   namedDyndbDriverParameters namedHL_String
syn match namedDyndbDriverParameters contained /[<>\|:"'a-zA-Z0-9_\.\-\/\\]\+[^;]/ 
\ skipwhite skipempty skipnl
\ contains=named_String_QuoteForced
\ containedin=namedStmtDyndbSection
\ nextgroup=namedSemicolon

syn region namedStmtDyndbSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

syn match namedStmtDyndbDriverFilespec contained 
\ /[a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced
syn match namedStmtDyndbDriverFilespec contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced
syn match namedStmtDyndbDriverFilespec contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ skipwhite skipempty skipnl
\ nextgroup=namedStmtDyndbSection
\ contains=named_String_QuoteForced

hi link namedStmtDyndbIdent namedHL_Identifier
syn match namedStmtDyndbIdent contained /[a-zA-Z0-9_\.\-]\{1,63}/ 
\ skipwhite 
\ nextgroup=namedStmtDyndbDriverFilespec
\ contains=namedDyndbName

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within top-level 'key' statement
" 
" key <key_name> { algorithm <string>; secret <string>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedK_E_SecretValue namedHL_Base64
syn match namedK_E_SecretValue contained /["'0-9A-Za-z\+\=\/]\{1,4098}\s*;/
\ skipwhite
\ contains=namedTypeBase64
\ nextgroup=namedSemicolon,namedError

hi link namedK_E_SecretKeyword namedHL_Option
syn match namedK_E_SecretKeyword contained /\<secret\>/ skipwhite skipempty
\ nextgroup=namedK_E_SecretValue,namedError
\ containedin=namedStmtKeySection

syn match namedK_E_AlgorithmName contained /[a-zA-Z0-9\-_\.]\{1,128}\s*;/he=e-1
\ skipwhite skipnl skipempty
\ contains=namedKeyAlgorithmName
\ nextgroup=namedK_E_SecretKeyword,namedError

hi link namedK_E_AlgorithmKeyword namedHL_Option
syn match namedK_E_AlgorithmKeyword contained /\<algorithm\>/ skipwhite skipempty
\ nextgroup=namedK_E_AlgorithmName,namedError
\ containedin=namedStmtKeySection

syn region namedStmtKeySection start=+{+ end=+}+
\ contained skipwhite skipempty
\ contains=
\    namedK_E_AlgorithmKeyword
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

hi link namedStmtKeyIdent namedHL_Identifier
syn match namedStmtKeyIdent contained /[a-zA-Z0-9_\-]\{1,63}/
\ skipwhite skipnl skipempty
\ nextgroup=namedStmtKeySection,namedNotParem,namedError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'logging' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # logging {
"    [ channel <channel_name> {
"        [ buffered <boolean>; ]
"        ( file <path_name>
"            [ version (<number> |unlimited) ]
"            [ size <size_spec> ]
"          | stderr;
"          | null;
"          | syslog <log_facility>;
"        )
"      [ severity ( critical | error | warning | notice
"                   info | debug [ <level> ] | dynamic ); ]
"      [ print-category <boolean>; ]
"      [ print-severity <boolean>; ]
"      [ print-time ( iso8601 | iso8601-utc | local | <boolean>) ;  ]
"    }; ]
"    [ category category_name {
"      channel_name ; [ channel_name ; ... ]
"    }; ]
"    ...
" }
hi link namedLoggingCategoryChannelName namedHL_Type
syn match namedLoggingCategoryChannelName contained /\i\+/ skipwhite
\ containedin=namedLoggingCategorySection

syn region namedLoggingCategorySection contained start=+{+ end=+}+ 
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedLoggingCategoryBuiltins namedHL_Builtin
syn keyword namedLoggingCategoryBuiltins contained skipwhite 
\    client cname config database default delegation-only dnssec dispatch
\    dnstap edns-disabled general lame-servers
\    network notify nsid queries query-errors 
\    rate-limit resolver rpz security serve-stale spill 
\    trust-anchor-telemetry unmatched update update-security
\    xfer-in xfer-out zoneload 
\ nextgroup=namedLoggingCategorySection
\ containedin=namedStmtLoggingSection

hi link namedLoggingCategoryCustom Identifier
syn match namedLoggingCategoryCustom contained skipwhite /\i\+/
\ containedin=namedStmtLoggingSection

hi link namedLoggingCategoryIdent Identifier
syn match namedLoggingCategoryIdent /\i\+/ skipwhite contained
\ contains=namedLoggingCategoryBuiltins
\ nextgroup=namedLoggingCategorySection,namedError
\ containedin=namedStmtLoggingSection

hi link namedLoggingOptCategoryKeyword namedHL_Option
syn match namedLoggingOptCategoryKeyword contained skipwhite /category/
\ nextgroup=namedLoggingCategoryIdent,namedError skipwhite
\ containedin=namedStmtLoggingSection

" logging { channel xxxxx { ... }; };

hi link namedLoggingChannelSeverityDebugValue namedHL_Number
syn match namedLoggingChannelSeverityDebugValue /[0-9]\{1,5}/ 
\ contained skipwhite 
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError

hi link namedLoggingChannelSeverityDebug namedHL_Builtin
syn match namedLoggingChannelSeverityDebug contained /debug\s*[^;]/me=e-1
\ nextgroup=
\    namedLoggingChannelSeverityDebugValue,
\    namedComment,
\    namedSemicolon,
\    namedNotSemicolon_SC,
\    namedNotComment,
\    namedError
syn match namedLoggingChannelSeverityDebug contained /debug\s*;/he=e-1

hi link namedLoggingChannelSeverityType namedHL_Builtin
syn keyword namedLoggingChannelSeverityType contained
\    info
\    notice
\    warning
\    error
\    critical
\    dynamic
\ skipwhite
\ nextgroup=namedSemicolon,namedError

hi link namedLoggingChannelOptNull namedHL_Clause
syn keyword namedLoggingChannelOptNull null contained skipwhite
\ nextgroup=namedComment,namedSemicolon,namedNotSemicolon,namedError
syn keyword namedLoggingChannelOptNull stderr contained skipwhite
\ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelOpts namedHL_Option
syn keyword namedLoggingChannelOpts contained skipwhite 
\    buffered
\    print-category
\    print-severity
\ nextgroup=@namedClusterBoolean_SC,namedError
" \    /\(buffered\)\|\(print\-category\)\|\(print\-severity\)/

" BUG: You can specify 'severity' twice on same line before semicolon
hi link namedLoggingChannelOptSeverity namedHL_Option
syn keyword namedLoggingChannelOptSeverity contained severity skipwhite skipempty
\ nextgroup=
\    namedLoggingChannelSeverityType,
\    namedLoggingChannelSeverityDebug,
\    namedComment,
\    namedError

" hi link namedLoggingChannelSyslogFacilityKern namedHL_Builtin
" syn keyword namedLoggingChannelSyslogFacilityKern kern contained skipwhite
" \ nextgroup=namedSemicolon,namedNotSemicolon,namedComment,namedError

hi link namedLoggingChannelSyslogFacility namedHL_Builtin
syn keyword namedLoggingChannelSyslogFacility contained
\    user kern mail daemon
\    auth syslog lpr news
\    uucp cron authpriv
\    local0 local1 local2 local3 local4
\    local5 local6 local7 local8 local9
\ nextgroup=namedSemicolon,namedComment,namedParenError,namedError

hi link namedLoggingChannelOptSyslog namedHL_Option
sy keyword namedLoggingChannelOptSyslog syslog contained skipwhite 
\ nextgroup=
\    namedLoggingChannelSyslogFacilityKern,
\    namedLoggingChannelSyslogFacilityUser,
\    namedLoggingChannelSyslogFacility,
\    namedParenError,
\    @namedClusterCommonNext,

hi link namedLoggingChannelOptPrinttimeISOs namedHL_Builtin
syn keyword namedLoggingChannelOptPrinttimeISOs contained skipwhite
\    iso8601
\    iso8601-utc
\    local
\ nextgroup=
\    namedSemicolon,
\    namedComment,
\    namedError

hi link namedLoggingChannelOptPrintTime namedHL_Option
syn match namedLoggingChannelOptPrintTime /print\-time/ contained skipwhite
\ nextgroup=
\    namedLoggingChannelOptPrinttimeISOs,
\    @namedClusterBoolean_SC,
\    namedParenError,
\    @namedClusterCommonNext,
\    namedError,

hi link namedLoggingChannelFileVersionOptUnlimited namedHL_Builtin
syn match namedLoggingChannelFileVersionOptUnlimited /unlimited/
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptSize,
\           namedSemicolon
syn match namedLoggingChannelFileVersionOptInteger contained skipwhite
\    /[0-9]\{1,11}/
\    contains=namedNumber
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptSize,
\           namedSemicolon
hi link namedLoggingChannelFileOptVersions namedHL_Option
syn match namedLoggingChannelFileOptVersions contained skipwhite /versions/
\ nextgroup=
\    namedLoggingChannelFileVersionOptInteger,
\    namedLoggingChannelFileVersionOptUnlimited,

hi link namedLoggingChannelFileSizeOpt namedHL_Number
" [0-9]\{1,12}\([BbKkMmGgPp]\{1}\)/
syn match namedLoggingChannelFileSizeOpt 
\ /[0-9]\{1,11}\([BbKkMmGgPp]\)\{0,1}/
\ contains=named_SizeSpec
\ contained skipwhite
\ nextgroup=namedLoggingChannelFileOptSuffix,
\           namedLoggingChannelFileOptVersions,
\           namedSemicolon

hi link namedLoggingChannelFileOptSize namedHL_Option
syn match namedLoggingChannelFileOptSize /size/
\ contained  skipwhite
\ nextgroup=namedLoggingChannelFileSizeOpt

hi link namedLoggingChannelFileSuffixOpt namedHL_Builtin
syn match namedLoggingChannelFileSuffixOpt /\(\(increment\)\|\(timestamp\)\)/
\ contained 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

hi link namedLoggingChannelFileOptSuffix namedHL_Option
syn match namedLoggingChannelFileOptSuffix contained /suffix/
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileSuffixOpt,
\    namedEParenError

syn match namedLoggingChannelFileIdent contained 
\ /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/
\ contained
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

hi link namedLoggingChannelFileIdent namedHL_String
syn match namedLoggingChannelFileIdent contained 
\ /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ contained
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

syn match namedLoggingChannelFileIdent contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ contained
\ skipwhite skipnl skipempty
\ contains=named_Filespec
\ nextgroup=
\    namedLoggingChannelFileOptSuffix,
\    namedLoggingChannelFileOptSize,
\    namedLoggingChannelFileOptVersions,
\    namedSemicolon

" file <namedLoggingChannelOptFile> [ ... ];
hi link namedLoggingChannelOptFile namedHL_Option
syn match namedLoggingChannelOptFile /file/ contained 
\ skipwhite skipempty
\ nextgroup=
\    namedLoggingChannelFileIdent,
\    namedParenError

syn region namedLoggingChannelSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ contains=
\    namedLoggingChannelOpts,
\    namedLoggingChannelOptFile,
\    namedLoggingChannelOptPrintTime,
\    namedLoggingChannelOptSyslog,
\    namedLoggingChannelOptNull,
\    namedLoggingChannelOptSeverity,
\    namedComment,
\    namedInclude,
\    namedParenError
\ nextgroup=namedSemicolon

hi link namedLoggingChannelIdent namedHL_Identifier
syn match namedLoggingChannelIdent /\S\+/ contained skipwhite
\ nextgroup=namedLoggingChannelSection

hi link namedLoggingOptChannelKeyword namedHL_Option
syn match namedLoggingOptChannelKeyword contained skipwhite /channel/
\ nextgroup=namedLoggingChannelIdent,namedError
\ containedin=namedStmtLoggingSection

syn region namedStmtLoggingSection contained start=+{+ end=+}+ 
\ contains=
\    namedLoggingOptCategoryKeyword,
\    namedLoggingOptChannelKeyword,
\    namedComment,namedInclude,namedParenError
\ nextgroup=namedSemicolon
\ skipwhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'managed-keys' statement
"
" managed-keys { string string integer integer integer quoted_string; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedMk_E_KeySecret namedKeySecretValue
syn match namedMk_E_KeySecret contained /["'0-9A-Za-z\+\=\/]\{1,4098}/ 
\ skipwhite skipempty
\ contains=namedKeySecretValue
\ nextgroup=namedSemicolon,namedNotSemicolon,namedError

hi link namedMk_E_AlgorithmType namedHL_Number
syn match namedMk_E_AlgorithmType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_KeySecret,namedError

hi link namedMk_E_ProtocolType namedHL_Number
syn match namedMk_E_ProtocolType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_AlgorithmType,namedError

hi link namedMk_E_FlagType namedHL_Number
syn match namedMk_E_FlagType contained skipwhite /\d\{1,3}/ skipempty
\ nextgroup=namedMk_E_ProtocolType,namedError

hi link namedMk_E_InitialKey namedHL_Number
syn match namedMk_E_InitialKey contained /[0-9A-Za-z][-0-9A-Za-z.]\{1,4096}/ 
\ skipwhite skipempty
\ contains=namedString
\ nextgroup=namedMk_E_FlagType,namedError

hi link namedMk_E_DomainName namedHL_Identifier
syn match namedMk_E_DomainName contained /[0-9A-Za-z][_\-0-9A-Za-z.]\{1,1024}/
\ skipwhite skipempty 
\ nextgroup=namedMk_E_InitialKey,namedError

syn region namedStmt_ManagedKeysSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ contains=namedMk_E_DomainName
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" masters <masterIdentifier> { <masters_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedM_E_MasterKeyName namedHL_Identifier
syn match namedM_E_MasterKeyName contained /[a-zA-Z][0-9a-zA-Z\-_]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedSemicolon,
\    namedNotSemicolon,
\    namedError

hi link namedM_E_KeyKeyword namedHL_Option
syn match namedM_E_KeyKeyword contained skipwhite /key/
\ nextgroup=
\    namedM_E_MasterKeyName,
\    namedError

hi link namedM_E_IPaddrPortNumber namedHL_Error
syn match namedM_E_IPaddrPortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=named_Port
\ nextgroup=
\    namedM_E_KeyKeyword,

hi link namedM_E_IPaddrPortKeyword namedHL_Option
syn match namedM_E_IPaddrPortKeyword contained skipwhite /port/
\ nextgroup=
\    namedM_E_IPaddrPortNumber,
\    namedError

hi link namedM_E_MasterName namedHL_Identifier
syn match namedM_E_MasterName contained skipwhite /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ nextgroup=
\    namedM_E_KeyKeyword,
\    namedSemicolon,
\   namedComment, namedInclude,
\    namedError
\ containedin=namedStmtMastersSection

" hi link namedM_E_IP6addr namedHL_Number
syn match namedM_E_IP6addr contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedStmtMastersSection

hi link namedM_E_IP4addr namedHL_Number
syn match namedM_E_IP4addr contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedStmtMastersSection

syn region namedStmtMastersSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedM_Dscp_Number namedHL_Number
syn match namedM_Dscp_Number contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedM_Port,namedStmtMastersSection,namedSemicolon

hi link namedM_Port_Number namedHL_Number
syn match namedM_Port_Number contained skipwhite
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ nextgroup=namedM_Dscp,namedStmtMastersSection,namedSemicolon

hi link namedM_Port  namedHL_Option
syn match namedM_Port /port/ contained skipwhite
\ nextgroup=namedM_Port_Number

hi link namedM_Dscp  namedHL_Option
syn match namedM_Dscp /dscp/ contained skipwhite
\ nextgroup=namedM_Dscp_Number

hi link namedStmt_MastersNameIdentifier namedHL_Identifier
syn match namedStmt_MastersNameIdentifier contained /\<[0-9a-zA-Z\-_\.]\{1,64}/
\ contains=namedMasterName
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedStmtMastersSection,
\    namedM_Port,
\    namedM_Dscp,
\    namedComment, namedInclude,
\    namedError

" End of Masters section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'options' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedO_Boolean_Group namedHL_Option
syn keyword namedO_Boolean_Group contained 
\     automatic-interface-scan 
\     answer-cookie
\     flush-zones-on-shutdown
\     match-mapped-addresses
\     memstatistics
\     querylog
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite

hi link namedO_UdpPorts namedHL_Option
syn keyword namedO_UdpPorts contained skipwhite
\    avoid-v4-udp-ports
\    avoid-v6-udp-ports
\ nextgroup=named_PortSection,namedInclude,namedComment,namedError

hi link named_Hostname_SC namedHL_Builtin
syn keyword named_Hostname_SC contained skipwhite
\    hostname
\ nextgroup=namedSemicolon

hi link namedO_ServerId namedHL_Option
syn keyword namedO_ServerId contained skipwhite
\    server-id
\ nextgroup=
\    named_Builtin_None_SC,
\    named_Hostname_SC,
\    named_QuotedDomain_SC

hi link namedO_String_QuoteForced namedHL_Option
syn keyword namedO_String_QuoteForced contained skipwhite
\    bindkeys-file
\    cache-file
\    directory
\    dump-file
\    geoip-directory
\    managed-keys-directory
\    memstatistics-file
\    named-xfer
\    pid-file
\ nextgroup=
\    named_String_QuoteForced_SC,
\    namedNotString

hi link namedO_ListenOn_DscpValue namedHL_Number
syn match namedO_ListenOn_DscpValue contained skipwhite skipnl skipempty
\ /\d\{1,11}/
\ nextgroup=
\    namedA_AML

hi link namedO_ListenOn_Dscp namedHL_Option
syn keyword namedO_ListenOn_Dscp contained dscp skipwhite skipnl skipempty
\ nextgroup=namedO_ListenOn_DscpValue

hi link namedO_ListenOn_PortValue namedHL_Number
syn match namedO_ListenOn_PortValue contained skipwhite skipnl skipempty
\ /\d\{1,5}/
\ nextgroup=
\    namedA_AML,
\    namedO_ListenOn_Dscp

hi link namedO_ListenOn_Port namedHL_Option
syn keyword namedO_ListenOn_Port contained port skipwhite skipnl skipempty
\ nextgroup=
\    namedO_ListenOn_PortValue

hi link namedO_ListenOn namedHL_Option
syn keyword namedO_ListenOn contained skipwhite skipnl skipempty
\    listen-on
\    listen-on-v6
\ nextgroup=
\    namedO_ListenOn_Port,
\    namedO_ListenOn_Dscp,
\    namedA_AML,
\    namedInclude,
\    namedComment

hi link namedO_Blackhole namedHL_Option
syn keyword namedO_Blackhole contained skipwhite
\    blackhole
\ nextgroup=
\    namedA_AML,
\    namedInclude,
\    namedComment

hi link namedO_CheckNamesType namedHL_Builtin
syn match namedO_CheckNamesType contained /primary/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /secondary/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /response/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /master/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC
syn match namedO_CheckNamesType contained /slave/ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC 

" not the same as 'check-names' in View or Zone
hi link namedO_CheckNames namedHL_Option
syn keyword namedO_CheckNames contained check-names skipwhite
\ nextgroup=
\    namedO_CheckNamesType,
\    namedError

hi link namedO_CookieAlgorithmChoices namedHL_Type
syn match namedO_CookieAlgorithmChoices contained skipwhite
\ /\%(aes\)\|\%(sha256\)\|\%(sha1\)/
\ nextgroup=namedSemicolon,namedError

hi link namedO_CookieAlgs namedHL_Option
syn keyword namedO_CookieAlgs contained cookie-algorithm
\ skipwhite
\ nextgroup=
\    namedO_CookieAlgorithmChoices

hi link namedO_CookieSecretValue namedHL_Identifier
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{32}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{20}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedO_CookieSecretValue contained 
\ /\c['"][0-9a-f]\{16}['"]/
\ contains=namedHexSecretValue
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_CookieSecret namedHL_Option
syn keyword namedO_CookieSecret contained cookie-secret
\ skipwhite
\ nextgroup=namedO_CookieSecretValue

hi link named_NumberSize_SC namedHL_Number
syn match named_NumberSize_SC contained
\ /\<\d\{1,10}[bBkKMmGgPp]\{0,1}\>/he=e-1
\ nextgroup=namedSemicolon

hi link namedO_DefaultUnlimitedSize namedHL_Option
syn keyword namedO_DefaultUnlimitedSize contained 
\     coresize
\     datasize
\     stacksize
\ skipwhite
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

hi link namedO_DnstapOutputSuffix namedHL_Builtin
syn keyword namedO_DnstapOutputSuffix contained 
\    increment
\    timestamp
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputSize namedHL_Number
syn match namedO_DnstapOutputSize contained /[0-9]\+/
\ skipwhite
\ nextgroup=namedSemicolon
    
hi link namedO_DnstapOutputSizeBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputSizeBuiltin contained 
\    unlimited
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputVersionBuiltin namedHL_Builtin
syn keyword namedO_DnstapOutputVersionBuiltin contained 
\    unlimited
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputVersion namedHL_Number
syn match namedO_DnstapOutputVersion contained /\d\+/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputKywdVersion namedHL_Option
syn keyword namedO_DnstapOutputKywdVersion contained version 
\ skipwhite
\ nextgroup=
\    namedO_DnstapOutputVersionBuiltin
\    namedO_DnstapOutputVersion
\ containedin=
\    namedO_DnstapOutputSection

hi link namedO_DnstapOutputKywdSize namedHL_Option
syn keyword namedO_DnstapOutputKywdSize contained size 
\ skipwhite
\ nextgroup=
\    namedO_DnstapOutputSizeBuiltin,
\    namedO_DnstapOutputSize
\ containedin=
\    namedO_DnstapOutputSection

hi link namedO_DnstapOutputKywdSuffix namedHL_Option
syn keyword namedO_DnstapOutputKywdSuffix contained suffix 
\ skipwhite
\ nextgroup=namedO_DnstapOutputSuffix
\ containedin=
\    namedO_DnstapOutputSection

syn region namedO_DnstapOutputSection contained start=/\zs\S\ze/ end=/;/me=e-1
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_DnstapOutputFilespec namedHL_String
syn match namedO_DnstapOutputFilespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl  nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection
syn match namedO_DnstapOutputFilespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl nextgroup=namedO_DnstapOutputSection

hi link namedO_DnstapOutputType namedHL_Type
syn keyword namedO_DnstapOutputType contained skipwhite skipempty
\    file
\    unix
\ nextgroup=namedO_DnstapOutputFilespec

hi link namedO_DnstapOutputKeyword namedHL_Option
syn keyword namedO_DnstapOutputKeyword contained dnstap-output skipwhite skipempty
\ nextgroup=
\    namedO_DnstapOutputType,
\    namedO_DnstapOutputFilespec

hi link namedO_DnstapVersion namedHL_Option
syn keyword namedO_DnstapVersion contained
\    dnstap-version
\ skipwhite
\ nextgroup=
\    named_Builtin_None_SC,
\    named_E_Filespec_SC

hi link namedO_DscpNumber namedHL_Number
syn match namedO_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Dscp namedHL_Option
syn keyword namedO_Dscp contained dscp skipwhite
\ nextgroup=namedO_DscpNumber

hi link namedO_Fstrm_ModelValue namedHL_Builtin
syn keyword namedO_Fstrm_ModelValue contained
\    mpsc
\    spsc
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedO_Fstrm_Model namedHL_Option
syn keyword namedO_Fstrm_Model contained
\    fstrm-set-output-queue-model
\ skipwhite
\ nextgroup=namedO_Fstrm_ModelValue

hi link namedO_InterfaceInterval namedHL_Option
syn keyword namedO_InterfaceInterval contained skipwhite
\    interface-interval
\ nextgroup=named_Number_Max28day_SC

hi link namedO_Number_Group namedHL_Option
syn keyword namedO_Number_Group contained
\    fstrm-set-buffer-hint
\    fstrm-set-flush-timeout
\    fstrm-set-input-queue-size
\    fstrm-set-output-notify-threshold
\    fstrm-set-output-queue-size
\    fstrm-set-reopen-interval
\    max-rsa-exponent-size
\    nocookie-udp-size
\    notify-rate
\    recursive-clients
\    reserved-sockets
\    serial-query-rate
\    startup-notify-rate
\    tcp-advertised-timeout
\    tcp-clients
\    tcp-idle-timeout
\    tcp-initial-timeout
\    tcp-keepalive-timeout
\    tcp-listen-queue
\    transfer-message-size
\    transfers-in
\    transfers-out
\    transfers-per-ns
\ skipwhite
\ nextgroup=named_Number_SC

hi link namedO_Ixfr_From_Diff_Opts namedHL_Builtin
syn keyword namedO_Ixfr_From_Diff_Opts contained
\    primary
\    master
\    secondary
\    slave
\ skipwhite
\ nextgroup=namedSemicolon

" ixfr-from-differences is different in View/Zone sections
hi link namedO_Ixfr_From_Diff namedHL_Option
syn keyword namedO_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ nextgroup=namedO_Ixfr_From_Diff_Opts

hi link namedO_KeepResponseOrder namedHL_Option
syn keyword namedO_KeepResponseOrder contained skipwhite skipempty
\     keep-response-order 
\ nextgroup=namedA_AML

hi link namedO_RecursingFile namedHL_Option
syn keyword namedO_RecursingFile contained skipwhite
\    recursing-file
\ nextgroup=named_E_Filespec_SC

hi link namedO_Filespec_None_ForcedQuoted_Group namedHL_Option
syn keyword namedO_Filespec_None_ForcedQuoted_Group contained skipwhite
\    random-device
\ nextgroup=
\    named_E_Filespec_SC,
\    named_Builtin_None_SC

hi link namedO_Filespec_Group namedHL_Option
syn keyword namedO_Filespec_Group contained skipwhite
\    secroots-file
\    statistics-file
\ nextgroup=
\    named_E_Filespec_SC,
\    named_Builtin_None_SC

hi link namedO_Port namedHL_Option
syn keyword namedO_Port contained port skipwhite
\ nextgroup=named_Port_SC

hi link namedO_SessionKeyAlg namedHL_Option
syn keyword namedO_SessionKeyAlg contained session-keyalg skipwhite
\ nextgroup=named_AlgorithmName_SC

hi link namedO_SessionKeyfile namedHL_Option
syn keyword namedO_SessionKeyfile contained session-keyfile skipwhite
\ nextgroup=
\    named_Filespec_SC,
\    named_Builtin_None_SC

" RNDC/rndc keywords
hi link namedO_DefaultKey namedHL_Option
syn keyword namedO_DefaultKey contained default-key skipwhite skipnl skipempty
\ nextgroup=
\    namedKeyName_SC

hi link namedO_DefaultServer namedHL_Option
syn keyword namedO_DefaultServer contained default-server skipwhite skipnl skipempty
\ nextgroup=
\    named_E_IP4Addr_SC,
\    named_E_IP6Addr_SC

hi link namedO_DefaultPort namedHL_Option
syn keyword namedO_DefaultPort contained default-port skipwhite skipnl skipempty
\ nextgroup=
\    named_Port_SC
" syn keyword namedO_Keywords deallocate-on-exit
" syn keyword namedO_Keywords deallocate-on-exit
" syn keyword namedO_Keywords filter-aaaa
" syn keyword namedO_Keywords filter-aaaa-on-v4
" syn keyword namedO_Keywords filter-aaaa-on-v6
" syn keyword namedO_Keywords host-statistics
" syn keyword namedO_Keywords host-statistics-max
" syn keyword namedO_Keywords lock-file
" syn keyword namedO_Keywords min-roots
" syn keyword namedO_Keywords multiple-cnames
" syn keyword namedO_Keywords mult-master
" syn keyword namedO_Keywords nosit-udp-size
" syn keyword namedO_Keywords notify
" syn keyword namedO_Keywords queryport-port-ports
" syn keyword namedO_Keywords queryport-port-updateinterval
" syn keyword namedO_Keywords querylog
" syn keyword namedO_Keywords request-nsid
" syn keyword namedO_Keywords request-sit
" syn keyword namedO_Keywords response-policy
" syn keyword namedO_Keywords rfc2308-type1
" syn keyword namedO_Keywords rrset-order
" syn keyword namedO_Keywords sit-secret
" syn keyword namedO_Keywords statistics-interval
" syn keyword namedO_Keywords support-ixfr
" syn keyword namedO_Keywords suppress-initial-notify
" syn keyword namedO_Keywords tkey-dhkey
" syn keyword namedO_Keywords tkey-domain
" syn keyword namedO_Keywords tkey-gssapi-credential
" syn keyword namedO_Keywords tkey-gssapi-keytab
" syn keyword namedO_Keywords transfers
" syn keyword namedO_Keywords transfers-format
" syn keyword namedO_Keywords transfers-source
" syn keyword namedO_Keywords transfers-source-v6
" syn keyword namedO_Keywords trusted-anchor-telemetry
" syn keyword namedO_Keywords use-v4-udp-ports
" syn keyword namedO_Keywords use-v6-udp-ports
" syn keyword namedO_Keywords version

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'plugin' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedP_Parameter namedHL_String
syn match namedP_Parameter contained skipwhite
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)=+\{\}]\{1,1024}"/hs=s+1,he=e-1
\ containedin=namedP_ParametersSection
syn match namedP_Parameter contained 
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)=+\{\}]\{1,1024}'/hs=s+1,he=e-1
\ containedin=namedP_ParametersSection
syn match namedP_Parameter contained 
\ /[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)=+]\{1,1024}/
\ containedin=namedP_ParametersSection

syn region namedP_ParametersSection start=+{+ end=+}+ contained 
\ nextgroup=namedSemicolon

hi link namedP_Filespec namedHL_Identifier
hi link namedP_Filespec namedHL_String
syn match namedP_Filespec contained skipwhite skipempty skipnl
\ /'[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1
\ nextgroup=namedP_ParametersSection
syn match namedP_Filespec contained skipwhite skipempty skipnl
\ /"[ a-zA-Z\]\-\[0-9\._,:;\\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1
\ nextgroup=namedP_ParametersSection
syn match namedP_Filespec contained skipwhite skipempty skipnl
\ /[a-zA-Z\]\-\[0-9\._,:\\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ 
\ nextgroup=namedP_ParametersSection

hi link namedStmt_Plugin_QueryKeyword namedHL_Option
syn keyword namedStmt_Plugin_QueryKeyword contained query skipwhite
\ nextgroup=namedP_Filespec

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'server' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server-statement-specific syntaxes
hi link namedS_Bool_Group namedHL_Option
syn keyword namedS_Bool_Group contained
\   bogus
\   edns
\   request-nsid
\   tcp-keepalive
\   tcp-only
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite

hi link namedS_GroupNumber namedHL_Number
syn match namedS_GroupNumber contained /\d\{1,10}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedS_NumberGroup namedHL_Option
syn keyword namedS_NumberGroup contained
\ skipwhite
\    edns-version
\    padding
\    transfers
\ nextgroup=namedS_GroupNumber

hi link namedS_Keys_Id namedHL_String
syn match namedS_Keys_Id contained /[a-zA-Z0-9_\-]\{1,63}/ skipwhite
\ nextgroup=namedSemicolon

hi link namedS_Keys namedHL_Option
syn keyword namedS_Keys contained keys skipwhite
\ nextgroup=namedS_Keys_Id

" syn keyword namedStmtServerKeywords request-sit
" syn keyword namedStmtServerKeywords support-ixfr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'view' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" view statement - minute_type
hi link namedV_MinuteGroup namedHL_Statement
syn keyword namedV_MinuteGroup contained 
\    heartbeat-interval
\ skipwhite
\ nextgroup=
\    namedTypeMinutes,
\    namedComment,
\    namedError

hi link namedV_FilespecGroup namedHL_Option
syn keyword namedV_FilespecGroup contained
\ skipwhite
\    cache-file
\    managed-keys-directory
\ nextgroup=
\    named_String_QuoteForced,
\    namedNotString

hi link namedV_Match namedHL_Option
syn keyword namedV_Match contained skipwhite
\    match-clients
\    match-destinations
\ nextgroup=
\    namedA_AML,
\    namedError

hi link namedV_Key namedHL_Option
syn  keyword namedV_Key  contained key skipwhite
\ nextgroup=
\    namedStmtKeyIdent,
\    namedStmtKeySection

hi link namedV_Boolean_Group namedHL_Option
syn  keyword namedV_Boolean_Group  contained skipwhite
\    match-recursive-only
\ nextgroup=@namedClusterBoolean

" syn keyword namedV_Keywords class
" syn keyword namedV_Keywords filter-aaaa
" syn keyword namedV_Keywords filter-aaaa-on-v4
" syn keyword namedV_Keywords filter-aaaa-on-v6
" syn keyword namedV_Keywords min-roots
" syn keyword namedV_Keywords multiple-cnames
" syn keyword namedV_Keywords mult-master
" syn keyword namedV_Keywords nosit-udp-size
" syn keyword namedV_Keywords notify
" syn keyword namedV_Keywords queryport-port-ports
" syn keyword namedV_Keywords queryport-port-updateinterval
" syn keyword namedV_Keywords request-nsid
" syn keyword namedV_Keywords request-sit
" syn keyword namedV_Keywords response-policy
" syn keyword namedV_Keywords rfc2308-type1
" syn keyword namedV_Keywords support-ixfr
" syn keyword namedV_Keywords suppress-initial-notify
" syn keyword namedV_Keywords transfers
" syn keyword namedV_Keywords transfers-format
" syn keyword namedV_Keywords transfers-source
" syn keyword namedV_Keywords transfers-source-v6

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found only within 'zone' statement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedZ_Boolean_Group namedHL_Option
syn keyword namedZ_Boolean_Group contained skipwhite
\    delegation-only
\ nextgroup=@namedClusterBoolean_SC

hi link namedZ_File namedHL_Option
syn keyword namedZ_File contained file skipwhite
\ nextgroup=named_String_QuoteForced

hi link namedZ_InView namedHL_Option
syn keyword namedZ_InView contained in-view skipwhite
\ nextgroup=named_E_ViewName_SC

hi link namedZ_Filespec_Group namedHL_Option
syn keyword namedZ_Filespec_Group contained journal skipwhite
\ nextgroup=named_E_Filespec_SC

hi link namedZ_Masters namedHL_Option
syn keyword namedZ_Masters contained masters skipwhite
\ nextgroup=
\    namedComment,
\    namedInclude,
\    namedStmtMastersSection,
\    namedM_Port,
\    namedM_Dscp,
\    namedError
\ containedin=namedStmt_ZoneSection

hi link namedOVZ_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOVZ_DefaultUnlimitedSize_Group contained 
\    max-journal-size
\    max-ixfr-log-size
\ skipwhite
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

hi link namedZ_Database namedHL_Option
syn keyword namedZ_Database contained database skipwhite
\ nextgroup=named_E_Filespec_SC

hi link namedZ_ServerAddresses namedHL_Option
syn keyword namedZ_ServerAddresses contained skipwhite
\    server-addresses
\ nextgroup=namedA_AML

hi link namedZ_ServerNames namedHL_Option
syn keyword namedZ_ServerNames contained server-names skipwhite
\ nextgroup=namedA_AML

hi link namedZ_ZoneTypes namedHL_Builtin
syn keyword namedZ_ZoneTypes contained type skipwhite
\    primary
\    master
\    secondary
\    slave
\    mirror
\    hint
\    stub
\    static-stub
\    forward
\    redirect
\    delegation-only
\ nextgroup=namedSemicolon

hi link namedZ_ZoneType namedHL_Option
syn keyword namedZ_ZoneType contained type skipwhite
\ nextgroup=namedZ_ZoneTypes

" syn keyword namedZ_Keywords class
" syn keyword namedZ_Keywords client-per-query
" syn keyword namedZ_Keywords database
" syn keyword namedZ_Keywords mult-master
" syn keyword namedZ_Keywords notify
" syn keyword namedZ_Keywords rrset-order
" syn keyword namedZ_Keywords transfers-source
" syn keyword namedZ_Keywords transfers-source-v6
" syn keyword namedZ_Keywords type
" syn keyword namedZ_Keywords update-policy

" syn keyword namedO_KeywordsObsoleted acache-cleaning-interval
" syn keyword namedO_KeywordsObsoleted acache-enable
" syn keyword namedO_KeywordsObsoleted additional-from-auth
" syn keyword namedO_KeywordsObsoleted additional-from-cache
" syn keyword namedO_KeywordsObsoleted fake-iquery
" syn keyword namedO_KeywordsObsoleted has-old-clients
" syn keyword namedO_KeywordsObsoleted maintain-ixfr-base
" syn keyword namedO_KeywordsObsoleted max-acache-size
" syn keyword namedO_KeywordsObsoleted serial-queries
" syn keyword namedO_KeywordsObsoleted treat-cr-as-space
" syn keyword namedO_KeywordsObsoleted use-ixfr
" syn keyword namedO_KeywordsObsoleted use-queryport-pool
" syn keyword namedO_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedStmtServerKeywordsObsoleted edns-udp-size
" syn keyword namedStmtServerKeywordsObsoleted keys
" syn keyword namedStmtServerKeywordsObsoleted transfers
" syn keyword namedStmtServerKeywordsObsoleted transfers-format
" syn keyword namedStmtServerKeywordsObsoleted transfers-source
" syn keyword namedStmtServerKeywordsObsoleted transfers-source-v6

" syn keyword namedV_KeywordsObsoleted maintain-ixfr-base
" syn keyword namedV_KeywordsObsoleted max-acache-size
" syn keyword namedV_KeywordsObsoleted use-queryport-pool
" syn keyword namedV_KeywordsObsoleted use-queryport-updateinterval

" syn keyword namedZ_KeywordsObsoleted ixfr-base
" syn keyword namedZ_KeywordsObsoleted maintain-ixfr-base
" syn keyword namedZ_KeywordsObsoleted pubkey
" syn keyword namedZ_KeywordsObsoleted use-id-pool

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Both 'options' and 'servers' only.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOS_Boolean_Group namedHL_Option
syn keyword namedOS_Boolean_Group contained skipwhite
\    tcp-keepalive
\ nextgroup=@namedClusterBoolean
\ containedin=
\    namedStmt_OptionsSection,

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOSV_UdpSize namedHL_Option
syn keyword namedOSV_UdpSize contained skipwhite
\    edns-udp-size
\    max-udp-size
\ nextgroup=named_Number_UdpSize

" query-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" query-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];

hi link namedOSV_QuerySource_Dscp namedHL_Option
syn keyword namedOSV_QuerySource_Dscp contained dscp skipwhite
\ nextgroup=named_Dscp_SC

hi link namedOSV_QuerySource_PortValue namedHL_Number
syn match namedOSV_QuerySource_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Dscp,
\    namedSemicolon

hi link namedOSV_QuerySource_Port namedHL_Option
syn keyword namedOSV_QuerySource_Port contained port skipwhite
\ nextgroup=namedOSV_QuerySource_PortValue

hi link namedOSV_QuerySource_IP4Addr namedHL_Number
syn match namedOSV_QuerySource_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=namedOSV_QuerySource_Port

hi link namedOSV_QuerySource_Address namedHL_Option
syn keyword namedOSV_QuerySource_Address contained address skipwhite
\ nextgroup=namedOSV_QuerySource_IP4Addr

hi link namedOSV_QuerySource namedHL_Option
syn keyword namedOSV_QuerySource contained skipwhite
\    query-source
\ nextgroup=
\    namedOSV_QuerySource_Address,
\    namedOSV_QuerySource_IP4Addr,
\    namedOSV_QuerySource_Port

" query-source-v6 [address] 
"              ( * | <ip6_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" query-source-v6 [ [ address ] 
"                ( * | <ip6_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSV_QuerySource_IP6Addr namedHL_Number
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSV_QuerySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSV_QuerySource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSV_QuerySource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSV_QuerySource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSV_QuerySource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSV_QuerySource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSV_QuerySource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSV_QuerySource_Port,
\    namedSemicolon

hi link namedOSV_QuerySource_Address6 namedHL_Option
syn keyword namedOSV_QuerySource_Address6 contained address skipwhite
\ nextgroup=namedOSV_QuerySource_IP6Addr

hi link namedOSV_QuerySourceIP6 namedHL_Option
syn match namedOSV_QuerySourceIP6 contained skipwhite
\    /\<query-source-v6\>/
\ nextgroup=
\    namedOSV_QuerySource_Address6,
\    namedOSV_QuerySource_IP6Addr,
\    namedOSV_QuerySource_Port

hi link namedOSV_TransferFormat_Builtin namedHL_Builtin
syn keyword namedOSV_TransferFormat_Builtin contained skipwhite
\    many-answers
\    one-answer
\ nextgroup=namedSemicolon

hi link namedOSV_TransferFormat namedHL_Option
syn keyword namedOSV_TransferFormat contained transfer-format skipwhite
\ nextgroup=
\    namedOSV_TransferFormat_Builtin

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOV_SizeSpec_Group namedHL_Option
syn keyword namedOV_SizeSpec_Group contained skipwhite
\    lmdb-mapsize
\ nextgroup=named_SizeSpec

hi link namedOV_DefaultUnlimitedSize_Group namedHL_Option
syn keyword namedOV_DefaultUnlimitedSize_Group contained skipwhite
\    max-cache-size
\ nextgroup=
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

" <0-30000> millisecond
hi link namedOV_Interval_Max30ms_Group namedHL_Option
syn keyword namedOV_Interval_Max30ms_Group contained skipwhite
\    resolver-query-timeout
\    resolver-retry-interval
\ nextgroup=named_Interval_Max30ms_SC

hi link namedOV_Ttl_Group namedHL_Option
syn keyword namedOV_Ttl_Group contained skipwhite
\    lame-ttl
\    servfail-ttl
\ nextgroup=named_Ttl_Max30min_SC

hi link namedOV_Ttl90sec_Group namedHL_Option
syn keyword namedOV_Ttl90sec_Group contained skipwhite
\    min-cache-ttl
\    min-ncache-ttl
\ nextgroup=named_Ttl_Max90sec_SC

hi link namedOV_Ttl_Max3h_Group namedHL_Option
syn keyword namedOV_Ttl_Max3h_Group contained skipwhite
\    max-ncache-ttl
\ nextgroup=named_Ttl_Max3hour_SC

hi link namedOV_Ttl_Max1week_Group namedHL_Option
syn keyword namedOV_Ttl_Max1week_Group contained skipwhite
\    nta-lifetime
\    nta-recheck
\    max-cache-ttl
\ nextgroup=named_Ttl_Max1week_SC

" view statement - hostname [ none | <domain_name> ];
hi link named_Builtin_None_SC namedHL_Builtin
syn match named_Builtin_None_SC contained /none/ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_Hostname namedHL_Option
syn keyword namedOV_Hostname contained hostname skipwhite
\ nextgroup=
\    named_Builtin_None_SC,
\    named_QuotedDomain_SC

hi link namedOV_DnssecLookasideOptKeyname namedHL_String
syn match namedOV_DnssecLookasideOptKeyname contained 
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOV_DnssecLookasideOptTD namedHL_Clause
syn keyword namedOV_DnssecLookasideOptTD contained trust-anchor
\ nextgroup=namedOV_DnssecLookasideOptKeyname
\ skipwhite

hi link namedOV_DnssecLookasideOptDomain namedHL_String
syn match namedOV_DnssecLookasideOptDomain contained 
\    /[0-9A-Za-z][-0-9A-Za-z\.\-_]\+/ 
\ nextgroup=namedOV_DnssecLookasideOptTD
\ skipwhite

hi link namedOV_DnssecLookasideOptAuto namedHL_Error
syn keyword namedOV_DnssecLookasideOptAuto contained auto
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_DnssecLookasideOpt namedHL_Type
syn keyword namedOV_DnssecLookasideOpt contained no
\ skipwhite
\ nextgroup=namedSemicolon

" dnssec-lookaside [ auto | no | <domain_name> trusted-anchor <key_name>];
hi link namedOV_DnssecLookasideKeyword namedHL_Option
syn keyword namedOV_DnssecLookasideKeyword contained
\    dnssec-lookaside
\ skipwhite
\ nextgroup=
\    namedOV_DnssecLookasideOpt,
\    namedOV_DnssecLookasideOptDomain,
\    namedOV_DnssecLookasideOptAuto

hi link namedOV_Boolean_Group namedHL_Option
syn keyword namedOV_Boolean_Group contained
\    allow-new-zones
\    auth-nxdomain 
\    dnsrps-enable
\    dnssec-accept-expired
\    dnssec-enable
\    empty-zone-enable
\    fetch-glue
\    glue-cache
\    message-compression
\    minimal-any
\    recursion
\    require-server-cookie
\    root-key-sentinel
\    stale-answer-enable
\    synth-from-dnssec
\    trust-anchor-telemetry
\ nextgroup=@namedClusterBoolean_SC
\ skipwhite
\ containedin=
\    namedStmt_ViewSection 

hi link namedOV_Filespec namedHL_Option
syn keyword namedOV_Filespec contained
\    new-zones-directory
\ skipwhite
\ nextgroup=named_E_Filespec_SC

" allow-query-cache { <address_match_list>; };
" allow-query-cache-on { <address_match_list>; };
" allow-recursion { <address_match_list>; };
" allow-recursion-on { <address_match_list>; };

hi link namedOV_IP4Addr namedHL_Number
syn match namedOV_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/

syn region namedOV_AML_Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ contains=
\    namedOV_IP4Addr_SC
\ nextgroup=
\    namedSemicolon,
\    namedParenError
\ containedin=
\    namedElementAMLSection,

hi link namedOV_AML_Group namedHL_Option
syn keyword namedOV_AML_Group contained skipwhite skipempty
\    allow-query-cache
\    allow-query-cache-on
\    allow-recursion
\    allow-recursion-on
\    no-case-compress
\    sortlist
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen

hi link namedOV_AttachCache namedHL_Option
syn keyword namedOV_AttachCache contained attach-cache skipwhite
\ nextgroup=
\    named_E_ViewName_SC,
\    namedError

hi link namedOV_Number_Group namedHL_Option
syn keyword namedOV_Number_Group contained
\    clients-per-query 
\    max-clients-per-query 
\    resolver-nonbackoff-tries
\    max-recursion-depth
\    max-recursion-queries
\    max-stale-ttl
\    stale-answer-ttl
\    v6-bias
\ skipwhite
\ nextgroup=named_Number_SC

hi link namedOV_DnsrpsElement namedHL_String
syn region namedOV_DnsrpsElement start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsElement start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1 contained
\ skipwhite
\ nextgroup=namedSemicolon
\ containedin=namedOV_DnsrpsOptionsSection

syn region namedOV_DnsrpsOptionsSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon,namedNotSemicolon

hi link namedOV_DnsrpsOptions namedHL_Option
syn keyword namedOV_DnsrpsOptions contained
\    dnsrps-options
\ skipwhite
\ nextgroup=
\    namedOV_DnsrpsOptionsSection

syn match namedOV_DenyAnswerElementDomainName /['"][_\-0-9A-Za-z\.]\{1,1024}['"]/
\ contained skipwhite skipempty 
\ contains=namedDomain
\ nextgroup=namedSemicolon

" deny-answer-addresses { <AML>; } [ except from { <domain_name>; }; } ];
syn region namedOV_DenyAnswerExceptSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedSemicolon

" deny-answer-addresses { <AML>; } [ except from { ... }; } ];
hi link namedOV_DenyAnswerExceptKeyword namedHL_Option
syn match namedOV_DenyAnswerExceptKeyword contained
\    /\(except\)\s\+\(from\)/
\ skipwhite
\ nextgroup=
\    namedOV_DenyAnswerExceptSection,
\    namedSemicolon
 
" deny-answer-addresses { <AML>; } ...
syn region namedOV_DenyAnswerAddrSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOV_DenyAnswerExceptKeyword,
\    namedSemicolon

" deny-answer-addresses { } ...
hi link namedStmtOptionsViewDenyAnswerAddrKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAddrKeyword contained 
\    deny-answer-addresses
\ skipwhite
\ nextgroup=namedOV_DenyAnswerAddrSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" deny-answer-aliases { <AML>; } ...
syn region namedOV_DenyAnswerAliasSection contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=
\    named_E_ACLName_SC,
\    namedOV_DenyAnswerElementDomainName,
\    namedInclude,
\    namedComment 
\ nextgroup=
\    namedOV_DenyAnswerExceptKeyword,
\    namedSemicolon

" deny-answer-aliases { } ...
hi link namedStmtOptionsViewDenyAnswerAliasKeyword namedHL_Option
syn keyword namedStmtOptionsViewDenyAnswerAliasKeyword contained 
\    deny-answer-aliases
\ skipwhite
\ nextgroup=namedOV_DenyAnswerAliasSection
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" disable-algorithms <name> { <algo_name>; ... };
hi link namedOV_DisableAlgosElementName namedHL_String
syn match namedOV_DisableAlgosElementName contained 
\   /['"]\?[a-zA-Z0-9\.\-_]\{1,64}['"]\?/
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ containedin=namedOV_DisableAlgosSection

" disable-algorithms <name> { ...; };
syn region namedOV_DisableAlgosSection contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon

" disable-algorithms <name> { ... };
hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /[a-zA-Z0-9\.\-_]\{1,64}/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /"[a-zA-Z0-9\.\-_]\{1,64}"/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

hi link namedOV_DisableAlgosIdent namedHL_Identifier
syn match namedOV_DisableAlgosIdent contained 
\   /'[a-zA-Z0-9\.\-_]\{1,64}'/
\ skipwhite
\ nextgroup=namedOV_DisableAlgosSection

" disable-algorithms <name> ...
hi link namedOV_DisableAlgorithms namedHL_Option
syn keyword namedOV_DisableAlgorithms contained 
\    disable-algorithms
\ skipwhite skipempty
\ nextgroup=namedOV_DisableAlgosIdent

" disable-ds-digests <name> ...
hi link namedOV_DisableDsDigests namedHL_Option
syn keyword namedOV_DisableDsDigests contained 
\    disable-ds-digests
\ skipwhite skipempty
\ nextgroup=namedOV_DisableAlgosIdent

hi link namedOV_DisableEmptyZone namedHL_Option
syn keyword namedOV_DisableEmptyZone contained skipwhite
\    disable-empty-zone 
\ nextgroup=
\    namedElementZoneName,
\    namedError

hi link namedOV_Dns64Element namedHL_Option
" dns64 <netprefix> { break-dnssec <boolean>; };
syn keyword namedOV_Dns64Element contained 
\    break-dnssec
\    recursive-only
\ skipwhite
\ nextgroup=@namedClusterBoolean


" dns64 <netprefix> { clients { xxx; }; };
syn region namedOV_Dns64ClientsSection contained start=+{+ end=+}+
\ skipwhite
\ contains=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

" dns64 <netprefix> { suffix <ip_addr>; };
syn keyword namedOV_Dns64Element contained suffix
\ skipwhite
\ nextgroup=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_E_ACLName_SC

" dns64 <netprefix> { break-dnssec <bool>; };
syn match namedOV_Dns64Element contained 
\    /\(break-dnssec\)\|\(recursive-only\)/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

" dns64 <netprefix> { mapped { ... }; };
syn keyword namedOV_Dns64Element contained 
\    clients
\    exclude
\    mapped
\ skipwhite
\ nextgroup=namedOV_Dns64ClientsSection

" dns64 <netprefix> { <AML>; };
syn region namedOV_Dns64Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ contains=namedOV_Dns64Element
\ nextgroup=namedSemicolon

" dns64 <netprefix> { 
hi link namedOV_Dns64Ident namedError
syn match namedOV_Dns64Ident contained /[0-9a-fA-F:%\.\/]\{7,48}/
\ contained skipwhite skipempty
\ contains=named_IP4AddrPrefix,named_IP6AddrPrefix
\ nextgroup=namedOV_Dns64Section

" dns64 <netprefix> 
hi link namedOV_Dns64 namedHL_Option
syn keyword namedOV_Dns64 contained dns64 skipwhite
\ nextgroup=
\    namedOV_Dns64Ident,
\    namedError
\ containedin=
\    namedStmt_OptionsSection,
\    namedStmt_ViewSection

" dns64-contact <string>
" dns64-server <string>
hi link namedOV_Dns64_Group namedHL_Option
syn keyword namedOV_Dns64_Group contained skipwhite
\    dns64-contact
\    dns64-server
\    empty-server
\    empty-contact
\ nextgroup=
\    named_QuotedDomain_SC,
\    namedError

hi link named_Auto_SC namedHL_Builtin
syn match named_Auto_SC contained /auto/ skipwhite
\ nextgroup=namedSemicolon

" dnssec-validation [ yes | no | auto ];
hi link namedOV_DnssecValidation namedHL_Option
syn keyword namedOV_DnssecValidation contained 
\    dnssec-validation
\ skipwhite
\ nextgroup=
\    @namedClusterBoolean_SC,
\    named_Auto_SC

" dnstap { ... };
hi link namedOV_DnstapClauses namedHL_Builtin
syn keyword namedOV_DnstapClauses contained
\    query
\    response
\ nextgroup=namedSemicolon
\ skipwhite

hi link namedOV_DnstapOpts namedHL_Builtin
syn keyword namedOV_DnstapOpts contained 
\    all 
\    auth
\    client
\    forwarder
\    resolver
\    update
\ skipwhite
\ nextgroup=namedOV_DnstapClauses

syn region namedOV_DnstapSection contained start=+{+ end=+}+
\ skipwhite skipempty skipnl
\ nextgroup=namedSemicolon
\ contains=namedOV_DnstapOpts

hi link namedOV_Dnstap namedHL_Option
syn keyword namedOV_Dnstap contained 
\    dnstap
\ skipwhite
\ nextgroup=namedOV_DnstapSection

hi link namedOV_FetchQuotaParamsHigh namedHL_Number
syn match namedOV_FetchQuotaParamsHigh contained /\d\{1,10}\.\d/ skipwhite nextgroup=namedSemicolon

hi link namedOV_FetchQuotaParamsMed namedHL_Number
syn match namedOV_FetchQuotaParamsMed contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsHigh

hi link namedOV_FetchQuotaParamsLow namedHL_Number
syn match namedOV_FetchQuotaParamsLow contained
\    /\d\{1,10}\.\d/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsMed

hi link namedOV_FetchQuotaParamsRecalPerQueries namedHL_Number
syn match namedOV_FetchQuotaParamsRecalPerQueries contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaParamsLow

hi link namedOV_FetchQuotaParams namedHL_Option
syn keyword namedOV_FetchQuotaParams contained fetch-quota-params skipwhite
\ nextgroup=
\    namedOV_FetchQuotaParamsRecalPerQueries

hi link namedOV_FetchQuotaPersType namedHL_Builtin
syn keyword namedOV_FetchQuotaPersType contained
\    fail
\    drop
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_FetchQuotaPersValue namedHL_Number
syn match namedOV_FetchQuotaPersValue contained
\    /\d\{1,10}/
\ skipwhite
\ nextgroup=namedOV_FetchQuotaPersType

hi link namedOV_FetchPers namedHL_Option
syn keyword namedOV_FetchPers contained 
\    fetches-per-server
\    fetches-per-zone
\ skipwhite
\ nextgroup=
\    namedOV_FetchQuotaPersValue

" heartbeat-interval: range: 0-40320
hi link named_Number_Max28day_SC namedHL_Number
syn match named_Number_Max28day_SC contained
\ /\%(40320\)\|\%(403[0-1][0-9]\)\|\%(40[0-2][0-9][0-9]\)\|\%([1-3][0-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9][0-9]\)\|\%([1-9][0-9][0-9]\)\|\%([1-9][0-9]\)\|\%([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_HeartbeatInterval namedHL_Option
syn keyword namedOV_HeartbeatInterval contained skipwhite
\    heartbeat-interval
\ nextgroup=named_Number_Max28day_SC

"  dual-stack-servers [ port <pg_num> ] 
"                     { ( <domain_name> [port <p_num>] |
"                         <ipv4> [port <p_num>] | 
"                         <ipv6> [port <p_num>] ); ... };
"  /.\+/
"  /\is*;/
hi link namedOV_DualStack_E_Port namedHL_Option
syn match namedOV_DualStack_E_Port /port/
\ contained skipwhite
\ nextgroup=named_Port,namedWildcard

syn match namedDSS_Element_DomainAddrPort 
\ /\<[0-9A-Za-z\._\-]\+\>/ 
\ contained skipwhite
\ contains=namedDomain
\ nextgroup=
\    namedOV_DualStack_E_Port,
\    namedSemicolon,
\    namedError

syn region namedOV_DualStack_Section start=+{+ end=/}/ contained 
\ contains=
\     namedDSS_Element_DomainAddrPort,
\     namedInclude,
\     namedComment
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOV_DualStack_PortValue namedHL_Number
syn match namedOV_DualStack_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=namedOV_DualStack_Section

hi link namedOV_DualStack_Port namedHL_Option
syn keyword namedOV_DualStack_Port contained port contained 
\ nextgroup=namedOV_DualStack_PortValue
\ skipwhite

hi link namedOV_DualStack namedHL_Option
syn keyword namedOV_DualStack contained dual-stack-servers skipwhite
\ nextgroup=
\    namedOV_DualStack_Port,
\    namedOV_DualStack_Section

" Gee whiz, ya think they could have used SEMICOLON within
" 'catalog-zone' ... ya know, out of consistency????
" Before I make convoluted syntaxes just for this corner 
" case.  I am going to build latest Bind9 9.17 and test 
" this assumption and pray that it is just a bad case of 
" documentation ... I thought it would be this:
"
" catalog-zones {
"     zone <zone_name> {
"         default-masters { <ip_addr>; ... };
"         in-memory no;
"         zone-directory <filespec>;
"         min-update-interval <seconds>;
"         };
"     ... 
"     };
" FUCK! Tested 9.17; zone is that must first keyword but 
" the rest can come in any order.  
" This means ALL needed syntaxes in here must be cloned 
" and used ONLY by and within 'catalog-zones'. 
" No reuse of prior existing syntax here possible.  
" Crap.  
" Could/should/would have introduced curly braces as
" I've thought and shown above earlier.
"
" catalog-zones {
"     zone <zone_name> default-masters { <ip_addr>; ... }
"         in-memory no  zone-directory <filespec>
"         min-update-interval <seconds>
"       ; ... };

hi link namedOV_CZ_Filespec namedHL_String
syn match namedOV_CZ_Filespec contained /'[ a-zA-Z\]\-\[0-9\._,:;\/?<>|"`~!@#$%\^&*\\(\\)+{}]\{1,1024}'/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /"[ a-zA-Z\]\-\[0-9\._,:;\/?<>|'`~!@#$%\^&*\\(\\)+{}]\{1,1024}"/hs=s+1,he=e-1 skipwhite skipempty skipnl
syn match namedOV_CZ_Filespec contained /[a-zA-Z\]\-\[0-9\._,:\/?<>|'"`~!@#$%\^&*\\(\\)+]\{1,1024}/ skipwhite skipempty skipnl

hi link  namedOV_CZ_ZoneDir namedHL_Clause
syn keyword namedOV_CZ_ZoneDir contained zone-directory skipwhite
\ nextgroup=namedOV_CZ_Filespec
\ containedin=namedOV_CatalogZones_Section

hi link  namedOV_CZ_MinUpdate_Interval namedHL_Number
syn match namedOV_CZ_MinUpdate_Interval contained /\d\+/ skipwhite
\ nextgroup=
\    namedOV_CZ_InMemory,
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
\ containedin=namedOV_CatalogZones_Section

hi link  namedOV_CZ_MinUpdate namedHL_Clause
syn keyword namedOV_CZ_MinUpdate contained min-update-interval skipwhite
\ nextgroup=namedOV_CZ_MinUpdate_Interval
\ containedin=namedOV_CatalogZones_Section

hi link namedOV_CZ_InMemory_Boolean namedHL_Type
syn match namedOV_CZ_InMemory_Boolean contained /\cyes/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\cno/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\ctrue/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn match namedOV_CZ_InMemory_Boolean contained /\cfalse/ skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn keyword namedOV_CZ_InMemory_Boolean contained 1 skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
syn keyword namedOV_CZ_InMemory_Boolean contained 0 skipwhite 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon

hi link  namedOV_CZ_InMemory namedHL_Clause
syn keyword namedOV_CZ_InMemory contained in-memory skipwhite
\ nextgroup=
\    namedOV_CZ_InMemory_Boolean
\ containedin=
\    namedOV_CatalogZones_Section

syn region namedOV_CZ_DefMasters_MML contained start=+{+ end=+}+ skipwhite skipempty
\ nextgroup=
\    namedOV_CZ_InMemory,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_ZoneDir,
\    namedSemicolon
\ contains=
\    namedInclude,
\    namedComment 

hi link  namedOV_CZ_DefMasters namedHL_Clause
syn keyword namedOV_CZ_DefMasters contained default-masters skipwhite
\ nextgroup=namedOV_CZ_DefMasters_MML
\ containedin=namedOV_CatalogZones_Section

hi link namedOV_CZ_QuotedDomain namedHL_Identifier
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /[0-9A-Za-z\._\-]\{1,1023}\.\{0,1}/
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /'[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}'/hs=s+1,he=e-1
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon
syn match namedOV_CZ_QuotedDomain contained skipwhite
\ /"[0-9A-Za-z\.\-_]\{1,1023}\.\{0,1}"/hs=s+1,he=e-1 
\ nextgroup=
\    namedOV_CZ_DefMasters,
\    namedOV_CZ_MinUpdate,
\    namedOV_CZ_InMemory,
\    namedSemicolon

hi link namedOV_CZ_Zone namedHL_Clause
syn keyword namedOV_CZ_Zone contained zone skipwhite
\ nextgroup=namedOV_CZ_QuotedDomain
\ containedin=namedOV_CatalogZones_Section

syn region namedOV_CatalogZones_Section contained start=+{+ end=+}+
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon

hi link namedOV_CatalogZones namedHL_Option
syn keyword namedOV_CatalogZones contained catalog-zones skipwhite
\ nextgroup=
\    namedOV_CatalogZones_Section

hi link namedOV_QnameMin namedHL_Option
syn keyword namedOV_QnameMin contained qname-minimization skipwhite
\ nextgroup=
\    named_StrictRelaxedDisabledOff

hi link namedOV_MinResponse_Opts namedHL_Builtin
syn keyword namedOV_MinResponse_Opts contained skipwhite
\    no-auth
\    no-auth-recursive
\ nextgroup=namedSemicolon

hi link namedOV_MinimalResponses namedHL_Option
syn keyword namedOV_MinimalResponses contained skipwhite
\    minimal-responses
\ nextgroup=
\    namedOV_MinResponse_Opts,
\    @namedClusterBoolean

hi link namedOV_NxdomainRedirect namedHL_Option
syn keyword namedOV_NxdomainRedirect contained skipwhite
\    nxdomain-redirect
\ nextgroup=named_QuotedDomain_SC

hi link namedOV_RootDelegation_Domain namedHL_Domain
syn match namedOV_RootDelegation_Domain contained /\<[0-9A-Za-z\._\-]\+\>/
\ nextgroup=namedSemicolon
\ containedin=namedOV_RootDelegation_Section

syn region namedOV_RootDelegation_Section contained start=+{+ end=+}+
\ skipwhite skipempty
\ nextgroup=namedSemicolon

hi link namedOV_RootDelegation_Opts namedHL_Clause
syn match namedOV_RootDelegation_Opts contained /exclude/ skipwhite
\ nextgroup=namedOV_RootDelegation_Section

hi link namedOV_RootDelegation namedHL_Option
syn keyword namedOV_RootDelegation contained skipwhite
\    root-delegation-only
\ nextgroup=
\    namedOV_RootDelegation_Opts

hi link namedOV_AorAAAA_SC namedHL_Builtin
" syn match namedOV_AorAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match namedOV_AorAAAA_SC /\ca/ contained skipwhite nextgroup=namedSemicolon
syn match namedOV_AorAAAA_SC /\caaaa/ contained skipwhite nextgroup=namedSemicolon

hi link namedOV_AorAAAA namedHL_Option
syn keyword namedOV_AorAAAA contained skipwhite
\    preferred-glue
\ nextgroup=namedOV_AorAAAA_SC 

hi link named_Number_Max10sec_SC namedHL_Number
syn match named_Number_Max10sec_SC contained skipwhite 
\     /\d\+/
\ nextgroup=
\    namedSemicolon

hi link namedOV_First_Number_Max10sec namedHL_Number
syn match namedOV_First_Number_Max10sec contained skipwhite 
\     /\d\+/
\ nextgroup=
\    namedSemicolon,
\    named_Number_Max10sec_SC

hi link namedOV_Prefetch namedHL_Option
syn keyword namedOV_Prefetch contained skipwhite
\    prefetch
\ nextgroup=
\    namedOV_First_Number_Max10sec

hi link namedOV_Key namedHL_Option
syn match namedOV_Key contained /\_^\_s*\<key\>/ skipwhite
\ nextgroup=namedStmtKeyIdent

hi link namedOV_RateLimit_AllPerSec namedHL_Clause
syn keyword namedOV_RateLimit_AllPerSec contained all-per-second skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ErrorsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ErrorsPerSec contained skipwhite
\    errors-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

syn region namedOV_RateLimit_ExemptClientsSection contained start=/{/ end=/}/ skipwhite skipempty
\ contains=
\    named_AML_Not_Operator,
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins,
\    named_E_ACLName_SC,
\    namedParenError,
\    namedInclude,
\    namedComment 
\ nextgroup=namedSemicolon

hi link namedOV_RateLimit_ExemptClients namedHL_Clause
syn keyword namedOV_RateLimit_ExemptClients contained skipwhite
\    exempt-clients
\ nextgroup=namedOV_RateLimit_ExemptClientsSection
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_IP4PrefixLen namedHL_Clause
syn keyword namedOV_RateLimit_IP4PrefixLen contained skipwhite
\     ipv4-prefix-length 
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_IP6PrefixLen namedHL_Clause
syn keyword namedOV_RateLimit_IP6PrefixLen contained skipwhite
\     ipv6-prefix-length 
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_LogOnly namedHL_Clause
syn keyword namedOV_RateLimit_LogOnly contained skipwhite
\     log-only
\ nextgroup=@namedClusterBoolean_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_MaxTableSize namedHL_Clause
syn keyword namedOV_RateLimit_MaxTableSize contained max-table-size skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_MinTableSize namedHL_Clause
syn keyword namedOV_RateLimit_MinTableSize contained min-table-size skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_NoDataPerSec namedHL_Clause
syn keyword namedOV_RateLimit_NoDataPerSec contained skipwhite
\    nodata-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_NxdomainsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_NxdomainsPerSec contained skipwhite
\    nxdomains-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_QpsScale namedHL_Clause
syn keyword namedOV_RateLimit_QpsScale contained qps-scale skipwhite
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ReferralsPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ReferralsPerSec contained skipwhite
\     referrals-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_ResponsesPerSec namedHL_Clause
syn keyword namedOV_RateLimit_ResponsesPerSec contained skipwhite
\    responses-per-second
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_Slip namedHL_Clause
syn keyword namedOV_RateLimit_Slip contained skipwhite
\    slip
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection

hi link namedOV_RateLimit_Window namedHL_Clause
syn keyword namedOV_RateLimit_Window contained skipwhite
\    window
\ nextgroup=named_Number_SC
\ containedin=namedOV_RateLimitSection


syn region namedOV_RateLimitSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon

hi link namedOV_RateLimit namedHL_Option
syn keyword namedOV_RateLimit contained rate-limit skipwhite skipempty
\ nextgroup=namedOV_RateLimitSection

hi link namedOV_ResponsePadding_BlockSize namedHL_Clause
syn match namedOV_ResponsePadding_BlockSize contained skipwhite
\    /block\-size/
\ nextgroup=named_Number_SC

hi link namedOV_ResponsePadding_Not_Operator namedHL_Operator
syn match namedOV_ResponsePadding_Not_Operator contained skipwhite
\    /!/
\ nextgroup=
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins,
\    namedSemicolon

syn region namedOV_ResponsePaddingSection contained start=/{/ end=/}/ 
\ skipwhite skipempty
\ contains=
\    namedOV_ResponsePadding_Not_Operator,
\    named_E_IP6AddrPrefix_SC,
\    named_E_IP6Addr_SC,
\    named_E_IP4AddrPrefix_SC,
\    named_E_IP4Addr_SC,
\    named_Bind_Builtins
\ nextgroup=
\     namedSemicolon,
\     namedOV_ResponsePadding_BlockSize

hi link namedOV_ResponsePadding namedHL_Option
syn keyword namedOV_ResponsePadding contained response-padding skipwhite
\ nextgroup=
\    namedOV_ResponsePaddingSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'view'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" syn keyword namedOZ_Boolean_Group contained skipwhite
" \ nextgroup=named_Number_SC
" \ containedin=
" \    namedStmt_OptionsSection,
" \    namedStmt_ZoneSection

syn match namedOZ_DialupOptBoolean contained /\S\+/
\ skipwhite
\ contains=@namedClusterBoolean
\ nextgroup=namedSemicolon

hi link namedOZ_DialupOptBuiltin namedHL_Builtin
syn match namedOZ_DialupOptBuiltin contained 
\     /\%(notify\)\|\%(notify-passive\)\|\%(passive\)\|\%(refresh\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Dialup namedHL_Option
syn keyword namedOVZ_Dialup contained dialup
\ skipwhite
\ nextgroup=
\    namedOZ_DialupOptBuiltin,
\    namedOZ_DialupOptBoolean

hi link namedOptionsDnstapIdentityOpts namedHL_Builtin
syn keyword namedOptionsDnstapIdentityOpts contained
\    none
\    hostname
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOptionsDnstapIdentityDomain namedHL_String
syn match namedOptionsDnstapIdentityDomain contained
\    /\<[0-9A-Za-z\._\-]\{1,1023}\>/
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedOptionsDnstapIdentityDomain contained
\    /'[0-9A-Za-z\.\-_]\{1,1023}'/
\ skipwhite
\ nextgroup=namedSemicolon
syn match namedOptionsDnstapIdentityDomain contained
\    /"[0-9A-Za-z\.\-_]\{1,1023}"/ 
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOZ_DnstapIdentity namedHL_Option
syn keyword namedOZ_DnstapIdentity contained 
\    dnstap-identity
\ skipwhite
\ nextgroup=
\    namedOptionsDnstapIdentityOpts,
\    namedOptionsDnstapIdentityDomain

hi link namedOZ_Files_Wildcard namedHL_Builtin
syn match namedOZ_Files_Wildcard /\*/ contained skipwhite

hi link namedOZ_Files namedHL_Option
syn keyword namedOZ_Files contained files skipwhite
\ nextgroup=
\    namedOZ_Files_Wildcard,
\    named_DefaultUnlimited_SC,
\    named_SizeSpec_SC

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', and 'zone'  ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'server', and 'zone'  ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'zone'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedOVZ_Timestamp_Group namedHL_Builtin
syn keyword namedOVZ_Timestamp_Group contained skipwhite
\    date
\    unixtime
\    increment
\ nextgroup=namedSemicolon

hi link namedOVZ_SerialUpdateMethod namedHL_Option
syn keyword namedOVZ_SerialUpdateMethod contained skipwhite
\    serial-update-method
\ nextgroup=namedOVZ_Timestamp_Group

hi link namedOVZ_Number_Group namedHL_Option
syn keyword namedOVZ_Number_Group contained skipwhite
\    max-records
\    notify-delay
\    sig-signing-nodes
\    sig-signing-signatures
\    sig-signing-type
\ nextgroup=named_Number_SC

hi link namedOVZ_Boolean_Group namedHL_Option
syn keyword namedOVZ_Boolean_Group contained skipwhite
\    check-sibling
\    check-integrity
\    check-wildcard
\    dnssec-dnskey-kskonly
\    dnssec-secure-to-insecure
\    inline-signing
\    multi-master
\    notify-to-soa
\    try-tcp-refresh
\    update-check-ksk
\    use-alt-transfer-source
\    zero-no-soa-ttl
\    zero-no-soa-ttl-cache
\ nextgroup=@namedClusterBoolean_SC

hi link namedOVZ_AML_Not_Operator namedHL_Operator
syn match namedOVZ_AML_Not_Operator contained /!/ skipwhite
\ nextgroup=named_E_AMLSection_SC


hi link namedOVZ_AML_Group namedHL_Option
syn keyword namedOVZ_AML_Group contained skipwhite skipempty
\    allow-notify
\    allow-query
\    allow-query-on
\    allow-transfer
\    allow-update
\    allow-update-forwarding
\    namedStmt_ZoneSection
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon,
\    namedE_UnexpectedRParen,
\    namedE_MissingLParen


hi link namedOVZ_Number_Max28days namedHL_Option
syn keyword namedOVZ_Number_Max28days contained skipwhite
\    max-transfer-idle-in
\    max-transfer-idle-out
\    max-transfer-time-in
\    max-transfer-time-out
\ nextgroup=named_Number_Max28day_SC

hi link namedOptATSClauseDscp  namedHL_Clause
syn match namedOptATS_DSCP contained /6[0-3]\|[0-5][0-9]\|[1-9]/ skipwhite
\ contains=namedDSCP 
\ nextgroup=
\    namedOptATSClausePort,
\    namedSemicolon

hi link namedOptATS_PortWild namedHL_Number
syn match namedOptATS_PortWild contained /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=
\    namedOptATSClauseDscp,
\    namedSemicolon

hi link namedOptATSClausePort  namedHL_Clause
syn keyword namedOptATSClausePort contained port skipwhite 
\ nextgroup=
\    namedOptATS_PortWild 
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauseDscp contained /dscp/ skipwhite 
\ nextgroup=namedOptATS_DSCP
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauses /port/ contained 
\ nextgroup=namedOptATS_Port skipwhite
\ containedin=namedOptATS_IPwild
syn match namedOptATSClauses /dscp/ contained 
\ nextgroup=namedOptATS_DSCP skipwhite
\ containedin=namedOptATS_IPwild

hi link namedOptATS_IP4wild namedHLKeyword
hi link namedOptATS_IP6wild namedHLKeyword
syn match namedOptATS_IP4wild /\S\+/ contained
\ contains=namedIPwild,named_IP4Addr
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon
\ skipwhite

syn match namedOptATS_IP6wild contained /\S\+/ skipwhite
\ contains=
\    namedIPwild,
\    named_IP6Addr
\ nextgroup=
\    namedOptATSClausePort,
\    namedOptATSClauseDscp,
\    namedSemicolon

hi link namedOVZ_OptATS namedHL_Option
syn keyword namedOVZ_OptATS contained skipwhite
\    alt-transfer-source-v6
\ nextgroup=
\    namedOptATS_IP6wild 
syn keyword namedOVZ_OptATS contained
\    alt-transfer-source
\ nextgroup=namedOptATS_IP4wild skipwhite

hi link namedOVZ_AutoDNSSEC namedHL_Option
syn keyword namedOVZ_AutoDNSSEC contained auto-dnssec skipwhite
\ nextgroup=
\    named_AllowMaintainOff,
\    namedComment,
\    namedError 

hi link namedOVZ_IgnoreWarnFail namedHL_Option
syn keyword namedOVZ_IgnoreWarnFail contained 
\    check-dup-records
\    check-mx-cname
\    check-mx
\    check-srv-cnames
\    check-spf
\ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC

" <0-3660> days (dnskey-sig-validity)
hi link named_Number_Max3660days namedHL_Number
syn match named_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=namedSemicolon

hi link namedOVZ_DnskeyValidity namedHL_Option
syn keyword namedOVZ_DnskeyValidity contained skipwhite
\    dnskey-sig-validity
\ nextgroup=named_Number_Max3660days

" <0-1440> (dnssec-loadkeys-interval)
hi link namedOVZ_DnssecLoadkeysInterval namedHL_Number
syn match namedOVZ_DnssecLoadkeysInterval contained 
\ /\%(1440\)\|\%(14[0-3][0-9]\)\|\%(1[0-3][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_DnssecLoadkeys namedHL_Option
syn keyword namedOVZ_DnssecLoadkeys contained 
\    dnssec-loadkeys-interval
\ skipwhite
\ nextgroup=
\    namedOVZ_DnssecLoadkeysInterval

" cleaning-interval: range: 0-1440
hi link namedOVZ_CleaningValue namedHL_Number
syn match namedOVZ_CleaningValue contained
\    /\(1440\)\|\(14[0-3][0-9]\)\|\([1[0-3][0-9][0-9]\)\|\([0-9][0-9][0-9]\)\|\([0-9][0-9]\)\|\([0-9]\)/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_CleaningInterval namedHL_Option
syn keyword namedOVZ_CleaningInterval contained
\    cleaning-interval
\ nextgroup=namedOVZ_CleaningValue
\ skipwhite

" dnssec-must-be-secure <domain_name> <boolean>; [ Opt View ]  # v9.3.0+
syn match namedDMBS_FQDN contained /\<[0-9A-Za-z\.\-_]\{1,1023}\>/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /'[0-9A-Za-z\.\-_]\{1,1023}'/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite
syn match namedDMBS_FQDN contained /"[0-9A-Za-z\.\-_]\{1,1023}"/
\ contains=named_QuotedDomain 
\ nextgroup=@namedClusterBoolean_SC skipwhite

hi link namedOVZ_DnssecMustBeSecure namedHL_Option
syn keyword namedOVZ_DnssecMustBeSecure contained 
\    dnssec-must-be-secure 
\ nextgroup=namedDMBS_FQDN
\ skipwhite

hi link namedOVZ_DnssecUpdateModeOpt namedHL_Builtin
syn keyword namedOVZ_DnssecUpdateModeOpt contained
\   maintain
\   no-resign
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_DnssecUpdateMode namedHL_Option
syn keyword namedOVZ_DnssecUpdateMode contained
\    dnssec-update-mode
\ skipwhite
\ nextgroup=namedOVZ_DnssecUpdateModeOpt

hi link namedOVZ_ForwardOpt namedHL_Builtin
syn keyword namedOVZ_ForwardOpt contained
\    only
\    first
\ nextgroup=namedSemicolon

hi link namedOVZ_Forward namedHL_Option
syn keyword namedOVZ_Forward contained forward
\ skipwhite
\ nextgroup=namedOVZ_ForwardOpt

hi link namedOVZ_Forwarders_Opt_PortNumber namedHL_Error
syn match namedOVZ_Forwarders_Opt_PortNumber contained /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ contains=named_Port
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_Opt_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Forwarders_Opt_Dscp namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Dscp contained dscp
\ skipwhite
\ nextgroup=
\    namedOVZ_Forwarders_Opt_DscpNumber
\ containedin=
\    namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Opt_Port namedHL_Option
syn keyword namedOVZ_Forwarders_Opt_Port contained skipwhite port
\ nextgroup=
\    namedOVZ_Forwarders_Opt_PortNumber,
\    namedError
\ containedin=namedOVZ_Forwarders_Section

" hi link namedOVZ_Forwarders_IP6 namedHL_Number
syn match namedOVZ_Forwarders_IP6 contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_IP4 namedHL_Number
syn match namedOVZ_Forwarders_IP4 contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedOVZ_Forwarders_Opt_Port,
\   namedOVZ_Forwarders_Opt_Dscp,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOVZ_Forwarders_Section

syn region namedOVZ_Forwarders_Section contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedOVZ_Forwarders_DscpNumber namedHL_Number
syn match namedOVZ_Forwarders_DscpNumber contained /6[0-3]\|[0-5][0-9]\|[1-9]/
\ skipwhite
\ nextgroup=
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Section,
\    namedSemicolon

hi link namedOVZ_Forwarders_PortNumber namedHL_Number
syn match namedOVZ_Forwarders_PortNumber contained skipwhite
\ /\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ nextgroup=
\    namedOVZ_Forwarders_Dscp,
\    namedOVZ_Forwarders_Section

hi link namedOVZ_Forwarders_Port  namedHL_Option
syn match namedOVZ_Forwarders_Port /port/ contained skipwhite
\ nextgroup=namedOVZ_Forwarders_PortNumber

hi link namedOVZ_Forwarders_Dscp  namedHL_Option
syn match namedOVZ_Forwarders_Dscp /dscp/ contained skipwhite
\ nextgroup=namedOVZ_Forwarders_DscpNumber


hi link namedOVZ_Forwarders namedHL_Option
syn keyword namedOVZ_Forwarders contained 
\    forwarders
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedOVZ_Forwarders_Section,
\    namedOVZ_Forwarders_Port,
\    namedOVZ_Forwarders_Dscp,
\    namedComment, namedInclude,
\    namedError

hi link namedOVZ_MasterfileFormat_Opts namedHL_Builtin
syn keyword namedOVZ_MasterfileFormat_Opts contained
\    raw
\    text
\    map
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileFormat namedHL_Option
syn keyword namedOVZ_MasterfileFormat contained
\    masterfile-format
\ nextgroup=
\    namedOVZ_MasterfileFormat_Opts
\ skipwhite

hi link namedOVZ_MasterfileStyles namedHL_Builtin
syn keyword namedOVZ_MasterfileStyles contained
\    full
\    relative
\ skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_MasterfileStyle namedHL_Option
syn keyword namedOVZ_MasterfileStyle contained
\    masterfile-style
\ nextgroup=namedOVZ_MasterfileStyles
\ skipwhite


hi link namedOVZ_TtlUnlimited namedHL_Builtin
syn keyword namedOVZ_TtlUnlimited contained unlimited skipwhite
\ nextgroup=namedSemicolon

hi link namedOVZ_Ttl namedHL_Number
syn match namedOVZ_Ttl contained skipwhite
\ /\d\{1,10}/
\ nextgroup=namedSemicolon

hi link namedOVZ_MaxZoneTtl namedHL_Option
syn keyword namedOVZ_MaxZoneTtl contained max-zone-ttl skipwhite
\ nextgroup=
\    namedOVZ_TtlUnlimited,
\    namedOVZ_Ttl


" view statement - Filespec (directory, filename)
hi link namedOVZ_Filespec_Group namedHL_Option
syn keyword namedOVZ_Filespec_Group contained skipwhite
\    key-directory
\ nextgroup=
\    named_String_QuoteForced_SC,
\    namedNotString

" max-refresh-time obsoleted in view and zone section

hi link namedOVZ_RefreshRetry namedHL_Option
syn keyword namedOVZ_RefreshRetry contained skipwhite
\    max-refresh-time
\    max-retry-time
\    min-refresh-time
\    min-retry-time
\ nextgroup=named_Number_Max24week_SC

hi link namedOVZ_ZoneStat_Opts namedHL_Builtin
syn keyword namedOVZ_ZoneStat_Opts contained skipwhite
\    full
\    terse
\    none
\ nextgroup=namedSemicolon

hi link namedOVZ_ZoneStat namedHL_Option
syn keyword namedOVZ_ZoneStat contained skipwhite
\    zone-statistics
\ nextgroup=
\    namedOVZ_ZoneStat_Opts,
\    @namedClusterBoolean

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" Syntaxes that are found in all 'options', 'view', and 'zone' ABOVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'view', and 'server'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link named_A6orAAAA_SC namedHL_String
" syn match named_A6orAAAA_SC contained /\(AAAA\)\|\(A6\)/ skipwhite
syn match named_A6orAAAA_SC /\caaaa/ contained skipwhite nextgroup=namedSemicolon
syn match named_A6orAAAA_SC /\ca6/ contained skipwhite nextgroup=namedSemicolon

hi link namedOSV_OptAV6S namedHL_Option
syn keyword namedOSV_OptAV6S contained skipwhite
\    allow-v6-synthesis
\ nextgroup=named_A6orAAAA_SC 

hi link namedOSV_Boolean_Group namedHL_Option
syn keyword namedOSV_Boolean_Group contained skipwhite
\    provide-ixfr
\    request-nsid
\    send-cookie
\ nextgroup=@namedClusterBoolean 

" <0-3660> days (sig-validity-interval)
hi link namedOVZ_First_Number_Max3660days namedHL_Number
syn match namedOVZ_First_Number_Max3660days contained skipwhite
\ /\%(3660\)\|\%(36[0-5][0-9]\)\|\%(3[0-5][0-9][0-9]\)\|\%([1-9][0-9][0-9]\|[1-9][0-9]\|[0-9]\)/
\ nextgroup=named_Number_Max3660days,namedSemicolon

hi link namedOVZ_SigSigning namedHL_Option
syn keyword namedOVZ_SigSigning contained skipwhite
\    sig-validity-interval
\ nextgroup=
\    namedOVZ_First_Number_Max3660days

hi link namedOVZ_Notify_Opts namedHL_Builtin
syn keyword namedOVZ_Notify_Opts contained skipwhite
\    explicit
\    master-only
\ nextgroup=namedSemicolon

hi link namedOVZ_Notify namedHL_Option
syn keyword namedOVZ_Notify contained skipwhite
\    notify
\ nextgroup=
\    namedOVZ_Notify_Opts,
\    @namedClusterBoolean

hi link namedOVZ_Keyname_SC namedHL_String
syn match namedOVZ_Keyname_SC contained skipwhite
\    /\<[0-9A-Za-z][-0-9A-Za-z\.\-_]\+\>/ 
\ nextgroup=namedSemicolon

hi link namedOVZ_SessionKeyname namedHL_Option
syn keyword namedOVZ_SessionKeyname contained session-keyname skipwhite
\ nextgroup=namedOVZ_Keyname_SC

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'options', 'server', 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi link namedOSVZ_Boolean_Group namedHL_Option
syn keyword namedOSVZ_Boolean_Group  contained skipwhite
\    notify-to-soa
\    request-expire
\    request-ixfr
\ nextgroup=@namedClusterBoolean_SC

" transfer-source ( * | <ip4_addr> )
"                 [ port ( * | <port_number> ) ]
"                 [ dscp <dscp> ];
"
hi link namedOSVZ_TransferSource_Dscp namedHL_Option
syn keyword namedOSVZ_TransferSource_Dscp contained dscp skipwhite
\ nextgroup=named_Dscp_SC

hi link namedOSVZ_TransferSource_PortValue namedHL_Number
syn match namedOSVZ_TransferSource_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_PortWildcard namedHL_Builtin
syn match namedOSVZ_TransferSource_PortWildcard contained /\*/ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_Port namedHL_Option
syn keyword namedOSVZ_TransferSource_Port contained port skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_PortValue,
\    namedOSVZ_TransferSource_PortWildcard

hi link namedOSVZ_TransferSource_IP4Addr namedHL_Number
syn match namedOSVZ_TransferSource_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=namedOSVZ_TransferSource_Port

" transfer-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" transfer-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSVZ_TransferSource_IP6Addr namedHL_Number
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSVZ_TransferSource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSVZ_TransferSource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSVZ_TransferSource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSVZ_TransferSource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSVZ_TransferSource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_TransferSource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_TransferSource_IPWildcard namedHL_Builtin
syn match namedOSVZ_TransferSource_IPWildcard contained /\*/ skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_Port,
\    namedOSVZ_TransferSource_Dscp

hi link namedOSVZ_TransferSource namedHL_Option
syn keyword namedOSVZ_TransferSource contained transfer-source skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_IP4Addr,
\    namedOSVZ_TransferSource_IPWildcard

hi link namedOSVZ_TransferSourceIP6 namedHL_Option
syn keyword namedOSVZ_TransferSourceIP6 contained transfer-source-v6 skipwhite
\ nextgroup=
\    namedOSVZ_TransferSource_IP6Addr,
\    namedOSVZ_TransferSource_IPWildcard

syn match namedOptPortKeyval contained /port\s\+\d\\+/ms=s+5 contains=named_PortVal

syn region named_PortSection contained start=+{+ end=+}+ skipwhite
\ contains=
\    namedElementPortWild,
\    namedParenError,
\    namedComment,
\    namedInclude
\ nextgroup=namedSemicolon

hi link namedOSVZ_E_MasterName namedHL_Identifier
syn match namedOSVZ_E_MasterName contained skipwhite /[a-zA-Z][a-zA-Z0-9_\-]\+/
\ nextgroup=
\    namedM_E_KeyKeyword,
\    namedSemicolon,
\   namedComment, namedInclude,
\    namedError
\ containedin=namedOSVZ_Masters_MML

" hi link namedOSVZ_E_IP6addr namedHL_Number
syn match namedOSVZ_E_IP6addr contained skipwhite /[0-9a-fA-F:\.]\{6,48}/
\ contains=named_IP6Addr
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOSVZ_Masters_MML

hi link namedOSVZ_E_IP4addr namedHL_Number
syn match namedOSVZ_E_IP4addr contained skipwhite 
\ /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ nextgroup=
\   namedSemicolon,
\   namedM_E_IPaddrPortKeyword,
\   namedM_E_KeyKeyword,
\   namedComment, namedInclude,
\   namedError
\ containedin=namedOSVZ_Masters_MML

syn region namedOSVZ_Masters_MML contained start=/{/ end=/}/
\ skipwhite skipempty
\ contains=namedComment
\ nextgroup=
\    namedSemicolon,
\    namedInclude,
\    namedComment

hi link namedOSVZ_AlsoNotify namedHL_Option
" In 'server', `also-notify` is no longer valid after 9.13
syn keyword namedOSVZ_AlsoNotify contained skipwhite
\    also-notify
\ nextgroup=
\    namedOSVZ_Masters_MML,
\    namedInclude,
\    namedComment,
\    namedError

" notify-source [address] 
"              ( * | <ip4_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" notify-source [ [ address ] 
"                ( * | <ip4_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
hi link named_Dscp_SC namedHL_Number
syn match named_Dscp_SC contained /\d\+/ skipwhite
\ nextgroup=namedSemicolon

hi link namedOSVZ_NotifySource_Dscp namedHL_Option
syn keyword namedOSVZ_NotifySource_Dscp contained dscp skipwhite
\ nextgroup=named_Dscp_SC

hi link namedOSVZ_NotifySource_PortValue namedHL_Number
syn match namedOSVZ_NotifySource_PortValue contained 
\ /\*\|\%(6553[0-5]\)\|\%(655[0-2][0-9]\)\|\%(65[0-4][0-9][0-9]\)\|\%(6[0-4][0-9]\{3,3}\)\|\([1-5]\%([0-9]\{1,4}\)\)\|\%([0-9]\{1,4}\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Dscp,
\    namedSemicolon

hi link namedOSVZ_NotifySource_Port namedHL_Option
syn keyword namedOSVZ_NotifySource_Port contained port skipwhite
\ nextgroup=namedOSVZ_NotifySource_PortValue

hi link namedOSVZ_NotifySource_IP4Addr namedHL_Number
syn match namedOSVZ_NotifySource_IP4Addr contained /\<\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedOSVZ_NoityfSource_Dscp,
\    namedSemicolon

hi link namedOSVZ_NotifySource namedHL_Option
syn keyword namedOSVZ_NotifySource contained skipwhite
\    notify-source
\ nextgroup=
\    namedOSVZ_NotifySource_IP4Addr,
\    namedOSVZ_NotifySource_Port

" notify-source-v6 [address] 
"              ( * | <ip6_addr> )
"                  [ port ( * | <port> )]
"                  [ dscp <dscp> ];
" notify-source-v6 [ [ address ] 
"                ( * | <ip6_addr> ) ]
"              port ( * | <port> )
"              [ dscp <dscp> ];
"
" Full IPv6 (without the trailing '/') with trailing semicolon
hi link namedOSVZ_NotifySource_IP6Addr namedHL_Number
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{7,7}\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::                              1:2:3:4:5:6:7::
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,7}:/ 
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::8             1:2:3:4:5:6::8  1:2:3:4:5:6::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,6}:\x\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::7:8           1:2:3:4:5::7:8  1:2:3:4:5::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,5}\%(:\x\{1,4}\)\{1,2}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::6:7:8         1:2:3:4::6:7:8  1:2:3:4::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,4}\%(:\x\{1,4}\)\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::5:6:7:8       1:2:3::5:6:7:8  1:2:3::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,3}\%(:\x\{1,4}\)\{1,4}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::4:5:6:7:8     1:2::4:5:6:7:8  1:2::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\%(\x\{1,4}:\)\{1,2}\%(:\x\{1,4}\)\{1,5}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 1::3:4:5:6:7:8   1::3:4:5:6:7:8  1::8
syn match namedOSVZ_NotifySource_IP6Addr contained /\x\{1,4}:\%(\%(:\x\{1,4}\)\{1,6}\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" fe80::7:8%eth0   (link-local IPv6 addresses with zone index)
syn match namedOSVZ_NotifySource_IP6Addr contained /fe08%[a-zA-Z0-9\-_\.]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" fe80::7:8%1     (link-local IPv6 addresses with zone index)
syn match namedOSVZ_NotifySource_IP6Addr contained /fe08::[0-9a-fA-F]\{1,4}:[0-9a-fA-F]\{1,4}%[a-zA-Z0-9]\{1,64}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::2:3:4:5:6:7:8  ::2:3:4:5:6:7:8 ::8       ::
syn match namedOSVZ_NotifySource_IP6Addr contained /::\x\{1,4}\%(:\x\{0,3}\)\{0,6}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::ffff:0:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::ffff:0\{1,4}:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::ffff:255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::ffff:\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" 2001:db8:3:4::192.0.2.33  64:ff9b::192.0.2.33 (IPv4-Embedded IPv6 Address)
syn match namedOSVZ_NotifySource_IP6Addr contained /\x\{1,4}\%(:\x\{1,4}\)\{1,3}::[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}\.[0-9]\{1,3}/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon
" ::255.255.255.255 (IPv4-mapped IPv6 addresses and IPv4-translated addresses)
syn match namedOSVZ_NotifySource_IP6Addr contained /::\%(\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)\.\)\{3,3}\%(25[0-5]\|\%(2[0-4]\|1\{0,1}[0-9]\)\{0,1}[0-9]\)/
\ skipwhite
\ nextgroup=
\    namedOSVZ_NotifySource_Port,
\    namedSemicolon

" Do both IPv4 and IPv6 for notify-source
hi link namedOSVZ_NotifySource namedHL_Option
syn match namedOSVZ_NotifySource contained skipwhite
\    /\<notify-source-v6\>/
\ nextgroup=
\    namedOSVZ_NotifySource_IP6Addr

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes that are found in all 'view', and 'zone'.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Not the same as 'check-names' in 'options' statement
hi link namedVZ_CheckNames namedHL_Option
syn keyword namedVZ_CheckNames contained 
\    check-names
\ skipwhite
\ nextgroup=named_IgnoreWarnFail_SC

" not the same as ixfr-from-differences in 'options' statement
hi link namedVZ_Ixfr_From_Diff namedHL_Option
syn keyword namedVZ_Ixfr_From_Diff contained ixfr-from-differences skipwhite
\ skipwhite
\ nextgroup=@namedClusterBoolean_SC

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections ({ ... };) of statements go below here
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options { <options_statement>; ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_OptionsSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOV_AML_Group,
\    namedOVZ_AML_Group,
\    namedOV_AorAAAA,
\    namedOV_AttachCache,
\    namedOVZ_AutoDNSSEC,
\    namedO_Blackhole,
\    namedO_Boolean_Group,
\    namedOS_Boolean_Group,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedOV_Boolean_Group,
\    namedOVZ_Boolean_Group,
\    namedOV_CatalogZones,
\    namedO_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedO_CookieAlgs,
\    namedO_CookieSecret,
\    namedO_DefaultKey,
\    namedO_DefaultPort,
\    namedO_DefaultServer,
\    namedO_DefaultUnlimitedSize,
\    namedOV_DefaultUnlimitedSize_Group,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOVZ_Dialup,
\    namedOV_DisableAlgorithms,
\    namedOV_DisableDsDigests,
\    namedOV_DisableEmptyZone,
\    namedOV_Dns64,
\    namedOV_Dns64_Group,
\    namedOVZ_DnskeyValidity,
\    namedOV_DnsrpsOptions,
\    namedOVZ_DnssecLoadkeys,
\    namedOV_DnssecLookasideKeyword,
\    namedOV_DnssecLookasideOptTD,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOV_DnssecValidation,
\    namedOV_Dnstap,
\    namedOZ_DnstapIdentity,
\    namedO_DnstapOutputKeyword,
\    namedO_DnstapVersion,
\    namedO_DscpNumber,
\    namedOV_DualStack,
\    namedOV_FetchPers,
\    namedOV_FetchQuotaParams,
\    namedOZ_Files,
\    namedO_Filespec_Group,
\    namedOV_Filespec,
\    namedOVZ_Filespec_Group,
\    namedO_Filespec_None_ForcedQuoted_Group,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedO_Fstrm_Model,
\    namedOV_HeartbeatInterval,
\    namedOV_Hostname,
\    namedOVZ_IgnoreWarnFail,
\    namedO_InterfaceInterval,
\    namedOV_Interval_Max30ms_Group,
\    namedO_Ixfr_From_Diff,
\    namedO_KeepResponseOrder,
\    namedOV_Key,
\    namedO_ListenOn,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedOVZ_MaxZoneTtl,
\    namedOV_MinimalResponses,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOSVZ_NotifySource_Dscp,
\    namedO_Number_Group,
\    namedOV_Number_Group,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOV_NxdomainRedirect,
\    namedOVZ_OptATS,
\    namedOSV_OptAV6S,
\    namedOV_Prefetch,
\    namedOV_QnameMin,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOV_RateLimit,
\    namedO_RecursingFile,
\    namedOVZ_RefreshRetry,
\    namedOV_ResponsePadding,
\    namedOV_RootDelegation,
\    namedOVZ_SerialUpdateMethod,
\    namedO_ServerId,
\    namedO_SessionKeyAlg,
\    namedO_SessionKeyfile,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOV_SizeSpec_Group,
\    namedO_String_QuoteForced,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedOV_Ttl_Group,
\    namedOV_Ttl_Max3h_Group,
\    namedOV_Ttl_Max1week_GRoup,
\    namedOV_Ttl90sec_Group,
\    namedO_UdpPorts,
\    namedOSV_UdpSize,
\    namedOVZ_ZoneStat,
\    namedParenError

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { <namedStmtServerKeywords>; };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmt_ServerSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedS_Bool_Group,
\    namedOS_Boolean_Group,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedS_Keys,
\    namedOSVZ_NotifySource,
\    namedOSVZ_NotifySource_Dscp,
\    namedS_NumberGroup,
\    namedOSV_OptAV6S,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedOSV_UdpSize,
\    namedInclude


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" server <namedStmt_ServerNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmt_ServerNameIdentifier namedHL_Identifier
syn match namedStmt_ServerNameIdentifier contained
\ /[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{0,3}\([\/][0-9]\{1,3}\)\{0,1}/
\ skipwhite
\ nextgroup=
\    namedComment,
\    namedInclude,
\    namedStmt_ServerSection,
\    namedError 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" view <namedStmt_ViewNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn region namedStmt_ViewSection contained start=+{+ end=+}+ 
\ skipwhite skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOV_AML_Group,
\    namedOVZ_AML_Group,
\    namedOV_AorAAAA,
\    namedOV_AttachCache,
\    namedOVZ_AutoDNSSEC,
\    namedOSV_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedOV_Boolean_Group,
\    namedOVZ_Boolean_Group,
\    namedV_Boolean_Group,
\    namedOV_CatalogZones,
\    namedVZ_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedOV_DefaultUnlimitedSize_Group,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOVZ_Dialup,
\    namedOV_DisableAlgorithms,
\    namedOV_DisableDsDigests,
\    namedOV_DisableEmptyZone,
\    namedOV_Dns64,
\    namedOV_Dns64_Group,
\    namedOVZ_DnskeyValidity,
\    namedOV_DnsrpsOptions,
\    namedOVZ_DnssecLoadkeys,
\    namedOV_DnssecLookasideKeyword,
\    namedOV_DnssecLookasideOptTD,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOV_DnssecValidation,
\    namedOV_Dnstap,
\    namedOV_DualStack,
\    namedOV_Filespec,
\    namedOV_FetchPers,
\    namedOV_FetchQuotaParams,
\    namedOVZ_Filespec_Group,
\    namedV_FilespecGroup,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedOV_HeartbeatInterval,
\    namedOV_Hostname,
\    namedVZ_Ixfr_From_Diff,
\    namedOVZ_IgnoreWarnFail,
\    namedOV_Interval_Max30ms_Group,
\    namedOV_Key,
\    namedV_Key,
\    namedV_Match,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedOVZ_MaxZoneTtl,
\    namedOV_MinimalResponses,
\    namedV_MinuteGroup,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOV_Number_Group,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOV_NxdomainRedirect,
\    namedOVZ_OptATS,
\    namedOSV_OptAV6S,
\    namedOV_Prefetch,
\    namedOV_QnameMin,
\    namedOSV_QuerySource,
\    namedOSV_QuerySourceIP6,
\    namedOV_RateLimit,
\    namedOVZ_RefreshRetry,
\    namedOV_ResponsePadding,
\    namedOV_RootDelegation,
\    namedOVZ_SerialUpdateMethod,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOV_SizeSpec_Group,
\    namedOV_Ttl_Group,
\    namedOV_Ttl_Max3h_Group,
\    namedOV_Ttl_Max1week_GRoup,
\    namedOV_Ttl90sec_Group,
\    namedOSV_TransferFormat,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedOSV_UdpSize,
\    namedOVZ_ZoneStat,
\    namedParenError

hi link namedStmt_ViewNameIdentifier namedHL_Identifier
syn match namedStmt_ViewNameIdentifier contained /\i\+/ skipwhite skipnl skipempty
\ nextgroup=namedStmt_ViewSection

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zone <namedStmt_ZoneNameIdentifier> { ... };
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn region namedStmt_ZoneSection contained start=+{+ end=+}+ 
\ skipwhite skipnl skipempty
\ nextgroup=namedSemicolon
\ contains=
\    namedInclude,
\    namedComment,
\    namedOSVZ_AlsoNotify,
\    namedOVZ_AML_Group,
\    namedOVZ_AutoDNSSEC,
\    namedOVZ_Boolean_Group,
\    namedOSVZ_Boolean_Group,
\    namedZ_Boolean_Group,
\    namedVZ_CheckNames,
\    namedOVZ_CleaningInterval,
\    namedZ_Database,
\    namedOVZ_DefaultUnlimitedSize_Group,
\    namedOVZ_Dialup,
\    namedOVZ_DnskeyValidity,
\    namedOVZ_DnssecLoadkeys,
\    namedOVZ_DnssecMustBeSecure,
\    namedOVZ_DnssecUpdateMode,
\    namedOZ_DnstapIdentity,
\    namedZ_File,
\    namedOZ_Files,
\    namedOVZ_Filespec_Group,
\    namedZ_Filespec_Group,
\    namedOVZ_Forward,
\    namedOVZ_Forwarders,
\    namedOVZ_IgnoreWarnFail,
\    namedZ_InView,
\    namedVZ_Ixfr_From_Diff,
\    namedOVZ_MasterFileFormat,
\    namedOVZ_MasterFileStyle,
\    namedOVZ_MaxZoneTtl,
\    namedOVZ_Notify,
\    namedOSVZ_NotifySource,
\    namedOVZ_Number_Group,
\    namedOVZ_Number_Max28days,
\    namedOVZ_OptATS,
\    namedOVZ_RefreshRetry,
\    namedOVZ_SerialUpdateMethod,
\    namedZ_ServerAddresses,
\    namedZ_ServerNames,
\    namedOVZ_SessionKeyname,
\    namedOVZ_SigSigning,
\    namedOSVZ_TransferSource,
\    namedOSVZ_TransferSourceIP6,
\    namedOVZ_ZoneStat,
\    namedZ_ZoneType,
\    namedParenError

hi link namedStmtZoneClass namedHL_Identifier
syn match namedStmtZoneClass contained /\<\c\%(CHAOS\)\|\%(HESIOD\)\|\%(IN\)\|\%(CH\)\|\%(HS\)\>/
\ skipwhite skipempty skipnl
\ nextgroup=
\    namedStmt_ZoneSection,
\    namedComment,

hi link namedStmt_ZoneNameIdentifier namedHL_Identifier
syn match namedStmt_ZoneNameIdentifier contained /\S\+/ 
\ skipwhite skipempty skipnl
\ contains=named_QuotedDomain
\ nextgroup=
\    namedStmt_ZoneSection,
\    namedStmtZoneClass,
\    namedComment


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Top-level statment (formerly clause) keywords
" 'uncontained' statements are the ones used GLOBALLY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link namedStmtKeyword namedHL_Statement
syn match namedStmtKeyword /\_^\s*\<acl\>/ skipwhite skipempty
\ nextgroup=
\    namedA_ACLIdentifier,
" \    namedE_UnexpectedSemicolon

syn match namedStmtKeyword /\_^\s*\<controls\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmt_ControlsSection

syn match namedStmtKeyword /\_^\s*\<dlz\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmt_DlzName_Identifier
\ containedin=
\    namedStmt_ViewSection,
\    namedStmt_ZoneSection

syn match namedStmtKeyword /\_^\s*\<dyndb\>/ skipempty skipnl skipwhite
\ nextgroup=namedStmtDyndbIdent
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<key\>/ skipwhite skipempty
\ nextgroup=namedStmtKeyIdent 

syn match namedStmtKeyword /\_^\s*\<logging\>/ skipempty skipwhite
\ nextgroup=namedStmtLoggingSection 

syn match namedStmtKeyword /\_^\s*\<managed-keys\>/ skipempty skipwhite
\ nextgroup=namedStmt_ManagedKeysSection 

syn match namedStmtKeyword /\_^\s*\<masters\>/ skipwhite skipnl skipempty 
\ nextgroup=
\    namedStmt_MastersNameIdentifier,
\    namedComment, 
\    namedInclude,
" \ namedError prevents a linefeed between 'master' and '<master_name'

syn match namedStmtKeyword /\_^\s*\<options\>/ skipempty skipwhite
\ nextgroup=namedStmt_OptionsSection 

syn match namedStmtKeyword /\_^\s*\<plugin\>/ skipempty skipwhite
\ nextgroup=
\    namedStmt_Plugin_QueryKeyword,
\    namedP_Filespec,

syn match  namedStmtKeyword /\_^\s*\<server\>/ skipempty skipwhite
\ nextgroup=namedStmt_ServerNameIdentifier,namedComment 
\ containedin=namedStmt_ViewSection

syn match namedStmtKeyword /\_^\s*\<statistics-channels\>/ skipempty skipwhite
\ nextgroup=namedIntIdent 

syn match namedStmtKeyword /\_^\s*\<trusted-keys\>/ skipempty skipwhite skipnl
\ nextgroup=namedIntSection 

" view <namedStmt_ViewNameIdentifier> { ... };  
syn match namedStmtKeyword /\_^\s*\<view\>/ skipwhite skipnl skipempty
\ nextgroup=namedStmt_ViewNameIdentifier 

" TODO: namedStmtError, how to get namedHL_Error to appear
" zone <namedStmt_ZoneNameIdentifier> { ... };
syn match namedStmtKeyword /\_^\_s*\<zone\>/ skipempty skipnl skipwhite
\ nextgroup=
\    namedStmt_ZoneNameIdentifier,
\    namedComment,
\    namedStmtError 
\ containedin=namedStmt_ViewSection

let &cpoptions = s:save_cpo
unlet s:save_cpo

let b:current_syntax = 'named'

if main_syntax ==# 'bind-named'
  unlet main_syntax
endif

" Google Vimscript style guide
" vim: ts=2 sts=2 ts=80
