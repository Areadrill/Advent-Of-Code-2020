import java.io.File
import java.math.BigInteger
import kotlin.math.ceil

fun main(args: Array<String>) {
    val input = "../input.txt"
    val inputLines = File(input).readLines()

    val availableBuses = inputLines[1].split(",")
        .mapIndexed { idx, it ->
            if(it != "x") {
                Integer.parseInt(it) to idx
            } else {
                -1 to idx
            }
        }.filter { it.first != -1 }

    var leastCommonMultiple = BigInteger("1")
    var accum = BigInteger("0")

    for (i in 0 until availableBuses.size - 1) {
        val target = availableBuses[i+1].first
        val targetOffset = availableBuses[i+1].second

        leastCommonMultiple *= BigInteger.valueOf(availableBuses[i].first.toLong())

        while ((accum.plus(BigInteger.valueOf(targetOffset.toLong()))).remainder(BigInteger.valueOf(target.toLong())) != BigInteger.ZERO) {
            accum += leastCommonMultiple
        }
    }
}