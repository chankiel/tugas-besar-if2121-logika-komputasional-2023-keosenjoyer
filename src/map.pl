:- use_module(library(random)).

/* Fakta dan Relasi */
benua(amerikautara).
benua(eropa).
benua(asia).
benua(amerikaselatan).
benua(afrika).
benua(australia).

wilayah(na1).
wilayah(na2).
wilayah(na3).
wilayah(na4).
wilayah(na5).
wilayah(sa1).
wilayah(sa2).
wilayah(e1).
wilayah(e2).
wilayah(e3).
wilayah(e4).
wilayah(e5).
wilayah(af1).
wilayah(af2).
wilayah(af3).
wilayah(a1).
wilayah(a2).
wilayah(a3).
wilayah(a4).
wilayah(a5).
wilayah(a6).
wilayah(a7).
wilayah(au1).
wilayah(au2).

tetangga(Kode1,Kode2).
tetangga(na1,na2).
tetangga(na2,na1).
tetangga(na1,na3).
tetangga(na3,na1).
tetangga(na2,na4).
tetangga(na4,na2).
tetangga(na5,na2).
tetangga(na2,na5).
tetangga(na5,na4).
tetangga(na4,na5).
tetangga(na3,sa1).
tetangga(sa2,sa1).
tetangga(sa1,na3).
tetangga(sa1,sa2).
tetangga(sa2,af1).
tetangga(af1,sa2).
tetangga(af1,af2).
tetangga(af2,af1).
tetangga(af1,af3).
tetangga(af3,af1).
tetangga(af2,af3).
tetangga(af3,af2).
tetangga(af1,e3).
tetangga(e3,af1).
tetangga(af2,e4).
tetangga(e4,af2).
tetangga(e3,e1).
tetangga(e1,e3).
tetangga(e1,e2).
tetangga(e2,e1).
tetangga(e2,e4).
tetangga(e4,e2).
tetangga(e3,e4).
tetangga(e4,e3).
tetangga(e4,e5).
tetangga(e5,e4).
tetangga(e1,na5).
tetangga(na5,e1).
tetangga(e2,a1).
tetangga(a1,e2).
tetangga(e5,a4).
tetangga(a4,e5).
tetangga(a1,a4).
tetangga(a4,a1).
tetangga(a4,a2).
tetangga(a2,a4).
tetangga(a4,a5).
tetangga(a5,a4).
tetangga(a4,a6).
tetangga(a6,a4).
tetangga(a2,a5).
tetangga(a5,a2).
tetangga(a2,a6).
tetangga(a6,a2).
tetangga(a6,a5).
tetangga(a5,a6).
tetangga(a3,a5).
tetangga(a5,a3).
tetangga(a6,a7).
tetangga(a7,a6).
tetangga(a6,au1).
tetangga(au1,a6).
tetangga(a3,na1).
tetangga(na1,a3).
tetangga(a3,na3).
tetangga(na3,a3).
tetangga(au1,au2).
tetangga(au2,au1).
tetangga(au2,sa2).
tetangga(sa2,au2).

partBenua(X,Y).
partBenua(na1,amerikautara).
partBenua(na2,amerikautara).
partBenua(na3,amerikautara).
partBenua(na4,amerikautara).
partBenua(na5,amerikautara).
partBenua(sa1,amerikaselatan).
partBenua(sa2,amerikaselatan).
partBenua(e1,eropa).
partBenua(e2,eropa).
partBenua(e3,eropa).
partBenua(e4,eropa).
partBenua(e5,eropa).
partBenua(af1,afrika).
partBenua(af2,afrika).
partBenua(af3,afrika).
partBenua(a1,asia).
partBenua(a2,asia).
partBenua(a3,asia).
partBenua(a4,asia).
partBenua(a5,asia).
partBenua(a6,asia).
partBenua(a7,asia).
partBenua(au1,australia).
partBenua(au2,australia).
partBenua(au3,australia).


/* Dynamic predicate */
dynamic(JmlhTentara/2).   
dynamic(WilayahMilik/2).
dynamic(InfoTentara/3)   

/* Rule */
displayMap.
takeLocation(KodeWilayah):- 
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(KodeWilayah,Pemilik)),
    Pemilik == NULL, 
    assertz(WilayahMilik(KodeWilayah,Player)).
takeLocation(KodeWilayah):- 
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(KodeWilayah,Pemilik)),
    Pemilik \== NULL, 
    write('Wilayah sudah dikuasai. Tidak bisa mengambil.').
placeTroops(Wilayah,Num):-
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik \== Player,
    write('Wilayah tersebut dimiliki pemain lain.'),
    write('Silahkan pilih wilayah lain.').
placeTroops(Wilayah,Num):-
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retrack(InfoTentara(Player,Aktif,Tambahan)),
    Num > Tambahan,
    write('Jumlah tentara tidak cukup.').
placeTroops(Wilayah,Num):-
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retrack(InfoTentara(Player,Aktif,Tambahan)),
    Num <= Aktif,
    retrack(JmlhTentara(Wilayah,N)),
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
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik \== Player,
    write('Player '),
    write(Player),
    write(' tidak memiliki wilayah '),
    write(Wilayah).
draft(Wilayah,Num):-
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retrack(InfoTentara(Player,Aktif,Tambahan)),
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
    write(NewTambahan)
    write('draft dibatalkan.').
draft(Wilayah,Num):-
    retrack(currentPlayer(Player)), 
    retrack(WilayahMilik(Wilayah,Pemilik)),
    Pemilik == Player,
    retrack(InfoTentara(Player,Aktif,Tambahan)),
    Num <= Aktif,
    retrack(JmlhTentara(Wilayah,N)),
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
    retrack(currentPlayer(Player)),
    retrack(InfoTentara(Player,Aktif,Tambahan)),
    Tambahan == 0,
    write('Seluruh tentara '),
    write(Player),
    write(' sudah diletakkan.').
placeAutomatic:-
    retrack(currentPlayer(Player)),
    retrack(InfoTentara(Player,Aktif,Tambahan)),
    Tambahan \== 0,
    random(1,Tambahan,Num),
    retrack(Wilayah,Pemilik),
    randomFirstArgument(Player,Wilayah),
    retrack(JmlhTentara(Wilayah,N)),
    NewTambahan is Aktif-Num,
    NewAktif is Aktif+Num,
    assertz(InfoTentara(Player,NewAktif,NewTambahan)),
    Nl is N + Num, 
    assertz(JmlhTentara(Wilayah,Nl)),
    placeAutomatic.
checkLocationDetail(X).   
checkPlayerDetail(X).     
checkPlayerTerritories(X). 
checkIncomingTroops(X).    
