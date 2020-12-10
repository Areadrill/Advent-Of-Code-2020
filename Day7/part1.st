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

    getConnectedNodes: val [
        | directlyConnectedBags accumulatorSet|
        ((connections keys) includes: val)
            ifTrue: [
                directlyConnectedBags := (connections at: val).
                accumulatorSet := Set new.
                accumulatorSet addAll: directlyConnectedBags.

                directlyConnectedBags do: [ :value |
                    accumulatorSet addAll: (self getConnectedNodes: value).
                ].
                ^accumulatorSet
            ]
            ifFalse: [
                ^(Set new)
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
            val =~ '\d+ (.+) bags?' ifMatched: [:match |
                key := (match at: 1). 

                (bagRelationships keys includes: key) 
                    ifTrue: [ (bagRelationships at: key) add: containingBag ]
                    ifFalse: [ 
                        bagRelationships at: key put: Set new.
                        (bagRelationships at: key) add: containingBag.
                    ].
            ].
        ].
    ].
].

bagGraph := Graph from: bagRelationships.

(bagGraph getConnectedNodes: 'shiny gold') size printNl.
f close.