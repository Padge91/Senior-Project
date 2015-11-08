#!/usr/bin/python

__author__ = 'nicholaspadgett'

import cgi

from Utilities import *
from LibraryORM import *


required_params = ["session", "user_id"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        form["current_user_id"] = get_user_id_from_session(form)
        orm = LibraryORM()
        response = orm.get_user_libraries(form);
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()