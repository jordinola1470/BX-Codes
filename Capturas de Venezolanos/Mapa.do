clear all
global user "C:\Users\JOSE\Desktop\Trabajo\BX\Capturas de Venezolanos"
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Capturas de Venezolanos"
*cd "D:\Trabajo\Barómetro\BX\Capturas de Venezolanos"
import excel "Participación_migrantes_crimen.xlsx", firstrow 

gen area = 5 if Region == "Antioquia" 
replace area = 8 if Region == "Atlantico"  
replace area =11 if Region == "Bogotá"  
replace area = 13 if Region == "Bolivar"  
replace area = 15 if Region == "Boyacá"  
replace area = 17 if Region == "Caldas"  
replace area = 20 if Region == "Cesar"  
replace area = 25 if Region == "Cundinamarca"  
replace area = 23 if Region == "Cordoba"  
replace area = 41 if Region == "Huila"   
replace area = 47 if Region == "Magdalena Medio"   
replace area = 50 if Region == "Meta"  
replace area = 54 if Region == "Norte de Santander"  
replace area = 52 if Region == "Nariño"
replace area = 70 if Region == "Sucre"  
replace area = 19 if Region == "Cauca"  
replace area = 44 if Region == "Guajira"  
replace area = 85 if Region == "Casanare"  
replace area = 18 if Region == "Caqueta"  
replace area = 81 if Region == "Arauca"  
replace area = 27 if Region == "Choco"  
replace area = 63 if Region == "Quindio"  
replace area = 66 if Region == "Risaralda"  
replace area = 68 if Region == "Santander"  
replace area = 76 if Region == "Valle del Cauca"  
replace area = 73 if Region == "Tolima"  
replace area = 88 if Region == "San Andrés y Providencia"  
replace area = 86 if Region == "Putumayo"  
replace area = 95 if Region == "Guaviare"  
replace area = 99 if Region == "Vichada"  
replace area = 98 if Region == "Amazonas" 
replace area = 96 if Region == "Guainia" 
replace area = 97 if Region == "Vaupes" 

tempfile datos 
save `datos'

use colombia, clear
describe 
rename NOMBRE_DPT Region
gen area = 5 if Region == "ANTIOQUIA" 
replace area = 8 if Region == "ATLANTICO"  
replace area =11 if Region == "SANTAFE DE BOGOTA D.C"  
replace area = 13 if Region == "BOLIVAR"  
replace area = 15 if Region == "BOYACA"  
replace area = 17 if Region == "CALDAS"  
replace area = 20 if Region == "CESAR"  
replace area = 25 if Region == "CUNDINAMARCA"  
replace area = 23 if Region == "CORDOBA"  
replace area = 41 if Region == "HUILA"   
replace area = 47 if Region == "MAGDALENA"   
replace area = 50 if Region == "META"  
replace area = 54 if Region == "NORTE DE SANTANDER"  
replace area = 52 if id == 17 /* Nariño*/
replace area = 70 if Region == "SUCRE"  
replace area = 19 if Region == "CAUCA"  
replace area = 44 if Region == "LA GUAJIRA"  
replace area = 85 if Region == "CASANARE"  
replace area = 18 if Region == "CAQUETA"  
replace area = 81 if Region == "ARAUCA"  
replace area = 27 if Region == "CHOCO"  
replace area = 63 if Region == "QUINDIO"  
replace area = 66 if Region == "RISARALDA"  
replace area = 68 if Region == "SANTANDER"  
replace area = 76 if Region == "VALLE DEL CAUCA"  
replace area = 73 if Region == "TOLIMA"  
replace area = 88 if Region == "ARCHIPIELAGO DE SAN ANDRES PROVIDENCIA Y SANTA CATALINA"  
replace area = 86 if Region == "PUTUMAYO"
replace area = 98 if Region == "AMAZONAS"   
replace area = 95 if Region == "GUAVIARE"  
replace area = 99 if Region == "VICHADA"  
replace area = 96 if Region == "GUAINIA" 
replace area = 97 if Region == "VAUPES" 

merge 1:1 area using `datos', nogen 

save "Base_entera.dta", replace
replace TasaparticipaciónenCrimen = 0 if TasaparticipaciónenCrimen == .
spmap TasaparticipaciónenCrimen using colomcoordinates, id(id) fcolor(Reds) ndfcolor(dimgray) legstyle (1) name(Grafica_2, replace)

graph export "mapa.png", replace