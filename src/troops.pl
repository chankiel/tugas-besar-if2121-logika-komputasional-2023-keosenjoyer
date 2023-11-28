:- include('data.pl').

checkIncomingTroops(PlayerLabel) :-
    (   (PlayerLabel == 'p1') -> 
        Label is 1
    ;   (PlayerLabel == 'p2') -> 
        Label is 2
    ;   (PlayerLabel == 'p3') -> 
        Label is 3
    ;   (PlayerLabel == 'p4') -> 
        Label is 4
    ),
    labelpemain(NamaPlayer, Label),
    write('Nama : '), write(NamaPlayer), nl,
    findall(Wilayah, mapInformation(NamaPlayer, Wilayah, _), ListWilayah),
    listLength(ListWilayah, BanyakWilayah),
    write('Total wilayah : '), write(BanyakWilayah), nl,
    TentaraTambahan is BanyakWilayah div 2,
    write('Jumlah tentara tambahan dari wilayah : '), write(TentaraTambahan), nl,
    findall(Benua, infoBenua(NamaPlayer, Benua), ListBenuaYangDiconquer),
    (   
        ListBenuaYangDiconquer \== [] ->
        calculate_bonus_troops(ListBenuaYangDiconquer, 0, BonusTroops),
        TotalTentaraTambahan is TentaraTambahan + BonusTroops,
        write('Total tentara tambahan : '), write(TotalTentaraTambahan), nl
    ;   write('Total tentara tambahan : '), write(TentaraTambahan), nl
    ),!.

calculate_bonus_troops([], Acc, Acc).
calculate_bonus_troops([Benua | Tail], Acc, TotalBonus) :-
    bonusTentara(Benua, Bonus),
    write('Bonus benua '), write(Benua), write(' : '), write(Bonus), nl,
    NewAcc is Acc+Bonus,
    calculate_bonus_troops(Tail, NewAcc, TotalBonus).

/*
cheatTambahTentara(Player,N):-
    \+ playerInformation(Player,_,_,_),
    write('Tidak ada player tersebut'),!.
cheatTambahTentara(Player,N):-
    retract(playerInformation(Player,Aktif,Tambahan,BanyakWilayah)),
    NewTambahan is Tambahan + N,
    assertz(playerInformation(Player,Aktif,NewTambahan,BanyakWilayah)),
    write('Berhasil menambahkan '),
    write(N),
    write(' tentara kepada player'),
    write(Player),nl,
    write('JANGAN CURANG WOIIII!!!').
*/
cheatTambahTentara(N):-
    currentPlayer(Player),
    retract(playerInformation(Player,Aktif,Tambahan,BanyakWilayah)),
    NewTambahan is Tambahan + N,
    assertz(playerInformation(Player,Aktif,NewTambahan,BanyakWilayah)),
    write('Berhasil menambahkan '),
    write(N),
    write(' tentara kepada player '),
    write(Player),nl,
    write('JANGAN CURANG WOIIII!!!'),!.