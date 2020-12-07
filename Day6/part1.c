#include <stdio.h>
#include <string.h>

#define NEWLINE '\n'

int countGroupAnswers(int alphabet[]) {
    int counter = 0;
    for (int i = 0; i < 26; i++) {
        if (alphabet[i] == 1) {
            counter++;
        }
    }

    return counter;
}

int main() {
    FILE *input = fopen("input.txt", "r");

    if (input == NULL) {
        return 0;
    }

    int groupCounter = 0;
    int newlineCounter = 0;
    int groupAffirmativeAnswers[26] = {0};
    char currentChar;

    while (fscanf(input, "%c", &currentChar) == 1) {
        if(newlineCounter == 2) {
            groupCounter += countGroupAnswers(groupAffirmativeAnswers);
            newlineCounter = 0;
            memset(groupAffirmativeAnswers, 0, 26*sizeof(int));
        }

        if(currentChar == NEWLINE) {
            newlineCounter++;
            continue;
        } else {
            newlineCounter = 0;
        }

        groupAffirmativeAnswers[currentChar - 97] = 1;
    }

    groupCounter += countGroupAnswers(groupAffirmativeAnswers);

    printf("%d", groupCounter);
}