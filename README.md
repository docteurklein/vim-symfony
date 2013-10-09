Symfony2 plugin for ViM
=======================

This plugin handles:

 - symfony routing autocompletion
 - symfony DIC autocompletion
 - symfony console
 - php stack trace navigation using quickfix list

=========================

Variables:

You can overwride two variables on your .vimrc:

    let g:symfony_app_console_caller= "php"
    let g:symfony_app_console_path= "app/console"

=========================

To handle routing or DIC autocompletion, you must define the path to your app console that returns valid output concerning dic and routing.

Then you can use <C-x><C-u> (user completion feature) to see all routes and DIC services with some extra informations in the ViM's menu popup.

**Symfony interactive console**

    <C-F> To open the Symfony interactive console.

If you want to change this:

    let g:symfony_enable_shell_mapping = 0 "disable the mapping of symfony console

    " Use your key instead of default key which is <C-F>
    map *MY KEY* :execute ":!"g:symfony_enable_shell_cmd<CR>



=========================

To handle stack trace navigation with Symfony2, you can use this exception handler class:

    https://github.com/docteurklein/vim-symfony/blob/master/VimExceptionHandler.php

Don't forget to require it in your autoload system.

Then you'll have to register the exception listener, for example (in your config_dev.yml):

    services:
        vim.stack_trace:
            class: VimExceptionHandler
            arguments: [ 'dev-vim-server' ] # optional vim server name, defaults to 'dev'
            tags:
                -  { name: 'kernel.event_listener', event: 'kernel.exception', method: 'onKernelException' }

To use it in another system, just use the same class by typing:

    // require 'VimExceptionHandler.php'
    VimExceptionHandler::register();


Then launch vim using:

    vim --servername dev-vim-server


