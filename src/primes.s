#  Calculates first n prime numbers

.extern _put_int, _print_newline, _exit_success
.globl _entrypoint

.set nprimes, 15                        #  Number of prime numbers to find
.set nsz, 8                             #  Size of prime number array element

.data

.lcomm primes, nprimes * nsz            #  Array of prime numbers

.text


#  Main entry point

_entrypoint:
        mov     %rsp, %rbp              #  Set up stack

        mov     $nprimes, %rdi          #  Pass number of primes
        lea     primes(%rip), %rsi      #  Pass address of array
        call    calcprimes              #  Find primes

        mov     $nprimes, %rdi          #  Pass number of primes
        lea     primes(%rip), %rsi      #  Pass address of array
        call    printqarray             #  Print found primes

        call    _exit_success           #  Exit


#  Prints an array of quad words
#  Argument 1 - number of elements in array
#  Argument 2 - address of array
#  Return 0.

printqarray:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $32, %rsp 

        .set    size, -32               #  Local - size of array
        .set    array, -24              #  Local - address of array
        .set    cnt, -16                #  Local - current count

        movq    %rdi, size(%rbp)        #  Store size of array
        movq    %rsi, array(%rbp)       #  Store address of array
        movq    $0, cnt(%rbp)           #  Set count to zero

0:
        movq    size(%rbp), %rdx        #  Retrieve size of array
        movq    cnt(%rbp), %rcx         #  Retrieve count
        cmp     %rdx, %rcx              #  If at end of array...
        je      1f                      #  ...then stop looping.

        movq    array(%rbp), %rax       #  Retrieve address of array
        movq    (%rax, %rcx, nsz), %rdi #  Load value of array element
        call    _put_int                #  Output it
        call    _print_newline          #  Output newline
        incq    cnt(%rbp)               #  Increment count
        jmp     0b                      #  Loop again
        
1:
        xor     %rax, %rax              #  Return 0
        leave
        ret


#  Calculates the first n prime numbers
#  Argument 1 - the number of primes to find
#  Argument 2 - the quad word array in which to store them
#  Returns 0.
#  Caller is responsible for making array large enough.

calcprimes:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        cmp     $2, %rdi                #  If number is less than 2...
        jl      4f                      #  ...don't even try.

        movq    $2, (%rsi)              #  Manually populate...
        movq    $3, nsz(%rsi)           #  ...the first 2 primes.
        mov     $2, %rcx                #  Number of primes found
        mov     $5, %r8                 #  Current number to test

0:
        cmp     %rdi, %rcx              #  If all primes are found...
        jge     4f                      #  ...then stop.
        mov     $1, %r9                 #  Primes found index, skip 2
        mov     $1, %r10                #  Found flag, default true

1:
        cmp     %rcx, %r9               #  If past found primes...
        je      2f                      #  ...then stop.
        mov     (%rsi, %r9, nsz), %r11  #  Get next found prime
        inc     %r9                     #  Increment found prime index
        xor     %rdx, %rdx              #  Zero HO bits for idiv
        mov     %r8, %rax               #  Get current test number
        idivq   %r11                    #  Divide by next found prime
        cmp     $0, %rdx                #  If it doesn't divide...
        jne     1b                      #  ...keep looking
        mov     $0, %r10                #  Otherwise found flag false

2:
        cmp     $1, %r10                #  Check if we found a prime...
        jne     3f                      #  ...and skip if we didn't.
        mov     %r8, (%rsi, %rcx, nsz)  #  Store the found prime
        inc     %rcx                    #  Increment primes found count

3:
        add     $2, %r8                 #  Go to next odd number
        jmp     0b                      #  Loop again.

4:
        xor     %rax, %rax              #  Return 0
        leave
        ret
