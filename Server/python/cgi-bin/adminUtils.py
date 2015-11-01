__author__ = 'nicholaspadgett'

from DataSource import *

def updateItem(id, creator):
    sql = "update items set creator='"+creator+"' where id="+str(id)
    insert_query(sql)
    return True