open System.IO
open System

let target = int64(675280050)

let input = File.ReadAllText "input.txt"
let parsedInput = input.Split [|'\n'|]
                  |> Array.map (fun x -> x |> int64)
                 
let rec findArray  (head: int) (tail: int) = 
    let sequence = parsedInput.[head..tail] 
    if ((Array.sum sequence).CompareTo(target)) = 0 then
        Console.WriteLine(((Array.max sequence) + (Array.min sequence)))
        0
    else if ((Array.sum sequence).CompareTo(target)) > 0 then
        findArray (head + 1) tail 
    else
        findArray head (tail + 1)

findArray 0 2