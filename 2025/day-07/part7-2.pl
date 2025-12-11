process_file(Result) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", String_Lines),
    maplist(string_chars, String_Lines, [First_Line | Lines]),
    maplist([X, Y]>>(X = 'S' -> Y=1 ; Y=0), First_Line, Start_Beams),
    solve(Lines, Start_Beams, Solution),
    sum_list(Solution, Result).

solve([], Beams, Beams).
solve([Line | Lines], Beams, Solution) :- 
    length(Beams, Size),
    findall(I, nth1(I, Line, '^'), Splitters),
    length(StartList, Size),
    maplist(=(0), StartList),
    maplist(
        [J, L]>>(nth1(J, Beams, N), splits_at(J, N, Size, L)),
        Splitters,
        Splitters_Map
        ),
    maplist([X, Y]>>(X = '^' -> Y=0 ; Y=1), Line, Non_Splitters),
    maplist([X, Y, Z]>>(Z is X * Y), Beams, Non_Splitters, Non_Splitted_Beams),
    foldl(  
        [L, Acc, Res]>>
        maplist([X, Y, Z]>>(Z is X + Y), L, Acc, Res),
        Splitters_Map, StartList, Combined_Splitted_Beams
        ),
    maplist([X, Y, Z]>>(Z is X + Y), Combined_Splitted_Beams, Non_Splitted_Beams, Next_Beams),
    solve(Lines, Next_Beams, Solution).

splits_at(I, N, Size, L) :-
    findall(K, (between(1, Size, J), ((J is I - 1; J is I + 1) -> K=N ; K=0)), L).
