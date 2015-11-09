#!/usr/bin/python

__author__ = 'nicholaspadgett'

required_params = ["session","comment_id"]
import cgi
from Utilities import *
from CommentORM import *

def main():
    try:
        form = get_required_parameters(cgi, required_params)
        orm = CommentORM()
        response = orm.flag_comment(form)
        success_response(response)
    except Exception as e:
        failure_response(e.message)


if __name__ == "__main__":
    main()