from flask import Flask, jsonify, request
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("10.1.0.18",27017)
mongo = client['gebruikers']
collection = mongo.test

@app.route('/gebruikers', methods=['GET'])
def alles_opvragen():
  users = mongo.users
  resultaat = []
  for u in users.find():
    resultaat.append({'Naam' : u['Naam'], 'wachtwoord' : u['Password'], 'Adres' : u['Adres'],'Postcode' : u['Postcode']})
  return jsonify({'resultaat' : resultaat})

@app.route('/gebruikers/<string:naam>', methods=['GET'])
def een_opvragen(naam):
  users = mongo.users
  u = users.find_one({'naam' : naam})
  if u:
    resultaat = {'Naam' : u['Naam'], 'wachtwoord' : u['Password'], 'Adres' : u['Adres'],'Postcode' : u['Postcode']}
  else:
    resultaat = "Geen correcte gegevens ingevoerd"
  return jsonify({'resultaat' : resultaat})

@app.route('/delete/<string:Naam>', methods=['DELETE'])
def delete(naam):
  users = mongo.users
  u = users.find_one({'Naam' : naam})
  if u:
    users.remove({'Naam': naam })
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
# leeftijd = request.json['leeftijd']
  user_id = users.insert({'Naam': Naam,'Password': password,'Adres': Adres,'Postcode': Postcode})
  new_user = users.find_one({'_id': user_id })
  resultaat = {'naam' : new_user['Naam'],'Password': new_user['Password'],'Adres': new_user['Adres'], 'Postcode': new_user['Postcode']}
  #db.users.create_index([("Naam", pymongo.ASCENDING)], unique=True)
  return jsonify({'resultaat' : resultaat})

if __name__ == '__main__':
    app.run(host='127.0.0.1',debug=True)
