/* Nama pemain, Troops Aktif, Troops Tambahan, Wilayah yang dimiliki*/
:- dynamic(playerInformation/4). 
/* Nama pemilik, Kode wilayah, Troops pemilik pada wilayah tersebut*/
:- dynamic(mapInformation/3).
/* List player sesuai urutan main inisialisasi*/
:- dynamic(urutanPemain/1).
/* Nama pemain dan urutannya */
:- dynamic(labelpemain/2).
/* Nama pemain sekarang */
:- dynamic(currentPlayer/1).
/* Nama dan Benua */
:- dynamic(infoBenua/2).
/* Nama dan risk card sekarang */
:- dynamic(riskStat/2).
/* Jumlah aksi current player (move,attack) */
:- dynamic(countAction/2).

risk_content(['CEASEFIRE ORDER','SUPER SOLDIER SERUM','AUXILIARY TROOPS','REBELLION','DISEASE OUTBREAK','SUPPLY CHAIN ISSUE']).

countBonus([],0).
countBonus([H|T],Res):-
    bonusTentara(H,B),
    countBonus(T,ResT),
    Res is B+ResT.

rotate_list([Head|Tail], RotatedList) :-
    append(Tail, [Head], RotatedList).

listLength([],0).
listLength([_|Xs],N) :- listLength(Xs,M), N is M+1.

getElmt([H|_],1,H).
getElmt([H|T],Idx,Res):-
    NewIdx is Idx-1,
    getElmt(T,NewIdx,ResT),
    Res = ResT.

deleteElmt([H|T],Elmt,Res):-
    H==Elmt,!,
    Res = T.
deleteElmt([H|T],Elmt,Res):-
    deleteElmt(T,Elmt,ResT),
    Res = [H|ResT].

/* inisialisasi */
inisialisasiMapInformation:-
    assertz(mapInformation(null,na1,0)),
    assertz(mapInformation(null,na2,0)),
    assertz(mapInformation(null,na3,0)),
    assertz(mapInformation(null,na4,0)),
    assertz(mapInformation(null,na5,0)),
    assertz(mapInformation(null,sa1,0)),
    assertz(mapInformation(null,sa2,0)),
    assertz(mapInformation(null,e1,0)),
    assertz(mapInformation(null,e2,0)),
    assertz(mapInformation(null,e3,0)),
    assertz(mapInformation(null,e4,0)),
    assertz(mapInformation(null,e5,0)),
    assertz(mapInformation(null,af1,0)),
    assertz(mapInformation(null,af2,0)),
    assertz(mapInformation(null,af3,0)),
    assertz(mapInformation(null,a1,0)),
    assertz(mapInformation(null,a2,0)),
    assertz(mapInformation(null,a3,0)),
    assertz(mapInformation(null,a4,0)),
    assertz(mapInformation(null,a5,0)),
    assertz(mapInformation(null,a6,0)),
    assertz(mapInformation(null,a7,0)),
    assertz(mapInformation(null,au1,0)),
    assertz(mapInformation(null,au2,0)).

bonusTentara(amerikautara,3).
bonusTentara(amerikaselatan,2).
bonusTentara(eropa,3).
bonusTentara(asia,5).
bonusTentara(afrika,2).
bonusTentara(australia,1).

benua(amerikautara).
benua(eropa).
benua(asia).
benua(amerikaselatan).
benua(afrika).
benua(australia).

jmlhWilBenua(amerikautara,5).
jmlhWilBenua(eropa,5).
jmlhWilBenua(amerikaselatan,2).
jmlhWilBenua(afrika,3).
jmlhWilBenua(asia,7).
jmlhWilBenua(australia,2).

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

namaWilayah(na1, canada).
namaWilayah(na2, greenland).
namaWilayah(na3, mexico).
namaWilayah(na4, cuba).
namaWilayah(na5, jamaica).
namaWilayah(sa1, brazil).
namaWilayah(sa2, argentina).
namaWilayah(e1, italy).
namaWilayah(e2, germany).
namaWilayah(e3, france).
namaWilayah(e4, netherlands).
namaWilayah(e5, switzerland).
namaWilayah(af1, nigeria).
namaWilayah(af2, kenya).
namaWilayah(af3, ghana).
namaWilayah(a1, china).
namaWilayah(a2, indonesia).
namaWilayah(a3, singapore).
namaWilayah(a4, jepang).
namaWilayah(a5, korea).
namaWilayah(a6, malaysia).
namaWilayah(a7, vietnam).
namaWilayah(au1, sydney).
namaWilayah(au2, melbourne).

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