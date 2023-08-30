import pandas as pd

class Data_Processing:
    def __init__(self,archivo,hoja):
        self.archivo = archivo
        self.hoja    = hoja

    def matriz_base(self):

        matriz = pd.read_excel(self.archivo,self.hoja)
        matriz = matriz[matriz['Nombre de agente'].notnull() & matriz['Fecha de la pieza comunicativa (dd/mm/aaaa)'].notna()]
        
        matriz['FECHA']=pd.to_datetime(matriz['Fecha de la pieza comunicativa (dd/mm/aaaa)'])

        matriz['Year'] = matriz['FECHA'].dt.year
        matriz['Month'] = matriz['FECHA'].dt.month
        matriz['Day'] = matriz['FECHA'].dt.day

        lista_medios = matriz['Nombre de agente'].value_counts().index 

        print('lista medios\n',list(lista_medios))
        print('\ntamaño base original\n',matriz.shape)
        print('\nvalidacion_datos',matriz['Nombre de agente'].isnull().value_counts())

        return matriz
    
    def linea_base(self,matriz_fecha,fecha_inicio,fecha_final):

        matriz_fecha.set_index('FECHA',inplace=True)    
        matriz_fecha = matriz_fecha.loc[fecha_inicio : fecha_final]

        return matriz_fecha


# matriz_lineaBase, matriz,lineaSalida 
     