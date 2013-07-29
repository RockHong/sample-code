#include <boost/array.hpp>
#include <gtest/gtest.h>

TEST(ArrayTest, xxx) {
	boost::array<int, 0> i0;
	EXPECT_EQ(0, i0.size());
}

