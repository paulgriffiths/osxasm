#include <stdio.h>
#include "pgasm.h"

int main(void)
{
    seedrandom();

    for ( int i = 1; i < 15; ++i ) {
        printf("Random number %2d: %d\n", i, pgrandom(100) + 1);
    }

    return 0;
}
