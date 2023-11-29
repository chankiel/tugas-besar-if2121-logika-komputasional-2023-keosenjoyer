:- include('data.pl').
/* Rule */

checkPlayerTerritories(PlayerLabel) :-
    (   (PlayerLabel == 'p1') -> 
        labelpemain(PlayerName, 1)
    ;   (PlayerLabel == 'p2') -> 
        labelpemain(PlayerName, 2)
    ;   (PlayerLabel == 'p3') -> 
        labelpemain(PlayerName, 3)
    ;   (PlayerLabel == 'p4') -> 
        labelpemain(PlayerName, 4)
    ),
    write('Nama :'),
    write(PlayerName), nl,
    findall(KodeWilayah, mapInformation(PlayerName,KodeWilayah,_), ListOfKodeWilayah),
    findPlayerContinents(PlayerName, ListOfKodeWilayah, [], ListOfContinent),
    detailsOfContinent(PlayerName,ListOfContinent), !.

findPlayerContinents(_, [], ListOfContinents, ListOfContinents).

findPlayerContinents(PlayerName, [KodeWilayah|Rest], TempList, ListOfContinents) :-
    findall(Continent, partBenua(KodeWilayah, Continent), ListOfNewContinents),
    mergeUnique(TempList, ListOfNewContinents, UpdatedList),
    findPlayerContinents(PlayerName, Rest, UpdatedList, ListOfContinents).

mergeUnique(List1, List2, Result) :-
    append(List1, List2, CombinedList),
    removeUninstantiated(CombinedList, FilteredList),
    sort(FilteredList, Result).

removeUninstantiated([], []).
removeUninstantiated([H|T], List) :-
    (   var(H) -> 
        removeUninstantiated(T, List)
    ;   removeUninstantiated(T, Tail),
        List = [H|Tail]
    ).

isInList(Item, [Item|_]).
isInList(Item, [_|Tail]) :-
    isInList(Item, Tail).

detailsOfContinent(PlayerName, []).
detailsOfContinent(PlayerName, [NamaBenua | Tail]) :-
    write('Benua '),
    write(NamaBenua),
    write(' ('),
    findall(KodeWilayah, mapInformation(PlayerName,KodeWilayah,_), ListWilayahPunyaPlayer),
    filterWilayahBaseOnBenua(ListWilayahPunyaPlayer, NamaBenua, [], FilteredWilayah),
    listLength(FilteredWilayah,BanyakFiltered),
    findall(Wilayah, partBenua(Wilayah, NamaBenua), ListOfWilayah),
    listLength(ListOfWilayah,BanyakWilayah),
    write(BanyakFiltered),
    write('/'),
    write(BanyakWilayah),
    write(')'), nl,
    printListKodeWilayah(FilteredWilayah),
    detailsOfContinent(PlayerName,Tail).

filterWilayahBaseOnBenua([], _, Temp, Temp).
filterWilayahBaseOnBenua([CurrentWilayah | Tail], NamaBenua, Temp, FilteredWilayah) :-
    (
        partBenua(CurrentWilayah, NamaBenua) ->
        append(Temp, [CurrentWilayah], NewTemp)
    ;
        NewTemp = Temp
    ),
    filterWilayahBaseOnBenua(Tail, NamaBenua, NewTemp, FilteredWilayah).

printListKodeWilayah([]).
printListKodeWilayah([KodeWilayah | Tail]) :-
    write(KodeWilayah), nl,
    namaWilayah(KodeWilayah, NamaWilayah),
    write('Nama : '), write(NamaWilayah), nl,
    mapInformation(_, KodeWilayah, JumlahTentara),
    write('Jumlah tentara : '), write(JumlahTentara), nl, nl,
    printListKodeWilayah(Tail).

nextPlayer(ListPlayer,Player):-
    ListPlayer = [X|_],
    X == Player.
nextPlayer(ListPlayer,Player):-    
    playerInformation(Player,_,Tambahan,_),
    Tambahan \== 0,!.
nextPlayer(ListPlayer,Player):-
    retract(currentPlayer(Player)),
    retract(urutanPemain(ListPlayerNow)),
    rotate_list(ListPlayerNow, NextListPlayer),
    NextListPlayer = [NewCurrentPlayer| _],
    assertz(urutanPemain(NextListPlayer)), 
    assertz(currentPlayer(NewCurrentPlayer)),
    nextPlayer(ListPlayer,NewCurrentPlayer).
placeTroops(Wilayah,Num):-
    currentPlayer(Player), 
    mapInformation(Pemilik,Wilayah,N),
    Pemilik \== Player,
    write('Wilayah tersebut dimiliki pemain lain.'),nl,
    write('Silahkan pilih wilayah lain.'),nl,
    write('Giliran '),
    write(Player),
    write(' untuk meletakkan tentaranya.'),!.
placeTroops(Wilayah,Num):-
    currentPlayer(Player), 
    mapInformation(Pemilik,Wilayah,N),
    Pemilik == Player,
    playerInformation(Player,Aktif,Tambahan,_),
    @>(Num,Tambahan),
    write('Jumlah tentara tidak cukup.'),nl,
    write('Giliran '),
    write(Player),
    write(' untuk meletakkan tentaranya.'),!.
placeTroops(Wilayah,Num):-
    retract(currentPlayer(Player)),
    retract(mapInformation(Pemilik,Wilayah,N)),
    Pemilik == Player,
    retract(playerInformation(Player,Aktif,Tambahan,BanyakWilayah)),
    @=<(Num,Tambahan), 
    NewTambahan is Tambahan-Num,
    NewAktif is Aktif+Num,
    Nl is N + Num, 
    assertz(playerInformation(Player,NewAktif,NewTambahan,BanyakWilayah)),
    assertz(mapInformation(Player,Wilayah,Nl)),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara di wilayah '),
    write(Wilayah),
    write('.'),nl,
    write('Terdapat '),
    write(NewTambahan),
    write(' tentara yang tersisa.'),nl,
    retract(urutanPemain(ListPlayer)),
    rotate_list(ListPlayer, NextListPlayer),
    NextListPlayer = [NewCurrentPlayer| _],
    assertz(urutanPemain(NextListPlayer)), 
    assertz(currentPlayer(NewCurrentPlayer)),
    nextPlayer(ListPlayer,NewCurrentPlayer),
    write('Giliran '),
    currentPlayer(X),
    write(X),
    write(' untuk meletakkan tentaranya.'),!.

getFirstArguments(Pemilik, WilayahList) :-
    findall(Wilayah, mapInformation(Pemilik, Wilayah, N), WilayahList).
randomElement(List, RandomElement) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, RandomElement).
randomFirstArgument(Second, RandomFirst) :-
    getFirstArguments(Second, FirstList),
    randomElement(FirstList, RandomFirst).

placeAutomatic:-
    currentPlayer(Player),
    playerInformation(Player,Aktif,Tambahan,BanyakWilayah),
    Tambahan == 0,
    write('Seluruh tentara '),
    write(Player),
    write(' sudah diletakkan.'),nl,
    retract(currentPlayer(Player)),
    retract(urutanPemain(ListPlayer)),
    rotate_list(ListPlayer, NextListPlayer),
    NextListPlayer = [NewCurrentPlayer| _],
    assertz(urutanPemain(NextListPlayer)), 
    assertz(currentPlayer(NewCurrentPlayer)),
    nextPlayer(ListPlayer,NewCurrentPlayer),
    currentPlayer(X),
    write('Giliran '),
    write(X),
    write(' untuk meletakkan tentaranya.'),nl,!,
    Player == X,
    write('Seluruh pemain telah meletakkan sisa tentara.'),nl,
    write('Memulai permainan.').

placeAutomatic:-
    currentPlayer(Player), 
    retract(playerInformation(Player,Aktif,Tambahan,BanyakWilayah)),
    randomFirstArgument(Player,Wilayah),
    retract(mapInformation(Player,Wilayah,N)),
    TempTambahan is Tambahan + 1,
    random(1,TempTambahan,Num),
    NewTambahan is Tambahan-Num,
    NewAktif is Aktif+Num,
    Nl is N + Num, 
    assertz(playerInformation(Player,NewAktif,NewTambahan,BanyakWilayah)),
    assertz(mapInformation(Player,Wilayah,Nl)),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara di wilayah '),
    write(Wilayah),nl,
    placeAutomatic,!.


checkLocationDetail(KodeWilayah):-
    mapInformation(Player,KodeWilayah,N),
    write('Kode                     :'),
    write(KodeWilayah), nl,
    write('Nama                     :'),
    namaWilayah(KodeWilayah,Nama),
    write(Nama), nl,
    findall(Tetangga, tetangga(KodeWilayah,Tetangga), ListTetangga),
    listLength(ListTetangga,LengthListTetangga),
    write('Pemilik                  :'),
    write(Player), nl,
    write('Total Tentara            :'),
    write(N), nl,
    write('Tetangga                 :'),
    write(LengthListTetangga), nl, !.

checkPlayerDetail(PlayerLabel):-
    (   (PlayerLabel == 'p1') -> 
        labelpemain(PlayerName, 1),
        write('PLAYER P1'), nl
    ;   (PlayerLabel == 'p2') -> 
        labelpemain(PlayerName, 2),
        write('PLAYER P2'), nl
    ;   (PlayerLabel == 'p3') -> 
        labelpemain(PlayerName, 3),
        write('PLAYER P3'), nl
    ;   (PlayerLabel == 'p4') -> 
        labelpemain(PlayerName, 4),
        write('PLAYER P4'), nl
    ),
    retract(playerInformation(PlayerName,TentaraAktif,TentaraTambahan,BanyakWilayah)),
    findall(Benua,infoBenua(PlayerName,Benua),ListOfContinent),
    write('Nama                     :'),
    write(PlayerName), nl,
    write('Benua                    :'),
    listLength(ListOfContinent,LengthListOfContinent),
    (
        LengthListOfContinent == 0 ->
        write('-'), nl
    ;   printListBenua(ListOfContinent), nl
    ),
    write('Total Wilayah            :'),
    write(BanyakWilayah), nl,
    write('Total Tentara Aktif      :'),
    write(TentaraAktif), nl,
    write('Total Tentara Tambahan   :'),
    write(TentaraTambahan), nl,
    assertz(playerInformation(PlayerName,TentaraAktif,TentaraTambahan,BanyakWilayah)), !.
printListBenua([]).
printListBenua([CurrentBenua | Rest]) :- 
    write(CurrentBenua),
    (   Rest \= [] -> write(', '); true ),
    printListBenua(Rest).

initTesting:-
    assertz(currentPlayer(tes)),
    assertz(urutanPemain([kiel,ben,tes])),
    assertz(labelpemain(kiel,1)),
    assertz(labelpemain(ben,2)),
    assertz(labelpemain(tes,3)),
    assertz(countAction(0,0)),
    assertz(playerInformation(tes,0,0,8)),  
    assertz(playerInformation(kiel,0,0,8)),
    assertz(playerInformation(ben,0,0,8)),
    assertz(mapInformation(tes,af1,2)),
    assertz(mapInformation(tes,af2,2)),
    assertz(mapInformation(tes,af3,2)),
    assertz(mapInformation(kiel,a1,2)),
    assertz(mapInformation(kiel,a2,2)),
    assertz(mapInformation(kiel,a3,2)),
    assertz(mapInformation(ben,a4,2)),
    assertz(mapInformation(ben,a5,2)),
    assertz(mapInformation(ben,a6,2)).