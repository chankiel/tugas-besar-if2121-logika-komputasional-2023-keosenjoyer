:- use_module(library(random)).
:- include('data.pl').

/* Rule */
displayMap :- write('#################################################################################################\n'),
             write('#         North America         #        Europe         #                 Asia                  #\n'),
             write('#                               #                       #                                       #\n'),
             write('#       [NA1('), write(')]-[NA2('), write(']       #                       #                                       #\n'),
             write('-----------|       |----[NA5('), write(')]----[E1('), write(')]-[E2('), write(')]----------[A1('), write(')] [A2('), write(')] [A3('), write(')]-----------\n'),
             write('#       [NA3('), write(')]-[NA4('), write(')]       #       |       |       #        |       |       |              #\n'),
             write('#          |                    #    [E3('), write(')]-[E4('), write(')]    ####     |       |       |              #\n'),
             write('###########|#####################       |       |-[E5('), write(')]-----[A4('), write(')]----+----[A5('), write(')]           #\n'),
             write('#          |                    ########|#######|###########             |                      #\n'),
             write('#       [SA1('), write(')]               #       |       |          #             |                      #\n'),
             write('#          |                    #       |    [AF2('), write(')]     #          [A6('), write(')]---[A7('), write(')]         #\n'),
             write('#   |---[SA2('), write(')]---------------------[AF1('), write(')]---|          #             |                      #\n'),
             write('#   |                           #               |          ##############|#######################\n'),
             write('#   |                           #            [AF3('), write(')]      #             |                      #\n'),
             write('----|                           #                          #          [AU1('), write(')]---[AU2('), write(')]-------\n'),
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
cheatAkuisisiWilayah(Player,KodeWilayah):-
    mapInformation(Pemilik,KodeWilayah,N),
    Pemilik == Player,
    write('Wilayah tersebut milik anda.'),!.
cheatAkuisisiWilayah(Player,KodeWilayah):-
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