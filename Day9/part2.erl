-module(part2).
-export([main/0]).

%% This actually ran too slowly so I wrote a C++
%% solution that was fast enough.
%%
%% This code theoretically works though if you're patient enough - 
%% it worked on test input.
main() ->
    Str = io:get_line("") -- "\n",
    Res = decompress(Str, 0),
    io:format("~p~n", [Res]).

decompress([], Len) ->
    Len;
decompress([H|Rest], Len) when H =:= $( ->
    [C, R] = re:split(Rest, "[)]", [{return,list},{parts,2}]),
    [Num, Times] = lists:map(fun(X) -> list_to_integer(X) end, re:split(C, "[x]", [{return,list}])),
    {Compressed, Tail} = lists:split(Num, R),
    decompress(lists:flatten(lists:duplicate(Times, Compressed) ++ Tail), Len);
decompress([_|T], Len) ->
    decompress(T, Len+1).
