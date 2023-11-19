setlocal nofoldenable
setlocal spell spellcapcheck=

let b:EditorConfig_disable = 1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal nofoldenable< spell< spellcapcheck<'
let b:undo_ftplugin .= '|unlet b:EditorConfig_disable'
