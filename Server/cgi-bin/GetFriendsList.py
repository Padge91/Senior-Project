#!/usr/bin/python
__author__ = 'nicholaspadgett'

from Utilities import *
import cgi
from FriendsORM import *
required_params = ["user_id"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = FriendsORM()
        response = orm.list_friends(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)

if __name__ == "__main__":
    main()