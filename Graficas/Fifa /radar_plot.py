#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 23:05:48 2021

@author: diegoalejandrobermudezsierra
"""

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

def example_data():
    '''
    Basicamente el array a continuacion se puede entender como un df de dfs donde:
    Cada df pertenece a un caso (4 casos en total) y dentro de cada caso tenemos:
    Columnas que corresponden a cada una de las variabels arriba descritas (9 en total)
    Filas donde cada una corresponde a un Factor que sería lo que realmente graficamos
    Cada fila seria un "diamante" dentro de la figura
    '''
    spoke_labels = ['Salud', 'Seguridad', 'Educación', 'Xenofobia', 'Trabajo', 'Vivienda']
    data = [ # La estrutura es el nombre de cada uno de los casos de análisis y 
             # el valor de cada una de las varaibels en el ordene specificado.
        ('Bogotá', [
            [0.88, 0.1, 0.3, 0.3, 0.2, 0.6],
            [0.07, 0.95, 0.04, 0.05, 0.00, 0.02],
            [0.01, 0.02, 0.85, 0.19, 0.05, 0.10],
            [0.02, 0.01, 0.07, 0.01, 0.21, 0.12],
            [0.01, 0.01, 0.02, 0.71, 0.74, 0.70]]),
        ('Medellin', [
            [0.88, 0.02, 0.02, 0.02, 0.00, 0.05],
            [0.08, 0.94, 0.04, 0.02, 0.00, 0.01],
            [0.01, 0.01, 0.79, 0.10, 0.00, 0.05],
            [0.00, 0.02, 0.03, 0.38, 0.31, 0.31],
            [0.02, 0.02, 0.11, 0.47, 0.69, 0.58]]),
        ('Cali', [
            [0.89, 0.01, 0.07, 0.00, 0.00, 0.05],
            [0.07, 0.95, 0.05, 0.04, 0.00, 0.02],
            [0.01, 0.02, 0.86, 0.27, 0.16, 0.19],
            [0.01, 0.03, 0.00, 0.32, 0.29, 0.27],
            [0.02, 0.00, 0.03, 0.37, 0.56, 0.47]]),
        ('Barranquilla', [
            [0.87, 0.01, 0.08, 0.00, 0.00, 0.04],
            [0.09, 0.95, 0.02, 0.03, 0.00, 0.01],
            [0.01, 0.02, 0.71, 0.24, 0.13, 0.16],
            [0.01, 0.03, 0.00, 0.28, 0.24, 0.23],
            [0.02, 0.00, 0.18, 0.45, 0.64, 0.55]])
        ]
    return (spoke_labels, data)


# Nombres de las variables

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

    # Parte 4
            
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
    
    # Parte 5
    
    if remove:
        if n_rows==1:
            axs[n_cols-1].set_axis_off()
        else:
            axs[n_rows-1, n_cols-1].set_axis_off()


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
                ('Ciudad1', 'Ciudad2', 'Ciudad3', 'Ciudad4', 'Ciudad5', 'Ciudad6', 'Ciudad7', 'Ciudad8', 'Ciudad9', 'Ciudad10'),
                loc=1, bbox_to_anchor=(0.87, 1.1), labelspacing=0.1, fontsize=size_2)
        
        
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


