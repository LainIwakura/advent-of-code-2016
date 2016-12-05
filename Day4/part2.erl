-module(part2).
-export([main/0]).

%% This will decode everything in the file, just
%% redirect output to a file then search for 'north' to
%% find the answer
main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    PLines = parse_lines([], Lines),
    Decoded = lists:map(fun(X) -> {Enc,Key,_} = X, {lists:map(fun(Y) -> rot(Y, key(Key)) end, Enc), Key} end, PLines),
    io:format("~p~n", [Decoded]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

parse_lines(Parsed, []) ->
    Parsed;
parse_lines(Parsed, [H|T]) ->
    {match, [[EncName, Sector, ChkSum]]} = re:run(H, "([^\\d]+)-([\\d]+)\\[(\\w+)\\]", [global,{capture,all_but_first,list}]),
    parse_lines([{re:replace(EncName, "-", " ", [global,{return,list}]), list_to_integer(Sector), ChkSum}|Parsed], T).

% From Rosetta Code
%% rot: rotate Char by Key places
rot(Char,Key) when (Char >= $a) and (Char =< $z) ->
    Offset = $A + Char band 32,
    N = Char - Offset,
    Offset + (N + Key) rem 26;
rot(Char, _Key) ->
    Char.

% From Rosetta Code
%% key: normalize key.
key(Key) when Key < 0 ->
    26 + Key rem 26;
key(Key) when Key > 25 ->
    Key rem 26;
key(Key) ->
    Key.
