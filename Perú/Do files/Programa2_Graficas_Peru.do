***************************************Programa 2***********************

**Este programa parte del archivo mapa.0m de cada mes para realizar los mapas de la tasa de xenofobia.
**Los datos están a nivel departamental 
** Este programa crea un mapa para el mes actual, el mes anterior y la comparación entre ambos
*"C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Input\departamentos"

global user "/Users/juliodaly/Dropbox/Mi Mac (MacBook Air de Julio)/Documents/Barometro/Peru"
cd "$user"
********************************************************************************
*1. Unir los dos meses más recientes 

*Mes t-2
*CAMBIAR MES
import delimited using "$user/Input/Input Informe Mensual/2021/Septiembre/Mapa02.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region

tempfile Xenofobia 
save `Xenofobia'

**Mes t-1
*CAMBIAR MES
import delimited using "$user/Input/Input Informe Mensual/2021/Septiembre/Mapa02.csv", bindquote(nobind) stripquote(yes) encoding(UTF-8) clear
rename region Region
rename tasaxenofobia tasaxenofobia2

merge 1:1 area using `Xenofobia'
drop _m

*2. Juntar con la información espacial de los departamentos de Colombia. (En caso de requerirse también se puede hacer por departamentos)
*Ya que tenemos la información, la juntamos con la info de los mapas
tempfile Xenofobia 
save `Xenofobia'


* Realizar eliminaciíon de departamentos con baja conectividad

use "C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Do files\clean_data.dta", clear
keep if Region == "Callao" | Region == "Ica" | Region == "La Libertad" | Region == "Lambayeque" | Region == "Lima" | Region == "Lima Province" | Region == "Madre de Dios" | Region == "Moquegua" | Region == "Piura" | Region == "Tacna" | Region == "Ancash" 

save "C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Do files\clean_data_conectada.dta", replace
  
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Input\departamentos"
use Peru, clear
describe 
rename id area
merge 1:1 area using "C:\Users\JOSE\Desktop\Trabajo\BX\Perú\Do files\clean_data_conectada.dta"
drop _m

*3. Creacion de mapas

*Mes anterior

help spmap


spmap tasa_xenofobia_2021 using perucoordinates, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1) name(Grafica_1, replace)

*clm(custom) clb(0 0.05 0.1 0.2 0.7)

*Mes Actual
spmap tasa_xenofobia_2022 using perucoordinates, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1) name(Grafica_2, replace) // title (Tasa Xenofobia Marzo)

*clm(custom) clb(0 0.05 0.1 0.2 0.7)

gr export "$user/Datos Informe/2021/Septiembre/MapaTasaXenofobiaSeptiembrePeru.jpg", replace //cambiar mes

*spmap Incremento using colomcoordinates, id(id) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_3, replace) title (Incremento)

*Comparacion de dos meses
  gr combine Grafica_1 Grafica_2, col(2) graphregion(color(white)) ///
	title("",color(black)) xsize(12) ysize(8) name(Gr,replace) 
	
gr export "grafico_comparativo.png", replace

spmap Cambionormalizado using perucoordinates, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1) clm(custom) clb(0 0.2 0.4 0.6 0.8 1)  name(Grafica_3, replace)

gr export "grafico_cambio_normalizado.png", replace






