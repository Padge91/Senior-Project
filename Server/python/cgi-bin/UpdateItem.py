#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from adminUtils import *

required_params = ["id", "creator"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        response = updateItem(form["id"], form["creator"])
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()