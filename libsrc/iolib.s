#  IOLIB
#
#  Simple unbuffered IO and other utility functions
#
#  Paul Griffiths, November 7, 2015

.include "unix.inc"
.include "ascii.inc"

.globl _put_string, _get_string, _get_char, _put_char
.globl _print_newline, _put_int, _get_int, _get_char_line
.extern _string_length, _int_to_string, _string_to_int

.set BUFLEN, 128

.text


#  Prints a null-terminated string to standard output
#  Does not automatically add a new line character
#  Argument 1 - address of the string
#  Returns result of write system call 

_put_string:
        push    %rbp                        #  Set up stack
        movq    %rsp, %rbp
        subq    $16, %rsp

        .set    str, -8                     #  Address of string

        mov     %rdi, str(%rbp)             #  Save address of string
        call    _string_length              #  Calculate string length
        mov     str(%rbp), %rdi             #  Restore address of string
        mov     %rax, %rdx                  #  Pass length of string
        mov     $SC_WRITE, %rax             #  Pass system call number
        mov     %rdi, %rsi                  #  Pass address of string
        mov     $STDOUT, %rdi               #  Pass file descriptor
        syscall                             #  Make write system call

        leave                               #  Return
        ret


#  Reads a character from standard input
#  Returns the character read, or -1 on failure

_get_char:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $16, %rsp

        .set    c, -16                  #  Local - buffer, one character used

        mov     $SC_READ, %rax          #  Pass system call number
        mov     $STDIN, %rdi            #  Pass file descriptor
        lea     c(%rbp), %rsi           #  Pass address of buffer
        mov     $1, %rdx                #  Pass number of characters to read
        syscall                         #  Make read system call

        cmp     $1, %rax                #  Check number of characters read...
        jl      0f                      #  ...and fail if less than one

        movsbq  c(%rbp), %rax           #  Return the character read
        jmp     1f 

0:
        mov     $-1, %rax               #  Return -1 on failure

1:
        leave                           #  Finish
        ret


#  Writes a character to standard input
#  Argument 1 - the character to output
#  Returns 0 on success, -1 on failure

_put_char:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $16, %rsp

        .set    c, -16                  #  Local - buffer, one character used 

        mov     %rdi, %rax
        movb    %al, c(%rbp)
        mov     $SC_WRITE, %rax         #  Pass system call number
        mov     $STDOUT, %rdi           #  Pass file descriptor
        lea     c(%rbp), %rsi           #  Pass address of buffer
        mov     $1, %rdx                #  Pass number of characters to write
        syscall                         #  Make write system call

        cmp     $1, %rax                #  Check number of characters written
        jl      0f                      #  Fail if less than one
        mov     $0, %rax                #  Return 0 on success
        jmp     1f 

0:
        mov     $-1, %rax               #  Return -1 on failure

1:
        leave
        ret


#  Gets a line from standard input
#  Does not remove the new line character
#  Note - performs no sanity checks on buffer length
#  Argument 1 - address of the buffer into which to write
#  Argument 2 - length of the buffer
#  Returns number of characters read

_get_string:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $32, %rsp 

        .set    storeb, -24             #  Save value of rbx
        .set    count, -16              #  Local - loop counter
        .set    bufflen, -8             #  Local - length of buffer

        mov     %rbx, storeb(%rbp)      #  Store rbx register
        mov     %rsi, bufflen(%rbp)     #  Save length of buffer
        mov     %rdi, %rbx              #  Store address of buffer, rbx is
                                        #  preserved through function calls

        mov     $1, %rcx                #  Set loop counter to one, to allow
                                        #  room for terminating null

0:
        cmp     bufflen(%rbp), %rcx     #  Compare loop count to buffer length
        je      1f                      #  and end if only one space in buffer

        mov     %rcx, count(%rbp)       #  Save loop count
        call    _get_char               #  Get character from standard input
        mov     count(%rbp), %rcx       #  Restore loop count

        movb    %al, -1(%rbx, %rcx)     #  Store character in buffer
        inc     %rcx                    #  Increment loop count

        cmp     $CHAR_LF, %rax          #  Check if character is new line...
        jne     0b                      #  ...and continue loop if it isn't.

1:
        movb    $CHAR_NUL, -1(%rbx, %rcx)   #  Write terminating null

        mov     storeb(%rbp), %rbx      #  Restore rbx register
        dec     %rcx                    #  Decrement rcx for terminating null
        mov     %rcx, %rax              #  Returns number of character read
        leave
        ret


#  Prints a newline character

_print_newline:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

        mov     $CHAR_LF, %rdi          #  Pass newline character
        call    _put_char               #  Call function

        xor     %rax, %rax              #  Return 0
        leave
        ret


#  Prints an integer to standard output
#  Argument 1 - the integer to print

_put_int:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $32, %rsp               #  Big enough for 64 bit int

        .set    str, 32                 #  Local - string buffer

        lea     str(%rbp), %rsi         #  Pass buffer (integer already in
        call    _int_to_string          #  rdi) and convert to string

        lea     str(%rbp), %rdi         #  Pass address of buffer...
        call    _put_string             #  ...and print it

        xor     %rax, %rax              #  Return 0
        leave
        ret


#  Gets an integer from standard input

_get_int:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $BUFLEN, %rsp

        lea     -BUFLEN(%rbp), %rdi     #  Get string
        mov     $BUFLEN, %rsi
        call    _get_string

        lea     -BUFLEN(%rbp), %rdi     #  Convert to integer
        call    _string_to_int

        leave                           #  Return integer
        ret


#  Gets a single character and discards rest of line

_get_char_line:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp
        sub     $BUFLEN, %rsp

        lea     -BUFLEN(%rbp), %rdi     #  Get string
        call    _get_string

        xor     %rax, %rax              #  Zero rax
        movb    -BUFLEN(%rbp), %al      #  Return first character

        leave
        ret

