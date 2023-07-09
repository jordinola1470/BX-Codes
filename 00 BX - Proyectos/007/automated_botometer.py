# -*- coding: utf-8 -*-
"""
Created on Tue May  4 12:41:32 2021

@author: JOSE
"""

import urllib.request, urllib.parse, urllib.error
from urllib.request import urlopen
from bs4 import BeautifulSoup
import ssl
import requests
import json
import re
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

webpage = r'https://botometer.osome.iu.edu/'
driver = webdriver.Chrome(r'C:\Users\JOSE\Desktop\Trabajo\BX\007\chromedriver.exe')
driver.get(webpage)




driver.close()