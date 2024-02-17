#include <iostream>
#include <bitset>

int main() {
    int8_t a = 0b10000000;
    int8_t b = 0b10000000;
    std::cout<<"a ="<<static_cast<int>(a)<<std::endl;
    std::cout<<"b ="<<static_cast<int>(b)<<std::endl;
    std::cout<<std::bitset<16>(a*b)<<std::endl;
    return 0;
}
