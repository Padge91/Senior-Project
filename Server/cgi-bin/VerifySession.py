#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi

from userUtils import *
from Utilities import *


required_params = ["session"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        response = check_session_id(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__ == "__main__":
    main()