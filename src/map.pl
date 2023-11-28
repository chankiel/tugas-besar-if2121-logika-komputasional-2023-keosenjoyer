:- use_module(library(random)).
:- include('data.pl').

/* Rule */
displayMap :-
mapInformation(_, na1, NA1Troops),
mapInformation(_, na2, NA2Troops),
mapInformation(_, na3, NA3Troops),
mapInformation(_, na4, NA4Troops),
mapInformation(_, na5, NA5Troops),
mapInformation(_, e1, EU1Troops),
mapInformation(_, e2, EU2Troops),
mapInformation(_, e3, EU3Troops),
mapInformation(_, e4, EU4Troops),
mapInformation(_, e5, EU5Troops),
mapInformation(_, af1, AF1Troops),
mapInformation(_, af2, AF2Troops),
mapInformation(_, af3, AF3Troops),
mapInformation(_, a1, AS1Troops),
mapInformation(_, a2, AS2Troops),
mapInformation(_, a3, AS3Troops),
mapInformation(_, a4, AS4Troops),
mapInformation(_, a5, AS5Troops),
mapInformation(_, a6, AS6Troops),
mapInformation(_, a7, AS7Troops),
mapInformation(_, au1, AUS1Troops),
mapInformation(_, au1, AUS2Troops),
mapInformation(_, sa1, SA1Troops),
mapInformation(_, sa2, SA2Troops),
write('#################################################################################################\n'),
write('#         North America         #        Europe         #                 Asia                  #\n'),
write('#                               #                       #                                       #\n'),
write('#       [NA1('), write(NA1Troops), write(')]-[NA2('), write(NA2Troops), write(')]       #                       #                                       #\n'),
write('-----------|       |----[NA5('), write(NA5Troops), write(')]----[E1('), write(EU1Troops), write(')]-[E2('), write(EU2Troops), write(')]----------[A1('), write(AS1Troops), write(')] [A2('), write(AS2Troops), write(')] [A3('), write(AS3Troops), write(')]-----------\n'),
write('#       [NA3('), write(NA3Troops), write(')]-[NA4('), write(NA4Troops), write(')]       #       |       |       #        |       |       |              #\n'),
write('#          |                    #    [E3('), write(EU3Troops), write(')]-[E4('), write(EU4Troops), write(')]    ####     |       |       |              #\n'),
write('###########|#####################       |       |-[E5('), write(EU5Troops), write(')]-----[A4('), write(AS4Troops), write(')]----+----[A5('), write(AS5Troops), write(')]           #\n'),
write('#          |                    ########|#######|###########             |                      #\n'),
write('#       [SA1('), write(SA1Troops), write(')]                #       |       |          #             |                      #\n'),
write('#          |                    #       |    [AF2('), write(AF2Troops), write(')]      #          [A6('), write(AS6Troops), write(')]---[A7('), write(AS7Troops), write(')]         #\n'),
write('#   |---[SA2('), write(SA2Troops), write(')]---------------------[AF1('), write(AF1Troops), write(')]---|          #             |                      #\n'),
write('#   |                           #               |          ##############|#######################\n'),
write('#   |                           #            [AF3('), write(AF3Troops), write(')]      #             |                      #\n'),
write('----|                           #                          #          [AU1('), write(AUS1Troops), write(')]---[AU2('), write(AUS2Troops), write(')]-------\n'),
write('#                               #                          #                                    #\n'),
write('#       South America           #         Africa           #          Australia                 #\n'),
write('#################################################################################################\n').

takeLocation(KodeWilayah):- 
    \+ wilayah(KodeWilayah),
    write('Tidak ada wilayah tersebut'),!.
takeLocation(KodeWilayah):- 
    retract(mapInformation(Pemilik,KodeWilayah,N)),
    !,
    assertz(mapInformation(Pemilik,KodeWilayah,N)),
    write('Wilayah sudah dikuasai. Tidak bisa mengambil.'),nl,
    retract(currentPlayer(Player)),
    write('Giliran '),
    write(Player),
    write(' untuk memilih wilayahnya.'),
    assertz(currentPlayer(Player)).
takeLocation(KodeWilayah):- 
    retract(currentPlayer(Player)), 
    retract(playerInformation(Player,Aktif,Tambahan,BanyakWilayah)),
    NewAktif is Aktif + 1,
    NewTambahan is Tambahan - 1,
    NewBanyakWilayah is BanyakWilayah + 1,
    assertz(mapInformation(Player,KodeWilayah,1)), 
    assertz(playerInformation(Player,NewAktif,NewTambahan,NewBanyakWilayah)),
    write(Player),
    write(' mengambil wilayah '),
    write(KodeWilayah),
    write('.'),nl,
    retract(urutanPemain(ListPlayer)),
    rotate_list(ListPlayer, NextListPlayer),
    assertz(urutanPemain(NextListPlayer)), 
    NextListPlayer = [NewCurrentPlayer| _],
    assertz(currentPlayer(NewCurrentPlayer)), 
    write('Giliran '),
    write(NewCurrentPlayer),
    write(' untuk memilih wilayahnya.'),nl,
    findall(Place, mapInformation(Place,_,_), ListWilayah),
    listLength(ListWilayah, N),
    N == 24,
    write('Seluruh wilayah telah diambil pemain. Memulai pembagian sisa tentara.').

cheatAkuisisiWilayah(Player,KodeWilayah):-
    \+ playerInformation(Player,_,_,_),
    write('Tidak ada player tersebut'),!.
cheatAkuisisiWilayah(Player,KodeWilayah):-
    \+ wilayah(KodeWilayah),
    write('Tidak ada wilayah tersebut'),!.
cheatAkuisisiWilayah(KodeWilayah):-
    currentPlayer(Player),
    mapInformation(Pemilik,KodeWilayah,N),
    Pemilik == Player,
    write('Wilayah tersebut milik anda.'),!.
cheatAkuisisiWilayah(KodeWilayah):-
    currentPlayer(Player),
    retract(mapInformation(Pemilik,KodeWilayah,N)),
    retract(playerInformation(Player,AktifPlayer,TambahanPlayer, BanyakWilayahPlayer)),
    retract(playerInformation(Pemilik,AktifPemilik,TambahanPemilik, BanyakWilayahPemilik)),
    NewAktifPemilik is AktifPemilik - N,
    NewAktifPlayer is AktifPlayer + N,
    NewBanyakWilayahPlayer is BanyakWilayahPlayer + 1,
    NewBanyakWilayahPemilik is BanyakWilayahPemilik -1,
    assertz(mapInformation(Player,KodeWilayah,N)),
    assertz(playerInformation(Player,NewAktifPlayer,TambahanPlayer,NewBanyakWilayahPlayer)),
    assertz(playerInformation(Pemilik,NewAktifPemilik,TambahanPemilik,NewBanyakWilayahPemilik)),
    write('Wilayah '),
    write(KodeWilayah),
    write(' diakuisisi oleh '),
    write(Player).