import System.IO  
import Control.Monad
import Data.List

main = do  
        let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let singlewords = words contents
            list = (sort (toInt singlewords))   
        print ((length (filter (\x -> x == 1) (1 : (listDifferences list)))) * (length (filter (\x -> x == 3) (3 : (listDifferences list)))))
        hClose handle

toInt :: [String] -> [Int]
toInt = map read

joltageDifferences :: [Int] -> Int -> Int
joltageDifferences adapters idx = adapters!!idx - adapters!!(idx-1)  

listDifferences :: [Int] -> [Int]
listDifferences adapters = map (joltageDifferences adapters) [1..((length adapters) - 1)]
