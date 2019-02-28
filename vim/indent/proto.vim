if exists('b:did_indent')
   finish
endif
let b:did_indent = 1

setlocal cindent
setlocal expandtab
setlocal shiftwidth=2

let b:undo_indent = 'setl cin< et< sw<'
