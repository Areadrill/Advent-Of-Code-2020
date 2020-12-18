object Main {
  val input = Map(15 -> 1, 5 -> 2, 1 -> 3, 4 -> 4, 7 -> 5)

  def main(args: Array[String]) {
    println(turn(0, 7, input))
  }

  def turn(num: Int, currentTurn: Int, map: Map[Int, Int]): Int = {
    val lastTurn = map.getOrElse(num, 0)

    val newNum = if (lastTurn == 0) {
      0
    } else {
      currentTurn - lastTurn - 1
    }

    if (currentTurn == 30000000) {
      newNum
    } else {
      turn(newNum, currentTurn + 1, map + (num -> (currentTurn - 1)))
    }
  }
}
