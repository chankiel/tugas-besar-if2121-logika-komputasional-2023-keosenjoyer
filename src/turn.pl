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
