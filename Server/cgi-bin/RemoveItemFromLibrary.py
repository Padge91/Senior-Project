#!/usr/bin/python

__author__ = 'nicholaspadgett'

import cgi

from Utilities import *
from LibraryORM import *


required_params = ["session", "library_id", "item_id"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        form["user_id"] = get_user_id_from_session(form)
        library_orm = LibraryORM()
        response = library_orm.remove_item_from_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()