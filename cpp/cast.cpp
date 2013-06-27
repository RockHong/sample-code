#include <iostream>

using namespace std;

class Base {};
class Derived:public Base {};
class Other {};

int main(int argc, char **argv)
{
    //static_cast
    double d = 97.0;
    char c = static_cast<char>(d);//97
    cout <<"after static cast c = '" << c <<"'" <<"(" << static_cast<int>(c) <<")" <<endl;

    d = 97.1;
    c = static_cast<char>(d);//97
    cout <<"after static cast c = '" << c <<"'" <<"(" << static_cast<int>(c) <<")" <<endl;

    d = 97.1;
    c = d;//97
    cout <<"after static cast c = '" << c <<"'" <<"(" << static_cast<int>(c) <<")" <<endl;

    Base *pb = new Base;
    Derived *pd;
    pd = static_cast<Derived *>(pb); //ok
    pb = static_cast<Base *>(pd);//ok too
    
    Other *po;
    //po = static_cast<Other *>(pb); //compile error!

    /*
     * http://stackoverflow.com/questions/103512/in-c-why-use-static-castintx-instead-of-intx GOOD!
     * "A static_cast<>() is usually safe. There is a valid conversion in the language, or an appropriate constructor that makes it possible."
     * "static_cast means that you can't accidentally const_cast or reinterpret_cast, which is a good thing."
     * "When you write static_cast<bar> foo you are asking the compiler to at least check that the type conversion makes sense and, for integral types, to insert some conversion code."
     * "static_cast, aside from manipulating pointers to classes, can also be used to perform conversions explicitly defined in classes, as well as to perform standard conversions between fundamental types:"
     */

    // http://en.wikipedia.org/wiki/Static_cast
    // http://www.cplusplus.com/doc/tutorial/typecasting/ GOOD artical!
    // "static_cast can perform conversions between pointers to related classes, not only from the derived class to its base, but also from a base class to its derived. "
    // "static_cast can also be used to perform any other non-pointer conversion that could also be performed implicitly"

    /*
     *  http://www.learncpp.com/cpp-tutorial/44-type-conversion-and-casting/
     * Long double (highest)
     * Double
     * Float
     * Unsigned long int
     * Long int
     * Unsigned int
     * Int (lowest)
     * A good question is, “why is integer at the bottom of the tree? What about char and short?”. Char and short are always implicitly promoted to integers (or unsigned integers) before evaluation. This is called widening.
     */
    // "the signed integer (10) is promoted to an unsigned integer, and the result of this expression is the unsigned integer 4294967291!"
    cout <<5u - 10 <<endl; //4294967291
    int i = 10;
    cout <<static_cast<unsigned int>(10) <<endl;//10 seems "promotion not equals conversion"...
    
    // http://en.cppreference.com/w/cpp/language/implicit_cast  TODO to read
    return 0;
}
