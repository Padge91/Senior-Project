#!/usr/bin/python
__author__ = 'Ryan'

import cgi
from Utilities import *
from LibraryORM import *

required_params = ["session","library_id", "item_id"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = LibraryORM()
        response = orm.add_item_to_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)



if __name__=="__main__":
    main()