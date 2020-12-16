#!/usr/bin/swift
import Foundation

func rotate(x: Int, y: Int, amount: Int) -> (x: Int, y: Int) {
    if amount == 90 {
        return (-y, x)
    } else if amount == 180 {
        return (-x, -y)
    } else if amount == 270 {
        return (y, -x)
    } else {
        return (x, y)
    }

}

func makeMove(direction: String, amount: Int) {
    switch direction {
        case "N":
            waypointDistance.y += amount
        case "W":
            waypointDistance.x -= amount
        case "S":
            waypointDistance.y -= amount
        case "E":
            waypointDistance.x += amount
        case "F":
            distance.x += (waypointDistance.x * amount)
            distance.y += (waypointDistance.y * amount)
        case "L":
            waypointDistance = rotate(x: waypointDistance.x, y: waypointDistance.y, amount: amount)
        case "R":
            waypointDistance = rotate(x: waypointDistance.x, y: waypointDistance.y, amount: (360 - amount))
        default:
            print("not a real direction")
    }
}

let input = try String(contentsOfFile: "input.txt", encoding: .ascii)
let instuctions = input.split(separator: "\n")

var distance = (x: 0, y: 0)
var waypointDistance = (x: 10, y: 1)

instuctions.forEach { instruction in
    let direction = String(instruction.prefix(1))
    let amount = Int(instruction.suffix(instruction.count - 1)) ?? 0

    makeMove(direction: direction, amount: amount)
}

print(abs(distance.x) + abs(distance.y))