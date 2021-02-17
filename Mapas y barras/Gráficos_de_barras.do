/* Gráficas */
clear all

cd "C:\Users\JOSE\Desktop\Trabajo\BX\Mapas"

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

keep if porcentaje >= .0148028

set obs `=_N+1'

egen resto = sum(porcentaje)

replace resto = 1 - resto

replace Departamento = "Resto" if Departamento == ""
replace porcentaje = resto if porcentaje == .
drop resto

replace porcentaje = porcentaje*100

graph hbar porcentaje, ///
over(Departamento, label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Porcentaje por departamentos", size(small)) ///
title("Participación de mensajes de xenofobia por departamentos" ///
, span size(medium)) ///
blabel(bar, format(%4.1f)) ///
intensity(25) ///
note("Resto: comprende la suma de participación de 23 departamentos con aportación individual baja", size(tiny)) ///
caption("Datos tomados entre 1/01/2021 - 16/02/2021", size(tiny)) ///
graphregion(fcolor(white))
graph export "Xenofobia_Departamentos.png", as(png) replace

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

keep if porcentaje >= .0083803

set obs `=_N+1'

egen resto = sum(porcentaje)

replace resto = 1 - resto

replace Ciudades = "Resto" if Ciudades == ""
replace porcentaje = resto if porcentaje == .
drop resto

replace porcentaje = porcentaje*100

replace Ciudades = "Bogotá" if Ciudades == "Bogota"
replace Ciudades = "Medellín" if Ciudades == "Medellin"
replace Ciudades = "Cúcuta" if Ciudades == "Cucuta"
replace Ciudades = "Ibagué" if Ciudades == "Ibague"


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
