class Part2 {
    static void main(String[] args) {
        def boardingPasses = []
        
        new File("input.txt").eachLine {
            line -> {
                boardingPasses<<new BoardingPass(line - line.drop(7), line.drop(7))

                if (line == "BBBBBBBRRR") {
                    println 1023
                    System.exit(0)
                }
            }
        }

        def boardingPassRows = boardingPasses*.seatId() as Set
        def possibleRows = 0..1023
        def possibleRowsSet = possibleRows as Set

        def previousAmount = -1
        for (id in possibleRowsSet.minus(boardingPassRows)) {
            if (id - previousAmount > 1) {
                println id
                break
            }
            previousAmount = id
        }
    }    
}

class BoardingPass {
    int row
    int column

    def BoardingPass(String row, String column) {
        this.row = Integer.parseInt(row.replaceAll("F", "0").replaceAll("B", "1"), 2)
        this.column = Integer.parseInt(column.trim().replaceAll("L", "0").replaceAll("R", "1"), 2)
    }

    def seatId() {
        return (row*8) + column
    }
}