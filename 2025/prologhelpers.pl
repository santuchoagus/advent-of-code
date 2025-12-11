:- use_module(library(clpfd)).

pair_that_sum((X, Y), N) :-
    between(0, N, X), Y is N - X.

pair_that_sub((A, B), Max_A, Max_B, N) :-
    between(0, Max_A, A), between(0, Max_B, B), N is A - B.

mth0(M, I, J, E) :- nth0(I, M, Col), nth0(J, Col, E).

anti_diagonals(M, AD) :-
    length(M, N_Rows),
    nth0(0, M, Any_Row),
    length(Any_Row, N_Cols),
    K is (N_Cols - 1) + (N_Rows - 1),
    findall(D, (between(0, K, K2), anti_diagonal_k(K2, M, D)), AD).

anti_diagonal_k(K, M, D) :-
        length(M, N_Rows),
        nth0(0, M, Any_Row),
        length(Any_Row, N_Cols),
        findall((I, J), (pair_that_sum((I, J), K), I < N_Rows, J < N_Cols), DI),
        maplist(pair_to_elem(M), DI, D).
    
pair_to_elem(M, (I, J), E) :- mth0(M, I, J, E).

diagonal_k(K, M, D) :-
    length(M, N_Rows),
    nth0(0, M, Any_Row),
    length(Any_Row, N_Cols),
    Max_Rows is N_Rows - 1,
    Max_Cols is N_Cols - 1,
    findall((I, J), pair_that_sub((J, I), Max_Cols, Max_Rows, K), DI),
    maplist(pair_to_elem(M), DI, D).

replicate(E, N, XS) :-
    length(XS, N),
    maplist(=(E), XS).

count_first_consecutives(E, XS, C) :-

count_first_consecutives_h(_, [], 0).
count_first_consecutives_h(_, [_], 0).

count_first_consecutives(E, [X, Y|T], C) :- 
    E \= X,
    count_first_consecutives(E, [Y|T], C).

count_first_consecutives(E, [E, Y|T], 1) :- E \= Y.