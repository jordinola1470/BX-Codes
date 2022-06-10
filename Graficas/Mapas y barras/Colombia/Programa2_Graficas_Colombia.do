***************************************Programa 2***********************

**Este programa parte del archivo mapa.0m de cada mes para realizar los mapas de la tasa de xenofobia.
**Los datos están a nivel departamental 
** Este programa crea un mapa para el mes actual, el mes anterior y la comparación entre ambos


global user "C:\Users\JOSE\Desktop\Trabajo\BX\Graficas\Mapas y barras\Colombia"
cd "$user"
********************************************************************************
*1. Unir los dos meses más recientes 

*Mes t-2
*CAMBIAR MES
import delimited using "$user\Mapa02.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region

tempfile Xenofobia 
save `Xenofobia'

**Mes t-1
*CAMBIAR MES
import delimited using "$user\Mapa02.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region
rename tasaxenofobia tasaxenofobia2

merge 1:1 area using `Xenofobia'
drop _m

*2. Juntar con la información espacial de los departamentos de Colombia. (En caso de requerirse también se puede hacer por departamentos)
*Ya que tenemos la información, la juntamos con la info de los mapas
tempfile Xenofobia 
save `Xenofobia'
  
**cd "$user/Input/departamentos"
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
merge 1:1 area using "xenofobia_elecciones.dta"
*merge 1:1 area using `Xenofobia'
drop _m

*3. Creacion de mapas

*Mes anterior
replace porcentaje_peticiones = 0 if porcentaje_peticiones == .
replace Peticiones = 0 if Peticiones == .
replace total_peticiones = 0 if total_peticiones == .
spmap tasa_xenofobia using colomcoordinates, id(id) fcolor(Blues) ndfcolor(dimgray) legstyle (1) name(Grafica_1, replace) title  (Tasa de xenofobia enero-mayo 2022)


*Mes Actual
spmap tasaxenofobia2 using colomcoordinates, id(area) fcolor(Blues) ndfcolor(dimgray) legstyle (1)name(Grafica_2, replace) // title (Tasa Xenofobia Marzo)
gr export "$user\MapaTasaXenofobiaSeptiembrePeru.jpg", replace //cambiar mes

*spmap Incremento using colomcoordinates, id(id) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_3, replace) title (Incremento)

*Comparacion de dos meses
  gr combine Grafica_1 Grafica_2, col(2) graphregion(color(white)) ///
	title("",color(black)) xsize(12) ysize(8) name(Gr,replace) 
	
gr export "$user\TasaXenofobia112020.jpg", replace






