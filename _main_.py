from flask import Flask, request, render_template, url_for, redirect
from OpenSSL import SSL
from werkzeug.serving import make_ssl_devcert
import ssl, cgi, cgitb, pymongo, pprint, time
from pymongo import errors, MongoClient
import sys, traceback

app = Flask(__name__)
ipaddress = '127.0.0.1'
port = 27017
client = MongoClient(ipaddress, port)
db = client.test
collection = db.test

form = cgi.FieldStorage()
# ctx = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
# ctx.load_cert_chain('D:/School/2017/BlokB/Cloud Infrastructures/Website/Practicum-cloudinfra/venv.crt',
#                   "D:/School/2017/BlokB/Cloud Infrastructures/Website/Practicum-cloudinfra/venv.key")
#make_ssl_devcert('C:/Users/Daniel van Liempd/PycharmProjects/Practicum-cloudinfra/venv', host='Daniel-PC', cn=None)
#file = open('C:\Users\Daniel van Liempd\PycharmProjects\Practicum-cloudinfra\index.html')
cgitb.enable()

@app.route("/login", methods=['GET'])
def login():
 #    if request.method == 'POST':
 #        try:
 #            print ('test')
 #            login_name = request.args.get['username']  # die laatste waarde, dient voor een vervanging voor 'None'
 #            login_password = request.args.get['password']
 #            print ("gelukt")
 #           # register_name = request.form['register_name', '']
 #            # register_password = request.form['register_password', '']
 #            # adres = request.form['adres', '']
 #            # geslacht = request.form['geslacht', '']
 #            # geboortejaar = request.form['geboortejaar', '']
 #            if login_name != '' and login_password != '':
 # #              flash (login_password, login_name)
 #                print("if")
 #                return render_template('index.html')
 #        except:
 #            print("except")
 #            return render_template('index.html')

    if request.method == 'GET':
        try:
            print('test2')
            login_name = request.args.getlist('username')[0]  # die laatste waarde, dient voor een vervanging voor 'None'
            login_password = request.args.getlist('password')[0]
            print("gelukt")

            # register_name = request.form['register_name', '']
            # register_password = request.form['register_password', '']
            # adres = request.form['adres', '']
            # geslacht = request.form['geslacht', '']
            # geboortejaar = request.form['geboortejaar', '']
            if login_name != '' and login_password != '':
                #              flash (login_password, login_name)
                print (login_name)
                print (login_password)

                if login_name == 'Admin' and login_password == 'cisco12345':
                    print ("GELUKT!")
                    return render_template('index.html')

                    #return ('Welkom ', login_name, '!')

                else:
                    print("if2")
                    return render_template('index.html')
        except:
            print ("except2")
            return render_template('index.html')

    else:
        print ("else2")
        return render_template('index.html')

        # return render_template('index.html', error = error)
        #
        #    if register_name != '' and register_password != '':
        #        db.test.insert({"Naam": register_name}, {"Password": register_password},
        #                       {"Adres": adres}, {"Geboortejaar": geboortejaar})
        #        db.test.create_index([("wat?", pymongo.ASCENDING)], unique=True)
        #        print("Toegevoegd!")

@app.route("/register")
def register_page():
#    login_name = form.getvalue('login_name', '')  # die laatste waarde, dient voor een vervanging voor 'None'
#    login_password = form.getvalue('login_password', '')
        return render_template('register.html')

@app.route("/")
def base():
    return ('testbase')

@app.route("/homepage")
def homepage():
    return ('test')

#def test():
#    return render_template("cgi-bin/test.py")

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80, debug=True) #, ssl_context=ctx

#print ("/test")
#def registreren():
#    while True:
#        login_name          = request.form['login_name', ''] #die laatste waarde, dient voor een vervanging voor 'None'
#        login_password      = request.form['login_password', '']
#        register_name       = request.form['register_name', '']
#        register_password   = request.form['register_password', '']
#        adres               = request.form['adres', '']
#        geslacht            = request.form['geslacht', '']
#        geboortejaar        = request.form['geboortejaar', '']
#
#        if register_name != '' and register_password != '':

#            db.test.insert({"Naam": register_name}, {"Password": register_password},
#            {"Adres": adres},{"Geboortejaar": geboortejaar})
#            db.test.create_index([("wat?", pymongo.ASCENDING)], unique=True)
#            print("Toegevoegd!")

#registreren()

#    app.run(host='0.0.0.0', port='80',
#            debug=False / True,)
# ssl_context=context
