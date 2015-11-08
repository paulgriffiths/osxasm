#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "pgasm.h"

int main(void)
{
    bool correct = true;

    char s1[100] = "Hello, world!";
    char s2[100] = "!dlrow ,olleH";

    /*  Test string reverse  */

    string_rev(s1);
    if ( strcmp(s1, s2) ) {
        correct = false;
        printf("string_rev() failed\n");
        printf("'%s', '%s'\n", s1, s2);
    }

    /*  Test string length  */

    if ( string_length(s1) != 13 ) {
        correct = false;
        printf("string_length() failed\n");
    }

    /*  Test string to int  */

    strcpy(s1, "314159");
    int n = string_to_int(s1);
    if ( n != 314159 ) {
        correct = false;
        printf("string_to_int() failed\n");
        printf("%d\n", n);
    }

    /*  Test int to string  */

    int_to_string(918273, s1);
    if ( strcmp(s1, "918273") ) {
        correct = false;
        printf("int_to_string() failed\n");
    }

    /*  Output results  */

    if ( correct ) {
        puts("All tests passed.");
    }
    else {
        puts("Some tests FAILED.");
    }

    return 0;
}
