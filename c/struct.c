struct a {
    int i;
};

int main(int argc, char **argv)
{
    struct a foo= { 0 };

    struct a bar;
    bar = foo;         /* it's ok */
/*    bar = { 0 }; */  /* compile error, { 0 } can't use at assignment; can use during the declaration */

    return 0;
}
