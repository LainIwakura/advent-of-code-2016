-module(part1).
-export([main/0]).

%% Math trick to solve part 1, part 2 is solved by hand
main() ->
    io:format("~p~n", [1 + 2 * (3004953 - ipow(2, trunc(math:log2(3004953))))]).

ipow(X, 1) ->
    X;
ipow(X, Y) ->
    X * ipow(X, Y-1).
