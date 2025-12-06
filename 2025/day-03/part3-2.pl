process_file(Result) :-
    open('input.txt', read, Stream),
    read_line_to_string(Stream, Line),
    process_lines(Stream, Line, Joltages),
    sum_list(Joltages, Result),
    close(Stream), !.

process_lines(_, end_of_file, []).

process_lines(Stream, Line, Biggest_Joltages) :-
    string_chars(Line, Digits_Char),
    maplist(atom_number, Digits_Char, Digits),
    biggest_battery_of_size(Digits, 12, Battery),
    read_line_to_string(Stream, Next_Line),
    process_lines(Stream, Next_Line, Next_Result),
    append([Battery], Next_Result, Biggest_Joltages).


biggest_battery_of_size(_, 0, 0).
biggest_battery_of_size(XS, N, Joltage) :-
    length(XS, S),
    Max_Index is S - N + 1,
    slice(XS, 0, Max_Index, XSS),
    max_list(XSS, X),
    nth0(I, XS, X, _), !,
    I2 is I + 1,
    slice(XS, I2, S, YS),
    N2 is N - 1,
    biggest_battery_of_size(YS, N2, J2),
    Joltage is X * (10 ** N2) + J2.



% sacado de stackoverflow no queria pensar
slice(L, From, To, R) :-
    length(Prefix, From),
    Drop is To - From,
    length(R, Drop),
    append(Prefix, Rest, L),
    append(R, _, Rest).
