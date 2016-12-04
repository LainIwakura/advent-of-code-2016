-module(part2).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Triangles = lists:map(fun(X) -> 
        list_to_tuple(lists:map(fun(Y) -> 
            list_to_integer(Y) 
        end, tl(re:split(X, ["\s+"], [{return,list}])))) % need tl to avoid empty list at the beginning
    end, Lines),
    {L1, L2, L3} = lists:unzip3(Triangles),
    Tri1 = lists:map(fun(X) -> list_to_tuple(X) end, [lists:sublist(L1, X, 3) || X <- lists:seq(1, length(L1),3)]),
    Tri2 = lists:map(fun(X) -> list_to_tuple(X) end, [lists:sublist(L2, X, 3) || X <- lists:seq(1, length(L2),3)]),
    Tri3 = lists:map(fun(X) -> list_to_tuple(X) end, [lists:sublist(L3, X, 3) || X <- lists:seq(1, length(L3),3)]),
    P1 = possible_triangles(Tri1),
    P2 = possible_triangles(Tri2),
    P3 = possible_triangles(Tri3),
    io:format("~p~n", [P1+P2+P3]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

possible_triangles(L) ->
    lists:foldl(fun(Y, Sum) -> 
        case Y of 
            true -> Sum+1; 
            _ -> Sum 
        end 
    end, 0, lists:map(fun(S) -> 
        {X,Y,Z} = S, 
        (X+Y > Z) and (Y+Z > X) and (Z+X > Y) 
    end, L)).
