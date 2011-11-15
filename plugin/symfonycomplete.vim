
fun! CompleteSymfonyContainer(base, res)
    let shellcmd = 'php app/console container:debug'
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
    let shellcmd = 'php app/console router:debug'
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
set completefunc=CompleteSymfony
