from flask import Flask, jsonify, request
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("10.1.0.17",27017)
mongo = client['gebruikers']
collection = mongo.test

@app.route('/gebruikers', methods=['GET'])
def alles_opvragen():
  users = mongo.users
  resultaat = []
  for u in users.find():
    resultaat.append({'Naam' : u['Naam'], 'wachtwoord' : u['Password'], 'Adres' : u['Adres'],'Postcode' : u['Postcode']})
  return jsonify({'resultaat' : resultaat})

@app.route('/gebruiker/<string:Naam>', methods=['GET'])
def een_opvragen(Naam):
  users = mongo.users
  u = users.find_one({'Naam' : Naam})
  if u:
    resultaat = {'Naam' : u['Naam'], 'wachtwoord' : u['Password'], 'Adres' : u['Adres'],'Postcode' : u['Postcode']}
  else:
    resultaat = "Geen correcte gegevens ingevoerd"
  return jsonify({'resultaat' : resultaat})

@app.route('/delete/<string:Naam>', methods=['DELETE'])
def delete(Naam):
  users = mongo.users
  u = users.find_one({'Naam' : Naam})
  if u:
    users.remove({'Naam': Naam })
    return jsonify({'resultaat' : "Gelukt!"})
  else:
    resultaat = "Geen correcte gegevens ingevoerd"
    return jsonify({'resultaat' : resultaat})

@app.route('/registreren', methods=['POST'])
def registreren():
  users = mongo.users
  Naam = request.json['Naam']
  password = request.json['Password']
  Adres = request.json['Adres']
  Postcode = request.json['Postcode']
  user_id = users.insert({'Naam': Naam,'Password': password,'Adres': Adres,'Postcode': Postcode})
  u = users.find_one({'_id': user_id })
  resultaat = {'Naam' : u['Naam'],'Password': u['Password'],'Adres': u['Adres'], 'Postcode': u['Postcode']}
  #db.users.create_index([("Naam", pymongo.ASCENDING)], unique=True)
  return jsonify({'resultaat' : resultaat})

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
