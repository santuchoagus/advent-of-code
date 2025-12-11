:- use_module(library(dif)).
:- dynamic node/3.

process_file(Islands) :-
    open('input.txt', read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    split_string(String, "\n", "\n", Lines),
    maplist(csv_to_node, Lines),
    findall(node(X,Y,Z), node(X,Y,Z), Nodes),
    find_islands(Nodes, Islands).

find_islands([], []). 
find_islands([Node|Nodes], [Island | Next_Islands]) :-
    findall(N, connected(Node, N), Island),
    subtract(Nodes, Island, Unreachable_Nodes),
    find_islands(Unreachable_Nodes, Next_Islands).


% a,b,c -> node(a,b,c)
csv_to_node(String) :-
    split_string(String, "," , ",", [X_Str, Y_Str, Z_Str]),
    number_string(X, X_Str),
    number_string(Y, Y_Str),
    number_string(Z, Z_Str),
    assertz(node(X, Y, Z)).


:- dynamic edge/2.
edges(XS) :- 
    findall(edge(N1, N2), edge(N1, N2), XS).

connected(N, N).
connected(N1, N2) :-
    connected_h(N1, N1, N2).

connected_h(_, N1, N2) :- 
    edge(N1, N2).
connected_h(From, N1, N2) :-
    edge(N1, C),
    C \= From,
    connected_h(N1, C, N2).


min_d(Node_List, Node, (D - (Node, Min_D_Node))) :-
    member(Min_D_Node, Node_List),
    distance(Node, Min_D_Node, D),
    D =\= 0, % no puede ser él mismo.
    not((member(Other_Node, Node_List), distance(Node, Other_Node, D2), D2 =\= 0, D2 < D)).


min_d_disconnected(Node_List, Node, (D - (Node, Min_D_Node))) :-
    member(Min_D_Node, Node_List),
    not(connected(Node, Min_D_Node)),
    distance(Node, Min_D_Node, D),
    D =\= 0, % no puede ser él mismo.
    not((member(Other_Node, Node_List), not(connected(Node, Other_Node)), distance(Node, Other_Node, D2), D2 =\= 0, D2 < D)).


distance(node(X1, Y1, Z1), node(X2, Y2, Z2), D) :-
    DX is X1 - X2,
    DY is Y1 - Y2,
    DZ is Z1 - Z2,
    D is sqrt(DX*DX + DY*DY + DZ*DZ).


% main :-
%     findall(node(X,Y,Z), node(X,Y,Z), Nodes),
%     maplist(min_d(Nodes), Nodes, Nodes_Min_Distance_Tuples),
%     keysort(Nodes_Min_Distance_Tuples, Sorted_Nodes_Min_Distance_Tuples),
%     length(Shortests_Connections, 10),
%     append(Shortests_Connections, _, Sorted_Nodes_Min_Distance_Tuples),
%     forall(member(_ - (N1, N2), Shortests_Connections), connect_edge_only(N1, N2)).


connect_edge_only(N1, N2) :-
    not(connected(N1, N2)),
    assert(edge(N1, N2)).
connect_edge_only(_, _).


connect_shortest(0).
connect_shortest(K) :- K > 0,
    findall(node(X,Y,Z), node(X,Y,Z), Nodes),
    findall(N, (member(Node, Nodes), min_d_disconnected(Nodes, Node, N)), Nodes_Min_Distance_Tuples),
    keysort(Nodes_Min_Distance_Tuples, [Disconnected_Shortest | _]),
    Disconnected_Shortest = (D - (N1, N2)),
    format("Connecting ~w and ~w with distance ~w ~n", [N1, N2, D]),
    assert(edge(N1, N2)), % <-- connect
    assert(edge(N2, N1)), % <-- connect
    K2 is K - 1,
    connect_shortest(K2).
