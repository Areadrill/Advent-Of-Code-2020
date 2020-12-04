-module(part1).

-export([main/0]).

main() -> 
    [FirstLine|Lines] = getInputLines(),
    Length = string:len(bitstring_to_list(FirstLine)),

    countTrees(Lines, Length, 1, 0).

getInputLines() ->
    {ok, Input} = file:read_file("input.txt"),
    string:split(Input, "\n", all).

countTrees([Line|Lines], Length, Idx, Accum) ->
    NthIndex = (3*Idx rem Length) + 1,
    Character = lists:nth(NthIndex, string:split(string:join([[X]|| X <- bitstring_to_list(Line)], ","), ",", all)),

    Tree = case Character of
        "." -> 0;
        "#" -> 1
    end,

    case length(Lines) of
        0 -> Accum + Tree;
        _ -> countTrees(Lines, Length, Idx + 1, Accum + Tree)
    end.