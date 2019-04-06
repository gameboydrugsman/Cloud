from flask import Flask, flash, request, render_template, url_for, redirect, session
from OpenSSL import SSL
from werkzeug.serving import make_ssl_devcert
import ssl, cgi, cgitb, pymongo, pprint, time, hashlib, datetime, os, sys, traceback, requests
from pymongo import errors, MongoClient

app = Flask(__name__)
app.secret_key = os.urandom(24)

ipadressbackend = 'backend'
ipaddressmongodb = 'mongo'
port = 27017
username = urllib.quote_plus('root')
password = urllib.quote_plus('example')
client = MongoClient('mongodb://%s:%s@mongo' % (username, password))
db = client.gebruikers
collection = db.users

cgitb.enable()

@app.route("/login", methods=['GET'])
def login():
    try:
        if request.method == 'GET':
            try:
                admin = 'nietadmin'
                # check of admin account bestaat
                print ('test')
                zoeken = (db.users.find(
                    {'Naam': 'Admin'},
                    {"Naam": 1, '_id': 0}
                ))
                for database in zoeken:
                    dict = str(database)
                    admin = dict[10:-2]
                    print('username data =', admin)
                print ("test22")
                if admin != 'Admin':
                    print ("test3")
                    adminaccount = ({"Naam": 'Admin', "Password": '22f0e74dfb96c113dab01f83ec32b0c4602d64f68a6203a9c3e8406c3effb3db0c44fe7b593ef18c185c8f7593b476e92d409a486d39bcff6a2b1cc39e727cd6', "Adres": 'Raaigras 10', "Postcode": '2804NC'})
                    db.users.insert_one(adminaccount)
                    return render_template('index.html')

                else:
                    login_name = request.args.getlist('username')[0]
                    login_password = request.args.getlist('password')[0]
                    hash_pw = hashlib.sha512(bytes(login_password,"UTF-8")).hexdigest()  # vertaald het wachtwoord naar hash omdat het zo ook in de database staat.
                    login_password = hash_pw
                    print("Get is gelukt")
                    try:
                        if login_name == '' and login_password == '':
                            return render_template('index.html')

                        if login_name != '' and login_password != '':
                            print ('log testen')
                            currenttime = datetime.datetime.now().time().isoformat()
                            write_to_log = "[" + currenttime + "]" + "De user: " + str(login_name) + " heeft ingelogd!\r\n"
#                            with open("C:/Users/Daniel van Liempd/PycharmProjects/Practicum-cloudinfra/venv/static/logfile.txt", "a") as myfile:
#                                myfile.write(write_to_log)
                            print ('log weggeschreven')

                            print ('Login naam: ' + login_name)
                            print ('Login password: ', login_password)

                            if login_name == 'Admin' and login_password == '22f0e74dfb96c113dab01f83ec32b0c4602d64f68a6203a9c3e8406c3effb3db0c44fe7b593ef18c185c8f7593b476e92d409a486d39bcff6a2b1cc39e727cd6':
                                print ("Admin is ingelogd!")
                                return redirect('/admin_homepage')

                            # else:
                            try:
                        #------------------------- gebruikersnaam
                                print ("try database zoeken 1")
                                zoeken = (db.users.find(
                                    {'Naam': login_name},
                                    {"Naam": 1, '_id': 0}
                                ))
                                for database in zoeken:
                                    dict = str(database)
                                    username_data = dict[10:-2]
                                    print('username data =', username_data)

                        #------------------------- password
                                zoeken2 = (db.users.find(
                                    {'Password': login_password},
                                    {"Password": 1, '_id': 0}
                                ))

                                for database2 in zoeken2:
                                    dict2 = str(database2)
                                    password_data = dict2[14:-2]
                                    print('password data =',password_data)
                                print ("Database zoeken gelukt")

                        #------------------------- adres
                                zoeken3 = (db.users.find(
                                    {'Naam': login_name, 'Password': login_password},
                                    {"Adres": 1, '_id': 0}
                                ))

                                for database3 in zoeken3:
                                    dict3 = str(database3)
                                    huidig_adres = dict3[11:-2]
                                    print(huidig_adres)

                        #------------------------- Postcode
                                zoeken4 = (db.users.find(
                                    {'Naam': login_name, 'Password': login_password},
                                    {"Postcode": 1, '_id': 0}
                                ))
                                for database4 in zoeken4:
                                    dict4 = str(database4)
                                    huidige_postcode = dict4[14:-2]
                                    print(huidige_postcode)

                        #------------------------- Sessies
                                session['username'] = login_name
                                session['password'] = login_password
                                session['adres'] = huidig_adres
                                session['postcode'] = huidige_postcode
                                if 'username' in session:
                                    print ('sessie: '+ session['username'])

                                if login_name == username_data and login_password == password_data:
                                    #flash ("yeah")
                                    return redirect("/homepage")
                                    # return ('<h1>Je bent succesvol ingelogd, ' + login_name + '!<h1>' +
                                    #     "<h3><a href='/login'> Terug naar loginscherm </a><h3>" )

                                else:
                                    return ("Nope, you facked up")

                            except:
                                print("except3")
                                return render_template('index.html')
                    except:
                        print("except4")
                        return render_template('index.html')

            except:
                print ("except2")
                return render_template('index.html')

        else:
            print ("else2")
            return render_template('index.html')

    except:
        print("except123")
        return render_template('index.html')

@app.route("/register", methods=['GET'])
def register_page():
    if request.method == 'GET' or 'POST':
        try:

            print('test2')
            restapi_register_name = request.args.getlist('register_username')[0]  # die laatste waarde, dient voor een vervanging voor 'None'
            restapi_register_password = request.args.getlist('register_password')[0]
            restapi_adres = request.args.getlist('adres')[0]
            restapi_postcode = request.args.getlist('postcode')[0]
            lengte = len(restapi_register_password)
            print ('hier')
            numbers = sum(c.isdigit() for c in restapi_register_password)
            print ('daar')

            if lengte >= 8 and numbers >= 1:  # wachtwoord minimaal 8 lang en bevat een cijfer
                hash_rpw = hashlib.sha512(bytes(restapi_register_password, "UTF-8")).hexdigest()  # Vertaald wachtwoord naar hash, gaat zo ook de database in.
                restapi_register_password = hash_rpw
                print (restapi_register_password)
                print('test3')
                print("gelukt")
                if restapi_register_name != '' and restapi_register_password != '' and restapi_adres != '' and restapi_postcode != '':
                    #flash (login_password, login_name)
                    print ("test4")
                    print(str(restapi_register_name))
                    print(restapi_register_password)
                    print('functie wordt aangeroepen')
                    print('Account aanmaken met Python: ')
                    register_name = restapi_register_name
                    register_password = restapi_register_password
                    adres = restapi_adres
                    postcode = restapi_postcode
                    data = ({"Naam": register_name, "Password": register_password, "Adres": adres,
                             "Postcode": postcode})
                    r = requests.post('http://'+ipadressbackend+':5000/registreren', json=data)
                    headers = {'Content-type': 'application/json'}
                    #time.sleep(2)
                    # r = requests.get('http://127.0.0.1:5000/gebruikers', json={"naam": "Daniel"})
                    # headers = {'Content-type': 'application/json'}
                    # pils = r.content
                    # str2 = bytes.decode(pils)
                    # print("\n-------------------------------------------------")
                    # print("Onderstaand wordt de gehele database weergegeven: ")
                    #print(str2)
                    #test()
                    # data = ({"Naam": register_name, "Password": register_password, "Adres": adres,
                    #          "Postcode": postcode})
                    # r = requests.post('http://127.0.0.1:5000/registreren', json=data)
                    # headers = {'Content-type': 'application/json'}
                    # db.users.insert_one(data)
                    # print ("toevoegen proberen")
                    #db.users.create_index([("Naam", pymongo.ASCENDING)], unique=True)
                    print("Toegevoegd!")
                    return ('Succesvol geregistreerd!') + render_template('register.html')
                else:
                    return ("<h2>Je moet wel alle velden invullen!<h2>"
                "<h3><a href='/register'> Terug naar registreren </a><h3>" )
            else:
                return ("<h2>Het wachtwoord voldoet niet aan alle eisen!<h2>"
                "<h3><a href='/register'> Terug naar registreren </a><h3>" )
        except:
            print("except2")
            return render_template('register.html')
    else:
        print("else2")
        return render_template('register.html')

@app.route("/")
def base():
    return redirect('/login')

@app.route("/homepage")
def homepage():
    return render_template('homepage.html')

@app.route("/admin_homepage")
def admin_homepage():
    return render_template('admin_homepage.html')

@app.route("/admin_gegevens")
def admin_gegevens():
    try:
        print("Try searching")
        zoek_username = request.args.getlist('zoekusername')[0]
        zoek_password = request.args.getlist('zoekpassword')[0]
        zoek_adres = request.args.getlist('zoekadres')[0]
        zoek_postcode = request.args.getlist('zoekpostcode')[0]

        print ("Search succeeded")

#-----------------------------------------------------------------------USERNAME
        if zoek_username != '':
            print(zoek_username)
            print("try database zoeken 1")
            zoeken = (db.users.find(
                {'Naam': zoek_username},
                {"Naam": 1, '_id': 0}
            ))
            for database in zoeken:
                dict = str(database)
                zoek_username_data = dict[10:-2]
                print('username data =', zoek_username_data)

            # ------------------------- password
            zoeken2 = (db.users.find(
                {'Naam': zoek_username},
                {"Password": 1, '_id': 0}
            ))

            for database2 in zoeken2:
                dict2 = str(database2)
                zoek_password_data = dict2[14:-2]
                print('password data =', zoek_password_data)
            print("Database zoeken gelukt")

            # ------------------------- adres
            zoeken3 = (db.users.find(
                {'Naam': zoek_username},
                {"Adres": 1, '_id': 0}
            ))

            for database3 in zoeken3:
                dict3 = str(database3)
                zoek_huidig_adres = dict3[11:-2]
                print(zoek_huidig_adres)

            # ------------------------- Postcode
            zoeken4 = (db.users.find(
                {'Naam': zoek_username},
                {"Postcode": 1, '_id': 0}
            ))
            for database4 in zoeken4:
                dict4 = str(database4)
                zoek_huidige_postcode = dict4[14:-2]
                print(zoek_huidige_postcode)

            # ------------------------- Sessies
            session['zoek_username'] = zoek_username_data
            session['zoek_password'] = zoek_password_data
            session['zoek_adres'] = zoek_huidig_adres
            session['zoek_postcode'] = zoek_huidige_postcode
            if 'zoek_username' in session:
                print('sessie: ' + session['zoek_username'])
                print('sessie: ' + session['zoek_password'])
                print('sessie: ' + session['zoek_adres'])
                print('sessie: ' + session['zoek_postcode'])

            return render_template('admin_gegevens.html')

# -----------------------------------------------------------------------PASSWORD
        if zoek_password != '':
            print(zoek_password)
            print("try database zoeken 1")
            zoeken = (db.users.find(
                {'Password': zoek_password},
                {"Naam": 1, '_id': 0}
            ))
            for database in zoeken:
                dict = str(database)
                zoek_username_data = dict[10:-2]
                print('username data =', zoek_username_data)

            # ------------------------- password
            zoeken2 = (db.users.find(
                {'Password': zoek_password},
                {"Password": 1, '_id': 0}
            ))

            for database2 in zoeken2:
                dict2 = str(database2)
                zoek_password_data = dict2[14:-2]
                print('password data =', zoek_password_data)
            print("Database zoeken gelukt")

            # ------------------------- adres
            zoeken3 = (db.users.find(
                {'Password': zoek_password},
                {"Adres": 1, '_id': 0}
            ))

            for database3 in zoeken3:
                dict3 = str(database3)
                zoek_huidig_adres = dict3[11:-2]
                print(zoek_huidig_adres)

            # ------------------------- Postcode
            zoeken4 = (db.users.find(
                {'Password': zoek_password},
                {"Postcode": 1, '_id': 0}
            ))
            for database4 in zoeken4:
                dict4 = str(database4)
                zoek_huidige_postcode = dict4[14:-2]
                print(zoek_huidige_postcode)

            # ------------------------- Sessies
            session['zoek_username'] = zoek_username_data
            session['zoek_password'] = zoek_password_data
            session['zoek_adres'] = zoek_huidig_adres
            session['zoek_postcode'] = zoek_huidige_postcode
            if 'zoek_password' in session:
                print('sessie: ' + session['zoek_username'])
                print('sessie: ' + session['zoek_password'])
                print('sessie: ' + session['zoek_adres'])
                print('sessie: ' + session['zoek_postcode'])
            return render_template('admin_gegevens.html')


# -----------------------------------------------------------------------ADRES
        if zoek_adres != '':
            print(zoek_adres)
            print("try database zoeken 1")
            zoeken = (db.users.find(
                {'Adres': zoek_adres},
                {"Naam": 1, '_id': 0}
            ))
            for database in zoeken:
                dict = str(database)
                zoek_username_data = dict[10:-2]
                print('username data =', zoek_username_data)

            # ------------------------- password
            zoeken2 = (db.users.find(
                {'Adres': zoek_adres},
                {"Password": 1, '_id': 0}
            ))

            for database2 in zoeken2:
                dict2 = str(database2)
                zoek_password_data = dict2[14:-2]
                print('password data =', zoek_password_data)
            print("Database zoeken gelukt")

            # ------------------------- adres
            zoeken3 = (db.users.find(
                {'Adres': zoek_adres},
                {"Adres": 1, '_id': 0}
            ))

            for database3 in zoeken3:
                dict3 = str(database3)
                zoek_huidig_adres = dict3[11:-2]
                print(zoek_huidig_adres)

            # ------------------------- Postcode
            zoeken4 = (db.users.find(
                {'Adres': zoek_adres},
                {"Postcode": 1, '_id': 0}
            ))
            for database4 in zoeken4:
                dict4 = str(database4)
                zoek_huidige_postcode = dict4[14:-2]
                print(zoek_huidige_postcode)

            # ------------------------- Sessies
            session['zoek_username'] = zoek_username_data
            session['zoek_password'] = zoek_password_data
            session['zoek_adres'] = zoek_huidig_adres
            session['zoek_postcode'] = zoek_huidige_postcode
            if 'zoek_adres' in session:
                print('sessie: ' + session['zoek_username'])
                print('sessie: ' + session['zoek_password'])
                print('sessie: ' + session['zoek_adres'])
                print('sessie: ' + session['zoek_postcode'])
            return render_template('admin_gegevens.html')

# -----------------------------------------------------------------------POSTCODE
        if zoek_postcode != '':
            print(zoek_postcode)
            print("try database zoeken 1")
            zoeken = (db.users.find(
                {'Postcode': zoek_postcode},
                {"Naam": 1, '_id': 0}
            ))
            for database in zoeken:
                dict = str(database)
                zoek_username_data = dict[10:-2]
                print('username data =', zoek_username_data)

            # ------------------------- password
            zoeken2 = (db.users.find(
                {'Postcode': zoek_postcode},
                {"Password": 1, '_id': 0}
            ))

            for database2 in zoeken2:
                dict2 = str(database2)
                zoek_password_data = dict2[14:-2]
                print('password data =', zoek_password_data)
            print("Database zoeken gelukt")

            # ------------------------- adres
            zoeken3 = (db.users.find(
                {'Postcode': zoek_postcode},
                {"Adres": 1, '_id': 0}
            ))

            for database3 in zoeken3:
                dict3 = str(database3)
                zoek_huidig_adres = dict3[11:-2]
                print(zoek_huidig_adres)

            # ------------------------- Postcode
            zoeken4 = (db.users.find(
                {'Postcode': zoek_postcode},
                {"Postcode": 1, '_id': 0}
            ))
            for database4 in zoeken4:
                dict4 = str(database4)
                zoek_huidige_postcode = dict4[14:-2]
                print(zoek_huidige_postcode)

            # ------------------------- Sessies
            session['zoek_username'] = zoek_username_data
            session['zoek_password'] = zoek_password_data
            session['zoek_adres'] = zoek_huidig_adres
            session['zoek_postcode'] = zoek_huidige_postcode
            if 'zoek_postcode' in session:
                print('sessie: ' + session['zoek_username'])
                print('sessie: ' + session['zoek_password'])
                print('sessie: ' + session['zoek_adres'])
                print('sessie: ' + session['zoek_postcode'])
            return render_template('admin_gegevens.html')


        else:
            print('Er is nog niks ingevuld!')
            return render_template('admin_gegevens.html')

    except:
        print('except-gegevens')
        return render_template('admin_gegevens.html')

@app.route("/gegevens")
def gegevens():
    try:
        print("Try searching")
        zoek_username = request.args.getlist('zoekusername')[0]
        zoek_password = request.args.getlist('zoekpassword')[0]
        zoek_adres = request.args.getlist('zoekadres')[0]
        zoek_postcode = request.args.getlist('zoekpostcode')[0]

        print ("Search succeeded")

        session['zoek_username'] = zoek_username_data
        session['zoek_password'] = zoek_password_data
        session['zoek_adres'] = zoek_huidig_adres
        session['zoek_postcode'] = zoek_huidige_postcode
        if 'zoek_username' in session:
            print('sessie: ' + session['zoek_username'])
            print('sessie: ' + session['zoek_password'])
            print('sessie: ' + session['zoek_adres'])
            print('sessie: ' + session['zoek_postcode'])

            return render_template('gegevens.html')

        else:
            print('Er is nog niks ingevuld!')
            return render_template('gegevens.html')

    except:
        print('except-gegevens')
        return render_template('gegevens.html')

@app.route("/instances")
def instances():

        print ('functie instances wordt aangeroepen')
        return render_template('instances.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=8080, debug=True)
