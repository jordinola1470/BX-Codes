clear all
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Graficas\Mapas y barras\Colombia"
import delimited "Xenofobia_candidatos_2021.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
drop v2
rename (v1 v3) (Departamento Xenofobia_2021)
save "Xenofobia_2021.dta", replace 
import delimited "Xenofobia_candidatos_2022.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
drop v2
rename (v1 v3) (Departamento Xenofobia_2022)
save "Xenofobia_2022.dta", replace 
import delimited "General_candidatos_2021.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
drop v2
rename (v1 v3) (Departamento General_2021)
save "General_candidatos_2021.dta", replace 
import delimited "General_candidatos_2022.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
drop v2
rename (v1 v3) (Departamento General_2022)
save "General_candidatos_2022.dta", replace 
merge 1:1 Departamento using "General_candidatos_2021.dta", nogen
merge 1:1 Departamento using "Xenofobia_2022.dta", nogen
merge 1:1 Departamento using "Xenofobia_2021.dta", nogen
replace General_2021 = 128703 if (Departamento == "Bogota") & (General_2021 == .)
replace General_2022 = 85474 if (Departamento == "Bogota") & (General_2022 == .)
gen tasa_xenofobia_2021 = Xenofobia_2021/General_2021
gen tasa_xenofobia_2022 = Xenofobia_2022/General_2022
rename Departamento Region
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
replace area = 96 if Region == "Guainía"
replace area = 98 if Region == "Amazonas"     
replace area = 99 if Region == "Vichada"
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
replace area = 52 if id == 17
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

help export excel

export excel "Tabla_2020_2021.xlsx", replace

spmap tasa_xenofobia_2021 using colomcoordinates, id(id) fcolor(Reds) ndfcolor(dimgray) legstyle (1) name(Grafica_1, replace) title  (Tasa de xenofobia enero-mayo 2021)
spmap tasa_xenofobia_2022 using colomcoordinates, id(id) fcolor(Reds) ndfcolor(dimgray) legstyle (1) name(Grafica_2, replace) title (Tasa de xenofobia enero-mayo 2022)

gr combine Grafica_1 Grafica_2, col(2) graphregion(color(white)) ///
	title("",color(black)) xsize(12) ysize(8) name(Gr,replace) 
	
graph export "mapa_odio_2021_2022.png", replace

egen min_x1=min(General_2022)
egen max_x1=max(General_2022)
gen normal_x1=(General_2022-min_x1)/(max_x1-min_x1)


spmap normal_x1 using colomcoordinates, id(id) fcolor(Blues) ndfcolor(dimgray) legstyle (1) name(Grafica_3, replace) title  (Mensajes sobre migrantes ene-mayo 2022)

merge 1:1 area using peticiones.dta, nogen
pwcorr Peticiones normal_x1
