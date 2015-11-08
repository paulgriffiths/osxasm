#include "pgasm.h"

int main(void)
{
    char buffer[1024];

    put_string("Hello, world!\n");

    put_string("Enter a string: ");
    get_string(buffer, 1024);
    put_string("You entered: ");
    put_string(buffer);

    put_string("Enter an integer: ");
    int n = get_int();
    put_string("You entered: ");
    put_int(n);
    print_newline();

    return 0;
}
