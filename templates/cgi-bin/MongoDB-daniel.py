import pymongo
import pprint
import time
from pymongo import errors
from pymongo import MongoClient

ipaddress = '127.0.0.1'
port = 27017
client = MongoClient(ipaddress, port)
db = client.test
collection = db.test

input_naam = "Joris de Josselin de Jong"  # input("Wat is uw naam en achternaam?")
input_adres = "Teststraat 111"  # input("Wat is uw straatnaam")
input_postcode = "1234abc"  # input("Wat is uw postcode?")
input_code = "123456abc"  # input("Wat is de code van uw coupon?")
db.test.insert_one({"adres": {"Straat": input_adres, "Postcode": input_postcode},
                    "Naam": input_naam},
                   {"Coupon": input_code})
db.test.create_index([("Coupon", pymongo.ASCENDING)], unique=True)
print("Toegevoegd!")

