import System.IO  
import Control.Monad
import Data.List

main = do  
        let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let singlewords = words contents
            list = (sort (toInt singlewords))  
        print (findNumberOfArrangements (1 : ((listDifferences list) ++ [3])) 0 1)
        hClose handle

toInt :: [String] -> [Int]
toInt = map read

joltageDifferences :: [Int] -> Int -> Int
joltageDifferences adapters idx = adapters!!idx - adapters!!(idx-1)  

listDifferences :: [Int] -> [Int]
listDifferences adapters = map (joltageDifferences adapters) [1..((length adapters) - 1)]

validChoices :: Int -> Int
validChoices 0 = 1
validChoices 1 = 1
validChoices 2 = 2
validChoices 3 = 4
validChoices 4 = 7
validChoices 5 = 13
validChoices n = (validChoices (n-1)) + (validChoices (n-2)) + (validChoices (n-3))

findNumberOfArrangements :: [Int] -> Int -> Int -> Int
findNumberOfArrangements differences singleDiffAccum accum
    | (length differences) == 0 = accum
    | (head differences) == 3 = findNumberOfArrangements (tail differences) 0 (accum*(validChoices singleDiffAccum))
    | (head differences) == 1 = findNumberOfArrangements (tail differences) (singleDiffAccum+1) accum
    | otherwise = 0