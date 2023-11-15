/* Fakta dan Relasi */
benua(amerikautara)
benua(eropa)
benua(asia)
benua(amerikaselatan)
benua(afrika)
benua(australia)

tetangga(Kode1,Kode2)
tetangga(na1,na2)
tetangga(na2,na1)
tetangga(na1,na3)
tetangga(na3,na1)
tetangga(na2,na4)
tetangga(na4,na2)
tetangga(na5,na2)
tetangga(na2,na5)
tetangga(na5,na4)
tetangga(na4,na5)
tetangga(na3,sa1)
tetangga(sa2,sa1)
tetangga(sa1,na3)
tetangga(sa1,sa2)
tetangga(sa2,af1)
tetangga(af1,sa2)
/* lanjutin */

partBenua(X,Y)
partBenua(na1,amerikautara)
....

/* Dynamic predicate */
dynamic(jmlhTentara/2)    
dynamic(wilayahMilik/2)   

/* Rule */
displayMap   
takeLocation(kodeWilayah)
placeTroops(X,Y)         
placeAutomatic           
checkLocationDetail(X)   
checkPlayerDetail(X)     
checkPlayerTerritories(X) 
checkIncomingTroops(X)    
