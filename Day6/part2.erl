-module(part2).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Freq = lists:map(fun(X) -> frequency_list(X) end, transpose(Lines)),
    MostFreqWord = lists:append([element(1, hd(Y)) || Y <- Freq]),
    io:format("~p~n", [MostFreqWord]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

transpose([[]|_]) -> [];
transpose(M) ->
    [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].

%% Only change in part 2 is here we don't reverse this list
frequency_list(L) ->
    lists:keysort(2, 
        lists:foldl(fun(X,[{[X],I}|Q]) -> 
            [{[X],I+1}|Q]; (X, Acc) -> [{[X],1}|Acc] 
        end, [], lists:sort(L))).
