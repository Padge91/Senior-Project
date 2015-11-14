#!/usr/bin/python
__author__ = 'ryan'

import cgi

from Utilities import *
from ItemORM import *


required_params = ["title"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = ItemORM()
        response = orm.search_items(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()