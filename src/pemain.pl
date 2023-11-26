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