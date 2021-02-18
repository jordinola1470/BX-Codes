*************************Programa 1***********************

/////////////////////////////////////////////////Informacion BrandWatch //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////

global user "/Users/juliodaly/Documents/Barometro/Mapas/DatosMapa"
cd "$user"


////////Por departamento/////////
****En caso de importar todo el documento**********************
*Xenofobia 
****
*CAMBIAR MES
import delimited "$user/Diciembre/Xenofobia.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
rename (v1 v3) (Region Xenofobia)
**Creacion de codigo de ciudades

gen area = 5 if Region == "Antioquia" 
replace area = 8 if Region == "Atlántico"  
replace area =11 if Region == "Bogota"  
replace area = 13 if Region == "Bolívar"  
replace area = 15 if Region == "Boyacá"  
replace area = 17 if Region == "Caldas"  
replace area = 20 if Region == "Cesar"  
replace area = 25 if Region == "Cundinamarca"  
replace area = 23 if Region == "Córdoba"  
replace area = 41 if Region == "Huila"   
replace area = 47 if Region == "Magdalena"   
replace area = 50 if Region == "Meta"  
replace area = 54 if Region == "Norte de Santander"  
replace area = 52 if Region == "Nariño"
replace area = 70 if Region == "Sucre"  
replace area = 19 if Region == "Cauca"  
replace area = 44 if Region == "La Guajira"  
replace area = 85 if Region == "Casanare"  
replace area = 18 if Region == "Caquetá"  
replace area = 81 if Region == "Arauca"  
replace area = 27 if Region == "Chocó"  
replace area = 63 if Region == "Quindío"  
replace area = 66 if Region == "Risaralda"  
replace area = 68 if Region == "Santander"  
replace area = 76 if Region == "Valle del Cauca"  
replace area = 73 if Region == "Tolima"  
replace area = 88 if Region == "San Andrés y Providencia"  
replace area = 86 if Region == "Putumayo"  
replace area = 95 if Region == "Guaviare"  
replace area = 99 if Region == "Vichada"  
drop v2

label define a 5 "Medellín AM" 8 "Barranquilla AM" 11 "Bogotá DC" 13 "Cartagena" 15 "Tunja" 17 "Manizales AM" 18 "Florencia" 19 "Popayán" 20 "Valledupar" 23 "Montería" 27 "Quibdó" 41 "Neiva" 44 "Riohacha" 47 "Santa Marta" ///
50 "Villavicencio" 52 "Pasto" 54 "Cúcuta AM" 63 "Armenia" 66"Pereira AM" 68 "Bucaramanga AM" 70 "Sincelejo" 73 "Ibagué" 76 "Cali AM" 98 "98"
label values area a 

tempfile Xenofobia 
save `Xenofobia'

**Ahora uso los totales para sacar la tasa de mensajes xenofobos 
*CAMBIAR MES

import delimited "$user/Diciembre/Total.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(11) colrange(1) clear 
rename (v1 v3) (Region Total)
**Creacion de codigo de ciudades

gen area = 5 if Region == "Antioquia" 
replace area = 8 if Region == "Atlántico"  
replace area =11 if Region == "Bogota"  
replace area = 13 if Region == "Bolívar"  
replace area = 15 if Region == "Boyacá"  
replace area = 17 if Region == "Caldas"  
replace area = 20 if Region == "Cesar"  
replace area = 25 if Region == "Cundinamarca"  
replace area = 23 if Region == "Córdoba"  
replace area = 41 if Region == "Huila"   
replace area = 47 if Region == "Magdalena"   
replace area = 50 if Region == "Meta"  
replace area = 54 if Region == "Norte de Santander"  
replace area = 52 if Region == "Nariño"
replace area = 70 if Region == "Sucre"  
replace area = 19 if Region == "Cauca"  
replace area = 44 if Region == "La Guajira"  
replace area = 85 if Region == "Casanare"  
replace area = 18 if Region == "Caquetá"  
replace area = 81 if Region == "Arauca"  
replace area = 27 if Region == "Chocó"  
replace area = 63 if Region == "Quindío"  
replace area = 66 if Region == "Risaralda"  
replace area = 68 if Region == "Santander"  
replace area = 76 if Region == "Valle del Cauca"  
replace area = 73 if Region == "Tolima"  
replace area = 88 if Region == "San Andrés y Providencia"  
replace area = 86 if Region == "Putumayo"  
replace area = 95 if Region == "Guaviare"  
replace area = 99 if Region == "Vichada"  
drop v2
merge 1:1 area using `Xenofobia'

*Generar Tasa Xenofobia
gen TasaXenofobia = (Xenofobia/Total)*100
preserve
drop if Total < 200
drop _m 
*CAMBIAR MES NUMERO

export excel using "/Users/juliodaly/Documents/Barometro/Datos Informe/TasaXenofobiaRegion12.xlsx", sheetreplace firstrow(variables)
restore 
drop if Total < 200
keep Region TasaXenofobia
gsort -TasaXenofobia
drop if TasaXenofobia == .
*CAMBIAR MES NUMERO
export delimited using"/Users/juliodaly/Documents/Barometro/Mapas/InfoMapasArcgis/TasaXenofobiaDepartamento12.csv", replace




