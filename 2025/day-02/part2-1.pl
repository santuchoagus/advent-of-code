process_file(Result) :-
    process_stream(user_input, Numbers1),
    include(double_list, Numbers1, Numbers),
    maplist(string_chars, Numbers_String, Numbers),
    maplist(number_string, Numbers_List, Numbers_String),
    sum_list(Numbers_List, Result).

double_list(XS) :- append(A, A, XS).

expand_range(Line1, Line2, Number_Chars) :-
    number_string(N1, Line1),
    number_string(N2, Line2),
    findall(KC, (between(N1, N2, K), number_to_chars(K, KC)), Number_Chars).

number_to_chars(Number, Number_Chars) :-
    number_chars(Number, Number_Chars).

process_stream(Stream, Numbers) :-
    read_line_to_string(Stream, Line1),
    process_stream_h(Stream, Line1, Numbers).

process_stream_h(_, end_of_file, []).

process_stream_h(Stream, Line1, Numbers) :-
    read_line_to_string(Stream, Line2),
    expand_range(Line1, Line2, Expanded),
    process_stream(Stream, Rest),
    append(Expanded, Rest, Numbers).


% substring(N, ST), length(ST, LS), LS > 1,

% apareceen(ST, N, L)
% L = N
% L = N
% .
% .

% maplist(pred, N, L) --> L = [110113, 110113]

% length(L) > 1.