# :- include('initiating.pl').
:- include('map.pl').
:- include('data.pl').
# :- include('pemain.pl').
# :- include('troops.pl').
# :- include('turn.pl').

loop1(X, Y) :-
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(WilayahAttack),
    /*
    assertz(mapInformation('A1', 'Kiel', 10)),
    mapInformation(WilayahAttack, Pemilik, IsiArmy),
    */
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
        mapInformation(_, PemilikMusuh, IsiArmyMusuh),
        PemilikMusuh \== X ->
        
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
    mapInformation(X, Pemilik, IsiArmy),
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

loop3(X, Y) :-
    tetangga(X, _),
    mapInformation(_, PemilikMusuh, IsiArmyMusuh),
    PemilikMusuh \== Y ->
    write(_)
    /* ambil nanti di berapa */

loop4(X):-
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
        /* ambil info wilayah yang dipilih */
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
    loop3(WilayahAttack, Player),
    loop4(X),
    write('Perang telah dimulai!!! \n'),
    write('Player '),



/*
loop2:-
    repeat,
    write("Masukkan banyak tentara yang akan bertempur: ")
    read(TentaraMauAttack),
    write("\n"),
    TentaraMauAttack > JumlahT - 1,
    write("Banyak tentara tidak valid. Silahkan input kembali. \n").

attack :-
    write('Sekarang giliran Player '),
    retract(urutanPmemain(ListPlayer)),
    ListPlayer = [Player|_],
    write(Player),
    write(' menyerang!\n'),
    displayMap,
    write('\n'),
    loop1,
    write('Dalam daerah '),
    write(WiliyahAttack),
    write(', anda memiliki sebanyak '),
    write(JumlahT),
    write(' tentara. \n').
*/