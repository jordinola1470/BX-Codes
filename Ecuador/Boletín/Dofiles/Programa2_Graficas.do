*************************Programa 2***********************

/////////////////////////////////////////////////Gráficas de datos //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////
clear all
global user "C:\Users\JOSE\Desktop\Trabajo\BX\Ecuador\Boletín\Input"
cd "$user"


////////Por departamento/////////
*Unir los dos meses más recientes 

*Mes t-2
*CAMBIAR MES
import delimited using "TasaXenofobiaRegiont-2.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region
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

tempfile Xenofobia 
save `Xenofobia'

**Mes t-1
*CAMBIAR MES

import delimited using "TasaXenofobiaRegiont-1.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region
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
rename tasaxenofobia tasaxenofobia2

merge 1:1 area using `Xenofobia'
drop _m


**Graficas

**Tablas de Tasa Xenofobia 
gen Incremento = tasaxenofobia2 - tasaxenofobia
gsort -tasaxenofobia2
export excel tasaxenofobia tasaxenofobia2 Region using "TasaXenofobiaRegion.xlsx", sheetreplace firstrow(variables)

gsort -Incremento


**Mapas


*Ya que tenemos la información, la juntamos con la info de los mapas
tempfile Xenofobia 
save `Xenofobia'
 
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Ecuador\Boletín\Input\departamentos"
use Ecuador, clear
describe 
destring id, replace
rename id area
merge 1:1 area using `Xenofobia'
drop _m

ssc install spmap, replace
spmap tasaxenofobia using ecuadorcoordinates.dta, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1) name(Grafica_1, replace) title  (agosto 2021)
spmap tasaxenofobia2 using ecuadorcoordinates.dta, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_2, replace) title (julio 2021)

*spmap Incremento using colomcoordinates, id(id) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_3, replace) title (Incremento)

  gr combine Grafica_1 Grafica_2, col(2) graphregion(color(white)) ///
	title("",color(black)) xsize(12) ysize(8) name(Gr,replace) 
	
gr export "C:\Users\JOSE\Desktop\Trabajo\BX\Ecuador\Boletín\Datos Informe\TasaXenofobia.png", replace

/*
CORRER HASTA AQUÍ, ESO YA ES DE LA TESIS DE JULIO
*/

drop if tasaxenofobia == .

************************************************************************************************************
*Con datos de muertes violentas por departamento 
tempfile Xenofobia 
save `Xenofobia'

import delimited "/Users/juliodaly/Documents/Barometro/Mapas/InfoMapasArcgis/MuertesViolentasDep.csv", encoding(UTF-8) clear 
rename departamentohecho Region
gen area = 5 if Region == "Antioquia" 
replace area = 8 if Region == "Atlántico"  
replace area =11 if Region == "Bogotá, D.C."  
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
drop if area == .


merge 1:1 area using `Xenofobia'
drop _m

**Graficas
twoway (scatter tasaxenofobia total, msymbol(circle) mlabel(Region)),graphregion(color(white)) ///
title (Tasa de Xenofobia y muertes violentas) xtitle(Cantidad de muertes violentas de migrantes venezolanos) ytitle(Tasa de mensajes xenofobia)

tempfile Violencia 
save `Violencia'


**Juntar con cantidad de migrantes
**Usando datos PEP
use "/Users/juliodaly/Desktop/PEG/Crimen/Trabajo/Bases/municipal/BaseCrimenMigracionMunicipalProporCenso.dta",clear
collapse (sum) MigrantesPEP, by (area)
merge 1:1 area using `Violencia'
drop if area == 98


gen TasaViolencia = (total/MigrantesPEP)*1000



///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Tablas y Graficas/////////////////////////////////////////////////


**Graficas 

*Nominal


*Xenofobia Migrantes
twoway (scatter tasaxenofobia MigrantesPEP, msymbol(oh) mlabel(Region)),graphregion(color(white)) ///
title (Tasa de Xenofobia y cantidad de migrantes) xscale(log) xtitle(#Migrantes PEP) ytitle(Tasa de mensajes xenofobia) yline(10.37)

*Xenofobia violencia 
twoway (scatter tasaxenofobia total [aw = MigrantesPEP], msymbol(oh) mlabel(Region)),graphregion(color(white)) ///
title (Tasa de Xenofobia y muertes violentas) xtitle(Cantidad de muertes violentas de migrantes venezolanos) ytitle(Tasa de mensajes xenofobia) xline(16.5) yline(10.37)


twoway (scatter tasaxenofobia total [aw = MigrantesPEP], msymbol(oh)) ,graphregion(color(white)) xtitle(# muertes violentas de migrantes venezolanos) ytitle(% xenofobia)  xline(16.5) yline(10.37)

*En tasa 

twoway (scatter tasaxenofobia TasaViolencia [aw = MigrantesPEP] if area != 19, msymbol(oh)),graphregion(color(white)) xtitle(# muertes violentas de migrantes venezolanos) ytitle(% xenofobia) xlabel(0(0.1)3)


spmap relig1 using "Italy-RegionsCoordinates.dta", id(id)  /// 
  fcolor(BuRd) ocolor(white ..) /// 
  label(data(spmaplabels) xcoord(xcoord)  ycoord(ycoord) ///
  label(region) by(labtype) size(*0.85 ..) pos(12 0) )
