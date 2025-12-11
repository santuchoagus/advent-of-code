process_file(Result) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    maplist(string_chars, Lines, Atomic_Lines),
    total_number_of_accessible(Atomic_Lines, Result).

mth0(M, I, J, E) :- nth0(I, M, Col), nth0(J, Col, E).

total_number_of_accessible(M, T) :-
    number_of_accessible(M, MR, C),
    number_of_accessible(MR, MR2, C2),
    total_number_of_accessible_h(MR2, C, C2, T).

total_number_of_accessible_h(_, C, C, C).
total_number_of_accessible_h(M, C, C2, T) :-
    C \= C2,
    total_number_of_accessible(M, T).

number_of_accessible(M, MResult, C) :-
    length(M, N_Rows),
    nth0(0, M, Any_Row),
    length(Any_Row, N_Cols),
    Max_J is N_Cols - 1,
    Max_I is N_Rows - 1,

    length(MResult, N_Rows),
    maplist(same_length(Any_Row), MResult),

    findall((I, J), (between(0, Max_I, I), between(0, Max_J, J)), Bag_Pairs),
    maplist(slot(M), Bag_Pairs, MR),
    include(=('x'), MR, FMR),
    length(FMR, C),
    matrix_cols(N_Cols, MR, MResult).

matrix_cols(C, M, Matrix) :-
    maplist(length_swap(C), Matrix),
    append(Matrix, M).

length_swap(L, C) :-
    length(C, L).

slot(M, (I, J), 'x') :- accesible(M, I, J).
slot(M, (I, J), E) :- mth0(M, I, J, E).

accesible(M, I, J) :-
    mth0(M, I, J, '@'),
    Imin is I - 1, Imax is I + 1,
    Jmin is J - 1, Jmax is J + 1,
    findall(
        1, 
        (between(Imin, Imax, Ik), between(Jmin, Jmax, Jk), mth0(M, Ik, Jk, '@')), 
        Encounters
        ),
    sum_list(Encounters, C),
    C < 4 + 1. 
    % el 1 sale de que mnth0(...) va a matchear el mismo y hay que sacarlo.