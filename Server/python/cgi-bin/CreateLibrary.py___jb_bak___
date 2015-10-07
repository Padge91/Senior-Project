#!/usr/bin/python

import cgi
from Utilities import *
from ItemORM import *

required_params = ["LibraryID"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = ItemORM()
        response = orm.create_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()