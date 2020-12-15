function directionCheck(y, x, map, operation)
    horizontal = deepcopy(x) + operation[1]
    vertical = deepcopy(y) + operation[2]

    while horizontal > 0 && vertical > 0 && horizontal <= size(map[x])[1] && vertical <= size(map)[1]
        if map[vertical][horizontal] == "L"
            return false
        elseif map[vertical][horizontal] == "#"
            return true
        end

        horizontal += operation[1]
        vertical += operation[2]
    end

    return false
end

function analyzeNeighbours(y, x, map)
    visibleSeats = [
        directionCheck(y, x, map, (0, -1)),
        directionCheck(y, x, map, (0, 1)),
        directionCheck(y, x, map, (1, 0)),
        directionCheck(y, x, map, (-1, 0)),
        directionCheck(y, x, map, (-1, -1)),
        directionCheck(y, x, map, (-1, 1)),
        directionCheck(y, x, map, (1, -1)),
        directionCheck(y, x, map, (1, 1))
    ]
    
    return size(filter((seat) -> seat, visibleSeats))[1]
end

function step(map)
    newMap = deepcopy(map)

    for i = 1:size(map)[1]
        for j = 1:size(map[i])[1]
            if map[i][j] == "."
                continue
            end

            vacantSeat = map[i][j] == "L"
            occupiedSeat = map[i][j] == "#"

            occupiedSeatCounter = analyzeNeighbours(i, j, map)

            if vacantSeat && occupiedSeatCounter == 0
                newMap[i][j] = "#"
            elseif occupiedSeat && occupiedSeatCounter >= 5
                newMap[i][j] = "L"
            end
        end
    end

    return newMap
end

seatMap = readlines("input.txt")
seatMap = map((line) -> split(line, ""), seatMap)

stableMap = false

while !stableMap
    newSeatMap = step(seatMap)

    if newSeatMap == seatMap
        global stableMap = true
    else
        global seatMap = newSeatMap
    end
end

occupiedSeatsByLine = (map(((line) -> size(filter((seat) -> seat == "#", line))[1]), seatMap))
println(foldl(+, occupiedSeatsByLine))