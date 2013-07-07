/* todo: a excercise from <the c standard library> */

#include <stdio.h>
#include <stdlib.h>

#define x(a) ((a)*(a))

struct x {
    int x;
};

int main(int argc, char **argv)
{
    void *x = malloc(sizeof(struct x)); 
    goto x;

    x: ((struct x*)x)->x = x(8);
    
    printf("%d\n", ((struct x*)x)->x);
    return 0;
}
