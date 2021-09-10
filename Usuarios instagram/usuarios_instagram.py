# -*- coding: utf-8 -*-
"""
Created on Fri Jun 18 14:29:55 2021

@author: JOSE Y DIEGO
"""
import pandas as pd
import numpy as np
import re
import string
print('Ejemplo de una ruta completa: C:\ Users\ JOSE\ Desktop\ audience.xlsx')
ruta = input('Introduzca la ruta completa del archivo que quiere procesar /')
print('Procesando...')
base = pd.read_excel(ruta)
print('Definiendo funciones auxiliares...')
def deEmojify(text):
    regrex_pattern = re.compile(pattern = "["
         u"\U0001F600-\U0001F64F"  # emoticons
         u"\U0001F300-\U0001F5FF"  # symbols & pictographs
         u"\U0001F680-\U0001F6FF"  # transport & map symbols
         u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
         u"\U00002500-\U00002BEF"  # chinese char
         u"\U00002702-\U000027B0"
         u"\U00002702-\U000027B0"
         u"\U000024C2-\U0001F251"
         u"\U0001f926-\U0001f937"
         u"\U00010000-\U0010ffff"
         u"\u2640-\u2642"
         u"\u2600-\u2B55"
         u"\u200d"
         u"\u23cf"
         u"\u23e9"
         u"\u231a"
         u"\ufe0f"  # dingbats
         u"\u3030"
                           "]+", flags = re.UNICODE)
    return regrex_pattern.sub(r' ',text)
def remove_punctuations(text):
    for punctuation in string.punctuation:
      if (punctuation != '.') & (punctuation != '_') & (punctuation != '@'):
        text = text.replace(punctuation, ' ') 
        text = text.replace('•', ' ')
    return text
print('Limpiando la base...')
base['bio_clean'] = ""
for i in range(len(base)):
    base.loc[i, 'bio_clean'] =  deEmojify(str(base.loc[i, 'bio']))
    base.loc[i, 'bio_clean'] =  remove_punctuations(base.loc[i, 'bio_clean'])
base['bio_clean'] = base['bio_clean'].str.replace('(.com/|:|http[s]?://w{,3}[\\.]?)', ' ', regex=True)
base['bio_clean'] = base['bio_clean'].str.replace('http\S+', ' ', regex=True)
base['bio_clean'] = base['bio_clean'].str.replace('http', ' ', regex=False)
base['bio_clean'] = base['bio_clean'].str.replace('face', ' ', regex=False)
texto = [itm for itm in base['bio_clean'].str.lower().str.split() if len(str(itm))>0]
keywords = [word for words in texto for word in words]
copy = list()
patron = re.compile(r'(ig|insta\w*)')
for word in keywords:
  z = re.match(patron, word)
  if z :
    if (word not in copy) & (~word.startswith('igna')) & (~word.startswith('igua')) & (~word.startswith('igle')) :
      copy.append(word)
copy.append('www.instagram.com')
copy.append('@instagram')
copy.append('insta/snap')
copy.append('IG')
copy.append('INSTAGRAM')
keywords = copy
print('Creando una columna con los nombres de usuario de instagram...')
base['instagram'] = ""
for i in range(len(base)):
  text = texto[i]
  j = 0
  textoiterable = list(enumerate(text))
  for word in textoiterable:
    if (word[1] in keywords):
      try:
        cuenta = textoiterable[word[0] + 1][1]
        base.loc[i, 'instagram'] = cuenta
        if (textoiterable[word[0] + 1][1] == 'acc') | (textoiterable[word[0] + 1][1] == 'en') | (textoiterable[word[0] + 1][1] == 'es') | (textoiterable[word[0] + 1][1] == '@') | (textoiterable[word[0] + 1][1] == 'como'):
            cuenta = textoiterable[word[0] + 2][1]
            base.loc[i, 'instagram'] = cuenta
      except:
        # 1. Solución a 'Ex Penalista  EEN  CD  @11mcaceres Instagram'
        if (textoiterable[word[0] - 1][1] != ''):
          if (textoiterable[word[0] - 1][1] != 'en') & (textoiterable[word[0] - 1][1] != 'es') & (textoiterable[word[0] - 1][1] != 'como'): 
            cuenta = textoiterable[word[0] - 1][1]
            base.loc[i, 'instagram'] = cuenta
          # 2. Solución a '@hola en instagram'
          else:
            cuenta = textoiterable[word[0] - 2][1]
            base.loc[i, 'instagram'] = cuenta
        else:
          if (textoiterable[word[0] + 1][1] == 'acc'):
            cuenta = textoiterable[word[0] + 2][1]
            base.loc[i, 'instagram'] = cuenta
          else:
            base.loc[i, 'instagram'] = np.nan   
    j += 1
print('limpieza final...')
for i in range(len(base)):
  if (len(base.loc[i, 'instagram']) <= 4): 
    base.loc[i, 'instagram'] = 'NaN'
  elif (base.loc[i, 'instagram'].find('@') == -1):
    base.loc[i, 'instagram'] = '@' + base.loc[i, 'instagram']
print('Exportando.')
base.to_csv('Base_usuarios_instagram.csv')
print('La última columna del documento contiene los usuarios requeridos')
fin = input('FIN. Oprima cualquier tecla para salir')