#  String manipulation functions.
#
#  Paul Griffiths, March 21, 2015

.include        "ascii.inc"

.globl _string_length, _int_to_string, _string_to_int, _string_rev
.extern _char_is_digit

.text


#  Calculates the length of a string
#  Argument 1 (rdi) - address of string
#  Returns (%rax) the length of the string

_string_length:
        push    %rbp                        #  Set up stack
        movq    %rsp, %rbp

        movq    $-1, %rcx                   #  Set %rcx to maximum value
        xorb    %al, %al                    #  Set al to '\0'
        repne   scasb                       #  Scan until '\0'
        movq    $-2, %rax                   #  Set to not count null terminator
        sub     %rcx, %rax                  #  Calculate length of string

        leave                               #  Return the length
        ret


#  Converts a string containing a decimal integer representation to an integer
#  Argument 1, address of string
#  Returns the integer, or zero on failure
#  Note - assumes ASCII character set
#  Note - currently only handles positive integers

_string_to_int:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $8, %rsp                #  Align stack to save 3 registers

        push    %r12
        push    %r13
        push    %r14

        mov     %rdi, %r12              #  Store string
        xor     %r13, %r13              #  Store running total
        
0:
        movzbq  (%r12), %r14            #  Extract current character
        mov     %r14, %rdi              #  Pass current character
        call    _char_is_digit          #  Call digit test function
        cmp     $1, %rax                #  Test if character is a digit...
        jne     1f                      #  ...and terminate loop if it isn't.

        imul    $10, %r13               #  Multiply running total by 10
        sub     $CHAR_ZERO, %r14        #  Convert current character to number
        add     %r14, %r13              #  Add current character to total
        inc     %r12                    #  Increment string pointer
        jmp     0b                      #  Loop again

1:
        mov     %r13, %rax              #  Return running total

        pop     %r14
        pop     %r13
        pop     %r12

        leave
        ret


#  Reverses a string in-place
#  Argument 1 - the string to reverse

_string_rev:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $16, %rsp 

        .set    str, -8                 #  Local - address of string

        mov     %rdi, str(%rbp)         #  Save address of string
        call    _string_length          #  Get length of string
        mov     str(%rbp), %rdi         #  Restore address of string
        mov     %rax, %rdx              #  Set back counter to string...
        dec     %rdx                    #  ...length minus 1
        xor     %rcx, %rcx              #  Set front counter to zero

0:
        cmp     %rdx, %rcx              #  If front counter passes back...
        jge     1f                      #  ...counter, then stop looping

        movb    (%rdi, %rcx), %al       #  Get front byte...
        mov     %rax, %rsi              #  ...and save it
        movb    (%rdi, %rdx), %al       #  Get back byte...
        movb    %al, (%rdi, %rcx)       #  Get back byte...
        mov     %rsi, %rax              #  Retrieve saved front byte...
        movb    %al, (%rdi, %rdx)       #  Get back byte...

        inc     %rcx                    #  Increment front counter
        dec     %rdx                    #  Decrement back counter
        jmp     0b                      #  Loop again

1:
        xor     %rax, %rax              #  Return 0
        leave
        ret


#  Converts an integer to a string
#  Note: only handles unsigned integers
#  Note: caller is responsible for ensuring string is sufficiently large
#  Argument 1 - the integer to convert
#  Argument 2 - the address of the string

_int_to_string:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        xor     %rcx, %rcx              #  Set counter to zero
        mov     $10, %r9                #  Store divisor in r9
        xor     %rax, %rax              #  Clear all bits of %rax register

0:
        cmp     $0, %rdi                #  If integer is zero...
        je      1f                      #  ...then we're done

        xor     %rdx, %rdx              #  Clear high order bits for idiv
        mov     %rdi, %rax              #  Move integer into %rax
        idiv    %r9                     #  Divide by 10
        mov     %rax, %rdi              #  Replace previous int with quotient
        mov     %rdx, %rax              #  Move remainder to %rax
        add     $CHAR_ZERO, %rax        #  Convert to digit character
        movb    %al, (%rsi, %rcx)
        inc     %rcx                    #  Increment counter
        jmp     0b                      #  Loop again

1:
        cmp     $0, %rcx                #  Check if nothing written
        jne     2f                      #  Skip if false
        movb    $CHAR_ZERO, (%rsi, %rcx)
        inc     %rcx                    #  Increment loop counter

2:
        movb    $CHAR_NUL, (%rsi, %rcx)
        mov     %rsi, %rdi              #  Pass address of string...
        call    _string_rev             #  ...and reverse it

        xor     %rax, %rax              #  Return 0
        leave
        ret
