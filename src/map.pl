:- use_module(library(random)).
:- include('data.pl')

/* Rule */
displayMap.
displayMap :- write('#################################################################################################\n'),
             write('#         North America         #        Europe         #                 Asia                  #\n'),
             write('#                               #                       #                                       #\n'),
             write('#       [NA1(4)]-[NA2(1)]       #                       #                                       #\n'),
             write('-----------|       |----[NA5(2)]----[E1(11)]-[E2(4)]----------[A1(1)] [A2(13)] [A3(3)]-----------\n'),
             write('#       [NA3(3)]-[NA4(1)]       #       |       |       #        |       |       |              #\n'),
             write('#          |                    #    [E3(3)]-[E4(2)]    ####     |       |       |              #\n'),
             write('###########|#####################       |       |-[E5(2)]-----[A4(3)]----+----[A5(4)]           #\n'),
             write('#          |                    ########|#######|###########             |                      #\n'),
             write('#       [SA1(11)]               #       |       |          #             |                      #\n'),
             write('#          |                    #       |    [AF2(14)]     #          [A6(1)]---[A7(2)]         #\n'),
             write('#   |---[SA2(2)]---------------------[AF1(3)]---|          #             |                      #\n'),
             write('#   |                           #               |          ##############|#######################\n'),
             write('#   |                           #            [AF3(2)]      #             |                      #\n'),
             write('----|                           #                          #          [AU1(7)]---[AU2(13)]-------\n'),
             write('#                               #                          #                                    #\n'),
             write('#       South America           #         Africa           #          Australia                 #\n'),
             write('#################################################################################################\n').
takeLocation(KodeWilayah):- 
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(KodeWilayah,Pemilik)),
    Pemilik == NULL, 
    assertz(WilayahMilik(KodeWilayah,Player)).
takeLocation(KodeWilayah):- 
    retract(currentPlayer(Player)), 
    retract(WilayahMilik(KodeWilayah,Pemilik)),
    Pemilik \== NULL, 
    write('Wilayah sudah dikuasai. Tidak bisa mengambil.').


attack :-
    write("Sekarang giliran Player "),
    retract(currentPlayer(Player)),
    write(Player),
    write(" menyerang!\n"),
    displayMap,
    write("\n"),
    loop1:-
        repeat,
        write("Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: "),
        read(WiliyahAttack),
        retract(WilayahMilik(WiliyahAttack, Pemilik)),
        Pemilik \== Player,
        JumlahT <= 1,
        write("Daerah tidak valid. Silahkan input kembali. \n").
    write("Dalam daerah "),
    write(WiliyahAttack),
    write(", anda memiliki sebanyak "),
    write(JumlahT),
    write(" tentara. \n"),
    loop2:-
        repeat,
        write("Masukkan banyak tentara yang akan bertempur: ")
        read(TentaraMauAttack),
        write("\n"),
        TentaraMauAttack > JumlahT - 1,
        write("Banyak tentara tidak valid. Silahkan input kembali. \n").
    write("Pilihlah daerah yang ingin anda serang. \n"),
    # PRINT SELURUH DAERAH YANG INGIN DISERANG
    loop3:-
        write("Pilih: "),
        read(WilayahInginDiserang),
        # IF GAADA DI PILIHAN
        write("Input tidak valid. Silahkan input kembali.\n").
    write("Perang telah dimulai!!!"),
    write("Player "),
    write(Player),
    write("\n"),
    # PRINT DADU
    write("Player "),
    retract(WilayahMilik(WilayahInginDiserang), Pemilik2),
    write(Player2),
    write("\n"),
    # PRINT DADU
    # YG POINNYA LEBIH BESAR MENANG
    

    



    


