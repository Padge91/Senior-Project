#!/usr/bin/python

import cgi

from Utilities import *
from LibraryORM import *


required_params = ["session", "library_name", "visible"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = LibraryORM()
        response = orm.create_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()