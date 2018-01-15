from flask import Flask
from flask import render_template
from OpenSSL import SSL
app = Flask(__name__)
from werkzeug.serving import make_ssl_devcert
import ssl
import cgi, cgitb
import pymongo
import pprint
import time
from pymongo import errors
from pymongo import MongoClient
from flask import request


ipaddress = '127.0.0.1'
port = 27017
client = MongoClient(ipaddress, port)
db = client.test
collection = db.test


form = cgi.FieldStorage()

def test():
#    login_name = form.getvalue('login_name', '')  # die laatste waarde, dient voor een vervanging voor 'None'
#    login_password = form.getvalue('login_password', '')
    while True:

        if request.method == 'POST':
            print ('POST')
            login_name = request.form['login_name', '']  # die laatste waarde, dient voor een vervanging voor 'None'
            login_password = request.form['login_password', '']
            register_name = request.form['register_name', '']
            register_password = request.form['register_password', '']
            adres = request.form['adres', '']
            geslacht = request.form['geslacht', '']
            geboortejaar = request.form['geboortejaar', '']

            if register_name != '' and register_password != '':
                print(login_password)

print ("test")
test()

