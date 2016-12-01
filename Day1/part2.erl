-module(part2).
-import(string, [sub_string/2, sub_string/3]).
-export([main/0]).

main() ->
    In = io:get_line("") -- "\n",
    %% Split the input then transform to a list of tuples
    %% First element is the direction (L or R), second is the number of steps
    Dir = lists:map(fun(X) -> 
               {sub_string(X, 1, 1), list_to_integer(sub_string(X, 2))} 
          end, re:split(In, ", ", [{return,list}])),
    process_dir({0, 0}, 0, [], Dir).

process_dir({X, Y}, _, _, []) ->
    abs(X) + abs(Y);
process_dir({X, Y}, Dir, Visited, [H|T]) ->
    {Turn, Steps} = H,
    NewDir = case Turn of
                "L" -> (Dir + 3) rem 4;
                "R" -> (Dir + 1) rem 4
             end,
    NewV = process_steps({X,Y}, NewDir, [{X,Y}|Visited], Steps),
    case is_list(NewV) of
        true -> process_dir(hd(NewV), NewDir, NewV, T);
        false -> io:format("~p~n", [NewV])
    end.

process_steps({X,Y}, _, Visited, 0) ->
    [{X,Y}|Visited];
process_steps({X,Y}, Dir, Visited, Steps) ->
    NewXY = case Dir of
                0 -> {X, Y+1};
                1 -> {X+1, Y};
                2 -> {X, Y-1};
                3 -> {X-1, Y}
            end,
    case lists:member(NewXY, Visited) of
        true -> process_dir(NewXY, Dir, [], []);
        false -> process_steps(NewXY, Dir, [NewXY|Visited], Steps-1)
    end.

