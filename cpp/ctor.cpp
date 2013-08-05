
class Apple {
public:
	int i;
};

class Orange {
	Apple a;
	int i;
};

class Banana {
public:
	virtual int price();
private:
	int _p;
};
int Banana::price() { return _p;}

int main(int argc, char **argv) {
	//if no user-declared ctor for class X, a default ctor is implicitly declared
	//a ctor is trivial if it's an implicitly declared default ctor...
	Apple a;

	Orange o;

	Banana b;

	return 0;
}
