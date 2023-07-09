*Mapa de distribución de venezolanos

cd "C:\Users\JOSE\Desktop\Trabajo\BX\Ecuador\Boletín\Input\departamentos"

*Transformar archivos
ssc install shp2dta, replace
**
shp2dta using ecu_admbnda_adm1_inec_20190724, database(Ecuador) coordinates(ecuadorcoordinates) genid(id) replace

*
**
use Ecuador, clear
describe




**************************************************************************************************

**Creo que esto está de más
cd "/Users/juliodaly/Downloads/INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206"

shp2dta using INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206, database(Ecuador) coordinates(ecuadorcoordinates) genid(id)



use Peru, clear
describe
