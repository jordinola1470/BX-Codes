*************************Programa 1***********************

/////////////////////////////////////////////////Informacion BrandWatch //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////

global user "C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Do files"
cd "$user"

**Renombrar documentos (Esto lo hago manual siguiendo el orden de descarga. Los documentos deben llamarse Total Xenofobia Salud Educacion Trabajo Seguridad .csv)


**Tasa de Xenofobia (Por Departamento)

*Esta parte del programa une todos los archivos de las categorias para calcular las relevancias de las categorias


*Xenofobia 
****
*CAMBIAR MES
import excel "Perú_xenofobia.xlsx", firstrow clear 
split Region, parse(",")
drop Region
rename Region1 Region
*rename (v1 v3) (Region Xenofobia)

*Falta la region de APURIMA, las regiones están ordenadas alfabeticamente en el id del mapa
drop if Region == "Lima"

**Creacion de codigo de ciudades

gen area = 1 if Region == "Amazonas" 
replace area = 2 if Region == "Ancash"  
replace area = 3 if Region == "Apurímac"  
replace area = 4 if Region == "Arequipa"  
replace area = 5 if Region == "Ayacucho"  
replace area = 6 if Region == "Cajamarca"  
replace area = 7 if Region == "Callao"  
replace area = 8 if Region == "Cusco"  
replace area = 9 if Region == "Huancavelica"  
replace area = 10 if Region == "Huánuco"   
replace area = 11 if Region == "Ica"   
replace area = 12 if Region == "Junín"  
replace area = 13 if Region == "La Libertad"  
replace area = 14 if Region == "Lambayeque"
replace area = 15 if Region == "Lima Province"  
replace area = 16 if Region == "Loreto"  
replace area = 17 if Region == "Madre de Dios"  
replace area = 18 if Region == "Moquegua"  
replace area = 19 if Region == "Pasco"  
replace area = 20 if Region == "Piura"  
replace area = 21 if Region == "Puno"  
replace area = 22 if Region == "San Martín"  
replace area = 23 if Region == "Tacna"  
replace area = 24 if Region == "Tumbes"  
replace area = 25 if Region == "Ucayali"  
save "clean_data.dta", replace

drop v2


tempfile Xenofobia 
save `Xenofobia'

**Ahora pego todos los archivos de categorias
local archivos Educacion Salud Trabajo Seguridad
foreach x of local archivos {
*Xenofobia 
****
*CAMBIAR MES
import delimited "$user/Septiembre/`x'.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
rename (v1 v3) (Region `x')

drop if Region == "Lima"

**Creacion de codigo de ciudades

gen area = 1 if Region == "Amazonas" 
replace area = 2 if Region == "Ancash"  
replace area = 3 if Region == "Apurimac"  
replace area = 4 if Region == "Arequipa"  
replace area = 5 if Region == "Ayacucho"  
replace area = 6 if Region == "Cajamarca"  
replace area = 7 if Region == "Callao"  
replace area = 8 if Region == "Cusco"  
replace area = 9 if Region == "Huancavelica"  
replace area = 10 if Region == "Huánuco"   
replace area = 11 if Region == "Ica"   
replace area = 12 if Region == "Junín"  
replace area = 13 if Region == "La Libertad"  
replace area = 14 if Region == "Lambayeque"
replace area = 15 if Region == "Lima Province"  
replace area = 16 if Region == "Loreto"  
replace area = 17 if Region == "Madre de Dios"  
replace area = 18 if Region == "Moquegua"  
replace area = 19 if Region == "Pasco"  
replace area = 20 if Region == "Piura"  
replace area = 21 if Region == "Puno"  
replace area = 22 if Region == "San Martín"  
replace area = 23 if Region == "Tacna"  
replace area = 24 if Region == "Tumbes"  
replace area = 25 if Region == "Ucayali"  


drop v2

merge 1:1 area using `Xenofobia', nogen

tempfile Xenofobia 
save `Xenofobia'
}

tempfile Xenofobia 
save `Xenofobia'


**Ahora uso los totales para sacar la tasa de mensajes xenofobos 
*CAMBIAR MES

import delimited "$user/Septiembre/Total.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(11) colrange(1) clear 
rename (v1 v3) (Region Total)
**Creacion de codigo de ciudades

drop if Region == "Lima"

**Creacion de codigo de ciudades

gen area = 1 if Region == "Amazonas" 
replace area = 2 if Region == "Ancash"  
replace area = 3 if Region == "Apurimac"  
replace area = 4 if Region == "Arequipa"  
replace area = 5 if Region == "Ayacucho"  
replace area = 6 if Region == "Cajamarca"  
replace area = 7 if Region == "Callao"  
replace area = 8 if Region == "Cusco"  
replace area = 9 if Region == "Huancavelica"  
replace area = 10 if Region == "Huánuco"   
replace area = 11 if Region == "Ica"   
replace area = 12 if Region == "Junín"  
replace area = 13 if Region == "La Libertad"  
replace area = 14 if Region == "Lambayeque"
replace area = 15 if Region == "Lima Province"  
replace area = 16 if Region == "Loreto"  
replace area = 17 if Region == "Madre de Dios"  
replace area = 18 if Region == "Moquegua"  
replace area = 19 if Region == "Pasco"  
replace area = 20 if Region == "Piura"  
replace area = 21 if Region == "Puno"  
replace area = 22 if Region == "San Martín"  
replace area = 23 if Region == "Tacna"  
replace area = 24 if Region == "Tumbes"  
replace area = 25 if Region == "Ucayali"  


drop v2
merge 1:1 area using `Xenofobia'

*Generar Tasas Xenofobia, Salud, Trabjo, Eduacion

local archivos Xenofobia Educacion Salud Trabajo Seguridad
foreach x of local archivos {

gen Tasa`x' = (`x'/Total)*100
}

*rename id area 
*****************************************************************************************************
*1. FIFA 
preserve 
keep Region area Total TasaXenofobia TasaEducacion TasaSalud TasaTrabajo TasaSeguridad
order Region area Total TasaXenofobia TasaEducacion TasaSalud TasaTrabajo TasaSeguridad 
gsort -Total
export delimited using "/Users/juliodaly/Dropbox/Mi Mac (MacBook Air de Julio)/Documents/Barometro/Peru/Datos Informe/2021/Septiembre/DiamantesSeptiembrePeru.csv", replace //Cambiar mes
restore 
*****************************************************************************************************


*****************************************************************************************************
*Tabla para Barras (Esto es si queremos barras por departamento con la tasa de xenofobia. Por ahora esto ya no va en los boletines)
*CAMBIAR MES NUMERO
*preserve
*drop if Total < 200
*keep Region TasaXenofobia
*gsort TasaXenofobia
*drop if TasaXenofobia == .
*export excel using "/Users/juliodaly/Documents/Barometro/Datos Informe/TasaXenofobiaRegion12.xlsx", sheet("Enero21") firstrow(variables) sheetreplace
*restore 
*****************************************************************************************************
*2. Participación Xenofobia y Migración / Info para mapa Tasa Xenofobia 

*Eliminar los departamentos que tienen pocos mensajes
drop if Total < 100

*Tasa departamento
egen TotalXenofobia = sum(Xenofobia)
gen XenofobiaDepartamento = (Xenofobia/TotalXenofobia)*100
*Tasa migracion departamento
egen TotalMigracion = sum(Total)
gen MigracionDepartamento = (Total/TotalMigracion)*100


*Info para mapa Tasa Xenofobia  
preserve 
keep Region area TasaXenofobia XenofobiaDepartamento MigracionDepartamento
export delimited using "/$user/Septiembre/Mapa02.csv", replace //Cambiar mes
restore 


*Participación Xenofobia y Migración por departamento 
*Vamos a utilizar los dos departamentos con mayor incidencia en migración y 2 con mayor tasa de xenofobia 

keep Region area TasaXenofobia XenofobiaDepartamento MigracionDepartamento
gsort -TasaXenofobia 
gen i = _n
gsort -MigracionDepartamento
gen m = _n
gen Informe = (i < 3 | m < 4)  //El criterio es los 3 departamentos con mayor incidencia migracion y 2 departamentos con mayor tasa de xenofobia. El resto se promedia

tempfile Xenofobia 
save `Xenofobia'

collapse (sum) area XenofobiaDepartamento MigracionDepartamento if Informe == 0
replace area = 99 if area != 1

append using `Xenofobia'

replace Informe = 1 if Informe == .

*keep if Informe == 1
gsort -Informe
order Region area XenofobiaDepartamento MigracionDepartamento
keep Region XenofobiaDepartamento MigracionDepartamento Informe TasaXenofobia  
replace Region = "Resto" if Region == ""

export delimited using "/Users/juliodaly/Dropbox/Mi Mac (MacBook Air de Julio)/Documents/Barometro/Peru/Datos Informe/2021/Septiembre/ParticipacionXenofobiaMigracion_Peru.csv", replace




