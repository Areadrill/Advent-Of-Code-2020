class Part1 {
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

        def largestIdPass =  boardingPasses.max{it.seatId()}

        println largestIdPass.seatId()
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