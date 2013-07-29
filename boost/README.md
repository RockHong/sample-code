##environment
yum install boost-devel gtest-devel gmock-devel

##compile array.cpp
g++ array.cpp -lgtest_main -lgtest
