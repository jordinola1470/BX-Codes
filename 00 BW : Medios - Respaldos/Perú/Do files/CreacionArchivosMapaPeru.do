*Mapa de distribución de venezolanos

cd "/Users/juliodaly/Dropbox/Mi Mac (MacBook Air de Julio)/Documents/Barometro/Banco Mundial/Perú/Input/departamentos"

*Transformar archivos

shp2dta using DEPARTAMENTOS, database(Peru) coordinates(perucoordinates) genid(id)

*
use Peru, clear
describe



cd "/Users/juliodaly/Downloads/INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206"

shp2dta using INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206, database(Peru) coordinates(perucoordinates) genid(id)



use Peru, clear
describe
