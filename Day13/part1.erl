-module(part1).
-export([main/0]).

-define(INP, 1352).

main() ->
    Grid = init_grid(0, 40),
    io:format("~p~n", [length(digraph:get_short_path(Grid, {1,1}, {31,39})) - 1]).

open(X,Y) when X >= 0, Y >= 0 ->
    even(popcount(X*X + 3*X + 2*X*Y + Y + Y*Y + ?INP));
open(X,Y) when X < 0; Y < 0 ->
    false.

popcount(N) -> popcount(N, 0).
popcount(0, Acc) -> Acc;
popcount(N, Acc) -> 
    popcount(N div 2, Acc + N rem 2).

even(N) when N rem 2 =:= 0 -> true;
even(_) -> false.

init_grid(A, B) ->
    Coords = [{X,Y} || X <- lists:seq(A, B), Y <- lists:seq(A, B)],
    G = digraph:new(),
    lists:map(fun(X) -> digraph:add_vertex(G, X) end, Coords),
    add_edges(G, Coords).

add_edges(G, []) ->
    G;
add_edges(G, [H|T]) ->
    {X, Y} = H,
    ValidEdges = lists:filter(fun(R) -> {X1,Y1} = R, open(X1,Y1) end, [{X+1,Y},{X-1,Y},{X,Y+1},{X,Y-1}]),
    lists:map(fun(S) -> 
        digraph:add_edge(G, {X,Y}, S)
    end, ValidEdges),
    add_edges(G, T).
