-module(part1).
-export([main/0]).

-define(INPUT, ".^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.").
-define(TEST, ".^^.^.^^^^").

main() ->
    % Change to 400000 for part 2
    Map = get_iterations(40, ?INPUT, [?INPUT]),
    SafeTiles = lists:foldl(fun(Y, Sum) -> Sum+Y end, 0, lists:map(fun(X) -> count(X) end, Map)),
    io:format("~p~n", [SafeTiles]).

rule(X, Y) when X =:= Y -> $.;
rule(_, _) -> $^.

get_iterations(1, _, Acc) ->
    lists:reverse(Acc);
get_iterations(N, L, Acc) ->
    Next = next(L),
    get_iterations(N-1, Next, [Next|Acc]). 

gen_tails(L) ->
    lists:filter(fun(X) -> length(X) >= 3 end, tails("." ++ L ++ ".")).

next(L) ->
    lists:map(fun(X) ->
        F = lists:nth(1, X),
        S = lists:nth(3, X),
        rule(F, S)
    end, gen_tails(L)).

tails(X) ->
    tails(X, []).
tails([], Acc) ->
    lists:reverse([[]|Acc]);
tails(X, Acc) ->
    tails(tl(X), [X|Acc]).

count(L) ->
    lists:foldl(fun(X, Sum) -> case X of $. -> Sum+1; _ -> Sum end end, 0, L).
