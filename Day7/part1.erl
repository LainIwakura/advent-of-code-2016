-module(part1).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Matches = lists:map(fun(X) -> case has_inner_match(X) of true -> false; false -> has_match(X) end end, Lines),
    Sum = lists:foldl(fun(X, Acc) -> case X of true -> Acc+1; false -> Acc end end, 0, Matches),
    io:format("~p~n", [Sum]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

has_inner_match(L) ->
    case re:run(L, "\\[(\\w+)\\]", [global,{capture,all_but_first,list}]) of
        {match, [X]} when length(X) =:= 1 -> has_match(hd(X));
        {match, X} -> lists:any(fun(Y) -> has_match(hd(Y)) end, X)
    end.

has_match(L) ->
    case re:run(L, "(.)(?!\\1)(.)\\2\\1", [global,{capture,all_but_first,list}]) of
        nomatch -> false;
        {match, _} -> true
    end.
