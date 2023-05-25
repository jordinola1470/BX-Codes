cd "C:\Users\JOSE\Desktop\Trabajo\BX\Capturas de Venezolanos\Bases de medios"
import excel using "Medios_seguridad_general_authors.xlsx" , firstrow clear
save Medios_seguridad_general_authors.dta, replace
import excel using "Medios_seguridad_migrantes_authors.xlsx" , firstrow clear
save Medios_seguridad_migrantes_authors.dta, replace

merge 1:1 Medio using Medios_seguridad_general_authors

export excel "tasa_crimines_migrantes_redes.xlsx", firstrow(variables) replace




import excel using "Medios_seguridad_general_sites.xlsx" , firstrow clear
save Medios_seguridad_general_sites.dta, replace
import excel using "Medios_seguridad_migrantes_sites.xlsx" , firstrow clear
save Medios_seguridad_migrantes_sites.dta, replace

merge 1:1 Medio using Medios_seguridad_general_sites

export excel "tasa_crimines_migrantes_sitios.xlsx", firstrow(variables) replace