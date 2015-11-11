#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from LibraryORM import *

required_params = ["title", "library_id","session"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = LibraryORM()
        response = orm.search_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)

if __name__ == "__main__":
    main()