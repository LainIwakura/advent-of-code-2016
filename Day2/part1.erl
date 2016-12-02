-module(part1).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Code = process_lines(5, [], Lines),
    io:format("~p~n", [Code]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

process_lines(_, Code, []) ->
    lists:reverse(Code);
process_lines(N, Code, [H|T]) ->
    Digit = get_code(N, H),
    process_lines(Digit, [Digit|Code], T).

get_code(N, []) ->
    N;
get_code(N, [H|T]) ->
    Next = case H of
                $U -> move_up(N);
                $D -> move_down(N);
                $L -> move_left(N);
                $R -> move_right(N)
           end,
    get_code(Next, T).

move_up(N) when N =< 3 -> N;
move_up(4) -> 1;
move_up(5) -> 2;
move_up(6) -> 3;
move_up(7) -> 4;
move_up(8) -> 5;
move_up(9) -> 6.

move_down(N) when N >= 7 -> N;
move_down(1) -> 4;
move_down(2) -> 5;
move_down(3) -> 6;
move_down(4) -> 7;
move_down(5) -> 8;
move_down(6) -> 9.

move_left(N) when N =:= 1; N =:= 4; N =:= 7 -> N;
move_left(2) -> 1;
move_left(5) -> 4;
move_left(8) -> 7;
move_left(3) -> 2;
move_left(6) -> 5;
move_left(9) -> 8.

move_right(N) when N =:= 3; N =:= 6; N =:= 9 -> N;
move_right(2) -> 3;
move_right(5) -> 6;
move_right(8) -> 9;
move_right(1) -> 2;
move_right(4) -> 5;
move_right(7) -> 8.
