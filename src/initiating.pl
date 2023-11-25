:- use_module(library(random)).
:- dynamic(currentplayer/1).

startGame :-
    write('Masukkan jumlah pemain: '),
    read(NumPlayers), nl,
    validate_num_players(NumPlayers),
    get_player_names(NumPlayers, Players), nl,
    roll_dice(Players, Results), nl,
    sort_base_on_results(Results, SortedResults),
    get_sorted_players(SortedResults, SortedPlayers),
    write('Urutan Pemain: '),
    announce_order(SortedPlayers),
    SortedPlayers = [TopPlayer|_],
    assertz(currentplayer(TopPlayer)),
    write('Current player: '),
    write(TopPlayer),  % Display the top player
    rotate_list(SortedPlayers, RotatedPlayers),
    write(' dapat memulai terlebih dahulu.'), nl,
    write('Setiap pemain mendapatkan 16 tentara.'), nl,
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
    read(Name).

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

announce_order([]) :- nl.
announce_order([Player | Rest]) :- 
    write(Player),
    (   Rest \= [] -> write(' - '); true ),
    announce_order(Rest).

rotate_list([Head|Tail], RotatedList) :-
    append(Tail, [Head], RotatedList).

set_top_player([Head|Tail]) :- Head.