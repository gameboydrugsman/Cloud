#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask
from OpenSSL import SSL
from werkzeug.serving import run_simple
from werkzeug.serving import make_ssl_devcert
from werkzeug.serving import is_running_from_reloader

#from myproject import make_app

app = Flask(__name__)
bestand = open("C:/Users/Daniel van Liempd/Desktop/DANIEL.txt", 'r')
#print (bestand.read())

make_ssl_devcert('C:/Users/Daniel van Liempd/PycharmProjects/Practicum-cloudinfra/venv', host='Daniel-PC', cn=None)
is_running_from_reloader()


run_simple(hostname = 'Daniel-PC', port = 8080, application=(app), use_reloader=False,
use_debugger=False, use_evalex=True, extra_files=None, reloader_interval=1,
reloader_type='auto', threaded=False, processes=1, request_handler=None,
static_files=None, passthrough_errors=False, ssl_context=None)

def hello():
    return "Hello World!"

#app.run(host='192.168.2.10', port='12344',debug=False / True, ssl_context=context)
#app = make_app(...)

#key = ('D:/xxx/xxxx/playlist/playlist.m3u')

key = open("C:/Users/Daniel van Liempd/Desktop/DANIEL.txt", 'r')
crt = open("C:/Users/Daniel van Liempd/Desktop/DANIEL.txt", 'r')

context = SSL.Context(SSL.SSLv23_METHOD)
context.use_privatekey_file('yourserver.key')
context.use_certificate_file('yourserver.crt')


