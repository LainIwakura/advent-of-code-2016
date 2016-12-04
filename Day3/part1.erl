-module(part1).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Triangles = lists:map(fun(X) -> 
        list_to_tuple(lists:map(fun(Y) -> 
            list_to_integer(Y) 
        end, tl(re:split(X, ["\s+"], [{return,list}])))) % need tl to avoid empty list at the beginning
    end, Lines),
    PTri = lists:foldl(fun(Y, Sum) -> 
        case Y of 
            true -> Sum+1; 
            _ -> Sum 
        end 
    end, 0, lists:map(fun(S) -> 
        {X,Y,Z} = S, 
        (X+Y > Z) and (Y+Z > X) and (Z+X > Y) 
    end, Triangles)),
    io:format("~p~n", [PTri]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.
