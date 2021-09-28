*************************Programa 1***********************

/////////////////////////////////////////////////Informacion BrandWatch //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////
clear all

global user "C:\Users\JOSE\Desktop\Trabajo\BX\Ecuador\Boletín\Input"
cd "$user\Mes t-2"

////////Por departamento/////////
****En caso de importar todo el documento**********************
*Xenofobia 
****
*CAMBIAR MES
import delimited "Xenofobia_depto_-2.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
rename (v1 v3) (Region Xenofobia)
**Creacion de codigo de ciudades
replace Region = "Galapagos" if Region == "Galápagos"
replace Region = "Santo Domingo de los Tsachilas" if Region == "Santo Domingo de los Tsáchilas"
gen area = 1 if Region == "Azuay" 
replace area = 2 if Region == "Bolivar"  
replace area =3 if Region == "Cañar"  
replace area = 4 if Region == "Carchi"  
replace area = 5 if Region == "Chimborazo"  
replace area = 6 if Region == "Cotopaxi"  
replace area = 7 if Region == "El Oro"  
replace area = 8 if Region == "Esmeraldas"  
replace area = 9 if Region == "Galapagos"  
replace area = 10 if Region == "Guayas"   
replace area = 11 if Region == "Imbabura"   
replace area = 12 if Region == "Loja"  
replace area = 13 if Region == "Los Rios"  
replace area = 14 if Region == "Manabi"
replace area = 15 if Region == "Morona Santiago"  
replace area = 16 if Region == "Napo"  
replace area = 17 if Region == "Orellana"  
replace area = 18 if Region == "Pastaza"  
replace area = 19 if Region == "Pichincha"  
replace area = 20 if Region == "Santa Elena"  
replace area = 21 if Region == "Santo Domingo de los Tsachilas"  
replace area = 22 if Region == "Sucumbios"  
replace area = 23 if Region == "Tungurahua"  
replace area = 24 if Region == "Zamora Chinchipe"  
replace area = 25 if Region == "Zona No Delimitada"  
drop v2
/**
label define a 5 "Medellín AM" 8 "Barranquilla AM" 11 "Bogotá DC" 13 "Cartagena" 15 "Tunja" 17 "Manizales AM" 18 "Florencia" 19 "Popayán" 20 "Valledupar" 23 "Montería" 27 "Quibdó" 41 "Neiva" 44 "Riohacha" 47 "Santa Marta" ///
50 "Villavicencio" 52 "Pasto" 54 "Cúcuta AM" 63 "Armenia" 66"Pereira AM" 68 "Bucaramanga AM" 70 "Sincelejo" 73 "Ibagué" 76 "Cali AM" 98 "98"
label values area a 
*/
tempfile Xenofobia 
save `Xenofobia'

**Ahora uso los totales para sacar la tasa de mensajes xenofobos 
*CAMBIAR MES

import delimited "Total_depto_-2.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(11) colrange(1) clear 
rename (v1 v3) (Region Total)
**Creacion de codigo de ciudades
replace Region = "Galapagos" if Region == "Galápagos"
replace Region = "Santo Domingo de los Tsachilas" if Region == "Santo Domingo de los Tsáchilas"
gen area = 1 if Region == "Azuay" 
replace area = 2 if Region == "Bolivar"  
replace area =3 if Region == "Cañar"  
replace area = 4 if Region == "Carchi"  
replace area = 5 if Region == "Chimborazo"  
replace area = 6 if Region == "Cotopaxi"  
replace area = 7 if Region == "El Oro"  
replace area = 8 if Region == "Esmeraldas"  
replace area = 9 if Region == "Galapagos"  
replace area = 10 if Region == "Guayas"   
replace area = 11 if Region == "Imbabura"   
replace area = 12 if Region == "Loja"  
replace area = 13 if Region == "Los Rios"  
replace area = 14 if Region == "Manabi"
replace area = 15 if Region == "Morona Santiago"  
replace area = 16 if Region == "Napo"  
replace area = 17 if Region == "Orellana"  
replace area = 18 if Region == "Pastaza"  
replace area = 19 if Region == "Pichincha"  
replace area = 20 if Region == "Santa Elena"  
replace area = 21 if Region == "Santo Domingo de los Tsachilas"  
replace area = 22 if Region == "Sucumbios"  
replace area = 23 if Region == "Tungurahua"  
replace area = 24 if Region == "Zamora Chinchipe"  
replace area = 25 if Region == "Zona No Delimitada"    
drop v2
merge 1:1 area using `Xenofobia'

*Generar Tasa Xenofobia
gen TasaXenofobia = (Xenofobia/Total)*100
preserve
drop if Total < 100
drop _m 
*CAMBIAR MES NUMERO

export excel using "$user\TasaXenofobiaRegiont-2.xlsx", sheetreplace firstrow(variables)
restore 
drop if Total < 100
keep Region TasaXenofobia
gsort -TasaXenofobia
drop if TasaXenofobia == .
*CAMBIAR MES NUMERO
export delimited using"$user\TasaXenofobiaRegiont-2.csv", replace




