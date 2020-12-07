#include <stdio.h>
#include <string.h>

#define NEWLINE '\n'

int countGroupAnswers(int alphabet[], int peopleinGroup) {
    int counter = 0;
    for (int i = 0; i < 26; i++) {
        if (alphabet[i] == peopleinGroup) {
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
    int groupNumberCounter = 1;
    int newlineCounter = 0;
    int groupAffirmativeAnswers[26] = {0};
    char currentChar;

    while (fscanf(input, "%c", &currentChar) == 1) {
        if(newlineCounter == 2) {
            groupCounter += countGroupAnswers(groupAffirmativeAnswers, groupNumberCounter - 2);
            newlineCounter = 0;
            groupNumberCounter = 1;
            memset(groupAffirmativeAnswers, 0, 26*sizeof(int));
        }

        if(currentChar == NEWLINE) {
            newlineCounter++;
            groupNumberCounter++;
            continue;
        } else {
            newlineCounter = 0;
        }

        groupAffirmativeAnswers[currentChar - 97] += 1;
    }

    groupCounter += countGroupAnswers(groupAffirmativeAnswers, groupNumberCounter - 2);

    printf("%d", groupCounter);
}