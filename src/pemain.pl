:- include('initiating.pl').

/* Fakta dan Relasi */
initDistribusi(X,Y).
initDistribusi(2,24).
initDistribusi(3,26).
initDistribusi(4,12).

/* Dynamic predicate */
:- dynamic(nPemain/1).


/* Nama pemain, Troops Aktif, Troops Tambahan, Wilayah yang dimiliki, Benua yang dimiliki (maksudnya wilayahnya ada di benua mana aja)*/
:- dynamic(playerInformation/5). 
/ Nama pemilik, Kode wilayah, Troops pemilik pada wilayah tersebut*/
:- dynamic(mapInformation/3).
:- dynamic(NameTurn/2).     

/* Rule */
throw2Dice(X).           

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
detailsOfContinent([NamaBenua | Tail], X) :-
    write('Benua '),
    write(NamaBenua),
    write(' ('),
    findall(NamaBenua, partBenua(Kode,NamaBenua), ListKodeWilayah),
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
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik \== Player,
    write('Wilayah tersebut dimiliki pemain lain.'),
    write('Silahkan pilih wilayah lain.').

placeTroops(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Num > Tambahan,
    write('Jumlah tentara tidak cukup.').
placeTroops(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Num <= Aktif,
    retract(JmlhTentara(Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(InfoTentara(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(JmlhTentara(Wilayah,Nl)),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara di wilayah'),
    write(Wilayah),
    write('.'),
    write('Terdapat ')
    write(NewTambahan),
    write(' tentara yang tersisa.').
draft(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik \== Player,
    write('Player '),
    write(Player),
    write(' tidak memiliki wilayah '),
    write(Wilayah).
draft(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Num > Tambahan,
    write('Player '),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara tambahan di wilayah'),
    write(Wilayah),
    write('Pasukan tidak mencukupi.').
    write('Jumlah Pasukan Tambahan Player '),
    write(Player),
    write(': '),
    write(Tambahan)
    write('draft dibatalkan.').
draft(Wilayah,Num):-
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Num <= Aktif,
    retract(JmlhTentara(Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(InfoTentara(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(JmlhTentara(Wilayah,Nl)),
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
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Tambahan == 0,
    write('Seluruh tentara '),
    write(Player),
    write(' sudah diletakkan.').
placeAutomatic:-
    retract(currentPlayer(Player)),
    retract(InfoTentara(Player,Aktif,Tambahan)),
    Tambahan \== 0,
    random(1,Tambahan,Num),
    retract(Wilayah,Pemilik),
    randomFirstArgument(Player,Wilayah),
    retract(JmlhTentara(Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(InfoTentara(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(JmlhTentara(Wilayah,Nl)),
    placeAutomatic.
checkLocationDetail(KodeWilayah):-
    write('Kode                     :'),
    write(KodeWilayah),
    write('Nama                     :'),
    namaWilayah(KodeWilayah,Nama),
    asdkdakdm(KodeWilayah,Nama)
    write(Nama),
    write('Pemilik                  :'),
    retract(WilayahMilik(KodeWilayah,Pemilik)),
    write(Pemilik),
    write('Total Tentara            :'),
    retract(JmlhTentara(KodeWilayah,N)),
    write(N),
    write('Tetangga                 :'),
    tetangga(KodeWilayah,Sebelah),
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
    write('Nama                     :'),
    labelpemain(PlayerName, Label),
    write(PlayerName),
    write('Benua                    :'),
    retract(benuaMilik(Benua,Player)),
    write(Benua),
    write('Total Wilayah            :'),
    retract(playerInformation(PlayerName,Aktif,Tambahan,Total,List))
    write(Total),
    write('Total Tentara Aktif      :'),
    write(Aktif),
    write('Total Tentara Tambahan   :'),
    write(Tambahan).
