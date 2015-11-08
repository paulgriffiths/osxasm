#  Tests IO library functions with "Hello, World!" program.

.include "ascii.inc"

.extern _put_string, _exit_success
.globl  _entrypoint

.const_data

hwstr:
.asciz "Hello, world!\n"

.text

_entrypoint:
        lea     hwstr(%rip), %rdi
        call    _put_string
        call    _exit_success
