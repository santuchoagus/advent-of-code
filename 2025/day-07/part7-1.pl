process_file(Result) :-
    open('input.txt', read, Stream),
    read_line_to_string(Stream, Line),
    string_chars(Line, Line_Chars),
    findall(I, nth1(I, Line_Chars, 'S'), Beams),
    read_line_to_string(Stream, Next_Line),
    solve(Stream, Next_Line, Beams, Result),
    close(Stream).

solve(_, end_of_file, _, 0) :- !.

solve(Stream, Line, Beams, Total_Number_Of_Splits) :-
    map_splits(Beams, Line, Number_Splits, Next_Beams),
    read_line_to_string(Stream, Next_Line),
    solve(Stream, Next_Line, Next_Beams, Next_Number_Of_Splits),
    Total_Number_Of_Splits is Number_Splits + Next_Number_Of_Splits.

map_splits(Beams, Line, Number_Of_Splits, Result_Beams) :-
    string_chars(Line, Line_Chars),
    findall(I, nth1(I, Line_Chars, '^'), Splitters),
    subtract(Beams, Splitters, Beams_That_Didnt_Hit),
    intersection(Beams, Splitters, Beams_That_Hit),
    maplist(split_if_member(Beams), Beams_That_Hit, Splitted_Beams),
    flatten(Splitted_Beams, Flatten_Splitted_Beams),
    append(Flatten_Splitted_Beams, Beams_That_Didnt_Hit, Result_Beams_Repeated),
    length(Beams_That_Hit, Number_Of_Splits),
    sort(Result_Beams_Repeated, Result_Beams).

split_if_member(Line, A, [A1, A2]) :- 
    member(A, Line),
    A1 is A - 1, A2 is A + 1.
    
split_if_member(Line, A, A) :-
    not(member(A, Line)).