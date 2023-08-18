import pandas as pd
import numpy as np

import os
import re
import ssl
import sys
import math
import time
import traceback

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By


'''-------------------------------------------------------------------------------------------------------'''
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

chrome_options = Options()
chrome_options.add_experimental_option("prefs", {
  "download.prompt_for_download": False,
  "download.directory_upgrade": True,
  "safebrowsing.enabled": True
  })


def barra_carga(tiempo):
    sys.stdout.flush()
    sys.stdout.write("\b" * (tiempo+1))
    for i in range(tiempo):
        time.sleep(1) # do real work here
        # update the bar
        sys.stdout.write(f'{1+i}')
        sys.stdout.flush()
    sys.stdout.write("]\n")
    
    return 

URL = r'https://www.tiktok.com/@mariannycorderoo/video/7234287154828938501?_r=1&_t=8eux31EZrok'
driver = webdriver.Chrome()
driver.get(URL)

print("Esperando aparición y resolución de Captcha....")
barra_carga(60)



'''-------------------------------------------------------------------------------------------------------'''

def scroll_down(load_time, times, bottom):
  i = 0
  # Get scroll height
  last_height = driver.execute_script("return document.body.scrollHeight")
  browser_window_height = driver.get_window_size(windowHandle='current')['height']
  current_position = driver.execute_script('return window.pageYOffset')
  scrolling = times
  while i <= times:
    if bottom == 1080:
      # Scroll down to bottom
      driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
      # Wait to load page
      barra_carga(load_time)
    else:
      while (last_height - current_position > browser_window_height) & scrolling > 0:
        driver.execute_script(f"window.scrollTo({current_position}, {browser_window_height + current_position - bottom});")
        current_position = driver.execute_script('return window.pageYOffset')
        print('Voy a bajar a: ' + str(browser_window_height + current_position - bottom) + ' estando en: ' + str(current_position))
        scrolling -= 1
        barra_carga(load_time)
    # Calculate new scroll height and compare with last scroll height
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height
    i = i + 1
  return None

scroll_down(15,1,1080)

'''-------------------------------------------------------------------------------------------------------'''

seccion_comments = '/html/body/div[1]/div[2]/div[2]/div/div[2]/div/div[3]/div[2]/div/div['

def validacion(driver):
  if driver.find_element(By.XPATH, value = seccion_comments + '1]') : 
    print('Sección de comments encontrada')

  else: print('nada')

validacion(driver)
