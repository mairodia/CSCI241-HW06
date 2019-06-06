#include <iostream>
using namespace std;

int main(){
    int limit = 10;
    int i = 0;
    int x;
    while(i++ < limit and cin.read(reinterpret_cast<char*>(&x), 4))
        cout << x << endl;
}
