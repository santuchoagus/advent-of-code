process_file(Count) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "", Lines),
    include(has_char('-'), Lines, Ranges_Strings),
    maplist(string_range, Ranges_Strings, Ranges),
    unify_ranges(Ranges, Disjoint_Ranges),
    maplist(numbers_between, Disjoint_Ranges, Fresh_Ids),
    sum_list(Fresh_Ids, Count).

string_number(String, Number) :- number_string(Number, String).

unify_ranges([], []).

unify_ranges([R|RS], Disjoint_Ranges) :-
    once(any(range_union(R), RS)),
    maplist(r_absorbing_union(R), RS, PDRanges),
    unify_ranges(PDRanges, Disjoint_Ranges).

unify_ranges([R|RS], [R|Disjoint_Ranges]) :-
    not(any(range_union(R), RS)),
    unify_ranges(RS, Disjoint_Ranges).


any(Pred, List) :-
    once((member(E, List), call(Pred, E))).

has_char(Sub, String) :-
    sub_string(String, _, 1, _, Sub).

% Pasa de "A-B" a incl_range(A, B)
string_range(String, incl_range(A, B)) :-
    split_string(String, "-", "", [Lower, Upper]),
    number_string(A, Lower),
    number_string(B, Upper).

in_range(N, R) :-
    range_union(incl_range(N, N), R).

range_union(R1, R2) :-
    range_union(R1, R2, _).

range_union(incl_range(A1, B1), incl_range(A2, B2), incl_range(A, B)) :-
    once((A1 =< A2, B1 >= A2 ; A1 >= A2, B2 >= A1)), A is min(A1, A2), B is max(B1, B2).

r_absorbing_union(R1, R2, U) :-
    range_union(R1, R2, U), !.
    
r_absorbing_union(_, R2, R2).

numbers_between(incl_range(A, B), N) :- N is B - A + 1.
