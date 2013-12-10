#include <iostream>
using namespace std;

const int & f1(int i)
{
    return i; //will warn you, because you want to return a reference to a local variable
}

const int & f2(const int &i)
{
    return i;
}

int main()
{
    int i = 3;
    int &r1 = i;
    int &r2 = r1;

    int i2 = 6;
    int &r3 = i2;
    r3 = r1; // it's just a assignment, a 'copy'. r3 and r1 still point to two different objects.
             // you cant change the object a reference pointing
    r1 = 2;
    cout <<i <<endl;
    cout <<r1 <<endl;
    cout <<r3 <<endl;
    

    const int &cr1 = i;

    const int j = 5;
    const int &cr2 = j;
    //int &r3 = j; //it's a error

    // how to 'store' the returning value of f2()
    // 1) use non-reference variable to 'receive' the returning value
    //    it's ok, as it's just a copy, very safe
    int tmp1 = f2(i);

    // 2) use reference variable to 'receive' the returning value
    //    it's also 'safe'. call the reference variable to 'receive' the returning value A
    //    it's not possible to make A point to a dangling object. in below code, you can see at least, 'tmp2' and 'i'
    //    have the same scope
    {
        int i = 1;
        const int &tmp2 = f2(i);
    }

}
