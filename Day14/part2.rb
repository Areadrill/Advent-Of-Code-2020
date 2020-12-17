def findTargetRegisters(value, mask)
    binaryValue = value.to_i.to_s(2).rjust(36, '0')

    allRegisters = []

    additionalValues = []

    for i in 0..35
        if mask[i] == "1"
            binaryValue[i] = "1"
        elsif mask[i] == "X"
            additionalValues.append(2**(35-i))
            binaryValue[i] = "0"
        end
    end

    for j in 0..((2**additionalValues.length())-1)
        intValue = binaryValue.to_i(2)

        multipliers = j.to_s(2).rjust(additionalValues.length(), '0').split("").map { |string| string.to_i }

        for k in 0..(multipliers.length() - 1)
            intValue += (multipliers[k] * additionalValues[k])
        end
    
        allRegisters.append(intValue)
    end
    
    return allRegisters
 end

input = IO.readlines('input.txt', chomp: true)

mask = "0"*36
memoryMap = Hash.new

input.each do |instuction|
    instuctionTokens = instuction.split(" = ")
    
    if instuctionTokens[0] == "mask"
        mask = instuctionTokens[1]
    else 
        instuctionTokens[0].match(/mem\[(\d+)\]/) { |m|
            findTargetRegisters(m[1], mask).each do |register|
                memoryMap[register] = instuctionTokens[1].to_i
            end
        }
    end
end

print memoryMap.values.reduce(:+)
print "\n"