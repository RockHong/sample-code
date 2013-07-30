#include <iostream>
#include <string>
#include <gtest/gtest.h>

using namespace std;

int shiftedPosition(int *array, int low, int high)
{
	static string level;
	level.push_back(' ');
	cout << __FUNCTION__ <<level <<"run for array(" <<array <<"): low=" <<low <<", high=" <<high <<endl;
	int pos = 0;

	if (high - low <= 1) {
		pos = array[low] > array[high] ? high : low;
		level.erase(level.size() - 1);
		return pos;
	}

	int mid = (low + high)/2;
	if (array[low] > array[mid]) {
		pos = shiftedPosition(array, low, mid);
	}
	else if (array[mid] > array[high]) {
		pos = shiftedPosition(array, mid, high);
	}
	else {
		pos = low;
	}

	level.erase(level.size() - 1);
	return pos;
}

int shiftedArraySearch(int *array, int size, int key)
{
	int pos = shiftedPosition(array, 0, size-1);

	int low;
	int high;

	if (array[0] <= key && key <= array[pos-1]) {
		low = 0;
		high = pos -1;
	}
	else if (array[pos] <= key && key <= array[size -1]) {
		low = pos;
		high = size -1;
	}
	else {
		return -1;
	}

	while(low <= high) {
		int mid = (low + high)/2;
		if (array[mid] == key) return mid;
		if (array[mid] > key) high = mid - 1;
		else if (array[mid] < key) low = mid + 1;
	}
	
	return -1;
}

TEST(ShiftedArraySearchTest, xxx) {
	int array1[1] = {1};
	int arrayOdd[9] = {2, 5, 8, 9, 11, 15, 19, 21, 24};
	int arrayOddLargeLeft[9] = {9, 11, 15, 19, 21, 24, 2, 5, 8 };
	int arrayOddLargeRight[9] = {19, 21, 24, 2, 5, 8, 9, 11, 15};
	int arrayEven[8] = {2, 5, 8, 9, 11, 15, 19, 21};
	int arrayEvenLargeLeft[8] = {8, 9, 11, 15, 19, 21, 2, 5};
	int arrayEvenLargeRight[8] = {21, 2, 5, 8, 9, 11, 15, 19};

	EXPECT_EQ(0, shiftedPosition(array1, 0, 0));
	EXPECT_EQ(0, shiftedPosition(arrayOdd, 0, 8));
	EXPECT_EQ(6, shiftedPosition(arrayOddLargeLeft, 0, 8));
	EXPECT_EQ(3, shiftedPosition(arrayOddLargeRight, 0, 8));
	EXPECT_EQ(0, shiftedPosition(arrayEven, 0, 7));
	EXPECT_EQ(6, shiftedPosition(arrayEvenLargeLeft, 0, 7));
	EXPECT_EQ(1, shiftedPosition(arrayEvenLargeRight, 0, 7));

	EXPECT_EQ(-1, shiftedArraySearch(array1, 1, 999));
	EXPECT_EQ(0, shiftedArraySearch(array1, 1, 1));
	EXPECT_EQ(8, shiftedArraySearch(arrayOdd, 9, 24));
	EXPECT_EQ(-1, shiftedArraySearch(arrayEven, 8, 999));
	EXPECT_EQ(7, shiftedArraySearch(arrayOddLargeLeft, 9, 5));
	EXPECT_EQ(0, shiftedArraySearch(arrayEvenLargeRight, 8, 21));
}
