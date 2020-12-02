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

(def result 
  (first 
    (keep-indexed 
      (fn [idx num]
        (hasCorresponding 
          num
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
)

(println (* result (corresponding result)))