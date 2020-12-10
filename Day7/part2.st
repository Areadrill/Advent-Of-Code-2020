Object subclass: Graph [
    |connections|
    Graph class >> from: dict [
        | inst |
        inst := self new.
        dict keysAndValuesDo: [:key :val | (inst connections) at: key put: val].
        ^inst
    ]

    Graph class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        connections := Dictionary new
    ]

    connections [
        ^connections
    ]

    getBagCount: val [
        | directlyConnectedBags accumulator|
        val printNl.
        ((connections keys) includes: val)
            ifTrue: [
                directlyConnectedBags := (connections at: val).
                directlyConnectedBags printNl.
                accumulator := 1.
                
                directlyConnectedBags keysAndValuesDo: [ :key :value |
                    accumulator:= accumulator + ((self getContainedBagCount: key) * value).
                ].

                ^accumulator.
            ]
            ifFalse: [
                ^1
            ].
    ]
]

bagRelationships := Dictionary new.

f := FileStream open: 'input.txt' mode: FileStream read.
f linesDo: [ :c | 
    c =~ '(.*) bags contain (\d+ .+ bag)+' ifMatched: [:match |
        containingBag := (match at: 1).

        containedBagsStrings := (match at: 2) tokenize: ', '.
        containedBagsStrings do: [ :val | 
            val =~ '(\d+) (.+) bags?' ifMatched: [:match |
                containedBagName := (match at: 2). 
                quantity := (match at: 1).

                (bagRelationships keys includes: containingBag) 
                    ifTrue: [ (bagRelationships at: containingBag) at: containedBagName put: (quantity asNumber) ]
                    ifFalse: [ 
                        bagRelationships at: containingBag put: Dictionary new.
                        (bagRelationships at: containingBag) at: containedBagName put: (quantity asNumber).
                    ].
            ].
        ].
    ].
].

bagGraph := Graph from: bagRelationships.

((bagGraph getBagCount: 'shiny gold') - 1) printNl.
f close.