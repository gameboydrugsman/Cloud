import urllib.request
import json
import requests
import time
# body = {'ids': [12, 14, 50]}

# register_name = 'DVL'
# register_password = 'cisco12345'
# adres = 'raaigras 10,Gouda'
# postcode = '2804NC'

print('Account aanmaken met Python: ')
register_name = input('Naam: ')
register_password = input('Wachtwoord: ')
adres = input('Adres: ')
postcode = input('Postcode: ')

data = ({"Naam": register_name, "Password": register_password, "Adres": adres,
         "Postcode": postcode})
r = requests.post('http://127.0.0.1:5000/registreren', json=data)
headers = {'Content-type': 'application/json'}

time.sleep(1)
r = requests.get('http://127.0.0.1:5000/gebruikers', json={"naam": "Daniel"})
headers = {'Content-type': 'application/json'}
#print (r)
#print(r.status_code)
pils = r.content
#str(pils, 'utf-8')
#print (str)
str2 = bytes.decode(pils)

print ("\n-------------------------------------------------")
print ("Onderstaand wordt de gehele database weergegeven: ")
print (str2)