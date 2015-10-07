__author__ = 'Ryan'

#!/usr/bin/python

import cgi
from Utilities import *
from ItemORM import *
from LibraryORM import *

required_params = ["LibraryID"]
required_params = ["ItemID"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = ItemORM()
        response = orm.add_item_to_library(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)



if __name__=="__main__":
    main()