clear all
cd "D:\Trabajo\Barómetro\BX\Xenofobia Per cápita"
use "PANEL_CARACTERISTICAS_GENERALES(2021).dta", clear
sort ano
keep if ano == 2020
collapse (lastnm) depto (sum) pobl_tot, by (coddepto)
gen departamento = upper(depto)
replace departamento = "VALLE DEL CAUCA" if departamento == "VALLE CAUCA"
replace departamento = "BOGOTA" if departamento == "BOGOTA DC"
replace departamento = "NORTE DE SANTANDER" if departamento == "NORTE SANTANDER"
replace departamento = "SAN ANDRES Y PROVIDENCIA" if departamento == "ARCHIPIELAGO SAN ANDRES PROVIDENCIA Y SANTA CATALINA"
replace departamento = "LA GUAJIRA" if departamento == "GUAJIRA"
save población_departamento, replace


import excel using "Xenofobia_2021_depto.xlsx", firstrow clear
split Location, parse(",")
drop Location Location2
rename Location1 depto
gen departamento_coma = upper(depto)
gen departamento = ustrupper( ustrregexra( ustrnormalize( departamento_coma, "nfd" ) , "\p{Mark}", "" ) )
merge 1:1 departamento using "población_departamento.dta"
replace Xenofobia = 0 if Xenofobia == .
drop departamento_coma depto _merge
gen Xenofobia_per_capita = Xenofobia/pobl_tot
export excel "Base_final_xenofobia_per_capita_2021.xlsx", replace