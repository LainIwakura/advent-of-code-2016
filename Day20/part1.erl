-module(part1).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Ranges = lists:map(fun(X) -> [L, H] = re:split(X, "[-]", [{return,list}]), {list_to_integer(L), list_to_integer(H)} end, Lines),
    Lowest = find_lowest_ip(Ranges, 0),
    io:format("~p~n", [Lowest]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

find_lowest_ip(R, Ip) ->
    case lists:all(fun(X) -> {L,H} = X, (Ip < L) or (Ip > H) end, R) of
        true -> Ip;
        false -> find_lowest_ip(R, Ip+1)
    end.
