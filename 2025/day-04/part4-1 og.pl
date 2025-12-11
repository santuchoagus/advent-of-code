process_file(Result) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    maplist(string_chars, Lines, Atomic_Lines),
    number_of_accessible(Atomic_Lines, Result).

mth0(M, I, J, E) :- nth0(I, M, Col), nth0(J, Col, E).

number_of_accessible(M, C) :-
    length(M, N_Rows),
    nth0(0, M, Any_Row),
    length(Any_Row, N_Cols),
    Max_J is N_Cols - 1,
    Max_I is N_Rows - 1,
    findall(
        1,
        (between(0, Max_I, I), between(0, Max_J, J), accesible(M, I, J)),
        LA
        ),
    sum_list(LA, C).

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