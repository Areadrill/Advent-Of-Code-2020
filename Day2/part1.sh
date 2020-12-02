#!/bin/bash

validCount=0

input="input.txt"

while IFS= read -r line
do
    lineTokens=($line)

    range=(${lineTokens[0]//-/ })
    minimum=${range[0]}
    maximum=${range[1]}

    letter=$(sed s/://g <<< ${lineTokens[1]})

    password=${lineTokens[2]}

    occurrences=$(grep -o $letter <<< $password | wc -l)
    trimmedOccurrences=${occurrences// /}

    if [ $trimmedOccurrences -ge $minimum ] && [ $trimmedOccurrences -le $maximum ]
    then
        ((++validCount))
    fi
done < "$input"

echo $validCount
