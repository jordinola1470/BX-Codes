*llevarnos una columna
clear all
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo"
use base_combinada, clear
keep obs Region odio
save "Mapas\Polígonos\datos_racismo.dta", replace
*Mapa de distribución de venezolanos
clear all
cd "C:\Users\JOSE\Desktop\Trabajo\BX\Racismo\Mapas\Polígonos"

*Transformar archivos
*ssc install shp2dta, replace

spshape2dta INEGI_Entidad_, replace
use INEGI_Entidad_, clear
collapse (lastnm) _CX _CY NOMBRE, by(ID)
save INEGI_Entidad_label, replace
use INEGI_Entidad__shp, clear
gen obs = _n
merge 1:1 obs using datos_racismo.dta
replace odio = 0 if odio == .
collapse (lastnm) _X _Y (lastnm) odio, by(_ID)
gen obs = _n
spmap odio using INEGI_Entidad__shp, id(obs) fcolor(Reds2) ndfcolor(dimgray) ndo(black) legstyle (1) name(Grafica_1, replace) clmethod(custom) clbreaks(0 0.2 0.4 0.6 0.8) title  (% Mensajes de odio Feb-07 Feb-28)
spmap engagements_n using INEGI_Entidad__shp, id(obs) fcolor(Reds2) ndfcolor(dimgray) ndo(black) label(data(INEGI_Entidad_label) xcoord(_CX) ycoord(_CY) label(NOMBRE) size(*0.7 ..) pos(12 0)) legstyle (1) name(Grafica_2, replace) title  (Normalized Engagement Feb-07 Mar-08)
*merge 1:m _ID using INEGI_Entidad__shp
shp2dta using "INEGI_Entidad_.shp", database("INEGI_Entidad_.dbf") coordinates(mexicocoordinates) genid(id) replace
*
**
use Ecuador, clear
describe

help normal()


**************************************************************************************************

**Creo que esto está de más
cd "/Users/juliodaly/Downloads/INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206"

shp2dta using INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206, database(Ecuador) coordinates(ecuadorcoordinates) genid(id)



use Peru, clear
describe
