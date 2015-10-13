#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from userUtils import *

required_params = ["session"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        response = logout(form);
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()