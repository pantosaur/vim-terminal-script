let s:buffer_name = "term"
let s:shell = $SHELL

function OpenTermBuffer()
  if bufexists(s:buffer_name) == 0
    call term_start(s:shell,{'term_name' : s:buffer_name, 'term_finish' : 'close', 'hidden' : 0})
    call setbufvar(s:buffer_name,"&number",0)
    call CloseTermWindow()
  endif
endfunction

function CloseTermBuffer()
  if bufexists(s:buffer_name) == 1
    execute "bdelete! ".s:buffer_name
  endif
endfunction

function OpenTermWindow()
  if bufexists(s:buffer_name) == 1
    let g:window_list = win_findbuf(bufnr(s:buffer_name))
    if len(g:window_list) == 0
      10split
      execute "b ".s:buffer_name
      wincmd p
    endif
  else
    echoerr "no term buffers open"
  endif
endfunction

function CloseTermWindow()
  let g:window_list = win_findbuf(bufnr(s:buffer_name))
  let i = 0
  while i < len(g:window_list)
    call win_execute(g:window_list[i],'quit')
    let i += 1
  endwhile
endfunction

function Compile()
  call OpenTermBuffer()
  call OpenTermWindow()
  call term_sendkeys(bufnr(s:buffer_name), "gcc -o " . expand('%:r') . " " . @% . "\<cr>")
endfunction

function Run()
  call OpenTermBuffer()
  call OpenTermWindow()
  call term_sendkeys(bufnr(s:buffer_name), "cd " . expand('%:p:h') . "\<cr>" . "./" . expand('%:t:r') . "\<cr>")
endfunction
