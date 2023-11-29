:- include('data.pl').

checkBenua(Winner, Loser, Wil):-
    partBenua(Wil, BenuaWil),
    findall(X, (mapInformation(Winner, X, _), partBenua(X, BenuaX), BenuaX == BenuaWil), ListBenW),
    findall(Y, (mapInformation(Loser, Y, _), partBenua(Y, BenuaY), BenuaY == BenuaWil), ListBenL),
    listLength(ListBenW, BykWilW),
    listLength(ListBenL, BykWilL),
    jmlhWilBenua(BenuaWil, NumBen),
    checkAndAssert(NumBen, BykWilW, Winner, BenuaWil),
    checkAndRetract(NumBen,BykWilL, Loser, BenuaWil).

checkAndAssert(NumBen, BykWilW, Winner, BenuaWil) :-
    NumBen == BykWilW,
    !,
    assertz(infoBenua(Winner, BenuaWil)).
checkAndAssert(_, _, _, _).

checkAndRetract(NumBen, BykWilL, Loser, BenuaWil) :-
    BykWilL \== NumBen,
    infoBenua(Loser,BenuaWil),
    !,
    retract(infoBenua(Loser, BenuaWil)).
checkAndRetract(_, _, _, _).

isLose(Player):-
    \+mapInformation(Player,_,_),!,
    write('Jumlah wilayah Player '),write(Player),write(' 0\nPlayer '),write(Player),
    write(' keluar dari permainan!.\n'),
    retract(playerInformation(Player,_,_,_)),
    retract(urutanPemain(ListPlayer)),
    deleteElmt(ListPlayer,Player,ListUpdt),
    assertz(urutanPemain(ListUpdt)).
isLose(Player).

isWin(Player):-
    playerInformation(Player,_,_,NumWil),
    NumWil==24,!,
    write('******************************'),nl,
    write(Player),write(' telah menguasai dunia'),nl,
    write('******************************'),
    retractall(playerInformation(_,_,_,_)),
    retractall(mapInformation(_,_,_)),
    retractall(labelpemain(_,_)),
    retractall(currentPlayer(_)),
    retractall(countAction(_,_)),
    retractall(infoBenua(_,_)),
    retractall(riskStat(_,_)),
    retractall(urutanPemain(_)).
isWin(Player).

attack:-
    countAction(_,X),X==1,!,
    write('Anda sudah pernah attack!'),nl.

attack:-
    urutanPemain(ListP),
    listLength(ListP,Num),
    ListP = [Enemy|_],
    Num==2,riskStat(Enemy,'CEASEFIRE ORDER'),!,
    write('Tidak bisa menyerang, musuhnya CEASEFIRE!!'),nl.

attack:-
    currentPlayer(P),
    write('Sekarang giliran Player '),write(P), write(' menyerang.'),nl,
    inputAsal(Ori,P),
    write('Player '),write(P),write(' ingin memulai penyerangan dari daerah '),write(Ori),nl,
    mapInformation(P,Ori,Troops),
    write('Dalam daerah '),write(Ori),write(', Anda memiliki sebanyak '),write(Troops),write(' tentara.'),nl,
    inputTroops(Troops,CTroops,1),
    write('Player '),write(P),write(' mengirim sebanyak '),write(CTroops),nl,
    findall(Neigh, (tetangga(Ori, Neigh), mapInformation(OwnerOri, Ori, _), mapInformation(OwnerNeigh, Neigh, _), OwnerOri \== OwnerNeigh), ListNeigh),
    printTargets(ListNeigh,1),
    listLength(ListNeigh,NTargets),
    inputChoice(ListNeigh,NTargets,Target),
    getElmt(ListNeigh,Target,LocTarget),
    mapInformation(Name,LocTarget,TroopsTarget),
    /* Perang Mulai */
    write('Perang telah dimulai.'),nl,
    write('Player '),write(P),nl,
    (riskStat(P,'DISEASE OUTBREAK')->
        rollAttack(CTroops,Res1,1)
    ;riskStat(P,'SUPER SOLDIER SERUM')->
        rollAttack(CTroops,Res1,2)
    ;rollAttack(CTroops,Res1,3)
    ),
    write('Total: '),write(Res1),nl,

    write('Player '),write(Name),nl,
    (riskStat(Name,'DISEASE OUTBREAK')->
        rollAttack(TroopsTarget,Res2,1)
    ;riskStat(Name,'SUPER SOLDIER SERUM')->
        rollAttack(TroopsTarget,Res2,2)
    ;rollAttack(TroopsTarget,Res2,3)
    ),
    write('Total: '),write(Res2),nl,
    retract(mapInformation(P,Ori,Troops)),
    retract(mapInformation(Name,LocTarget,TroopsTarget)),
    (@>(Res1,Res2)->
        write('Player '),write(P),write(' menang! Wilayah '),write(LocTarget),
        write(' sekarang dikuasai oleh Player '),write(P),nl,
        MaxTroops is CTroops+1,
        inputTroops(MaxTroops,ResStay,2),
        /* Update Jmlh troops di LocTarget dan di Ori */
        assertz(mapInformation(P,LocTarget,ResStay)),
        OriTroops is Troops-ResStay,
        assertz(mapInformation(P,Ori,OriTroops)),
        /* Nambahin jmlh wilayah P sbnyk 1 */
        retract(playerInformation(P,Temp1,Temp2,Num)),
        NumWilT is (Num+1),
        assertz(playerInformation(P,Temp1,Temp2,NumWilT)),
        /* update tentara aktif dan jumlah wilayah si Name */
        retract(playerInformation(Name,AktifP,PasifP,NumWill)),
        NewAktif is AktifP-TroopsTarget,
        NumWillT is NumWilT-1,
        assertz(playerInformation(Name,NewAktif,PasifP,NumWillT)),
        write('Tentara di wilayah '),write(Ori),write(': '),write(OriTroops),nl,
        write('Tentara di wilayah '),write(LocTarget),write(': '),write(ResStay),nl,
        checkBenua(P,Name,LocTarget),
        isLose(Name),
        isWin(P)
    ;
        write('Player '),write(Name),write(' menang! Sayang sekali penyerangan Anda gagal :( '),nl,
        /* Update troops di LocTarget sama Ori */
        assertz(mapInformation(Name,LocTarget,TroopsTarget)),
        OriTroops is Troops-CTroops,
        assertz(mapInformation(P,Ori,OriTroops)),
        /* Update pemain aktif si P dikurangin */
        retract(playerInformation(P,Aktif1,Pasif1,NumWil1)),
        Aktif1T is Aktif1 - CTroops,
        assertz(playerInformation(P,Aktif1T,Pasif1,NumWil1)),
        write('Tentara di wilayah '),write(Ori),write(': '),write(OriTroops),nl,
        write('Tentara di wilayah '),write(LocTarget),write(': '),write(TroopsTarget),nl
    ),
    retract(countAction(M,A)),
    NewA is A+1,
    assertz(countAction(M,NewA)),
    retractall(riskStat(P,_)).

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
rollAttack(NTroops,Sum,3):-
    random(1,7,Res),
    write('Dadu '),write(NTroops),write(': '),write(Res),nl,
    NewNT is NTroops-1,
    rollAttack(NewNT,SumT,3),
    Sum is Res+SumT.

inputAsal(X,P):-
    write('Piihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(Y),
    (wilayah(Y)->
        (mapInformation(P,Y,Z)->
            (Z\==1->
                (tetangga(Y,Temp),mapInformation(P1,Temp,_),P1\==P->
                    X = Y
                ;
                    write('Tidak ada daerah di sekitar wilayah '),write(Y),write(' yang dapat diserang.\nPilih yang lain!\n'),
                    inputAsal(X,P)    
                )
            ;
                write('Jumlah troops di wilayah tersebut hanya satu. Pilih yang lain!\n'),
                inputAsal(X,P)
            )
        ;write('Wilayah tersebut bukan milikmu. Pilih yang lain!\n'),
         inputAsal(X,P)
        )
    ;
     write('Daerah tidak valid. Silahkan input kembali.'),nl,
     inputAsal(X,P)
    ).

inputTroops(MaxTroops, TroopCount, Type) :-
    (Type == 1 ->
        write('Masukkan banyak tentara yang akan bertempur: ')
    ;   write('Silahkan tentukan banyak tentara yang menetap di wilayaht tersebut: ')
    ),
    read(Y),
    (((Type==1,Y>=1,Y<MaxTroops);(Type\==1,Y>1,Y=<MaxTroops))->
        TroopCount = Y
    ;
        write('Banyak input tentara tidak valid. Silahkan coba lagi.'),nl,
        inputTroops(MaxTroops,TroopCount,Type)
    ).


inputChoice(ListTarget, X, Y) :-
    write('Pilih: '),
    read(Z),
    (Z =< X, Z >= 1 ->
        getElmt(ListTarget, Z, Res),
        mapInformation(Name, Res, _),
        (riskStat(_, 'CEASEFIRE ORDER') ->
            write('Tidak bisa menyerang!\nWilayah ini dalam pengaruh CEASEFIRE ORDER.\n'),
            inputChoice(ListTarget, X, Y)
        ;
            Y = Z
        )
    ;
        write('Input tidak valid. Silahkan input kembali.'), nl,
        inputChoice(ListTarget, X, Y)
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
    retract(playerInformation(Player,Aktif,Tambahan,NumWil)),
    NewTambahan is Tambahan-Num,
    NewAktif is Aktif+Num,
    assertz(playerInformation(Player,NewAktif,NewTambahan,NumWil)),
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
        findall(Y,(infoBenua(NewCurrent,Y)),List),
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
    retract(riskStat(NewCurrent,_)).

move(X1,X2,Y):-
    countAction(X,_),X==3,!,
    write('Anda sudah melakukan move sebanyak tiga kali!.'),nl.

move(X1,X2,Y):-
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
    write('Jumlah tentara di '),write(X2),write(': '),write(NewN2),nl,
    retract(countAction(X,Z)),
    XNew is X+1,
    assertz(countAction(XNew,Z)),!.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P1==C,P2==C,!,
    write(C),write(' memindahkan '),write(Y),write(' tentara dari '),
    write(X1),write(' ke '),write(X2),write('.'),nl,nl,
    write('Tentara tidak mencukupi.'),nl,write('Pemindahan dibatalkan.'),nl,!.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P1==C,!,
    write(C),write(' tidak memiliki wilayah '),write(X2),nl,
    write('Pemindahan dibatalkan.'),!,nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    P2==C,!,
    write(C),write(' tidak memiliki wilayah '),write(X1),nl,
    write('Pemindahan dibatalkan.'),!,nl.

move_action(P1,P2,X1,X2,N1,N2,Y,C):-
    write(C),write(' tidak memiliki wilayah '),write(X1),write(' dan '),
    write(X2),write('.'),nl,write('Pemindahan dibatalkan.'),!,nl.

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
    currentPlayer(C),
    \+mapInformation(C,_,_),!,
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'), nl,
    write('Eh tetapi Player '),write(C),write(' tidak punya wilayah, gajadi deh.'),nl.

risk_message(4):-
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'), nl,
    currentPlayer(C),
    findall(X, (playerInformation(X, _, _, _), X \== C), ListP),
    findall(Y,mapInformation(C,Y,_),ListW),
    getPlayerWil(ListP,ListW,TargetP,TargetW),
    updatePlayers(TargetP,C,TargetW),
    write('Wilayah '),write(TargetW),write(' sekarang dikuasai oleh Player '), write(TargetP),nl.

risk_message(5):-
    write('Hingga giliran berikutnya,'), nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1'), nl.

risk_message(6):-
    write('Pada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.'), nl.

updatePlayers(Winner,Loser,TargetW):-
    retract(mapInformation(Loser,TargetW,TroopsW)),
    retract(playerInformation(Winner,AktifW,PasifW,NumWilW)),
    retract(playerInformation(Loser,AktifL,PasifL,NumWilL)),
    NumWilWNew is NumWilW + 1,
    NumWilLNew is NumWilL - 1,
    AktifWNew is AktifW + TroopsW,
    AktifLNew is AktifL - TroopsW,
    assertz(mapInformation(Winner,TargetW,TroopsW)),
    assertz(playerInformation(Winner,AktifWNew,PasifW,NumWilWNew)),
    assertz(playerInformation(Loser,AktifLNew,PasifL,NumWilLNew)).

getPlayerWil(ListP,ListW,X,Y):-
    listLength(ListP,LengthP), 
    listLength(ListW,LengthW),
    getRandom(ListP,LengthP,TargetP),
    getRandom(ListW,LengthW,TargetW),
    X = TargetP, Y = TargetW.

getRandom(List,Length,Res):-
    random(1,Length,RN),
    getElmt(List,RN,ResT),
    Res = ResT.

init:-
    retractall(riskStat(_,_)),
    retractall(currentPlayer(_)),
    retractall(urutanPemain(_)),
    retractall(playerInformation(_,_,_,_)),
    retractall(mapInformation(_,_,_)),
    retractall(infoBenua(_,_)),
    assertz(currentPlayer(tes)),
    assertz(urutanPemain([kiel,ben,tes])),
    assertz(countAction(0,0)),
    assertz(playerInformation(tes,16,0,8)),
    assertz(playerInformation(kiel,16,0,8)),
    assertz(playerInformation(ben,16,0,8)),
    assertz(mapInformation(tes,af1,2)),
    assertz(mapInformation(tes,af2,2)),
    assertz(mapInformation(tes,af3,2)),
    assertz(mapInformation(tes,a1,2)),
    assertz(mapInformation(tes,a2,2)),
    assertz(mapInformation(tes,a3,2)),
    assertz(mapInformation(tes,a4,2)),
    assertz(mapInformation(tes,a5,2)),
    assertz(mapInformation(kiel,a6,2)),
    assertz(mapInformation(kiel,a7,2)),
    assertz(mapInformation(kiel,na5,2)),
    assertz(mapInformation(kiel,na4,2)),
    assertz(mapInformation(kiel,na3,2)),
    assertz(mapInformation(kiel,na2,2)),
    assertz(mapInformation(kiel,na1,2)),
    assertz(mapInformation(kiel,sa1,2)),
    assertz(mapInformation(ben,sa2,2)),
    assertz(mapInformation(ben,e1,2)),
    assertz(mapInformation(ben,e2,2)),
    assertz(mapInformation(ben,e3,2)),
    assertz(mapInformation(ben,e4,2)),
    assertz(mapInformation(ben,e5,2)),
    assertz(mapInformation(ben,au1,2)),
    assertz(mapInformation(ben,au2,2)),
    assertz(infoBenua(tes,afrika)),
    assertz(infoBenua(tes,asia)),
    assertz(infoBenua(ben,eropa)),
    assertz(infoBenua(ben,australia)),
    assertz(infoBenua(kiel,amerikautara)),
    assertz(labelpemain(tes,1)),
    assertz(labelpemain(kiel,2)),
    assertz(labelpemain(ben,3)).

inputRisk(Y):-
    write('Masukan angka: '),
    read(Pilihan),
    (
        Pilihan > 6 ->
        write('Angka tidak valid!\n'),
        inputRisk(Y)
    ;
        Pilihan < 1 ->
        write('Angka tidak valid!\n'),
        inputRisk(Y)
    ;
        Y is Pilihan
    ).

cheatAmbilKartu:-
    currentPlayer(Player),
    write('Pilih kartu risk yang ingin diambil '),nl,
    write('1. Ceasefire Order'),nl,
    write('2. Super Soldier Serum'),nl,
    write('3. Auxiliary Troops'),nl,
    write('4. Rebellion'),nl,
    write('5. Disease Outbreak'),nl,
    write('6. Supply Chain Issue'),nl,

    inputRisk(Angka),
    (   (Angka == 1) -> 
        assertz(riskStat(Player,'CEASEFIRE ORDER')),
        write('Anda mendapat kartu risk Ceasefire Order')
    ;(Angka == 2) -> 
        assertz(riskStat(Player,'SUPER SOLDIER SERUM')),
        write('Anda mendapat kartu risk Super Soldier Serum')
    ;(Angka == 3) -> 
        assertz(riskStat(Player,'AUXILIARY TROOPS')),
        write('Anda mendapat kartu risk Auxiliary Troops')
    ;(Angka == 4) -> 
        assertz(riskStat(Player,'REBELLION')),
        write('Anda mendapat kartu risk Rebellion')
    ;(Angka == 5) -> 
        assertz(riskStat(Player,'DISEASE OUTBREAK')),
        write('Anda mendapat kartu risk Disease Outbreak')
    ;(Angka == 6) -> 
        assertz(riskStat(Player,'SUPPLY CHAIN ISSUE')),
        write('Anda mendapat kartu risk Supply Chain Issue')
    ).