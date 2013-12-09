#include <iostream>

namespace foo{
  int x = 1;
};

namespace bar{
  double x = 1.1;
};

//int x = 3;

int main()
{
  using namespace std;

  {
    using namespace bar;
    cout <<x <<endl;
  }

  {
    using foo::x;
    cout <<x <<endl;
  }

//  cout <<x <<endl;
}
