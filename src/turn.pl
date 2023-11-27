/* Fakta dan Relasi */
bonusTentara(X,Y). 
bonusTentara(amerikautara,3).
bonusTentara(amerikaselatan,2).
bonusTentara(eropa,3).
bonusTentara(asia,5).
bonusTentara(afrika,2).
bonusTentara(australia,1).

maxMove(3).

# /* Nama pemain, Troops Aktif, Troops Tambahan, Wilayah yang dimiliki, Benua yang dimiliki (maksudnya wilayahnya ada di benua mana aja)*/
# :- dynamic(playerInformation/5). 
# / Nama pemilik, Kode wilayah, Troops pemilik pada wilayah tersebut*/
# :- dynamic(mapInformation/3).
# :- dynamic(NameTurn/2).  

/* Rule */
endTurn.    
draft(X,Y).   
move(X1,X2,Y):-
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C),
    P1==C,
    P2==C,
    Y<N1,!,
    write(C),write(' memindahkan '),write(Y),write(' tentara dari '),
    write(X1),write(' ke '),write(X2),write('.'),nl,nl,
    retract(mapInformation(P1,X1,N1)),
    retract(mapInformation(P2,X2,N2)),
    NewN2 is N2+Y, NewN1 is N1-Y,
    assertz(mapInformation(C,X1,NewN1)),
    assertz(mapInformation(C,X2,NewN2)),
    write('Jumlah tentara di '),write(X1),write(': '),write(NewN1),nl,
    write('Jumlah tentara di '),write(X2),write(': '),write(NewN2),nl.

move(X1,X2,Y):-
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C)
    P1==C,P2==C,!,
    write(C),write(' memindahkan '),write(Y),write(' tentara dari '),
    write(X1),write(' ke '),write(X2),write('.'),nl,nl,
    write('Tentara tidak mencukupi.'),nl,write('Pemindahan dibatalkan.'),nl.

move(X1,X2,Y):-
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C),
    P1==C,!,
    write(C),write('tidak memiliki wilayah '),write(X2),nl,
    write('Pemindahan dibatalkan.'),nl.

move(X1,X2,Y):-
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C),
    P2==C,!,
    write(C),write('tidak memiliki wilayah '),write(X1),nl,
    write('Pemindahan dibatalkan.'),nl.

move(X1,X2,Y):-
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C),
    write(C),write('tidak memiliki wilayah '),write(X1),write(' dan '),
    write(X2),write('.'),nl,write('Pemindahan dibatalkan.'),nl.

# Berisi nama dan kartu risk di tangan
RiskList = ["CEASEFIRE ORDER","SUPER SOLDIER SERUM","AUXILIARY TROOPS","REBELLION","DISEASE OUTBREAK","SUPPLY CHAIN"]

getRisk([H|_],1,H).
getRisk([H|T],Idx,Elmt):-
    IdxNew is Idx-1,
    getRisk(T,IdxNew,Elmt).

:- dynamic(riskStat/2)

risk:-
    currentPlayer(C),
    risk(C,R),!,
    random(1,7,RN),
    getRisk(RiskList,RN,Risk),
    assertz(riskStat(C,Risk)),
    risk_message(RN).

risk_message(RN):-
    RN==1,!,
    write('Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.'),nl.

risk_message(RN):-
    RN==2,!,
    write('Hingga giliran berikutnya,')nl,write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'),nl.

risk_message(RN):-
    RN==3,!,
    write('Pada giliran berikutnya,')nl,
    write('Tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.'),nl.

risk_message(RN):-
    RN==4,!,
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'),nl.

risk_message(RN):-
    RN==5,!,
    write('Hingga giliran berikutnya,'),nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1'),nl.

risk_message(RN):-
    RN==6,!,
    write('Pada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.'),nl.