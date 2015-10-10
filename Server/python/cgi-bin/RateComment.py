#!/usr/bin/python

import cgi
from Utilities import *
from CommentORM import *

required_params = ["session", "comment_id", "rating"]

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = CommentORM()
        response = orm.rate_comment(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)



if __name__=="__main__":
    main()