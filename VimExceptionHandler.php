<?php

use Symfony\Component\HttpKernel\Event\GetResponseForExceptionEvent;

/**
 * a vim exception handler
 *
 * Commands a remote vim instance to display the stacktrace in a quickfix list
 *
 * @author     Florian Klein <florian.klein@free.fr>
 */
class VimExceptionHandler
{
    private $levels = array(
        E_WARNING           => 'Warning',
        E_NOTICE            => 'Notice',
        E_USER_ERROR        => 'User Error',
        E_USER_WARNING      => 'User Warning',
        E_USER_NOTICE       => 'User Notice',
        E_STRICT            => 'Runtime Notice',
        E_RECOVERABLE_ERROR => 'Catchable Fatal Error',
    );

    private $level;

    static public function register($level = null)
    {
        $handler = new static();
        $handler->setLevel($level);
        set_error_handler(array($handler, 'handleError'));
        set_exception_handler(array($handler, 'handleException'));

        return $handler;
    }

    public function onKernelException(GetResponseForExceptionEvent $event)
    {
        $exception = $event->getException();
        $this->handleException($exception);
    }

    public function setLevel($level)
    {
        $this->level = null === $level ? error_reporting() : $level;
    }

    /**
     * @throws \ErrorException When error_reporting returns error
     */
    public function handleError($level, $message, $file, $line, $context)
    {
        if (0 === $this->level) {
            return false;
        }

        if (error_reporting() & $level && $this->level & $level) {
            throw new \ErrorException(sprintf('%s: %s in %s line %d', isset($this->levels[$level]) ? $this->levels[$level] : $level, $message, $file, $line));
        }

        return false;
    }

    private function handleException(Exception $exception)
    {
        $stack = '';
        foreach ($exception->getTrace() as $row) {
            if (isset($row['file'])) {
                $stack .= sprintf('%s | %s | %s', $row['file'], $row['line'], $row['function'])."\n";
            }
        }
        file_put_contents('/tmp/stack.php', $stack);

        $cmd = sprintf('vim --servername %s --remote-send ":call PhpStackTrace()<CR>"', 'florian');
        shell_exec($cmd);
    }
}

