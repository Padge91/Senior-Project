#!/usr/bin/python
__author__ = 'nicholaspadgett'


import cgi

from Utilities import *
from FriendsORM import *

required_params = ["session", "user_id"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = FriendsORM()
        response = orm.is_my_friend(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()