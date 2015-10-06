__author__ = 'nicholaspadgett'

import pymysql

host = 'localhost'
port=3306
user='db_user'
password='group2isthebest1!'
db='EMBR'

conn = pymysql.connect(host=host, port=port, user=user, passwd=password, db=db)
cursor = conn.cursor()

def select_query(query):
    cursor.execute(query)

    results = cursor.fetchall()
    return results

def insert_query(query, params):
    cursor.execute(query, params)
    conn.commit()

def close():
    cursor.close()
    conn.close()