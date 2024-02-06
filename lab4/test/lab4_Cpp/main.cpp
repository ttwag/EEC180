#include <iostream>
#include <vector>

std::vector<int> sequenceDetector(std::vector<int>& input) {
    std::vector<int> ans(input.size());
    if (input.size() < 3) return ans;
    int i = 0, j = 1, k = 2;
    while (k < input.size()) {
        if (input[i] == 0 && input[j] == 0 && input[k] == 0) return ans;
        else if (input[i] == 0 && input[j] == 0 && input[k] == 1) ans[k] = 0;
        else if (input[i] == 0 && input[j] == 1 && input[k] == 0) ans[k] = 0;
        else if (input[i] == 0 && input[j] == 1 && input[k] == 1) ans[k] = 0;
        else if (input[i] == 1 && input[j] == 0 && input[k] == 0) ans[k] = 0;
        else if (input[i] == 1 && input[j] == 0 && input[k] == 1) ans[k] = 1;
        else if (input[i] == 1 && input[j] == 1 && input[k] == 0) ans[k] = 0;
        else {
            ans[k] = 1;
            return ans;
        }
        i++, j++, k++;
    }
    return ans;
}

int main() {
    std::vector<int> input = {0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1};
    std::vector<int> output = sequenceDetector(input);
    for (int i = 0; i < output.size(); i++) {
        std::cout << output[i] << " ";
    }
    return 0;
}
