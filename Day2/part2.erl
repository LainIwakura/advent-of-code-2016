-module(part2).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    Code = process_lines($5, [], Lines),
    io:format("~s~n", [Code]).

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

move_up(N) when N =:= $1; N =:= $2; N =:= $4; N =:= $5; N =:= $9 -> N;
move_up($3) -> $1;
move_up($6) -> $2;
move_up($7) -> $3;
move_up($8) -> $4;
move_up($A) -> $6;
move_up($B) -> $7;
move_up($C) -> $8;
move_up($D) -> $B.

move_down(N) when N =:= $D; N =:= $A; N =:= $C; N =:= $5; N =:= $9 -> N;
move_down($1) -> $3;
move_down($2) -> $6;
move_down($3) -> $7;
move_down($4) -> $8;
move_down($6) -> $A;
move_down($7) -> $B;
move_down($8) -> $C;
move_down($B) -> $D.

move_left(N) when N =:= $5; N =:= $2; N =:= $A; N =:= $1; N =:= $D -> N;
move_left($6) -> $5;
move_left($3) -> $2;
move_left($7) -> $6;
move_left($B) -> $A;
move_left($4) -> $3;
move_left($8) -> $7;
move_left($9) -> $8;
move_left($C) -> $B.

move_right(N) when N =:= $9; N =:= $4; N =:= $C; N =:= $1; N =:= $D -> N;
move_right($2) -> $3;
move_right($3) -> $4;
move_right($5) -> $6;
move_right($6) -> $7;
move_right($7) -> $8;
move_right($8) -> $9;
move_right($A) -> $B;
move_right($B) -> $C.
