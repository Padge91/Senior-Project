#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from UserORM import *

required_params = ["session"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = UserORM()
        response = orm.get_current_user_info(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)

    
    
if __name__ == "__main__":
    main()