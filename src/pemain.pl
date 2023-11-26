/* Fakta dan Relasi */
initDistribusi(X,Y).
initDistribusi(2,24).
initDistribusi(3,26).
initDistribusi(4,12).

/* Dynamic predicate */
dynamic(nPemain/1).

/* Nama pemain, Troops Aktif, Troops Tambahan, Jumlah Wilayah yang dimiliki, Jumlah Benua yang dimiliki*/
dynamic(playerInformation/5). 
/ Nama pemilik, Kode wilayah, Troops pemilik pada wilayah tersebut, */
dynamic(mapInformation/4).
dynamic(NameTurn/2).     

/* Rule */
throw2Dice(X).           

checkPlayerTerritories(p3) :-
    write('Nama :'),
    write 