#  General utility functions

.globl _intlog

.const_data

one:
.quad   1

.text

#  Returns the integral (floored) log of an integer
#  e.g. intlog(12345, 10) would return 5
#  Argument 1 - the integer
#  Argument 2 - the base
#  Returns the requested log

_intlog:
        push    %rbp                     #  Set up stack
        mov     %rsp, %rbp

        mov     %rdi, %rax                #  Move integer to rax
        xor     %rcx, %rcx                #  Zero counter

0:
        cmp     $0, %rax                  #  Stop if integer is zero
        je      1f 
        xor     %rdx, %rdx                #  Zero high order bits for idiv
        idivq   %rsi                     #  Divide by base
        inc     %rcx                     #  Increment counter
        jmp     0b                   #  Loop again

1:
        mov     %rcx, %rax                #  Return counter
        cmp     $0, %rax                  #  If result is zero...
        cmove   one(%rip), %rax              #  ...set log to 1
        leave
        ret
