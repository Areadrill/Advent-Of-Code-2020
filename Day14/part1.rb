def maskedValue(value, mask)
    binaryValue = value.to_i.to_s(2).rjust(36, '0')
   
    for i in 0..35
        if mask[i] == "X"
            next
        end
        
        binaryValue[i] = mask[i]
     end
    
    return binaryValue.to_i(2)
 end

input = IO.readlines('input.txt', chomp: true)

mask = "X"*36
memoryMap = Hash.new

input.each do |instuction|
    instuctionTokens = instuction.split(" = ")
    
    if instuctionTokens[0] == "mask"
        mask = instuctionTokens[1]
    else 
        instuctionTokens[0].match(/mem\[(\d+)\]/) { |m| memoryMap[m[1]] = maskedValue(instuctionTokens[1], mask) }
    end
end

print memoryMap.values.reduce(:+)