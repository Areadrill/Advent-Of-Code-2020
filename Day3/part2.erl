-module(part2).

-export([main/0]).

main() -> 
    [FirstLine|Lines] = getInputLines(),
    Length = string:len(bitstring_to_list(FirstLine)),

    Slope1 = countTrees(Lines, Length, 1, 1, 0, 3),
    Slope2 = countTrees(Lines, Length, 1, 1, 0, 1),
    Slope3 = countTrees(Lines, Length, 1, 1, 0, 5),
    Slope4 = countTrees(Lines, Length, 1, 1, 0, 7),
    Slope5 = countTrees(Lines, Length, 1, 1, 0, 1, true),

    Slope1 * Slope2 * Slope3 * Slope4 * Slope5.

getInputLines() ->
    {ok, Input} = file:read_file("input.txt"),
    string:split(Input, "\n", all).

countTrees(Lines, Length, IdxVert, IdxHor, Accum, Right) -> 
    countTrees(Lines, Length, IdxVert, IdxHor, Accum, Right, false).

countTrees([Line|Lines], Length, IdxVert, IdxHor, Accum, Right, Skip) ->
    if 
        Skip == true andalso ((IdxVert rem 2) =/= 0) ->
            case length(Lines) of
                0 -> Accum;
                _ -> countTrees(Lines, Length, IdxVert+1, IdxHor, Accum, Right, Skip)
            end;
        true ->
            NthIndex = ((Right*IdxHor) rem Length) + 1,
            Character = lists:nth(NthIndex, string:split(string:join([[X]|| X <- bitstring_to_list(Line)], ","), ",", all)),

            Tree = case Character of
                "." -> 0;
                "#" -> 1
            end,

            case length(Lines) of
                0 -> Accum + Tree;
                _ -> countTrees(Lines, Length, IdxVert + 1, IdxHor + 1, Accum + Tree, Right, Skip)
            end
    end.