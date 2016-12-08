-module(part2).
-export([main/0]).

main() ->
    {ok, File} = file:open("input", [read]),
    Lines = read_lines(File),
    IPs = lists:map(fun(X) -> has_ssl(X) end, Lines),
    Sum = lists:foldl(fun(X, Acc) -> case X of true -> Acc+1; false -> Acc end end, 0, IPs),
    io:format("~p~n", [Sum]).

read_lines(File) ->
    case file:read_line(File) of
        {ok, Data} -> [Data -- "\n"|read_lines(File)];
        eof -> []
    end.

%% I feel like this got overly complicated.
%% Basically here we get the ABA sequences then make a unique list of them / invert them.
%% If we have no ABA sequences obviously neither does the hypernet.
%% If we do have some however, we'll run over every hypernet and check if ANY of the hypernets contain
%% ANY of the inverted ABA sequences - if they do that's good enough.
has_ssl(L) ->
    Codes = lists:append(lists:map(fun(X) -> 
        case re:run(X, "(?=((.)(?!\\2).\\2))", [global,{capture,all_but_first,list}]) of
            {match, Y} -> lists:map(fun(Z) -> hd(Z) end, Y);
            nomatch -> []
        end 
    end, re:split(L, "\\[\\w+\\]", [{return,list}]))),
    Unique = sets:to_list(sets:from_list(Codes)),
    Inverted = lists:map(fun(X) -> invert(X) end, Unique),
    case length(Inverted) of
        0 -> false;
        _ -> check_hypernets(L, Inverted)
    end.

invert([A1,A2,_]) ->
    [A2,A1,A2].

check_hypernets(L, Inverted) ->
    {match, Hypernets} = re:run(L, "\\[(\\w+)\\]", [global,{capture,all_but_first,list}]),
    Res = lists:map(fun(X) -> lists:any(fun(Y) -> string:str(hd(Y), X) > 0 end, Hypernets) end, Inverted),
    lists:any(fun(X) -> X =:= true end, Res).
