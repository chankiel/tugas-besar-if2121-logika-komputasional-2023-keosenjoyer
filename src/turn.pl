:- include('data.pl').
/* Rule */
/* endTurn. */

rotate_list([Head|Tail], RotatedList) :-
    append(Tail, [Head], RotatedList).

listLength([],0).
listLength([_|Xs],N) :- listLength(Xs,M), N is M+1.

getElmt([H|_],1,H).
getElmt([H|T],Idx,Res):-
    NewIdx is Idx-1,
    getElmt(T,NewIdx,ResT),
    Res = ResT.

attack:-
    countAction(_,X),X==1,!,
    write('Anda sudah pernah attack!'),nl.

attack:-
    currentPlayer(P),
    write('Sekarang giliran Player '),write(P), write(' menyerang.'),nl,
    inputAsal(Ori),
    write('Player '),write(P),write(' ingin memulai penyerangan dari daerah '),write(Ori),nl,
    retract(mapInformation(P,Ori,Troops)),
    write('Dalam daerah '),write(Ori),write(', Anda memiliki sebanyak '),write(Troops),write(' tentara.'),nl,
    inputTroops(Troops,CTroops,1),
    write('Player '),write(P),write(' mengirim sebanyak '),write(CTroops),
    findall(Neigh,tetangga(Ori,Neigh),ListNeigh),
    printTargets(ListNeigh,1),
    listLength(ListNeigh,NTargets),
    inputChoice(NTargets,Target),
    getElmt(ListNeigh,Target,LocTarget),
    retract(mapInformation(Name,LocTarget,TroopsTarget)),
    write('Perang telah dimulai.'),nl,
    write('Player '),write(P),nl,
    (riskStat(P,'DISEASE OUTBREAK')->
        rollAttack(CTroops,Res1,1)
    ;riskStat(P,'SUPER SOLDIER SERUM')->
        rollAttack(CTroops,Res1,2)
    ;rollAttack(CTroops,Res1,3)
    ).
    write('Total: '),write(Res1),nl,

    write('Player '),write(Name),nl,
    (riskStat(P,'DISEASE OUTBREAK')->
        rollAttack(TroopsTarget,Res2,1)
    ;riskStat(P,'SUPER SOLDIER SERUM')->
        rollAttack(TroopsTarget,Res2,2)
    ;rollAttack(TroopsTarget,Res2,3)
    ).
    (Res1>Res2->
        write('Player '),write(P),write('menang! Wilayah '),write(LocTarget),
        write('sekarang dikuasai oleh Player '),write(P),nl,
        MaxTroops is CTroops+1,
        inputTroops(MaxTroops,ResStay,2),
        assertz(mapInformation(P,LocTarget,ResStay)),
        OriTroops is Troops-ResStay,
        assertz(mapInformation(P,Ori,OriTroops)),
        retract(playerInformation(P,Temp1,Temp2,NumWil)),
        NumWilT is NumWil+1,
        assertz(playerInformation(P,Temp1,Temp2,NumWilT)),
        retract(playerInformation(Name,AktifP,PasifP,NumWill)),
        NewAktif is AktifP-TroopsTarget,
        NumWillT is NumWilT-1,
        assertz(playerInformation(Name,NewAktif,PasifP,NumWillT)),
        write('Tentara di wilayah '),write(Ori),write(': '),write(OriTroops),nl,
        write('Tentara di wilayah '),write(LocTarget),write(': '),write(ResStay),nl
    ;
        write('Player '),write(Name),write('menang! Sayang sekali penyerangan Anda gagal :( '),nl,
        assertz(mapInformation(Name,LocTarget,TroopsTarget)),
        OriTroops is Troops-CTroops,
        assertz(mapInformation(P,Ori,OriTroops)),
        retract(playerInformation(P,Aktif1,Pasif2,NumWil1)),
        Aktif1T is Aktif1 - CTroops,
        assertz(playerInformation(P,Aktif1,Pasif1,NumWil1)),
        write('Tentara di wilayah '),write(Ori),write(': '),write(OriTroops),nl,
        write('Tentara di wilayah '),write(LocTarget),write(': '),write(TroopsTarget),nl
    ).
        
rollAttack(0,0,_).
rollAttack(NTroops,Sum,1):-
    write('Dadu '),write(NTroops),write(': 1.\n'),
    NewNT is NTroops-1,
    rollAttack(NewNT,SumT,1),
    Sum is 1+SumT.
rollAttack(NTroops,Sum,2):-
    write('Dadu '),write(NTroops),write(': 6.\n'),
    NewNT is NTroops-1,
    rollAttack(NewNT,SumT,2),
    Sum is 6+SumT.
rollAttack(NTroops,Sum,1):-
    random(1,7,Res),
    write('Dadu '),write(NTroops),write(': '),write(Res),nl,
    NewNT is NTroops-1,
    rollAttack(NewNT,SumT,3),
    Sum is Res+SumT.

inputAsal(X):-
    write('Piihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(Y),
    (wilayah(Y)->
        X = Y
    ;
     write('Daerah tidak valid. Silahkan input kembali.'),nl,
     inputAsal(XReal), X = XReal
    ).

inputTroops(X,Res,Type):-
    {Type==1,!,write('Masukkan banyak tentara yang akan bertempur: ');write('Silahkan tentukan banyaknya tentara yang menetap di wilayah tersebut: ')},
    read(Y),
    (Y<X,Y>=1->
        Res = Y
    ;
        write('Banyak tentara tidak valid. Silahkan input kembali.'),nl,
        inputTroops(Z),Res = Z
    ).

inputChoice(ListTarget,X,Y):-
    write('Pilih: '),
    read(Z),
    (Z=<X,Z>=1->
        getElmt(ListTarget,Z,Res),
        mapInformation(Name,Res,_),
        (riskStat(Name,'CEASEFIRE ORDER')->
            write('Tidak bisa menyerang!\nWilayah ini dalam pengaruh CEASEFIRE ORDER.\n'),
            inputChoice(ListTarget,X,YNew), Y = YNew
        ;
            Y = Z
        )
    ;
        write('Input tidak valid. Silahkan input kembali.'),nl,
        inputChoice(A), Y = Z
    ).

printTargets([H],Idx):-
    write(Idx),write('. '),write(H),nl.
printTargets([H|T],Idx):-
    write(Idx),write('. '),write(H),nl,
    NewIdx is Idx+1,
    printTargets(T,NewIdx).

draft(Wilayah,_):-
    currentPlayer(Player),
    mapInformation(Pemilik,Wilayah,_),
    Pemilik \== Player,!,
    write('Player '),
    write(Player),
    write(' tidak memiliki wilayah '),
    write(Wilayah),nl.
draft(Wilayah,Num):-
    currentPlayer(Player), 
    playerInformation(Player,_,Tambahan,_),
    Num > Tambahan,!,
    write('Player '),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara tambahan di wilayah '),
    write(Wilayah),nl,
    write('Pasukan tidak mencukupi.'),nl,
    write('Jumlah Pasukan Tambahan Player '),
    write(Player),
    write(': '),
    write(Tambahan),nl,
    write('draft dibatalkan.'),nl.
draft(Wilayah,Num):-
    currentPlayer(Player),
    retract(mapInformation(Player,Wilayah,N)),
    retract(playerInformation(Player,Aktif,Tambahan,_)),
    NewTambahan is Tambahan-Num,
    NewAktif is Aktif+Num,
    assertz(playerInformation(Player,NewAktif,NewTambahan,_)),
    Nl is N + Num, 
    assertz(mapInformation(Player,Wilayah,Nl)),
    write('Player '),
    write(Player),
    write(' meletakkan '),
    write(Num),
    write(' tentara tambahan di wilayah '),
    write(Wilayah),nl,nl,
    write('Tentara total di '),
    write(Wilayah),
    write(': '),
    write(Nl),nl,
    write('Jumlah Pasukan Tambahan Player '),
    write(Player),
    write(': '),
    write(NewTambahan),nl,!.

endTurn:-
    retract(currentPlayer(C)),
    retract(urutanPemain(ListPlayer)),
    retract(countAction(_,_)),
    ListPlayer = [NewCurrent|_],
    rotate_list(ListPlayer,NewList),
    assertz(urutanPemain(NewList)),
    assertz(currentPlayer(NewCurrent)),
    assertz(countAction(0,0)),
    write('Player '),write(C),write(' mengakhiri giliran.'),nl,
    write('Sekarang giliran Player '),write(NewCurrent),write('!'),nl,
    (riskStat(NewCurrent,Risk),Risk=='SUPPLY CHAIN ISSUE' ->
        write('Player '),write(NewCurrent),write(' terdampak '),write(Risk),write('!\nPlayer '),
        write(NewCurrent),write(' tidak mendapatkan tentara tambahan.'),nl
    ;
        AddTroop is 4,
        retract(playerInformation(NewCurrent,TroopsA,TroopsT,NumWil)),
        AddTroop1 is AddTroop+(NumWil div 2),
        findall(Y,clause(infoBenua(NewCurrent,Y),_),List),
        countBonus(List,AddBonus),
        AddTroop2 is AddTroop1+AddBonus,
        (riskStat(NewCurrent,RiskT),RiskT=='AUXILIARY TROOPS'->
            write('Player '),write(NewCurrent),write(' mendapatkan '),write(RiskT),write('!\n'),
            AddTroopFinal is AddTroop2*2
        ;
            AddTroopFinal is AddTroop2
        ),
        NewTroopsT is TroopsT+AddTroopFinal,
        assertz(playerInformation(NewCurrent,TroopsA,NewTroopsT,NumWil)),
        write('Player '),write(NewCurrent),write(' mendapatkan '),
        write(AddTroopFinal),write(' tentara tambahan.'),nl
    ),
    (riskStat(NewCurrent,_)->
        retract(riskStat(_,_))
    ),!.

countBonus([],0).
countBonus([H|T],Res):-
    bonusTentara(H,B),
    countBonus(T,ResT),
    Res is B+ResT.

move(X1,X2,Y):-
    countAction(X,_),X==3,!,
    write('Anda sudah melakukan move sebanyak tiga kali!.'),nl.

move(X1,X2,Y):-
    retract(countAction(X,Z)),
    XNew is X+1,
    assertz(countAction(XNew,Z)),
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
    write(C),write(' tidak memiliki wilayah '),write(X2),nl,
    write('Pemindahan dibatalkan.'),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P2==C,!,
    write(C),write(' tidak memiliki wilayah '),write(X1),nl,
    write('Pemindahan dibatalkan.'),nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    write(C),write(' tidak memiliki wilayah '),write(X1),write(' dan '),
    write(X2),write('.'),nl,write('Pemindahan dibatalkan.'),nl.

getRisk([H|_], 1, H).
getRisk([_|T], Idx, Elmt) :-
    IdxNew is Idx-1,
    getRisk(T, IdxNew, Elmt).

risk:-
    currentPlayer(C),
    \+riskStat(C,_),!,
    random(1, 7, RN),
    risk_content(RiskList),
    getRisk(RiskList, RN, Risk),
    assertz(riskStat(C, Risk)),
    write('Player '),write(C),write(' mendapatkan risk card '),write(Risk),write('.'),nl,
    risk_message(RN),!.

risk:-
    write('Anda telah melakukan aksi RISK.\n').

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

initTesting:-
    assertz(currentPlayer(tes)),
    assertz(urutanPemain([kiel,ben,tes])),
    assertz(countAction(0,0)),
    assertz(playerInformation(tes,0,0,8)),
    assertz(playerInformation(kiel,0,0,8)),
    assertz(playerInformation(ben,0,0,8)),
    assertz(mapInformation(tes,af1,2)),
    assertz(mapInformation(tes,af2,2)),
    assertz(mapInformation(tes,af3,2)),
    assertz(mapInformation(kiel,a1,2)),
    assertz(mapInformation(kiel,a2,2)),
    assertz(mapInformation(kiel,a3,2)),
    assertz(mapInformation(ben,a4,2)),
    assertz(mapInformation(ben,a5,2)),
    assertz(mapInformation(ben,a6,2)).

cheatAmbilKartu():-
    currentPlayer(Player),
    write('Pilih kartu risk yang ingin diambil '),nl,
    write('1. Ceasefire Order'),nl,
    write('2. Super Soldier Serum'),nl,
    write('3. Auxiliary Troops'),nl,
    write('4. Rebellion'),nl,
    write('5. Disease Outbreak'),nl,
    write('6. Supply Chain Issue'),nl,
    write('Masukan angka: '),
    read(Angka),
    (   (Angka == 1) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'CEASEFIRE ORDER')),
        write('Anda mendapat kartu risk Ceasefire Order')
    ;(Angka == 2) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'SUPER SOLDIER SERUM')),
        write('Anda mendapat kartu risk Super Soldier Serum')
    ;(Angka == 3) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'AUXILIARY TROOPS')),
        write('Anda mendapat kartu risk Auxiliary Troops')
    ;(Angka == 4) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'REBELLION')),
        write('Anda mendapat kartu risk Rebellion')
    ;(Angka == 5) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'DISEASE OUTBREAK')),
        write('Anda mendapat kartu risk Disease Outbreak')
    ;(Angka == 6) -> 
        retract(riskStat(Player,Risk)),
        assertz(riskStat(Player,'SUPPLY CHAIN ISSUE')),
        write('Anda mendapat kartu risk Supply Chain Issue')
    ).