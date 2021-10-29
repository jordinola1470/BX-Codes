#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 17:06:18 2021

@author: diegoalejandrobermudezsierra
"""

import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, RegularPolygon
from matplotlib.path import Path
from matplotlib.projections.polar import PolarAxes
from matplotlib.projections import register_projection
from matplotlib.spines import Spine
from matplotlib.transforms import Affine2D
from matplotlib.ticker import FuncFormatter

def radar_factory(num_vars, frame='polygon'):
    """
    Esta función crea un 'radar chart' con dos parametros.
    Esta función toma como punto de partida un gráfico de tipo
    'polar axis'.
    Se uso como punto de partida un tipo de gráfico programado
    en matplotlib.
    
    Parametros
    ----------
    num_vars : int
        Número de variables 
    frame : {'circle', 'polygon'}
        Forma de la parte exterior del gráfico, por default polygon

    """
    
    # Calculamos un número equivalente de espacios para cada variable
    # Se pone como tamaño minimo 0 y maximo 2*pi que es la circunferencia
    # de un circulo.
    
    theta = np.linspace(0, 2*np.pi, num_vars, endpoint=False)

    class RadarAxes(PolarAxes):

        name = 'radar'
        # use 1 line segment to connect specified points
        RESOLUTION = 1

        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            # Originalmente el gráfico tiene como 0 el eje x, así que lo volteamos
            # para que el 0 quedde en el eje y (0 respecto a los grados)
            self.set_theta_zero_location('N')

        #def fill(self, *args, closed=True, **kwargs):
        #    """Override fill so that line is closed by default"""
        #    return super().fill(closed=closed, *args, **kwargs)

        def plot(self, *args, **kwargs):
            """Definimos un default donde los bordes siempre esten marcados"""
            lines = super().plot(*args, **kwargs)
            for line in lines:
                self._close_line(line)

        def _close_line(self, line):
            '''Construimos cada uno de los poligonos que representan los datos'''
            x, y = line.get_data()
            # FIXME: markers at x[0], y[0] get doubled-up
            if x[0] != x[-1]:
                x = np.append(x, x[0])
                y = np.append(y, y[0])
                line.set_data(x, y)

        def set_varlabels(self, labels, **kwargs):
            '''Pasamos de radianes a grados (e.g. 2*pi a 360)'''
            '''Agregamos etiquetas a los nombres de los ejes'''
            self.set_thetagrids(np.degrees(theta), labels)

        def _gen_axes_patch(self):
            # Definimos la forma y tamaño de la figura.
            # Los ejes de la figura deben estar centrados en (0.5, 0.5)
            # y tener un radio de 0.5en sus coordenadas.
            if frame == 'circle':
                #En caso de ser un circulo la forma es sencilla.
                return Circle((0.5, 0.5), 0.5)
            elif frame == 'polygon':
                # Cuando es un poligono lo que armamos es una figura con 
                # el mismo centro, número de lados segun el número de 
                # variables
                return RegularPolygon((0.5, 0.5), num_vars,
                                      radius=.5, edgecolor="k")
            else:
                # En caso que no sea posible determinar el tipo de figura que
                # se pide
                raise ValueError("Unknown value for 'frame': %s" % frame)

        def _gen_axes_spines(self):
            if frame == 'circle':
                return super()._gen_axes_spines()
            elif frame == 'polygon':
                # spine_type must be 'left'/'right'/'top'/'bottom'/'circle'.
                spine = Spine(axes=self,
                              spine_type='circle',
                              path=Path.unit_regular_polygon(num_vars))
                # unit_regular_polygon gives a polygon of radius 1 centered at
                # (0, 0) but we want a polygon of radius 0.5 centered at (0.5,
                # 0.5) in axes coordinates.
                spine.set_transform(Affine2D().scale(.5).translate(.5, .5)
                                    + self.transAxes)
                return {'polar': spine}
            else:
                raise ValueError("Unknown value for 'frame': %s" % frame)

    register_projection(RadarAxes)
    return theta

def multi_radar_plot(df, var_names, frame, title=None, n_cols=2, n_rows=None, fill=False, 
                     fig_size=(10, 10), colors=None, grids=[20, 40, 60, 80, 100], size='large', 
                     legend=False, remove=False, adj=False):
  
    '''
    Parametros
    -----------------------
    df <- un objeto de tipo lista cuyos elementos seran tuples con los elementos de cada unos de los graficos
    var_names <- un array con los nombres de las variables (las variables son las que van en la parte de afuera del
    grafico).
    frame <- String que me dice el tipo de gráfico que quiero (polygon/circle)
    n_cols <- numero de columnas (Por default 2)
    n_rows <- número de filas
    title <- El titulo que vamos a darle al gráfico.
    fill <- boolean que toma True si queremos que los gráficos esten rellenados o no
    fig_size <- Tamaño del plot que queremos hacer, por default este sera 10x10 (ancho*alto)
    color<- colores que queremos que tenga nuestro gráfico
    grids<-Definimos un array con las divisiones que queremos que tenga nuestro gráfico
    '''
    # Parte 1
    
    N=len(var_names)
    theta = radar_factory(N, frame=frame)
    
    # Parte 2
    
    if n_rows==None:
        
        if len(df)%n_cols==0: 
            n_rows=len(df) // n_cols
            
        else: 
            n_rows=(len(df) // n_cols)+1
    
    # Parte 3
    
    if fig_size==(10, 10):
        fig, axs = plt.subplots(figsize=(10, 10), 
                                nrows=n_rows, ncols=n_cols,
                                subplot_kw=dict(projection='radar'))     
        fig.subplots_adjust(wspace=0.25, hspace=0.2, top=0.85, bottom=0.05)
        
    else:
        fig, axs = plt.subplots(figsize=fig_size, 
                                nrows=n_rows, ncols=n_cols,
                                subplot_kw=dict(projection='radar'))
        
    if size=='xx-large': size_2='x-large'
    elif size=='x-large': size_2='large'
    elif size=='large': size_2='medium'
    elif size=='medium': size_2='small'
    elif size=='small': size_2='x-small'
    elif size=='x-small': size_2='xx-small'
    elif size=='xx-small': size_2='xx-small'
    elif size=='max':
        size=100
        size_2=30

    # Parte 4
    
    if remove:
        if n_rows==1:
            axs[n_cols-1].set_axis_off()
        else:
            axs[n_rows-1, n_cols-1].set_axis_off()

    
    if n_rows==1 & n_cols==1:
        # Parte 5
        random.seed(0)
        colors=(random.random(), random.random(), random.random())
        
        # Parte 6 
        
        axs.set_rgrids(grids, fmt='%.0f%%')            
        axs.set_title(df[0], color='black', weight='bold', size=size_2, pad=55)#.set_position([.5, 5])

        axs.plot(theta, df[1][0], color=colors, linewidth=3.0)   
        if fill: 
            axs.fill(theta, df[1][0], facecolor=colors, alpha=0.25) 
        axs.set_thetagrids(np.degrees(theta), var_names, size=size_2)
        
        for label, angle in zip(axs.get_xticklabels(), theta):
                if angle in (0, np.pi):
                    label.set_horizontalalignment('center')
                elif 0 < angle < np.pi:
                    label.set_horizontalalignment('right')  
                else:
                    label.set_horizontalalignment('left') 
        
        if legend:
            axs.legend(('Ciudad1', 'Ciudad2', 'Ciudad3', 'Ciudad4', 'Ciudad5', 
                       'Ciudad6', 'Ciudad7', 'Ciudad8', 'Ciudad9', 'Ciudad10'),
                      loc=1, bbox_to_anchor=(0.87, 1.1), labelspacing=0.1, 
                      fontsize=size_2)                     
        ax=axs
    else:
        # Parte 5
        if colors==None:
            random.seed(0)
            dim=0
            for i in range(len(df)): 
                if len(df[i][1])>dim: 
                    dim=len(df[i][1])                        
            colors=[]
            for i in range(dim):
                color=(random.random(), random.random(), random.random())
                colors.append(color)
        # Parte 6 
        for ax, (categoria, valores) in zip(axs.flat, df):                
            ax.set_rgrids(grids, fmt='%.0f%%')            
            ax.set_title(categoria, color='black', weight='bold', size=size_2)
          
            for d, color in zip(valores, colors):
                ax.plot(theta, d, color=color, linewidth=3.0)                
                if fill:
                    ax.fill(theta, d, facecolor=color, alpha=0.25)                
            ax.set_thetagrids(np.degrees(theta), var_names, size=size_2)            
            for label, angle in zip(ax.get_xticklabels(), theta):
                if angle in (0, np.pi):
                    label.set_horizontalalignment('center')
                elif 0 < angle < np.pi:
                    label.set_horizontalalignment('right')  
                else:
                    label.set_horizontalalignment('left')            
            if legend:
                ax.legend(
                    ('Ciudad1', 'Ciudad2', 'Ciudad3', 'Ciudad4', 'Ciudad5', 
                     'Ciudad6', 'Ciudad7', 'Ciudad8', 'Ciudad9', 'Ciudad10'),
                    loc=1, bbox_to_anchor=(0.87, 1.1), labelspacing=0.1, 
                    fontsize=size_2)
                
    if title!=None:
        fig.text(0.5, 0.95, title, horizontalalignment='center', 
                 color='black', 
                 weight='bold', 
                 size=size)
        
    if adj:  
        fig.tight_layout()
        fig.subplots_adjust(top=0.95)
    else:
        fig.tight_layout()
        fig.subplots_adjust(top=0.85)
    
    # Output

    return (fig, ax)

def to_tupple_list(df, categorias, start, end, sub_categorias=None, multi_cats=False, 
                   col_cat=None, col_subcat=None):
    
    i=0
    lista_final=[]
    
    if multi_cats:
        
        if sub_categorias==None:
            
            
        
            for categoria in categorias:
                temp=[]
                
                sub_df=df.loc[df[col_cat]==categoria]
                sub_categorias=list(sub_df[col_subcat])
                
                
                for i in range(len(sub_categorias)):
                    valores=list(sub_df.iloc[i, start:end])
                    temp.append(valores)
            
                sub_final=(categoria, temp)
                lista_final.append(sub_final)
                
        elif sub_categorias!=None:
            
            for categoria in categorias:
                temp=[]
                
                for i in range(len(sub_categorias)):
                    valores=list(df.iloc[i, start:end])
                    temp.append(valores)
                
                sub_final=(categoria, temp)
                lista_final.append(sub_final)
    
    else:
        
        for categoria in categorias:
            temp=[]

            valores=list(df.iloc[i, start:end])
        
            temp.append(valores)
            lista_temp=(categoria, temp)
            lista_final.append(lista_temp)
            
            i+=1
    
    return lista_final


path=input("Escriba el path del archivo con las tasas ---- ")
fifa=pd.read_csv(path)
#fifa=fifa.drop(['Xenofobia', 'Educacion', 'Salud', 'Trabajo', 'Seguridad'], axis=1)
fifa.columns=list(pd.Series(fifa.columns).str.replace('Tasa', ''))
fifa.columns=list(pd.Series(fifa.columns).str.replace('Educacion', 'Educación'))
fifa=fifa.round(2)
fifa=fifa.loc[fifa['Total']>200].reset_index(drop=True)
fifa.iloc[:,0]=fifa.iloc[:,0].str.replace('Bogota', 'Bogotá')

variables=list(fifa.columns[3:len(fifa.columns)])

fifa=fifa.sort_values(by=['Region'], ascending=True).reset_index(drop=True)

ciudades=list(fifa['Region'])

fifa= to_tupple_list(df=fifa, categorias=ciudades, start=3, end=len(fifa.columns))

if (len(fifa)%2)==0:
    fig, ax=multi_radar_plot(fifa, 
                             variables, 
                             'polygon',  
                             fig_size=(20, 24), #10*num_filas, 8*num_columnas
                             grids=[5, 10, 15, 20, 30, 40, 50],
                             fill=True,
                             size='xx-large',
                             n_cols=2,
                             n_rows=(round(len(fifa)/2))+1, 
                             remove=False)

elif (len(fifa)%2)!=0:
    fig, ax=multi_radar_plot(fifa, 
                             variables, 
                             'polygon',  
                             fig_size=(20, 24), #10*num_filas, 8*num_columnas
                             grids=[5, 10, 15, 20, 30, 40, 50],
                             fill=True,
                             size='xx-large',
                             n_cols=2,
                             n_rows=(round(len(fifa)/2))+1, 
                             remove=True)




fig.savefig('graph.jpg') 

i=0
while i<len(fifa):
    fig, ax=multi_radar_plot(fifa[i], 
                             variables, 
                             'polygon',  
                             fig_size=(16, 16), 
                             grids=[5, 10, 15, 20, 30, 40, 50],
                             fill=True,
                             size='max',
                             n_cols=1,
                             n_rows=1)
    
    nombre='_'.join(['graph', str(i)])
    nombre='.'.join([nombre, "jpg"])
    fig.savefig(nombre)
    i+=1

plt.show()



'''



i=0
j=2
while i<len(fifa):
    if len(fifa[i:j])>=2:
        fig, ax=multi_radar_plot(fifa[i:j], 
                                      variables, 
                                      'polygon',  
                                      fig_size=(16, 16), 
                                      grids=[5, 10, 15, 20, 30, 40, 50],
                                      fill=True,
                                      size='xx-large',
                                      n_cols=2,
                                      n_rows=1,
                                     )
        nombre='_'.join(['graph', str(i)])
        nombre='.'.join([nombre, "jpg"])
        fig.savefig(nombre)
        i=j
        j+=2
    else:
        fig, ax=multi_radar_plot(fifa[i:j], 
                                      variables, 
                                      'polygon',  
                                      fig_size=(16, 16), 
                                      grids=[5, 10, 15, 20, 30, 40, 50],
                                      fill=True,
                                      size='xx-large',
                                      n_cols=2,
                                      n_rows=1,
                                      remove=True
                                     )
        nombre='_'.join(['graph', str(i)])
        nombre='.'.join([nombre, "jpg"])
        fig.savefig(nombre)
        i=j
        j+=2    


plt.show()

'''