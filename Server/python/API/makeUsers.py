__author__ = 'nicholaspadgett'

import urllib2
import string
import random

number_of_users = 200
url ="http://localhost:8000/cgi-bin/CreateAccount.py?"
user_base_name="TestUser"

def main():
    for i in range(0, number_of_users):
        name = user_base_name+str(i)
        password = "Password1!"
        passwordConfirm = "Password1!"
        email=str(''.join(random.choice(string.ascii_uppercase) for i in range(12)))+"@gmail.com"
        param_string = add_parameters(name, email, password, passwordConfirm)

        response = urllib2.urlopen(url+param_string).read()
        print response

def add_parameters(name, email, password, passwordConfirm):
    return "username="+name+"&email="+email+"&password="+password+"&passwordConfirm="+passwordConfirm

if __name__=="__main__":
    main()