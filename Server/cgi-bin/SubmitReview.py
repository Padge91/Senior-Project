#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi

from ItemORM import *
from Utilities import *


required_params = ["session","item_id", "score"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = ItemORM()
        response = orm.add_score(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)

if __name__=="__main__":
    main()