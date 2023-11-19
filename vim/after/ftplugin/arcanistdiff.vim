setlocal textwidth=70

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal textwidth<'

if has('syntax')
  setlocal spell spellcapcheck=
  let b:undo_ftplugin .= '|setlocal spell< spellcapcheck<'
endif
