#!/usr/bin/python
__author__ = 'nicholaspadgett'

import pymysql


host = '52.88.5.108'
port=3306
user='db_user'
password='group2isthebest1!'
db='EMBR'
query = "SELECT * FROM mysql.user"

print("Database Example")

conn = pymysql.connect(host=host, port=port, user=user, passwd=password, db=db)
cursor = conn.cursor()
cursor.execute(query);

results = cursor.fetchall();

for i in range(0,len(results)):
    print "Row "+ str(i) + ": " + results[i][1]

print("Done");
