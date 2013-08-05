
class Apple {
public:
	int i;
};

class Orange {
	Apple a;
	int i;
};

class Grape {
public:
    Grape():i(0) {}
private:
    int i;
};

class SpecialGrape:public Grape {
};

class Watermelon {
    Grape g;
};

class Banana {
public:
	virtual int price();
private:
	int _p;
};
int Banana::price() { return _p;}

class Peach {
public:
    Peach(const Peach &o) { i = o.i; } // once you define one constructor, the compiler won't make up others
    Peach() {} 
    int i;
};

class Mango {
    Peach p;
};

class Melon {
    Peach p;
};

int main(int argc, char **argv) {
    // * * * default constructor * * * //

    // * implicitly declared default constructor. trivial
	Apple a;

    // * class Orange has a data member of class Apple, whose default constructor is trivial 
	Orange o;

    // * class Watermelon has a data member of class Grape, whose has a user-defined default constructor
    Watermelon w;

    // * class SpecialGrape's base class has a user-defined default constructor
    SpecialGrape sg;

    // * class Banana has a virtual function
	Banana b;

    // * * * copy constructor * * * //
    
    Apple a_2 = a;

    Mango m;
    Melon me;
    Melon me_2 = me;
    
	return 0;
}

