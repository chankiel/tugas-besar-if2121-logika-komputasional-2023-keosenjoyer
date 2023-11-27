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
    findall(KodeWilayah, mapInformation(PlayerName,KodeWilayah,_), ListKodeWilayah),
    listLength(ListKodeWilayah, Y),
    write(Y),
    write('/'),
    findall(Wilayah, partBenua(Wilayah, NamaBenua), ListOfWilayah),
    listLength(ListOfWilayah,BanyakWilayah),
    write(BanyakWilayah),
    write(')'), nl,
    printListKodeWilayah(ListKodeWilayah),
    detailsOfContinent(Tail).

printListKodeWilayah([]).
printListKodeWilayah([KodeWilayah | Tail]) :-
    write(KodeWilayah), nl,
    % Assume namaWilayah/2 is defined to fetch the name of the territory
    namaWilayah(KodeWilayah, NamaWilayah),
    write('Nama : '), write(NamaWilayah), nl,
    mapInformation(_, KodeWilayah, JumlahTentara),
    write('Jumlah tentara : '), write(JumlahTentara), nl, nl,
    printListKodeWilayah(Tail).

placeTroops(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,N)),
    assertz(mapInformation(Pemilik,Wilayah,N)),
    assertz(currentPlayer(Player)), 
    Pemilik \== Player,
    write('Wilayah tersebut dimiliki pemain lain.'),
    write('Silahkan pilih wilayah lain.'),!.
placeTroops(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,N)),
    assertz(mapInformation(Pemilik,Wilayah,N)),
    assertz(currentPlayer(Player)), 
    Pemilik == Player,
    retract(playerInformation(Player,Aktif,Tambahan,_,_)),
    Num > Tambahan,
    assertz(playerInformation(Player,Aktif,Tambahan,_,_)),
    assertz(mapInformation(Pemilik,Wilayah,N)),
    assertz(currentPlayer(Player)), 
    write('Jumlah tentara tidak cukup.'),!.
placeTroops(Wilayah,Num):-
    Num =< Aktif,
    NewTambahan is Tambahan-Num,
    NewAktif is Aktif+Num,
    Nl is N + Num, 
    assertz(playerInformation(Player,NewAktif,NewTambahan,_,_)),
    assertz(mapInformation(Player,Wilayah,Nl)),
    assertz(currentPlayer(Player)), 
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara di wilayah'),
    write(Wilayah),
    write('.'),
    write('Terdapat '),
    write(NewTambahan),
    write(' tentara yang tersisa.'),!.
draft(Wilayah,_):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,_)),
    Pemilik \== Player,
    write('Player '),
    write(Player),
    write(' tidak memiliki wilayah '),
    write(Wilayah),!.
draft(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,_)),
    Pemilik == Player,
    retract(playerInformation(Player,_,Tambahan,_,_)),
    Num > Tambahan,
    write('Player '),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara tambahan di wilayah'),
    write(Wilayah),
    write('Pasukan tidak mencukupi.'),
    write('Jumlah Pasukan Tambahan Player '),
    write(Player),
    write(': '),
    write(Tambahan),
    write('draft dibatalkan.').
draft(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,_)),
    Pemilik == Player,
    retract(playerInformation(Player,Aktif,_,_,_)),
    Num =< Aktif,
    retract(mapInformation(Player,Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(playerInformation(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(mapInformation(Player,Wilayah,Nl)),
    write('Player '),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara tambahan di wilayah'),
    write(Wilayah),
    write('Tentara total di'),
    write(Wilayah),
    write(': '),
    write(Nl),
    write('Jumlah Pasukan Tambahan Player '),
    write(Player),
    write(': '),
    write(NewTambahan).

getFirstArguments(Second, FirstList) :-
    findall(First, fact(First, Second), FirstList).
randomElement(List, RandomElement) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, RandomElement).
randomFirstArgument(Second, RandomFirst) :-
    getFirstArguments(Second, FirstList),
    randomElement(FirstList, RandomFirst).

placeAutomatic:-
    retract(currentPlayer(Player)),
    retract(playerInformation(Player,_,Tambahan,_,_)),
    Tambahan == 0,
    write('Seluruh tentara '),
    write(Player),
    write(' sudah diletakkan.').
placeAutomatic:-
    retract(currentPlayer(Player)),
    retract(playerInformation(Player,Aktif,Tambahan,_,_)),
    Tambahan \== 0,
    random(1,Tambahan,Num),
    retract(_,Wilayah,_),
    randomFirstArgument(Player,Wilayah),
    retract(mapInformation(Player,Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(playerInformation(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(mapInformation(Player,Wilayah,Nl)),
    placeAutomatic.

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