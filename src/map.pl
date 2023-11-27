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

/*
takeLocation(KodeWilayah):- 
    \+ wilayah(KodeWilayah),
    write('Tidak ada wilayah tersebut'),!.
takeLocation(KodeWilayah):- 
    retract(mapInformation(KodeWilayah,Pemilik,_)),
    !,
    assertz(mapInformation(KodeWilayah,Pemilik,_)),
    write('Wilayah sudah dikuasai. Tidak bisa mengambil.'),nl,
    retract(currentPlayer(Player)),
    write('Giliran '),
    write(Player),
    write(' untuk memilih wilayahnya.'),
    assertz(currentPlayer(Player)).
takeLocation(KodeWilayah):- 
    retract(currentPlayer(Player)), 
    assertz(mapInformation(KodeWilayah,Player,_)), 
    write(Player),
    write(' mengambil wilayah '),
    write(KodeWilayah),
    write('.'),nl,
    retract(urutanPemain(ListPlayer)),
    rotate_list(ListPlayer, NextListPlayer),
    NextListPlayer = [NewCurrentPlayer, _],
    assertz(urutanPemain(NextListPlayer)), 
    assertz(currentPlayer(NewCurrentPlayer)), 
    write('Giliran '),
    write(NewCurrentPlayer),
    write(' untuk memilih wilayahnya.'),nl,
    findall(Place, mapInformation(Place,_,_), ListWilayah),
    listLength(ListWilayah, N),
    N == 24,
    write('Seluruh wilayah telah diambil pemain. Memulai pembagian sisa tentara.').

/*
attack :-
    write('Sekarang giliran Player '),
    currentPlayer(Player),
    write(Player),
    write(' menyerang!\n'),
    displayMap,
    write('\n'),
    loop1(Player, Y),
    loop2(WilayahAttack, Player),
    displayMap,
    write("Pilihlah daerah yang ingin anda serang. \n"),
    loop3(WilayahAttack, Player, DaerahMusuhList),
    loop4(BanyakMusuh, DaerahMusuhList),
    write('Perang telah dimulai!!! \n'),
    write('Player ').
    write(Player),
    write('\n'),
    lempar_dadu_attack(JumlahT, MyPoints, 0),
    write("Total :"),
    write(MyPoints),
    write('\n'),
    write('Player ').
    write(Enemy),
    write('\n'),
    lempar_dadu_attack(EnemyTroops, YourPoints, 0),
    write("Total :"),
    write(YourPoints),
    write('\n'),
    (
        MyPoints > YourPoints ->
        write('Player '),
        write(Player),
        write(' menang! Wilayah '),
        write(HasilLoc),
        write(' sekarang sikuasai oleh '),
        write('Player '),
        write(Player),
        write('\n'),
        loop6
    ;
        MyPoints =< YourPoints ->
        write('Player '),
        write(Enemy),
        write(' menang! Sayang sekali penyerangan Anda kalah :(\n'),
        retract(mapInformation(Player, WiliyahAttack, IsiArmy)),
        assertz(mapInformation(Player, WilayahAttack, IsiArmy - JumlahT)),
        retract(playerInformation(Player, Trupaktip, Truptamba, Wilayahku, BerapaBenuaku)),
        assertz(playerInformation(Player, Trupaktip - JumlahT, Truptamba, Wilayahku, BerapaBenuaku))
    ;
        getIndex(Y, HasilLoc, Pilihan),
        mapInformation(Enemy, HasilLoc, EnemyTroops)
        /* ambil info wilayah yang dipilih */
    ).
