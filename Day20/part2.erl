-module(part2).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Ranges = lists:map(fun(X) -> [L, H] = re:split(X, "[-]", [{return,list}]), {list_to_integer(L), list_to_integer(H)} end, Lines),
    Allowed = count_allowed(Ranges, 0, 0),
    io:format("~p~n", [Allowed]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

count_allowed(_, Ip, C) when Ip >= 4294967295 ->
    C;
count_allowed(R, Ip, C) ->
    case first(R, Ip) of
        {_,H} -> count_allowed(R, H+1, C);
        []    -> count_allowed(R, Ip+1, C+1)
    end.

first(R, Ip) ->
    case lists:dropwhile(fun(X) -> {L,H} = X, not ((Ip >= L) and (Ip =< H)) end, R) of
        [] -> [];
        [X|_] -> X
    end.
