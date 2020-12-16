import java.io.File
import kotlin.math.ceil

fun main(args: Array<String>) {
    val input = "../input.txt"
    val inputLines = File(input).readLines()

    val arrivalTime = Integer.parseInt(inputLines[0])
    val availableBuses = inputLines[1].split(",")
        .filter { it != "x" }
        .map { Integer.parseInt(it) }

    val busesToClosestToArrivalTime = availableBuses.map {
        if (arrivalTime % it == 0) {
            arrivalTime to it
        } else {
            val undershootValue = (arrivalTime % it)
            (arrivalTime + it - undershootValue) to it
        }
    }.toMap()

    val earliestTime = busesToClosestToArrivalTime.entries.minOf { it.key }
    val busToTake = busesToClosestToArrivalTime[earliestTime] ?: 0

    println(busToTake * (earliestTime - arrivalTime))
}