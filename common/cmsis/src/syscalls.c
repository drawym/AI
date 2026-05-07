/**
  ******************************************************************************
  * @file    syscalls.c
  * @brief   System calls for newlib
  ******************************************************************************
  */

#include <errno.h>
#include <sys/stat.h>
#include <stdint.h>

/* External memory region definitions from linker script */
extern uint8_t _end;       /* Start of heap section (end of bss) */
extern uint8_t _estack;    /* End of RAM (start of stack) */

static uint8_t *heap_ptr = NULL;

/**
  * @brief  _sbrk_r - Reentrant version of _sbrk.
  *         Increases program data space by size bytes.
  *         Returns a pointer to the start of the new data area.
  */
void *_sbrk(int incr)
{
    uint8_t *prev_heap_ptr;

    if (heap_ptr == NULL)
    {
        heap_ptr = &_end;
    }

    prev_heap_ptr = heap_ptr;

    if ((heap_ptr + incr) > &_estack)
    {
        errno = ENOMEM;
        return (void *)-1;
    }

    heap_ptr += incr;
    return (void *)prev_heap_ptr;
}

/**
  * @brief  _close - Close a file.
  */
int _close(int file) __attribute__((used));
int _close(int file)
{
    return -1;
}

/**
  * @brief  _fstat - Get file status.
  */
int _fstat(int file, struct stat *st) __attribute__((used));
int _fstat(int file, struct stat *st)
{
    st->st_mode = S_IFCHR;
    return 0;
}

/**
  * @brief  _isatty - Check if file descriptor refers to a terminal.
  */
int _isatty(int file) __attribute__((used));
int _isatty(int file)
{
    return 1;
}

/**
  * @brief  _lseek - Set file position.
  */
int _lseek(int file, int ptr, int dir) __attribute__((used));
int _lseek(int file, int ptr, int dir)
{
    return 0;
}

/**
  * @brief  _read - Read from a file.
  */
int _read(int file, char *ptr, int len) __attribute__((used));
int _read(int file, char *ptr, int len)
{
    return 0;
}

/**
  * @brief  _exit - Terminate program.
  */
void _exit(int status)
{
    while (1);
}

/**
  * @brief  _kill - Send signal to a process.
  */
int _kill(int pid, int sig)
{
    errno = EINVAL;
    return -1;
}

/**
  * @brief  _getpid - Get process ID.
  */
int _getpid(void)
{
    return 1;
}