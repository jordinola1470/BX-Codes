***************************************Programa 2***********************

**Este programa parte del archivo mapa.0m de cada mes para realizar los mapas de la tasa de xenofobia.
**Los datos están a nivel departamental 
** Este programa crea un mapa para el mes actual, el mes anterior y la comparación entre ambos


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
  
cd "$user/Input/departamentos"
use Peru, clear
describe 
rename id area
merge 1:1 area using `Xenofobia'
drop _m

*3. Creacion de mapas

*Mes anterior

spmap tasaxenofobia using perucoordinates, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1) name(Grafica_1, replace) title  (Abril 2021)


*Mes Actual
spmap tasaxenofobia2 using perucoordinates, id(area) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_2, replace) // title (Tasa Xenofobia Marzo)
gr export "$user/Datos Informe/2021/Septiembre/MapaTasaXenofobiaSeptiembrePeru.jpg", replace //cambiar mes

*spmap Incremento using colomcoordinates, id(id) fcolor(Oranges) ndfcolor(dimgray) legstyle (1)name(Grafica_3, replace) title (Incremento)

*Comparacion de dos meses
  gr combine Grafica_1 Grafica_2, col(2) graphregion(color(white)) ///
	title("",color(black)) xsize(12) ysize(8) name(Gr,replace) 
	
gr export "$user/Datos Informe/2021/Septiembre/TasaXenofobia112020.jpg", replace






