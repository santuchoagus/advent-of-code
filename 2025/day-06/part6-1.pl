:- use_module(library(clpfd)).

process_file(Result) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    maplist(split_spaces, Lines, Splits),
    transpose(Splits, SplitsT),
    maplist(build_term, SplitsT, Operations),
    maplist(eval_term, Operations, Values),
    sum_list(Values, Result).
    
eval_term(Term, Value) :- Value is Term.

split_spaces(String, Splits) :- split_string(String, " ", " ", Splits).

build_term(String, Term) :-
    append(Numbers, [Operator], String),
    atomics_to_string(Numbers, Operator, Term_String),
    term_string(Term, Term_String).