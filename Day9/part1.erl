-module(part1).
-export([main/0]).

main() ->
    Str = string:strip(io:get_line("") -- "\n"),
    Res = decompress(Str, []),
    io:format("~p~n", [length(Res)]).

%% Variable names got a bit messy and it could probably be cleaned up
%% but hey it works
decompress([], Res) ->
    lists:flatten(lists:reverse(Res));
decompress([H|T], Res) ->
    case H of
        $( ->
            Pattern = lists:takewhile(fun(X) -> X =/= $) end, T),
            Rem = tl(lists:dropwhile(fun(X) -> X =/= $) end, T)),
            {match, [M]} = re:run(Pattern, "(\\d+)x(\\d+)", [global,{capture,all_but_first,list}]),
            Len = list_to_integer(hd(M)),
            Rep = list_to_integer(lists:last(M)),
            Uncompressed = lists:append(lists:duplicate(Rep, lists:sublist(Rem, Len))),
            {_, Rest} = lists:split(Len, Rem),
            decompress(Rest, [Uncompressed|Res]);
        _ -> decompress(T, [H|Res])
    end.
