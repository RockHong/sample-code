#include <stdio.h>
#include <limits.h>

int main(int argc, char *argv[])
{
    int i = -5;
    /*
    if i is a negative value, then the >> operator will keep the sign bit.
    */
    printf("%d, %d\n", i, i>>1);

    /*
    if you want the biggest positive value of int
    */
    int j = (~0u << 1 >>1);
    printf("%d, %d\n", j, INT_MAX);

    return 0;
}
