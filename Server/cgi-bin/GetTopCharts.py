#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi
from Utilities import *
from userUtils import *
from ChartsORM import *

required_params = ["session"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = ChartsORM()

        results = []
        #if no session
        if form["session"] == "None":
            results = orm.get_nosession_charts()
        #if session
        else:
            results = orm.get_all_charts(form)

        success_response(results)
    except Exception as e:
        failure_response(e.message)


if __name__ == "__main__":
    main()