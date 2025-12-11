process_file(Fresh_Ingredients, Count) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    include(has_char('-'), Lines, Ranges_Strings),
    exclude(has_char('-'), Lines, Ingredients_Strings),
    maplist(string_number, Ingredients_Strings, Ingredients_Numbers),
    maplist(range, Ranges_Strings, Ranges),
    findall(I, (member(I, Ingredients_Numbers), any(in_range(I), Ranges)), Fresh_Ingredients),
    length(Fresh_Ingredients, Count).

string_number(String, Number) :- number_string(Number, String).

in_any_range(N, Ranges) :-
    any(in_range(N), Ranges).

has_char(Sub, String) :-
    sub_string(String, _, 1, _, Sub).

% Pasa de "A-B" a incl_range(A, B)
range(String, incl_range(A, B)) :-
    split_string(String, "-", "", [Lower, Upper]),
    number_string(A, Lower),
    number_string(B, Upper).

in_range(N, incl_range(A, B)) :- between(A, B, N).

any(Pred, List) :-
    once((member(E, List), call(Pred, E))).