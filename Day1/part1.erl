-module(part1).
-import(string, [sub_string/2, sub_string/3]).
-export([main/0]).

main() ->
    In = io:get_line("") -- "\n",
    %% Split the input then transform to a list of tuples
    %% First element is the direction (L or R), second is the number of steps
    Dir = lists:map(fun(X) -> 
               {sub_string(X, 1, 1), list_to_integer(sub_string(X, 2))} 
          end, re:split(In, ", ", [{return,list}])),
    Res = process_dir({0, 0}, 0, Dir),
    io:format("~p~n", [Res]).

process_dir({X, Y}, _, []) ->
    abs(X) + abs(Y);
process_dir({X, Y}, Dir, [H|T]) ->
    {Turn, Steps} = H,
    NewDir = case Turn of
                "L" -> (Dir + 3) rem 4;
                "R" -> (Dir + 1) rem 4
             end,
    case NewDir of
        0 -> process_dir({X, Y+Steps}, NewDir, T);
        1 -> process_dir({X+Steps, Y}, NewDir, T);
        2 -> process_dir({X, Y-Steps}, NewDir, T);
        3 -> process_dir({X-Steps, Y}, NewDir, T)
    end.
