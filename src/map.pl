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
    retract(mapInformation(KodeWilayah,_,_)),
    !,
    assertz(mapInformation(KodeWilayah,_,_)),
    write('Wilayah sudah dikuasai. Tidak bisa mengambil.'),nl,
    retract(currentPlayer(Player)),
    write('Giliran '),
    write(Player),
    write(' untuk memilih wilayahnya.'),
    assertz(currentPlayer(Player)).
takeLocation(KodeWilayah):- 
    retract(currentPlayer(Player)), 
    assertz(mapInformation(Player,KodeWilayah,0)), 
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

loop1(X, Y) :-
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(WilayahAttack),
    /*
    assertz(mapInformation('A1', 'Kiel', 10)),
    */
    mapInformation(Pemilik, WilayahAttack, IsiArmy),
    /*
    write(X),
    write(Pemilik),
    */
    /* retract(mapInformation(WiliyahAttack, Pemilik, IsiArmy)), */
    /* read(JumlahT), */
    (
        Pemilik \== X -> 
        write('Daerah tidak valid. Silahkan input kembali. \n'),
        loop1(X, Y)
    ;
        /* tes seluruh area musuh */
        tetangga(WilayahAttack, _),
        /* mapInformation(_, PemilikMusuh, IsiArmyMusuh), */
        forall(mapInformation(PemilikMusuh, _, _), PemilikMusuh == X),
        (
            write('Daerah tidak valid. Silahkan input kembali. \n'),
            loop1(X, Y)
        )

    ;
        IsiArmy =< 1 -> 
        write('Daerah tidak valid. Silahkan input kembali. \n'),
        loop1(X, Y)
    ;
        write('Dalam daerah '),
        write(WilayahAttack),
        write(', Anda memiliki sebanyak '),
        write(IsiArmy),
        write(' tentara.\n')
    ).


loop2(X, Y) :-
    write('Masukkan banyak tentara yang akan bertempur: '),
    read(JumlahT),
    mapInformation(Pemilik, X, IsiArmy),
    (
        JumlahT =< 0  ->
        write('Banyak tentara tidak valid. Silahkan input kembali. \n'),
        loop2(X, Y)
    ;
        JumlahT > IsiArmy - 1 ->
        write('Banyak tentara tidak valid. Silahkan input kembali. \n'),
        loop2(X, Y)
    ;
        write('Player '),
        write(Y),
        write(' mengirim sebanyak '),
        write(JumlahT),
        write(' tentara untuk berperang\n')
    ).

loop3(X, Y, Z) :-
    tetangga(X, _),
    mapInformation(PemilikMusuh, _, IsiArmyMusuh),
    forall(
        mapInformation(PemilikMusuh, _A, _B),
        PemilikMusuh \== Y,
        (
            write(_A),
            write('\n')
        )
    ),
    findall(_A, (mapInformation(PemilikMusuh, _A, _B), PemilikMusuh \== Y), DaerahMusuhList),
    length(DaerahMusuhList, BanyakMusuh).
    /* ambil nanti di berapa */
    /* X is DaerahMusuhList. */

/* Get Index */
/* basis */
getIndex([H|_], H, 1) :- !.
/* rekurens */
getIndex([_|T], X, Idx) :- getIndex(T, X, IdxN), Idx is IdxN + 1.

loop4(X, Y):-
    read(Pilihan),
    (
        Pilihan > X ->
        write('Pilihan tidak valid!\n'),
        loop4(X)
    ;
        Pilihan < 1 ->
        write('Pilihan tidak valid!\n'),
        loop4(X)
    ;
        getIndex(Y, HasilLoc, Pilihan),
        mapInformation(Enemy, HasilLoc, EnemyTroops)
        /* ambil info wilayah yang dipilih */
    ).

lempar_dadu_attack(X, Y, Z):-
    random(1, 6, AttackPoints),
    Z < X,
    Z is Z + 1,
    write('Dadu '),
    write(Z),
    write(': '),
    write(AttackPoints),
    Y is Y + AttackPoints,
    lempar_dadu_attack(X, Y, Z).

loop6:-
    write('Silahkan tentukan banyaknya tentara yang menetap di wilayah '),
    write(HasilLoc),
    write(': '),
    read(BerapaYgMauDikirim),
    (
        BerapaYgMauDikirim > JumlahT ->
        write('Jumlah tentara invalid, silakan masukkan ulang\n'),
        loop6
    ;
        BerapaYgMauDikirim < 1 ->
        write('Jumlah tentara invalid, silakan masukkan ulang\n'),
        loop6
    ;
        write('Tentara di wilayah '),
        write(WilayahAttack),
        write(': '),
        write(IsiArmy - BerapaYgMauDikirim),
        write('\n'),
        retract(mapInformation(Player, WilayahAttack, IsiArmy)),
        assertz(mapInformation(Player, WilayahAttack, IsiArmy - BerapaYgMauDikirim)),
        write('Tentara di wilayah '),
        write(HasilLoc),
        write(': '),
        write(BerapaYgMauDikirim),
        write('\n'),
        retract(mapInformation(Enemy, HasilLoc, EnemyTroops)),
        assertz(mapInformation(Player, HasilLoc, BerapaYgMauDikirim)),

        retract(playerInformation(Player, Trupaktip, Truptamba, Wilayahku)),
        assertz(playerInformation(Player, Trupaktip, Truptamba, Wilayahku + 1)),
        retract(playerInformation(Enemy, Trupaktipmu, Truptambamu, Wilayahmu)),
        assertz(playerInformation(Enemy, Trupaktipmu - EnemyTroops, Truptambamu, Wilayahmu - 1))
        /* Set Status Kedua Wilayah */
    ).


attack :-
    write('Sekarang giliran Player '),
    assertz(currentPlayer('Kiel')),
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
    
