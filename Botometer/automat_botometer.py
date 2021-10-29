#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 17 21:13:38 2021

@author:JOSE
"""

import os
import re
import ssl
import sys
import time
import numpy as np
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait

from webdriver_manager.chrome import ChromeDriverManager


ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

def barra_carga(tiempo, usuarios):
    sys.stdout.write("%s: [" % ('Revisando '+str(usuarios)+' usuarios'))
    sys.stdout.flush()
    sys.stdout.write("\b" * (tiempo+1))
    
    for i in range(tiempo):
        time.sleep(1) # do real work here
        # update the bar
        if (round(tiempo/(i+1))%5)==0:
            sys.stdout.write("-")
            sys.stdout.flush()
    sys.stdout.write("]\n")
    return

### INPUT ###
## '/Users/diegoalejandrobermudezsierra/OneDrive - Universidad de los Andes/BX/Botometer/base_3_4.xlsx'
print('Ejemplo:', '/Users/diegobermudez/BX/author_list.xlsx')
path = input('Digite el path del archivo (.xlsx) con los autores -- ')
usuario = input('Digite su usuarios de twitter sin @ -- ')
contraseña = input('Digite su contraseña de twitter -- ')

folder = os.path.dirname(path)

autores = pd.read_excel(path)
autores = list(autores['autores'])

webpage = r'https://botometer.osome.iu.edu/' # edit me

chrome_options = Options()
chrome_options.add_experimental_option("prefs", {
  "download.prompt_for_download": False,
  "download.directory_upgrade": True,
  "safebrowsing.enabled": True
  })

if re.findall('C:', path) == []:
    driver = webdriver.Chrome(ChromeDriverManager().install(), executable_path = ''.join([folder, '/chromedriver']),
                          chrome_options=chrome_options)
else:
    driver = webdriver.Chrome(ChromeDriverManager().install())
driver.get(webpage)

screenname = driver.find_element_by_id("inputSN")
screenname.send_keys(usuario)
search_button = driver.find_element_by_xpath("//form/button[1]")
search_button.click()


tabs = driver.window_handles
print(tabs)
driver.switch_to.window(tabs[1])
user = driver.find_element_by_xpath("/html/body/div[2]/div/form/fieldset[1]/div[1]/input")

### INPUT

user.send_keys(usuario)

pas = driver.find_element_by_xpath("/html/body/div[2]/div/form/fieldset[1]/div[2]/input")

### INPUT
pas.send_keys(contraseña)

login = driver.find_element_by_xpath("/html/body/div[2]/div/form/fieldset[2]/input[1]")
login.click()
driver.switch_to.window(tabs[0])


sizer  =  range(len(usuario) + 1)
for letra in sizer:
    screenname.send_keys(Keys.BACK_SPACE)



for count, autor in enumerate(autores):
    if autor.find('.') == -1:
        screenname.send_keys(autor)
        search_button.click()
        sizer = range(len(autor) + 1)
        for letra in sizer:
            screenname.send_keys(Keys.BACK_SPACE)
        if autor == "Redsonoraradio":
            print(count)
        if (count == 700):
            restante = autores[count:]
            restante = pd.DataFrame(restante, columns = ['autores'])
            restante.to_excel('restante.xlsx')
            break
        if (((count+5)%180) == 0):
            barra_carga(tiempo = 900, usuarios = 180)

if count<=180:
    espera = count*6
else:
    espera = (count-((count%180)*180))*6


barra_carga(tiempo = espera, usuarios = count)

print('Exportando Datos ...')
export_button = driver.find_element_by_link_text('Export data')
export_button.click() 
'''
valores = []
for autor in autores:
    try:
        xpath = ''.join(['//*[@id="user-user-', autor, '"]/div[1]/span[2]/span'])
        valor = driver.find_element_by_xpath(xpath).text
    except:
        valor = 'not found'
        
    valores.append(valor)

valores = [re.sub(' / 5', '', valor) for valor in valores]
valores = [re.sub(r'( )\1+', '', valor) for valor in valores]
df = pd.DataFrame(list(zip(autores, valores)),
               columns =['Autores', 'Valores'])

pattern = '[+-]?([0-9]*[.])?[0-9]+'
df['Valores'] = np.where(df.Valores.str.match(pattern, str(df.Valores)), df['Valores'] , np.nan)

df['Valores'] = (((df['Valores'].astype('float'))/5)*100)

if re.findall('C:', path) == []:
    df.to_excel(''.join([folder, '/porc_bots.xlsx']), index=False)  
else:
    df.to_excel(''.join([folder, '\porc_bots.xlsx']), index=False)  

driver.close()
'''



