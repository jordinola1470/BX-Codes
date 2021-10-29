*************************Programa 1***********************

/////////////////////////////////////////////////Informacion BrandWatch //////////////////////////////////////////
////////////////////////////////////////////////Departamento///////////////////////////////

global user "C:\Users\JOSE\Desktop\Trabajo\BX\Graficas\Mapas y barras\Colombia"
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Graficas\Mapas y barras\Colombia"

**Renombrar documentos (Esto lo hago manual siguiendo el orden de descarga. Los documentos deben llamarse Total Xenofobia Salud Educacion Trabajo Seguridad .csv)


**Tasa de Xenofobia (Por Departamento)

*Esta parte del programa une todos los archivos de las categorias para calcular las relevancias de las categorias


*Xenofobia 
****
*CAMBIAR MES
import delimited "Xenofobia.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
rename (v1 v3) (Region Xenofobia)

*Falta la region de APURIMA, las regiones están ordenadas alfabeticamente en el id del mapa
drop if Region == "Lima"

**Creacion de codigo de ciudades

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
replace area = 99 if Region == "Vichada"  


drop v2


tempfile Xenofobia 
save `Xenofobia'

**Ahora pego todos los archivos de categorias
local archivos Educacion Salud Trabajo Seguridad
foreach x of local archivos {
*Xenofobia 
****
*CAMBIAR MES
import delimited "`x'.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(12) colrange(1) clear 
rename (v1 v3) (Region `x')

drop if Region == "Lima"

**Creacion de codigo de ciudades

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
replace area = 99 if Region == "Vichada" 


drop v2

merge 1:1 area using `Xenofobia', nogen

tempfile Xenofobia 
save `Xenofobia'
}

tempfile Xenofobia 
save `Xenofobia'


**Ahora uso los totales para sacar la tasa de mensajes xenofobos 
*CAMBIAR MES

import delimited "Total.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) rowrange(11) colrange(1) clear 
rename (v1 v3) (Region Total)
**Creacion de codigo de ciudades

drop if Region == "Lima"

**Creacion de codigo de ciudades

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
replace area = 99 if Region == "Vichada"  


drop v2
merge 1:1 area using `Xenofobia'

*Generar Tasas Xenofobia, Salud, Trabjo, Eduacion

local archivos Xenofobia Educacion Salud Trabajo Seguridad
foreach x of local archivos {

gen Tasa`x' = (`x'/Total)*100
}

*rename id area 

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
export delimited using "Mapa02.csv", replace //Cambiar mes
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

export delimited using "ParticipacionXenofobiaMigracion_Colombia.csv", replace




