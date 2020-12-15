function analyzeNeighbours(y, x, map)
    occupiedSeatCounter = 0

    for k = max(1, y-1):min(y+1, size(map)[1])
        for l = max(1, x-1):min(x+1, size(map[y])[1])
            if k == y && l == x
                continue
            end

            if map[k][l] == "#"
                occupiedSeatCounter += 1
            end
        end
    end

    return occupiedSeatCounter
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
            elseif occupiedSeat && occupiedSeatCounter >= 4
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