#!/bin/bash

validCount=0

input="input.txt"

while IFS= read -r line
do
    lineTokens=($line)

    positions=(${lineTokens[0]//-/ })
    firstPos=${positions[0]}
    secondPos=${positions[1]}

    letter=$(sed s/://g <<< ${lineTokens[1]})

    password=${lineTokens[2]}
    passwordChars=($(echo $password | grep -o .))

    charInFirstPos=${passwordChars[$(($firstPos - 1))]}
    charInSecondPos=${passwordChars[$(($secondPos - 1))]}

    if [ "$charInFirstPos" == "$letter" ] 
    then
        if [ $charInSecondPos != $letter ]
        then
            ((++validCount))
        fi
    else
        if [ $charInSecondPos == $letter ]
        then
            if [ "$charInFirstPos" != "$letter" ]
            then
                ((++validCount))
            fi
        fi
    fi
done < "$input"

echo $validCount
