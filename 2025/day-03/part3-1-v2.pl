process_file(Result) :-
    open('input.txt', read, Stream),
    read_line_to_string(Stream, Line),
    process_lines(Stream, Line, Joltages),
    sum_list(Joltages, Result),
    close(Stream).

process_lines(_, end_of_file, []).

process_lines(Stream, Line, Biggest_Joltages) :-
    string_chars(Line, Digits_Char),
    maplist(atom_number, Digits_Char, Digits),
    biggest_joltage(Digits, Pair),
    read_line_to_string(Stream, Next_Line),
    process_lines(Stream, Next_Line, Next_Result),
    append([Pair], Next_Result, Biggest_Joltages).
    

biggest_joltage(XS, P) :-
    append(XWLE, [_], XS),
    max_list(XWLE, X),
    nth1(I, XS, X, _),
    length(Pre, I),
    append(Pre, Rest, XS),
    max_list(Rest, Y),
    P is X * 10 + Y.