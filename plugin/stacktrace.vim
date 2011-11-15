
function! PhpStackTrace()
    let errorformat_bak=&errorformat
    try
        let &errorformat="%f\ |\ %l\ |\ %m"
        cexpr join(readfile('/tmp/stack.php'), "\n")
        copen
    finally
        let &errorformat=errorformat_bak
    endtry
endfunction
