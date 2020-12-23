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

function getValidIntervals(io:ReadableCharacterChannel sc) returns [string, [int, int], [int, int]][] | error {
    [string, [int, int], [int, int]][] accum = [];
    string line = readLine(sc);

    while (line != "") {
        string sectionName = stringutils:split(line, ": ")[0];
        
        string[] bothIntervals = stringutils:split(stringutils:split(line, ": ")[1], " or ");

        string[] firstInterval = stringutils:split(bothIntervals[0], "-");
        string[] secondInterval = stringutils:split(bothIntervals[1], "-");

        accum.push([
            sectionName,
            [check 'int:fromString(firstInterval[0]), check 'int:fromString(firstInterval[1])], 
            [check 'int:fromString(secondInterval[0]), check 'int:fromString(secondInterval[1])]
        ]);


        line = readLine(sc);
    }
    return accum;
}

function respectsLimits(int ticket, [string, [int, int], [int, int]][] intervals) returns 'boolean {
    foreach [string, [int, int], [int, int]] interval in intervals {
        if (ticket >= interval[1][0] && ticket <= interval[1][1]) {
            return false;
        } else if (ticket >= interval[2][0] && ticket <= interval[2][1]) {
            return false;
        }
    }

    return true;
}

function validForSection(int value, [string, [int, int], [int, int]] section) returns boolean {
    if (value >= section[1][0] && value <= section[1][1]) {
        return true;
    } else if (value >= section[2][0] && value <= section[2][1]) {
        return true;
    }

    return false;
}

public function main() returns @tainted error? {

    io:ReadableByteChannel readableFieldResult =
                            check io:openReadableFile("./input.txt");
    io:ReadableCharacterChannel sourceChannel =
                            new (readableFieldResult, "ascii");

    [string, [int, int], [int, int]][] sections = check getValidIntervals(sourceChannel);

    string[] useless = seekToLine(sourceChannel, "your ticket:");

    int[] targetTicket = stringutils:split(seekToLine(sourceChannel, "")[0], ",").map(function (string val) returns int {
            return <int>'int:fromString(val);
    });

    useless = seekToLine(sourceChannel, "nearby tickets:");

    string[] values = seekToLine(sourceChannel, "");

    int[][] validTickets = values
    .map(function (string str) returns int[] {
        return stringutils:split(str, ",").map(function (string val) returns int {
            return <int>'int:fromString(val);
        });
    }).filter(function (int[] vals) returns 'boolean {
        return vals.map(function (int val) returns boolean { return respectsLimits(val, sections); }).indexOf(true, 0) == ();
    });

    boolean[][][] compatibilityMatrix = sections.map(function ([string, [int, int], [int, int]] section) returns boolean[][] {
        return validTickets.map(function (int[] ticket) returns boolean[] {
            return ticket.map(function (int ticketSection) returns boolean {
                return validForSection(ticketSection, section);
            });
        });
    });

    boolean[][] sectionToTicketCompatibility = compatibilityMatrix.map(function (boolean[][] sectionCompatibility) returns boolean[] {
        boolean[] accum = [];

        foreach int i in 0...(sectionCompatibility[0].length() - 1) {
            boolean isCompatible = true;

            foreach int j in 0...(sectionCompatibility.length() - 1) {
                if (sectionCompatibility[j][i] == false) {
                    isCompatible = false;
                    break;
                }
            }

            accum.push(isCompatible);
        }

        return accum;
    });

    [string, boolean[]][] sectionOptions = [];

    foreach int i in 0...(sectionToTicketCompatibility.length() - 1) {
        sectionOptions.push([
            sections[i][0],
            sectionToTicketCompatibility[i]
        ]);
    }

    sectionOptions = sectionOptions.sort(function ([string, boolean[]] a, [string, boolean[]] b) returns int {
        int aPotentialChoices = a[1].filter(function (boolean compat) returns boolean {
            return compat;
        }).length();

        int bPotentialChoices = b[1].filter(function (boolean compat) returns boolean {
            return compat;
        }).length();

        if (aPotentialChoices > bPotentialChoices) {
            return -1;
        } else if (aPotentialChoices < bPotentialChoices) {
            return 1;
        } else {
            return 0;
        }
    });

    [string, int][] finalChoices = [];

    while (sectionOptions.length() != 0) {
        [string, boolean[]] nextSection = sectionOptions.pop();

        finalChoices.push([
            nextSection[0],
            <int>nextSection[1].indexOf(true)
        ]);

        sectionOptions = sectionOptions.map(function ([string, boolean[]] choice) returns [string, boolean[]] {
            boolean[] options = choice[1];
            options[<int>nextSection[1].indexOf(true)] = false;

            return [choice[0], options];
        });
    }

    int resultAccum = 1;

    foreach [string, int] sectionChoice in finalChoices {
        if(stringutils:split(sectionChoice[0], " ")[0] == "departure") {
            resultAccum *= targetTicket[sectionChoice[1]];
        }
    }

    io:println(resultAccum);
}