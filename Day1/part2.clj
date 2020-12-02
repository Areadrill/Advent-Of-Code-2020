(use 'clojure.java.io)
(use 'clojure.string)

(def input 
  (vec (map 
    read-string
    (split 
      (slurp "input.txt") 
      #"\n"
    )
  ))
)

(defn corresponding [num] (- 2020 num))

(defn hasCorresponding
  [num list]  
  (def correspondingNum (corresponding num))

  (if (some #(= correspondingNum %) list) num)
)

(defn explorePermutations
  [num list]
  (keep-indexed 
     (fn [idx it]
        (hasCorresponding 
          (+ num it)
          (vec 
            (drop 
              (+ 1 idx)
              list
            )
          )
        )   
    )
    list
  )  
)

(def result 
  (keep-indexed 
    (fn [idx it]
      (explorePermutations
        it
        (vec
          (drop
            (+ 1 idx)
            input
          )
        )
      )
    )
    input
  )
)

(def filteredResult 
  (first
    (keep-indexed 
      #(if 
        (> (count %2) 0)
        (first %2) 
      )
      result)
  )
)

(def firstNumber 
  (nth 
    input 
    (first
      (keep-indexed 
        #(if 
          (> (count %2) 0)
          %1 
        )
        result)
    )
  )
)

(println (* firstNumber (- filteredResult firstNumber) (corresponding filteredResult)))