#  Number guessing game

.include "ascii.inc"

.extern _put_string, _exit_success, _pgrandom, _seedrandom
.extern _get_int, _put_int, _put_char, _print_newline, _get_char_line
.globl _entrypoint


.data

.lcomm answer, 8
.lcomm turns, 8


.text


#  Program entry point

_entrypoint:
        call    start_program           #  Welcome and initialize program

0:                                      #  New game starts here
        call    start_game              #  Start new game

1:                                      #  New turn starts here
        call    get_guess               #  Get the player's guess
        mov     %rax, %rdi              #  Pass guess as argument and...
        call    eval_guess              #  ...evaluate the guess

        cmp     $0, %rax                #  Guess was right if return 0...
        jne     1b                      #  ...so new turn if not 0.

        call    end_game                #  Finish game
        call    query_new               #  Ask for new game
        cmp     $1, %rax                #  If return value was 0...
        je      0b                      #  ...then start new game.

        call    _exit_success


#  Initializes the program and prints a welcome message.
#  No arguments, no return value.

start_program:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msg1:
.asciz "Guess The Number!\n"

msg2:
.asciz "=================\n"

.text

        lea     msg1(%rip), %rdi        #  Output welcome message
        call    _put_string
        lea     msg2(%rip), %rdi        #  Output welcome message
        call    _put_string

        call    _seedrandom             #  Seed random number generator

        leave                           #  Return
        ret


#  Initializes a new game.
#  No arguments, no return value.

start_game:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msg3:
.asciz "I'm thinking of a number between 1 and 100..."
.asciz "can you guess it?\n"

.text

        mov     msg3@GOTPCREL(%rip), %rdi   #  Output new game message
        call    _put_string

        mov     $100, %rdi              #  Get a random number between...
        call    _pgrandom               #  ...0 and 99, inclusive.
        inc     %rax                    #  Add 1 to it...
        mov     %rax, answer(%rip)      #  ...and store as the answer.

        movq    $0, turns(%rip)         #  Reset number of turns to zero

        leave                           #  Return
        ret


#  Gets a guess from the player.
#  No arguments, returns player's guess.

get_guess:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msg4:
.asciz "Enter your guess: "

.text

        lea     msg4(%rip), %rdi        #  Prompt user for guess
        call    _put_string

        call    _get_int                #  Get the guess...

        leave                           #  ...and return it.
        ret


#  Evaluates a guess.
#  Single argument is the guess to evaluate.
#  Returns:
#    -1 if guess is too low
#     1 if guess is too high
#     0 if guess is correct

eval_guess:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msghigh:
.asciz "Too high! Try again.\n"

msglow:
.asciz "Too low! Try again.\n"

msgright:
.asciz "You got it! It was "

msgend:
.asciz ".\n"

.text

        cmpq    answer(%rip), %rdi      #  Compare guess with answer
        jl      0f                      #  Branch if guess is lower
        jg      1f                      #  Branch if guess is higher

        lea     msgright(%rip), %rdi    #  Output initial message
        call    _put_string

        mov     answer(%rip), %rdi      #  Output answer
        call    _put_int

        lea     msgend(%rip), %rdi      #  Output trailing message
        call    _put_string

        xor     %rax, %rax              #  Set return value to 0

        jmp     2f 

0:
        lea     msglow(%rip), %rdi      #  Output message
        call    _put_string

        mov     $-1, %rax               #  Set return value to -1

        jmp     2f 

1:
        lea     msghigh(%rip), %rdi     #  Output message
        call    _put_string

        mov     $1, %rax                #  Set return value to 1

2:
        incq    turns(%rip)             #  Increment number of turns taken
        leave                           #  Return
        ret


#  Ends the game.
#  No arguments, no return

end_game:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msg5:
.asciz "It took you "

msg5plural:
.asciz " turns.\n"

msg5single:
.asciz " turn.\n"

.text

        lea     msg5(%rip), %rdi        #  Output leading message
        call    _put_string

        mov     turns(%rip), %rdi       #  Output number of turns
        call    _put_int

        lea     msg5plural(%rip), %rdi  #  Default is more than one turn
        lea     msg5single(%rip), %rsi  #  Load address for cmove
        cmpq    $1, turns(%rip)         #  If only one turn was needed...
        cmove   %rsi, %rdi              #  ...use the singular, not the plural
        call    _put_string             #  Output trailing message

        leave                           #  Return
        ret


#  Asks player if they want a new game.
#  No arguments.
#  Returns 1 if players wants a new game, 0 otherwise.

query_new:
        push    %rbp                    #  Set up stack
        mov     %rsp, %rbp

.const_data

msg6:
.asciz "Would you like to play again (y/n)? "

.text

        lea     msg6(%rip), %rdi        #  Prompt for new game
        call    _put_string

        call    _get_char_line

        cmp     $'y', %rax              #  New game if 'y'
        je      0f 
        cmp     $'Y', %rax              #  New game if 'Y'
        je      0f

        mov     $0, %rax                #  Otherwise end game, return 0
        jmp     1f 

0:
        mov     $1, %rax                #  Return 1 for new game

1:
        leave                           #  Return
        ret
