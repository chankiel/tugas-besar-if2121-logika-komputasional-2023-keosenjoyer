:- include('data.pl').

initialize :-    
    assertz(mapInformation(null,af1,0)),
    assertz(mapInformation(null,af2,0)),
    assertz(mapInformation(null,af3,0)),
    assertz(mapInformation(null,a1,0)),
    assertz(mapInformation(null,a2,0)),
    assertz(mapInformation(null,a3,0)),
    assertz(mapInformation(null,a4,0)),
    assertz(mapInformation(null,a5,0)),
    assertz(mapInformation(null,a6,0)),
    assertz(mapInformation(null,a7,0)),
    assertz(mapInformation(null,na5,0)),
    assertz(mapInformation(null,na4,0)),
    assertz(mapInformation(null,na3,0)),
    assertz(mapInformation(null,na2,0)),
    assertz(mapInformation(null,na1,0)),
    assertz(mapInformation(null,sa1,0)),
    assertz(mapInformation(null,sa2,0)),
    assertz(mapInformation(null,e1,0)),
    assertz(mapInformation(null,e2,0)),
    assertz(mapInformation(null,e3,0)),
    assertz(mapInformation(null,e4,0)),
    assertz(mapInformation(null,e5,0)),
    assertz(mapInformation(null,au1,0)),
    assertz(mapInformation(null,au2,0)),
    write('Masukkan jumlah pemain: '),
    read(NumPlayers), nl,
    validate_num_players(NumPlayers),
    get_player_names(NumPlayers, Players), nl,
    roll_dice(Players, Results), nl,
    sort_base_on_results(Results, SortedResults),
    get_sorted_players(SortedResults, SortedPlayers),
    listLength(SortedPlayers, N),
    X is 48 div N,
    write('Urutan Pemain: '),
    announce_order(SortedPlayers, X),
    SortedPlayers = [TopPlayer|_],
    assertz(currentPlayer(TopPlayer)),
    write(TopPlayer),  % Display the top player
    write(' dapat memulai terlebih dahulu.'), nl,
    write('Setiap pemain mendapatkan '),write(X),
    write(' tentara.'), nl,
    assertz(countAction(0,0)),
    assertz(urutanPemain(SortedPlayers)).

gameInPlay :- 
    retract(urutanPemain(ListPlayer)),
    ListPlayer = [CurrentPlayer | _],
    write('Giliran '), write(CurrentPlayer),
    write(' untuk memilih wilayahnya.'),
    rotate_list(ListPlayer, RotatedPlayers),
    assertz(urutanPemain(RotatedPlayers)),
    write(RotatedPlayers).

validate_num_players(Num) :-
    Num >= 2, Num =< 4, !.
validate_num_players(_) :-
    write('Mohon masukkan angka antara 2 - 4.\n'),
    startGame.

get_player_names(0, []) :- !.
get_player_names(Num, [Name|Rest]) :-
    NewNum is Num - 1,
    get_player_names(NewNum, Rest),
    write('Masukkan nama pemain '),
    write(Num),
    write(': '),
    read(Name),
    assertz(labelpemain(Name, Num)).

get_sorted_players([], []).
get_sorted_players([[_, Player]|Rest], [Player|SortedRest]) :-
    get_sorted_players(Rest, SortedRest).
    
roll_dice([], []).
roll_dice([P|NextPlayer], [[Score, P]|Rs]) :-
    random(1, 12, Score),
    write(P),
    write(' melempar dadu dan mendapatkan '),
    write(Score),
    write('.\n'),
    roll_dice(NextPlayer, Rs).

sort_base_on_results([], []).

sort_base_on_results([Head|Tail], Sorted) :-
    sort_base_on_results(Tail, SortedTail),
    insert_in_order(Head, SortedTail, Sorted).

insert_in_order(X, [], [X]).
insert_in_order([ScoreX, PlayerX], [[ScoreY, PlayerY]|Rest], [[ScoreX, PlayerX],[ScoreY, PlayerY]|Rest]) :-
    ScoreX >= ScoreY.
insert_in_order([ScoreX, PlayerX], [[ScoreY, PlayerY]|Rest], [[ScoreY, PlayerY]|SortedRest]) :-
    ScoreX < ScoreY,
    insert_in_order([ScoreX, PlayerX], Rest, SortedRest).

announce_order([], X) :- nl.
announce_order([Player | Rest], X) :- 
    write(Player),
    assertz(playerInformation(Player,0,X,0)),
    (   Rest \= [] -> write(' - '); true ),
    announce_order(Rest, X).

rotate_list([Head|Tail], RotatedList) :-
    append(Tail, [Head], RotatedList).