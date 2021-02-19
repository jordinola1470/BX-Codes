/* Gráficas */
clear all

cd "C:\Users\JOSE\Desktop\Trabajo\BX\Mapas y barras"

* Departamentos

import delimited "xenofobia_regiones", rowrange(12:40)

rename v1 Location
rename v2 Xenofobia

split Location, parse(,) gen(Departamento)

drop Location Departamento2

rename Departamento1 Departamento

replace Departamento = "Atlántico" if Departamento == "AtlÃ¡ntico"
replace Departamento = "Bolívar" if Departamento == "BolÃ­var"
replace Departamento = "Córdoba" if Departamento == "CÃ³rdoba"
replace Departamento = "Boyacá" if Departamento == "BoyacÃ¡"
replace Departamento = "Quindío" if Departamento == "QuindÃ­o"
replace Departamento = "Nariño" if Departamento == "NariÃ±o"
replace Departamento = "Caquetá" if Departamento == "CaquetÃ¡"
replace Departamento = "Chocó" if Departamento == "ChocÃ³"
replace Departamento = "San Andrés y Providencia" if Departamento == "San AndrÃ©s y Providencia"
replace Departamento = "Bogota" if Departamento == "Bogotá"

egen Totales = sum(Xenofobia)

gen porcentaje = Xenofobia/Totales

keep if porcentaje >= .0087840

drop if Departamento == "Magdalena" || Departamento == "Bolívar" || Departamento == "Risaralda" || Departamento == "Norte de Santander"

set obs `=_N+1'

egen resto = sum(porcentaje)

replace resto = 1 - resto

replace Departamento = "Resto" if Departamento == ""
replace porcentaje = resto if porcentaje == .
drop resto Totales

replace porcentaje = porcentaje*100

save "xenofobia_regiones", replace

graph hbar porcentaje, ///
over(Departamento, label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Porcentaje por departamentos", size(small)) ///
title("Participación de mensajes de xenofobia por departamentos" ///
, span size(medium)) ///
blabel(bar, format(%4.1f)) ///
intensity(25) ///
note("Resto: comprende la suma de participación de 21 departamentos con aportación individual baja", size(tiny)) ///
caption("Datos tomados entre 1/01/2021 - 16/02/2021", size(tiny)) ///
graphregion(fcolor(white))
graph export "Xenofobia_Departamentos.png", as(png) replace

clear all

import delimited "migracion_regiones", rowrange(11:40)

rename v1 Location
rename v2 Migracion

split Location, parse(,) gen(Departamento)

drop Location Departamento2

rename Departamento1 Departamento

replace Departamento = "Atlántico" if Departamento == "AtlÃ¡ntico"
replace Departamento = "Bolívar" if Departamento == "BolÃ­var"
replace Departamento = "Córdoba" if Departamento == "CÃ³rdoba"
replace Departamento = "Boyacá" if Departamento == "BoyacÃ¡"
replace Departamento = "Quindío" if Departamento == "QuindÃ­o"
replace Departamento = "Nariño" if Departamento == "NariÃ±o"
replace Departamento = "Caquetá" if Departamento == "CaquetÃ¡"
replace Departamento = "Chocó" if Departamento == "ChocÃ³"
replace Departamento = "San Andrés y Providencia" if Departamento == "San AndrÃ©s y Providencia"
replace Departamento = "Bogota" if Departamento == "Bogotá"

egen Totales = sum(Migracion)

gen porcentajeM = Migracion/Totales

keep if porcentajeM >= .0083518

drop if Departamento == "Magdalena" || Departamento == "Bolívar" || Departamento == "Risaralda" || Departamento == "Norte de Santander" || Departamento == "Cesar"

set obs `=_N+1'

egen resto = sum(porcentajeM)

replace resto = 1 - resto

replace Departamento = "Resto" if Departamento == ""
replace porcentajeM = resto if porcentajeM == .
drop resto Totales

replace porcentajeM = porcentajeM*100

merge 1:1 Departamento using "xenofobia_regiones"

encode Departamento, gen(DepartamentoEncoded)

label var porcentajeM "Migración"

label var porcentaje "Xenofobia"

twoway (bar porcentaje DepartamentoEncoded, color(orange%30)) (bar porcentajeM DepartamentoEncoded, color(blue%30)), ///
ytitle("Porcentaje por departamentos", size(small)) ///
xtitle("Departamentos") ///
title("Participación de mensajes de xenofobia y migración por departamentos", span size(medium)) ///
xlabel(1 "Antioquia" 2 "Atlántico" 3 "Bogotá" 4 "Meta" 5 "Resto" 6 "Santander" 7 "Tolima" 8 "Valle del Cauca", labsize(small)) ///
note("Resto: comprende la suma de participación de 21 departamentos con aportación individual baja", size(tiny)) ///
caption("Datos tomados entre 1/01/2021 - 16/02/2021", size(tiny)) ///
graphregion(fcolor(white))

graph export "Barras_Departamentos.png", as(png) replace

* Ciudades
clear all
import delimited "xenofobia_ciudades", rowrange(12:58)

rename v1 Location
rename v2 Xenofobia
rename v3 Population

split Location, parse(,) gen(Ciudades)

drop Ciudades2 Ciudades3 Location

rename Ciudades1 Ciudades 

egen Totales = sum(Xenofobia)

gen porcentaje = Xenofobia/Totales
/*
keep if porcentaje >= .0083803

set obs `=_N+1'

egen resto = sum(porcentaje)

replace resto = 1 - resto
*/

replace Ciudades = "Resto" if Ciudades == ""
*replace porcentaje = resto if porcentaje == .

replace porcentaje = porcentaje*100

replace Ciudades = "Bogotá" if Ciudades == "Bogota"
replace Ciudades = "Medellín" if Ciudades == "Medellin"
replace Ciudades = "Cúcuta" if Ciudades == "Cucuta"
replace Ciudades = "Ibagué" if Ciudades == "Ibague"

save "xenofobia_ciudades", replace

graph hbar porcentaje, ///
over(Ciudades, label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Porcentaje por ciudades", size(small)) ///
title("Participación de mensajes de xenofobia por ciudades" ///
, span size(medium)) ///
blabel(bar, format(%4.1f)) ///
intensity(25) ///
note("Resto: comprende la suma de participación 37 ciudades con aportación individual baja", size(tiny)) ///
caption("Datos tomados entre 1/01/2021 - 16/02/2021", size(tiny)) ///
graphregion(fcolor(white))
graph export "Xenofobia_Ciudades.png", as(png) replace

clear all

import delimited "migracion_ciudades", rowrange(11:40)

rename v1 Location
rename v2 Migracion

split Location, parse(,) gen(Ciudades)

drop Ciudades2 Ciudades3 Location

rename Ciudades1 Ciudades 


egen Totales = sum(Migracion)

gen porcentajeM = Migracion/Totales

/*
keep if porcentajeM >= .0083952


set obs `=_N+1'

egen resto = sum(porcentajeM)

replace resto = 1 - resto
*/

replace Ciudades = "Resto" if Ciudades == ""
*replace porcentajeM = resto if porcentajeM == .
drop Totales

replace porcentajeM = porcentajeM*100

replace Ciudades = "Bogotá" if Ciudades == "Bogota"
replace Ciudades = "Medellín" if Ciudades == "Medellin"
replace Ciudades = "Cúcuta" if Ciudades == "Cucuta"
replace Ciudades = "Ibagué" if Ciudades == "Ibague"

merge 1:1 Ciudades using "xenofobia_ciudades"


label var porcentajeM "Migración"

label var porcentaje "Xenofobia"

drop if _merge != 3

sort porcentaje

keep if porcentaje >= .8380351

set obs `=_N+1'

egen restoM = sum(porcentajeM)

egen resto = sum(porcentaje)

replace resto = 100 - resto

replace restoM = 100 - restoM

replace Ciudades = "Resto" if Ciudades == ""
replace porcentajeM = restoM if Ciudades == "Resto" 
replace porcentaje = resto if Ciudades == "Resto"

encode Ciudades, gen(CiudadesEncoded)

sort CiudadesEncoded

twoway (bar porcentaje CiudadesEncoded, color(orange%30)) (bar porcentajeM CiudadesEncoded, color(blue%30)), ///
ytitle("Porcentaje por ciudades", size(small)) ///
xtitle("Ciudades") ///
title("Participación de mensajes de xenofobia y migración por ciudades", span size(medium)) ///
xlabel(1 "Barranquilla" 2 "Bogotá" 3 "Bucaramanga" 4 "Cali" 5 "Cartagena" 6 "Cúcuta" 7 "Ibagué" 8 "Medellín" 9 "Pereira" 10 "Resto" 11 "Villavicencio", labsize(tiny)) ///
note("Resto: comprende la suma de participación 37 ciudades con aportación individual baja", size(tiny)) ///
caption("Datos tomados entre 1/01/2021 - 16/02/2021", size(tiny)) ///
graphregion(fcolor(white))

graph export "Barras_Ciudades.png", as(png) replace