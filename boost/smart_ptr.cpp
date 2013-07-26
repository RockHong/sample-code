#include <boost/make_shared.hpp>
#include <boost/shared_ptr.hpp>
#include <iostream>

class Complete {
public:
	Complete() {
		using namespace std;
		cout<<"constructing..." <<endl;
	}

	~Complete() {
		using namespace std;
		cout<<"deconstructing..." <<endl;
	}
};

int main(int argc, char **argv)
{
	{
	boost::shared_ptr<Complete> pc = boost::make_shared<Complete>();
	}
	
	return 0;
}
