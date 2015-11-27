#!/usr/bin/python

__author__ = 'nicholaspadgett'

required_params = ["session","library_id"]

import cgi
from Utilities import *
from LibraryORM import *

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = LibraryORM()
        response = orm.delete_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__ == "__main__":
    main()