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
gen area = 01 if Region == "Aguascalientes" 
replace area = 02 if Region == "Baja California" 
replace area = 03 if Region == "Baja California Sur"   
replace area = 04 if Region == "Campeche" 
replace area =07 if Region == "Chiapas"  
replace area = 08 if Region == "Chihuahua"  
replace area = 05 if Region == "Coahuila"  
replace area = 06 if Region == "Colima"  
replace area = 10 if Region == "Durango" 
replace area = 11 if Region == "Guanajuato"  
replace area = 12 if Region == "Guerrero"  
replace area = 13 if Region == "Hidalgo"  
replace area = 14 if Region == "Jalisco"   
replace area = 09 if Region == "Mexico City"   
replace area = 16 if Region == "Michoacán"  
replace area = 17 if Region == "Morelos"  
replace area = 15 if Region == "México"
replace area = 18 if Region == "Nayarit"  
replace area = 19 if Region == "Nuevo León"  
replace area = 20 if Region == "Oaxaca"  
replace area = 21 if Region == "Puebla"  
replace area = 22 if Region == "Querétaro"  
replace area = 23 if Region == "Quintana Roo"  
replace area = 24 if Region == "San Luis Potosí"  
replace area = 25 if Region == "Sinaloa" 
replace area = 26 if Region == "SONORA"  
replace area = 27 if Region == "Tabasco"  
replace area = 28 if Region == "Tamaulipas"  
replace area = 29 if Region == "Tlaxcala"  
replace area = 30 if Region == "Veracruz"  
replace area = 31 if Region == "Yucatán"  
replace area = 32 if Region == "Zacatecas"  
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
gen area = 01 if Region == "Aguascalientes" 
replace area = 02 if Region == "Baja California" 
replace area = 03 if Region == "Baja California Sur"   
replace area = 04 if Region == "Campeche" 
replace area =07 if Region == "Chiapas"  
replace area = 08 if Region == "Chihuahua"  
replace area = 05 if Region == "Coahuila"  
replace area = 06 if Region == "Colima"  
replace area = 10 if Region == "Durango" 
replace area = 11 if Region == "Guanajuato"  
replace area = 12 if Region == "Guerrero"  
replace area = 13 if Region == "Hidalgo"  
replace area = 14 if Region == "Jalisco"   
replace area = 09 if Region == "Mexico City"   
replace area = 16 if Region == "Michoacán"  
replace area = 17 if Region == "Morelos"  
replace area = 15 if Region == "México"
replace area = 18 if Region == "Nayarit"  
replace area = 19 if Region == "Nuevo León"  
replace area = 20 if Region == "Oaxaca"  
replace area = 21 if Region == "Puebla"  
replace area = 22 if Region == "Querétaro"  
replace area = 23 if Region == "Quintana Roo"  
replace area = 24 if Region == "San Luis Potosí"  
replace area = 25 if Region == "Sinaloa" 
replace area = 26 if Region == "SONORA"  
replace area = 27 if Region == "Tabasco"  
replace area = 28 if Region == "Tamaulipas"  
replace area = 29 if Region == "Tlaxcala"  
replace area = 30 if Region == "Veracruz"  
replace area = 31 if Region == "Yucatán"  
replace area = 32 if Region == "Zacatecas"   
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




