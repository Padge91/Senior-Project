__author__ = 'nicholaspadgett'

from DataSource import *

def updateItem(id, creator):
    sql = "update items set creator='{0}' where id={1}".format(creator, id)
    insert_query(sql)
    return True