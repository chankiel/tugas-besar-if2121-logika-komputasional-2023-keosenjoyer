:- include('data.pl').
/* Rule */
       

checkPlayerTerritories(PlayerLabel) :-
    (   (PlayerLabel == 'p1') -> 
        Label is 1
    ;   (PlayerLabel == 'p2') -> 
        Label is 2
    ;   (PlayerLabel == 'p3') -> 
        Label is 3
    ;   (PlayerLabel == 'p4') -> 
        Label is 4
    ),

    write('Nama :'),
    labelpemain(PlayerName, Label),
    write(PlayerName), nl,
    playerInformation(PlayerName,_,_,_,ListOfContinent),
    detailsOfContinent(ListOfContinent).

detailsOfContinent([]).
detailsOfContinent([NamaBenua | Tail]) :-
    write('Benua '),
    write(NamaBenua),
    write(' ('),
    findall(NamaBenua, partBenua(_,NamaBenua), ListKodeWilayah),
    listLength(ListKodeWilayah, Y),
    write(Y),
    write('/'),
    findall(Wilayah, partBenua(Wilayah, NamaBenua), ListOfWilayah),
    listLength(ListOfWilayah,BanyakWilayah),
    write(BanyakWilayah),
    write(')'),
    printListKodeWilayah(ListKodeWilayah),
    detailsOfContinent(Tail).

printListKodeWilayah([]).
printListKodeWilayah([KodeWilayah | Tail]) :-
    write(KodeWilayah), nl,
    % Assume namaWilayah/2 is defined to fetch the name of the territory
    namaWilayah(KodeWilayah, NamaWilayah),
    write('Nama : '), write(NamaWilayah), nl,
    mapInformation(_, KodeWilayah, JumlahTentara),
    write('Jumlah tentara : '), write(JumlahTentara), nl,
    printListKodeWilayah(Tail).

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
    NextListPlayer = [NewCurrentPlayer, _],
    assertz(urutanPemain(NextListPlayer)), 
    assertz(currentPlayer(NewCurrentPlayer)),
    write('Giliran '),
    write(NewCurrentPlayer),
    write(' untuk meletakkan tentaranya.'),!.
draft(Wilayah,_):-
    retract(currentPlayer(Player)), 
    retract(mapInformation(Pemilik,Wilayah,_)),
    Pemilik \== Player,
    write('Player '),
    write(Player),
    write(' tidak memiliki wilayah '),
    write(Wilayah).
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
    write('Kode                     :'),
    write(KodeWilayah),
    write('Nama                     :'),
    namaWilayah(KodeWilayah,Nama),
    retract(mapInformation(Player,KodeWilayah,N)),
    tetangga(KodeWilayah,Sebelah),
    write(Nama),
    write('Pemilik                  :'),
    write(Player),
    write('Total Tentara            :'),
    write(N),
    write('Tetangga                 :'),
    write(Sebelah).
checkPlayerDetail(Player):-
    (   (PlayerLabel == 'p1') -> 
        Label is 1
    ;   (PlayerLabel == 'p2') -> 
        Label is 2
    ;   (PlayerLabel == 'p3') -> 
        Label is 3
    ;   (PlayerLabel == 'p4') -> 
        Label is 4
    ),
    labelpemain(PlayerName, Label),
    retract(benuaMilik(Benua,Player)),
    retract(playerInformation(PlayerName,Aktif,Tambahan,Total,_)),
    write('Nama                     :'),
    write(PlayerName),
    write('Benua                    :'),
    write(Benua),
    write('Total Wilayah            :'),
    write(Total),
    write('Total Tentara Aktif      :'),
    write(Aktif),
    write('Total Tentara Tambahan   :'),
    write(Tambahan).
