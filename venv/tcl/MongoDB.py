import pymongo
import pprint
import time

from pymongo import errors
from pymongo import MongoClient
ipaddress = '127.0.0.1'
port = 27017
client = MongoClient(ipaddress, port)

db = client.koffie
collection = db.test

while True:
    try:
        keuze = input("Wat wilt u graag doen?:"
                  "\n 1. Een account aanmaken"
                  "\n 2. Een account opzoeken"
                  "\n Kies 1 of 2:\n")
        if keuze == "1":
            input_naam = "Joris de Josselin de Jong" #input("Wat is uw naam en achternaam?")
            input_adres = "Teststraat 111" #input("Wat is uw straatnaam")
            input_postcode = "1234abc" #input("Wat is uw postcode?")
            input_code = "123456abc" #input("Wat is de code van uw coupon?")
            db.test.insert_one({"adres": { "Straat":input_adres, "Postcode":input_postcode },
                                 "Naam":input_naam },
                               { "Coupon":input_code })
            db.test.create_index([("Coupon", pymongo.ASCENDING)], unique=True)
            print("Toegevoegd!")
    except errors.DuplicateKeyError:
        print("Sorry deze coupon code bestaat al")
        time.sleep(1)
    except:
        print("Oepsie! er is iets mis gegaan wat ik niet begrijp")


    if keuze == "2":
        keuze2_1 = input("Waarop wilt u graag zoeken?"
                     "\n1. Op naam"
                     "\n2. Op postcode"
                     "\n3. Op coupon code"
                     "\n Kies 1, 2 of 3:\n")
        if keuze2_1 == "1":
            search_naam = "Joris de Josselin de Jong" #input("Geef de naam op die u wil zoeken:\n")
            vind_naam = str((pprint.pprint(db.test.find_one({ "Naam": search_naam }))))
            # if search_naam in vind_naam:
            #     print(vind_naam, "\n Dit hebben we kunnen vinden")
            # if search_naam not in vind_naam:
            #     print("Sorry daarop hebben we niks kunnen vinden")

        if keuze2_1 == "2":
            search_naam = input("Geef de postcode op die u wilt zoeken:\n")
            vind_naam = str((pprint.pprint(db.test.find_one({ "Postcode": search_naam }))))
            # if search_naam in vind_naam:
            #     print(vind_naam, "\n Dit hebben we kunnen vinden")
            # if search_naam not in vind_naam:
            #     print("Sorry daarop hebben we niks kunnen vinden")
        if keuze2_1 == "3":
            search_naam = input("Geef de coupon op die u wilt zoeken:\n")
            vind_naam = str((pprint.pprint(db.test.find_one({ "Coupon": search_naam }))))

    keuze_opnieuw = input("Wilt u nog iets doen?\n"
                            "Type in \'ja\' of \'nee\'\n")
    if keuze_opnieuw == 'ja':
        True
    if keuze_opnieuw == 'nee':
        break