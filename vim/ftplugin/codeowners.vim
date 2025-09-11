if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl comments=:# commentstring=#\ %s
setl formatoptions-=t formatoptions+=croql

let b:undo_ftplugin = 'setl com< cms< fo<'
