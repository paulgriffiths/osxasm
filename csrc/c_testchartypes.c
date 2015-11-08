/*  Tests char type functions from a C program.  */

#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>
#include "pgasm.h"

int main(void)
{
    bool correct = true;

    for ( int i = 1; i < CHAR_MAX; ++i ) {
        if ( (isdigit(i) && !char_is_digit(i)) ||
             (!isdigit(i) && char_is_digit(i)) ) {
            correct = false;
            printf("char_is_digit() failed for %d.\n", i);
        }

        if ( (isspace(i) && !char_is_space(i)) ||
             (!isspace(i) && char_is_space(i)) ) {
            correct = false;
            printf("char_is_space() failed for %d.\n", i);
        }

        if ( (isalpha(i) && !char_is_alpha(i)) ||
             (!isalpha(i) && char_is_alpha(i)) ) {
            correct = false;
            printf("char_is_alpha() failed for %d.\n", i);
        }

        if ( (isalnum(i) && !char_is_alnum(i)) ||
             (!isalnum(i) && char_is_alnum(i)) ) {
            correct = false;
            printf("char_is_alnum() failed for %d.\n", i);
        }
    }

    if ( correct ) {
        puts("All tests passed.");
    }
    else {
        puts("Some tests FAILED.");
    }

    return 0;
}
