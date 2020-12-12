open System.IO
open System

let corresponding(target: int64, number: int64) = 
    target - number

let input = File.ReadAllText "input.txt"
let parsedInput = input.Split [|'\n'|]
                  |> Array.map (fun x -> x |> int64)
                 
Array.mapi (fun idx (x: int64) -> 
    if idx < 25 then -1
    else
    let poolLowerBound = idx - 25
    let pool = parsedInput.[poolLowerBound..idx]
    
    if Array.length (Array.filter (fun (y: int64) -> Array.exists (fun (z: int64) -> (z.CompareTo(corresponding(int64(x), int64(y)))) = 0) pool ) (pool)) = 0 then
        Console.WriteLine(x)
        1
    else 0
) parsedInput
