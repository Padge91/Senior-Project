#!/usr/bin/python
__author__ = 'nicholaspadgett'

import pymysql
import cgi
import json
from ItemClass import *

def main():
    form = get_required_parameters(cgi)
    cursor = create_connection()
    response = run_query(cursor, form)
    respond(response)

#get request parameters
def get_required_parameters(request):
    required_params = ["id", "score"]
    form = request.FieldStorage()

    response = dict()
    for param in required_params:
        response[param] = form[param].value

    return response

#create connection
def create_connection():
    host = '52.88.5.108'
    port=3306
    user='db_user'
    password='group2isthebest1!'
    db='EMBR'

    conn = pymysql.connect(host=host, port=port, user=user, passwd=password, db=db)
    return conn.cursor()

#make database request
def run_query(cursor, form):
    #get items
    get_item_query = "select id, title, description, creator from items where title like '%{0}%'".format(form["name"])
    cursor.execute(get_item_query)

    fetched_rows = cursor.fetchall()

    response = []
    for i in range(0,len(fetched_rows)):
        response.append(Item(fetched_rows[i]))

    return response

#return response
def respond(response):
    print("Content-type:text/plain")
    print("")

    print json.dumps([object.__dict__ for object in response])


if __name__=="__main__":
    main()