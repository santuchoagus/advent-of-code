:- use_module(library(clpfd)).
:- use_module(library(yall)).

process_file(Result) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    append(Number_Lines, [Operators], Lines),
    split_string(Operators, "*+", "*+", SS),
    maplist(string_length, SS, Splitters_),
    
    % El +1 que le falta al final
    append(Prefix, [Last_Split], Splitters_),
    Inc_Last_Split is Last_Split + 1,
    append(Prefix, [Inc_Last_Split], Splitters),
    % fin del trastorno

    maplist([Line, Split]>>(run_splitter(Line, 0, Splitters, Split)), Number_Lines, Result_Splits),
    transpose(Result_Splits, Result_Splits_Transpose),
    maplist(columnar_to_numbers, Result_Splits_Transpose, Columnars),
    split_string(Operators, " ", " ", Operators_List),
    zip(Operators_List, Columnars, Operations),
    maplist(
        [(Op, Nums), Num]>>((atomics_to_string(Nums, Op, Calc_Str), term_string(Calc, Calc_Str), Num is Calc)), 
        Operations, Result_List),
    sum_list(Result_List, Result).

zip([], [], []).
zip([X|XS], [Y|YS], [(X,Y)|ZS]) :-
    zip(XS, YS, ZS).

columnar_to_numbers(String_Number_List, Columnars) :-
    maplist(string_chars, String_Number_List, Char_Matrix),
    transpose(Char_Matrix, Char_Matrix_T),
    maplist(string_chars, Columnars, Char_Matrix_T).

run_splitter(_, _, [], []).
run_splitter(Line, Starting_Index, [Length | Splitters], [Splitted_Number | Previous_Split]) :-
    sub_string(Line, Starting_Index, Length, _, Splitted_Number),
    Next_Index is Starting_Index + Length + 1,
    run_splitter(Line, Next_Index, Splitters, Previous_Split).

eval_term(Term, Value) :- Value is Term.

split_spaces(String, Splits) :- split_string(String, " ", " ", Splits).

build_term(String, Term) :-
    append(Numbers, [Operator], String),
    maplist(string_codes, Numbers, Codes),
    atomics_to_string(Numbers, Operator, Term_String),
    term_string(Term, Term_String).

length_swap(L, XS) :- length(XS, L). 