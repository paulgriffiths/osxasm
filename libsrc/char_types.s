#  Char types
#
#  Functions to test ASCII character types.
#
#  Paul Griffiths, March 21, 2015

.include "ascii.inc"

.globl _char_is_digit, _char_is_space, _char_is_alpha, _char_is_alnum

.text


#  Tests if a character is a digit
#  Argument 1 - the character to test
#  Returns - 1 if the character is a digit, 0 if it is not

_char_is_digit:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        mov     $1, %rax                #  Default return value of 1 if true
        mov     $0, %rcx                #  Needed for conditional moves

        cmp     $CHAR_ZERO, %rdi        #  Not digit if less than '0'...
        cmovl   %rcx, %rax              #  ...so return 0 if true.
        cmp     $CHAR_NINE, %rdi        #  Not digit if more than '9'...
        cmovg   %rcx, %rax              #  ...so return 0 if true.

        leave                           #  Return
        ret


#  Tests if a character is a space
#  Argument 1 - the character to test
#  Returns - 1 if the character is a space, 0 if it is not

_char_is_space:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        mov     $1, %rax                #  Default return value 1 if true
        mov     $0, %rcx                #  Needed for conditional moves

        cmp     $CHAR_HTAB, %rdi        #  Not space if less than htab...
        cmovl   %rcx, %rax              #  ...so return 0 if true.

        cmp     $CHAR_CR, %rdi          #  Not space if more than CR...
        cmovg   %rcx, %rax              #  ...so return 0 if true.

        mov     $1, %rcx                #  Needed for conditional moves
        cmp     $CHAR_SPACE, %rdi       #  ...unless it's space, then...
        cmove   %rcx, %rax              #  ...so return 1 if true.

        leave                           #  Return
        ret


#  Tests if character is alphabetic
#  Argument 1 - the character to test
#  Returns 1 if the character is alphabetic, 0 if not

_char_is_alpha:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        mov     $1, %rdx                #  Default result is true for uppercase
        mov     $0, %rcx                #  Needed for conditional moves
        cmp     $CHAR_UPPER_A, %rdi     #  False if below 'A'
        cmovl   %rcx, %rdx              #  ...so return 0 if true.
        cmp     $CHAR_UPPER_Z, %rdi     #  False if above 'Z'
        cmovg   %rcx, %rdx              #  ...so return 0 if true.

        mov     $1, %rax                #  Default result is true for lowercase
        cmp     $CHAR_LOWER_A, %rdi     #  False if below 'a'
        cmovl   %rcx, %rax              #  ...so return 0 if true.
        cmp     $CHAR_LOWER_Z, %rdi     #  False if above 'z'
        cmovg   %rcx, %rax              #  ...so return 0 if true.

        or      %rdx, %rax              #  True if either test was true

        leave                           #  Return
        ret


#  Tests if character is alphanumeric
#  Argument 1 - the character to test
#  Returns 1 if the character is alphanumeric, 0 if not

_char_is_alnum:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $16, %rsp

        .set     n, -8                  #  Local - character to test

        mov     %rdi, n(%rbp)           #  Store character

        call    _char_is_alpha          #  Check if alphabetic...
        mov     %rax, %rdx              #  ...and store result

        mov     n(%rbp), %rdi           #  Pass character to test
        call    _char_is_digit          #  Check if digit

        or      %rdx, %rax              #  True if either test was true

        leave                           #  Return
        ret
