#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from FriendsORM import *


#email_string and name_string should be "None" by default
required_fields = ["email_string", "name_string"]

def main():
    try:
        form = get_required_parameters(cgi, required_fields)
        orm = FriendsORM()
        response = orm.search_friends(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__ == "__main__":
    main()