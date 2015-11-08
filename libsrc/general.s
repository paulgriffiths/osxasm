#  General utility functions.

.include "unix.inc"

.globl  _exit_success, _exit_failure, _pgrandom, _seedrandom

.data

rand_x:
.long   123456789                       #  X value for PRNG

rand_y:
.long   362436069                       #  Y value for PRNG

rand_z:
.long   521288629                       #  Z value for PRNG

rand_w:
.long   88675123                        #  W value for PRNG


.text


#  Exits with successful status

_exit_success:
        mov    $SC_EXIT, %rax
        xor    %rdi, %rdi
        syscall 


#  Exits with unsuccessful status

_exit_failure:
        mov    $SC_EXIT, %rax
        mov    $1, %rdi
        syscall 


#  Generates a random number within a range.
#  Uses 'XORShift' algorithm.
#  Argument 1 - the exclusive top end of the desired range
#  Returns a pseudo-random number between 0 and n-1, inclusive

_pgrandom:
        push   %rbp                     #  Set up stack
        mov    %rsp, %rbp
        sub    $16, %rsp

        .set   range, -16               #  Local - argument
        .set   t, -8                    #  Local - temporary

        mov    %rdi, range(%rbp)        #  Store argument

        movl   rand_x(%rip), %eax       #  Get x value
        mov    %eax, %ecx               #  Copy x value
        shl    $11, %ecx                #  x << 11
        xor    %ecx, %eax               #  t = x ^ (x << 11)
        mov    %eax, %ecx               #  Copy t value
        shr    $8, %ecx                 #  t >> 8
        xor    %ecx, %eax               #  t = t ^ (t >> 8)
        mov    %eax, t(%rbp)            #  Store t value

        mov    rand_y(%rip), %eax       #  Copy y value...
        mov    %eax, rand_x(%rip)       #  ...to x
        mov    rand_z(%rip), %eax       #  Copy z value...
        mov    %eax, rand_y(%rip)       #  ...to y
        mov    rand_w(%rip), %eax       #  Copy w value...
        mov    %eax, rand_z(%rip)       #  ...to z

        mov    %eax, %ecx               #  Copy w value
        shr    $19, %ecx                #  w >> 19
        xor    %ecx, %eax               #  w = w ^ (w >> 19)
        mov    t(%rbp), %ecx            #  Retrieve t value
        xor    %ecx, %eax               #  w = w ^ t
        mov    %eax, rand_w(%rip)       #  Store w value

        xor    %edx, %edx               #  Zero high order bits for idiv
        idivq  range(%rbp)              #  Divide by range

        mov    %edx, %eax               #  Return remainder
        leave  
        ret    


#  Seeds the pseudo-random number generator.

_seedrandom:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $16, %rsp

        mov     $SC_GETPID, %rax        #  Make getpid system call
        syscall 

        movl    rand_x(%rip), %ecx
        add     %ecx, %eax
        mov     %eax, rand_x(%rip)

        xor     %rax, %rax              #  Return 0
        leave  
        ret    
