setlocal commentstring=//\ %s
setlocal foldexpr=getline(v:lnum)=~'^#pragma\ mark'?'>1':'='

if has('osx')
  let prefix = ''

  if executable('xcode-select')
    let xcode_path = split(system('xcode-select --print-path'), "\n", 1)[0]
    let prefix = xcode_path.'/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk'
  endif

  let includeexpr="substitute(v:fname,'\\([^/]\\+\\)/\\(.\\+\\)','".prefix."/System/Library/Frameworks/\\1.framework/Headers/\\2','')"
  exec 'let &l:includeexpr=includeexpr'
endif
