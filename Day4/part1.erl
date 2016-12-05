-module(part1).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    PLines = lists:map(fun(X) -> 
        {FList,Sector,ChkSum} = X, 
        {lists:concat(lists:map(fun(Y) -> {L, _} = Y, L end, lists:sublist(FList, 1, 5))), Sector, ChkSum} 
    end, parse_lines([], Lines)),
    io:format("~p~n", [get_score(PLines)]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

parse_lines(Parsed, []) ->
    Parsed;
parse_lines(Parsed, [H|T]) ->
    {match, [[EncName, Sector, ChkSum]]} = re:run(H, "([^\\d]+)-([\\d]+)\\[(\\w+)\\]", [global,{capture,all_but_first,list}]),
    parse_lines([{frequency_list(re:replace(EncName, "-", "", [global,{return,list}])), list_to_integer(Sector), ChkSum}|Parsed], T).

% Frequency fold found on stackoverflow
frequency_list(L) ->
    lists:reverse(lists:keysort(2, 
        lists:foldl(fun(X,[{[X],I}|Q]) -> 
            [{[X],I+1}|Q]; (X, Acc) -> [{[X],1}|Acc] 
        end, [], lists:sort(L)))).

get_score(L) ->
    lists:foldl(fun(X, Sum) -> {A, B, C} = X, case A =:= C of true -> Sum + B; false -> Sum end end, 0, L).
