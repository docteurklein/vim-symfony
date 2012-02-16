if !exists("g:symfony_app_console_path")
    let g:symfony_app_console_path = "app/console"
endif

if !exists("g:symfony_app_console_caller")
    let g:symfony_app_console_caller = "php"
endif

if !exists("g:symfony_enable_shell_mapping")
    let g:symfony_enable_shell_mapping = 0
endif

fun! CompleteSymfonyContainer(base, res)
    let shellcmd = g:symfony_app_console_caller. ' '.g:symfony_app_console_path.' container:debug'
    let output = system(shellcmd)
    if v:shell_error
        return 0
    endif

    for m in split(output, "\n")
        let row = split(m)
        if len(row) == 3
            let [service, scope, class] = row
            if service =~ '^' . a:base
                let menu = 'scope: '. scope .', class: '. class
                call add(a:res, { 'word': service, 'menu': menu })
            endif
        endif
    endfor
endfun

fun! CompleteSymfonyRouter(base, res)
    let shellcmd = g:symfony_app_console_caller. ' '.g:symfony_app_console_path.' router:debug'
    let output = system(shellcmd)
    if v:shell_error
        return 0
    endif

    for m in split(output, "\n")
        let row = split(m)
        if len(row) == 3
            let [route, method, url] = row
            if route =~ '^' . a:base
                let menu = 'method: '. method .', url: '. url
                call add(a:res, { 'word': route, 'menu': menu })
            endif
        endif
    endfor
endfun

fun! CompleteSymfony(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[a-zA-Z_\-.]'
            let start -= 1
        endwhile
        return start
    else
        " find symfony services id / routes matching with "a:base"
        let res = []
        call CompleteSymfonyContainer(a:base, res)
        call CompleteSymfonyRouter(a:base, res)

        return res
endfun

" activate completefunc only in twig, php, xml and yaml buffers
let oldcompletefunc = &completefunc

au BufEnter *.twig   setlocal completefunc=CompleteSymfony
au BufEnter *.php    setlocal completefunc=CompleteSymfony
au BufEnter *.yml    setlocal completefunc=CompleteSymfony
au BufEnter *.xml    setlocal completefunc=CompleteSymfony

" once leaved these buffers, switch back to the old completefunc, if any
au BufLeave *.twig   setlocal completefunc=oldcompletefunc
au BufLeave *.php    setlocal completefunc=oldcompletefunc
au BufLeave *.yml    setlocal completefunc=oldcompletefunc
au BufLeave *.xml    setlocal completefunc=oldcompletefunc


" Open console
let g:symfony_enable_shell_cmd = g:symfony_app_console_caller." ".g:symfony_app_console_path." -s"

if(g:symfony_enable_shell_mapping == 1)
    map <C-F> :execute ":!"g:symfony_enable_shell_cmd<CR>
endif
