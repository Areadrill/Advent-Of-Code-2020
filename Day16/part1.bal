import ballerina/io;
import ballerina/stringutils;
import ballerina/lang.'int;


function readLine(io:ReadableCharacterChannel sc) returns @tainted string {
    string accum = "";

    string | io:Error currentChar = sc.read(1);

    while (currentChar is string) {
        if (currentChar == "\n") {
            return accum;
        }

        accum = accum + currentChar;

        currentChar = sc.read(1);
    }

    return accum;
}

function seekToLine(io:ReadableCharacterChannel sc, string target) returns string[] {
    string line = readLine(sc); 
    string[] accum = [];

    while (line != target) {
        accum.push(line);

        line = readLine(sc);
    }

    return accum;
}

function getValidIntervals(io:ReadableCharacterChannel sc) returns [int, int][] | error {
    [int, int][] accum = [];
    string line = readLine(sc);

    while (line != "") {
        string[] bothIntervals = stringutils:split(stringutils:split(line, ": ")[1], " or ");

        string[] firstInterval = stringutils:split(bothIntervals[0], "-");
        accum.push([check 'int:fromString(firstInterval[0]), check 'int:fromString(firstInterval[1])]);

        string[] secondInterval = stringutils:split(bothIntervals[1], "-");
        accum.push([check 'int:fromString(secondInterval[0]), check 'int:fromString(secondInterval[1])]);

        line = readLine(sc);
    }
    return accum;
}

function respectsLimits(int value, [int, int][] intervals) returns 'boolean {
    foreach [int, int] interval in intervals {
        if (value >= interval[0] && value <= interval[1]) {
            return false;
        }
    }

    return true;
}

public function main() returns @tainted error? {

    io:ReadableByteChannel readableFieldResult =
                            check io:openReadableFile("./input.txt");
    io:ReadableCharacterChannel sourceChannel =
                            new (readableFieldResult, "ascii");

    [int, int][] validIntervals = check getValidIntervals(sourceChannel);

    string[] useless = seekToLine(sourceChannel, "nearby tickets:");

    string[] values = seekToLine(sourceChannel, "");

    int[] invalidValues = stringutils:split(",".'join(...values), ",")
    .map(function (string str) returns int {
        return <int>'int:fromString(str);
    }).filter(function (int val) returns 'boolean {
        return respectsLimits(val, validIntervals);
    });zz

    io:println(invalidValues.reduce(function (int accumulator, int currentValue) returns int {
        return accumulator + currentValue;
    }, 0));
}