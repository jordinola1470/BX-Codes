*************************Programa 2***********************

/////////////////////////////////////////////////Gráficas de datos //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////
clear all
global user "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
cd "$user"
*cd "D:\Trabajo\Barómetro\BX\Racismo"

////////Por departamento/////////
*Unir los dos meses más recientes 

*Mes t-2
*CAMBIAR MES
import delimited "Base_estados_mexicanos_completa.csv", encoding(UTF-8) clear
rename estado Region 
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
replace area = 26 if Region == "Sonora"  
replace area = 27 if Region == "Tabasco"  
replace area = 28 if Region == "Tamaulipas"  
replace area = 29 if Region == "Tlaxcala"  
replace area = 30 if Region == "Veracruz"  
replace area = 31 if Region == "Yucatán"  
replace area = 32 if Region == "Zacatecas"
drop if area == .
egen total_negativo = sum(count_negativo)
gen odio_nacional = count_negativo/total_negativo
save "Base_estados_mexicanos_completa.dta", replace
tempfile Xenofobia 
save `Xenofobia'

**Mes t-1
*CAMBIAR MES

import delimited using "TasaXenofobiaRegiont-1.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
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
replace area = 26 if Region == "Sonora"  
replace area = 27 if Region == "Tabasco"  
replace area = 28 if Region == "Tamaulipas"  
replace area = 29 if Region == "Tlaxcala"  
replace area = 30 if Region == "Veracruz"  
replace area = 31 if Region == "Yucatán"  
replace area = 32 if Region == "Zacatecas"   
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
clear all
*global user "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
*cd "$user"
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
use "Base_estados_mexicanos_completa.dta", clear
tempfile Xenofobia 
save `Xenofobia'
 
*cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo\Mapas\Polígonos"
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo\Mapas\Polígonos"
use INEGI_Entidad__shp, clear
cap drop obs
gen obs = _n
save INEGI_Entidad__shp, replace
use INEGI_Entidad_, clear
rename ID area
destring area, replace
merge 1:m _ID using INEGI_Entidad__shp.dta
drop _merge
*global user "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
*cd "$user"
*merge m:1 area using Base_estados_mexicanos_completa.dta
merge m:1 area using `Xenofobia'
drop _CX _CY rec_header shape_order NOMBRE _merge
sort obs _ID
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
save "base_combinada.dta", replace
use "base_combinada.dta", replace
*ssc install spmap, replace
*collapse (sum) _X _Y (lastnm) engagements, by(area)
*drop if area == .
*sort area
*collapse (sum) _X _Y (lastnm) engagements, by(area)
sort obs
spmap using base_combinada.dta, id(obs)
spmap Region using INEGI_Entidad__shp, id(obs) fcolor(Reds) ndfcolor(dimgray) legstyle (2) name(Grafica_1, replace) title  (Engagement Feb-07 Mar-08)
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
