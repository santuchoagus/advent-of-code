process_file(K) :-
    open('input.txt', read, Stream),
    read_line_to_string(Stream, Line),
    process_lines(Stream, Line, 50, K),
    close(Stream).

process_lines(_, end_of_file, 0, 0) :- !.
process_lines(_, end_of_file, _, 0) :- !.

process_lines(Stream, Line, Acum, Count) :-
    parse_line(Line, D, N),
    signed_dir(N, D, NS), % NS es N-signado
    NextAcum is (Acum + NS) mod 100,
    read_line_to_string(Stream, Next),
    format("~s, ~w, ~w, ~w, ~w~n", [Line, NS, Acum, NextAcum, Count]),
    process_lines(Stream, Next, NextAcum, NextCount),
    update_count(NextAcum, NextCount, Count).

update_count(0, NC, C) :- C is NC + 1.
update_count(K, C, C) :- K \= 0.

signed_dir(N, 'R', N).
signed_dir(N, 'L', M) :- M is (-1) * N.

parse_line(Line0, Dir, Num) :-
    normalize_space(string(Line), Line0),
    string_codes(Line, [D|Digits]),
    char_code(Dir, D),
    number_codes(Num, Digits).

print_chars(String) :-
    string_chars(String, Chars),
    writeln(Chars).