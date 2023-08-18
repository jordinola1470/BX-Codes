
import sys
from selenium.webdriver.common.by import By


#VALIDACION - FUNCION
def validacion(driver,seccion_comments):
    try:
        driver.find_element(By.XPATH, value = seccion_comments +'1]')
        print('SeccionComentario Encontrada')
    except: print('nada')

    try:
        driver.find_element(By.XPATH, value = '/html/body/div[1]/div[2]/div[2]/div/div[2]/div[1]/div[2]/div[2]/div/div[1]/div/div[1]/a/span').text
        print('UserName Encontrado')
    except:
        print('No pudo capturar el primer username del primer comment')
    
    return None
