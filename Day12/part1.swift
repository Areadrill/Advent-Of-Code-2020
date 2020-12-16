#!/usr/bin/swift
import Foundation

func makeMove(direction: String, amount: Int) {
    switch direction {
        case "N":
            distance.y += amount
        case "W":
            distance.x -= amount
        case "S":
            distance.y -= amount
        case "E":
            distance.x += amount
        case "F":
            makeMove(direction: possibleDirections[orientation] ?? "RIP", amount: amount)
        case "L":
            orientation = (orientation + amount) % 360
        case "R":
            makeMove(direction: "L", amount: (360 - amount))
        default:
            print("not a real direction")
    }
}

let input = try String(contentsOfFile: "input.txt", encoding: .ascii)
let instuctions = input.split(separator: "\n")

var distance = (x: 0, y: 0)

var orientation = 0
let possibleDirections = [0: "E", 90: "N", 180: "W", 270: "S" ]


instuctions.forEach { instruction in
    let direction = String(instruction.prefix(1))
    let amount = Int(instruction.suffix(instruction.count - 1)) ?? 0

    makeMove(direction: direction, amount: amount)
}

print(abs(distance.x) + abs(distance.y))
