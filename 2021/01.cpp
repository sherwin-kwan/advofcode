#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
int main() {
  // Part 1
  vector<int> my_arr;
  ifstream myfile ("./01.txt");
  for (string line; getline(myfile, line); ) {
    my_arr.push_back(stoi(line));
  }
  int counter = 0;
  for (int i = 1; i < my_arr.size(); i++) {
    if (my_arr[i] > my_arr[i-1]) {
      counter++;
    }
  }
  cout << counter << endl;
  // Part 2
  counter = 0;
  for (int i = 3; i < my_arr.size(); i++) {
    if ((my_arr[i]) > (my_arr[i-3])) {
      counter++;
    }
  }
  cout << counter << endl;
  return 0;
}