:- include('data.pl').

/* Rule */
endTurn.
draft(X,Y).

:- dynamic(countMove/1).

move(X1,X2,Y):-
    countMove(X),X==3,!,
    write('Anda sudah melakukan move sebanyak tiga kali!.'),nl.

move(X1,X2,Y):-
    assertz(countMove(1)),
    retract(countMove(X)),
    XNew is X+1,
    assertz(countMove(XNew)),
    mapInformation(P1,X1,N1),
    mapInformation(P2,X2,N2),
    currentPlayer(C),
    move_action(P1,P2,X1,X2,N1,N2,Y,C).

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P1==C,P2==C,Y<N1,!,
    write(C),write(' memindahkan '),write(Y),write(' tentara dari '),
    write(X1),write(' ke '),write(X2),write('.'),nl,nl,
    retract(mapInformation(P1,X1,N1)),
    retract(mapInformation(P2,X2,N2)),
    NewN2 is N2+Y, NewN1 is N1-Y,
    assertz(mapInformation(C,X1,NewN1)),
    assertz(mapInformation(C,X2,NewN2)),
    write('Jumlah tentara di '),write(X1),write(': '),write(NewN1),nl,
    write('Jumlah tentara di '),write(X2),write(': '),write(NewN2),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P1==C,P2==C,!,
    write(C),write(' memindahkan '),write(Y),write(' tentara dari '),
    write(X1),write(' ke '),write(X2),write('.'),nl,nl,
    write('Tentara tidak mencukupi.'),nl,write('Pemindahan dibatalkan.'),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P1==C,!,
    write(C),write('tidak memiliki wilayah '),write(X2),nl,
    write('Pemindahan dibatalkan.'),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P2==C,!,
    write(C),write('tidak memiliki wilayah '),write(X1),nl,
    write('Pemindahan dibatalkan.'),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    write(C),write('tidak memiliki wilayah '),write(X1),write(' dan '),
    write(X2),write('.'),nl,write('Pemindahan dibatalkan.'),nl.

getRisk([H|_], 1, H).
getRisk([_|T], Idx, Elmt) :-
    IdxNew is Idx-1,
    getRisk(T, IdxNew, Elmt).

risk:-
    assertz(currentPlayer('tes')),
    currentPlayer(C),
    random(1, 7, RN),
    risk_content(RiskList),
    getRisk(RiskList, RN, Risk),
    assertz(riskStat(C, Risk)),
    write('Player '),write(C),write(' mendapatkan risk card '),write(Risk),write('.'),nl,
    risk_message(RN),!.

risk_message(1):-
    write('Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.'), nl.

risk_message(2):-
    write('Hingga giliran berikutnya,'), nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'), nl.

risk_message(3):-
    write('Pada giliran berikutnya,'), nl,
    write('Tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.'), nl.

risk_message(4):-
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'), nl.

risk_message(5):-
    write('Hingga giliran berikutnya,'), nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1'), nl.

risk_message(6):-
    write('Pada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.'), nl.