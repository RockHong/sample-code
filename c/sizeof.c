#include <stdio.h>

int main(int argc, char **argv)
{
    char *pstr = "hello";
    /* sizeof pstr will be the size of a pointer
       sizeof a string constant will be the length of that string, including the trailing '\0'
    */
    printf("%d, %d\n", sizeof(pstr), sizeof("hello"));
    
    return 0;
}
